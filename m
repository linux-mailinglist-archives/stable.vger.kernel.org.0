Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F8F73D4F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbfGXUQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391711AbfGXTvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF96222ADC;
        Wed, 24 Jul 2019 19:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997912;
        bh=EMo90s9/Lf/53Jng08uBdWrjmrAc+fc74PM8durqgvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0rMiuBtUQ9HKObRyxjNBldpO1jeQQ4Kg2YZ9YJAf/X5KFZllYvQEuxhAUXzT3wBv
         Ta0+yfBjYidN1fZS/M3ri1pjqdtVmgWcHMCUY+8RidoVR7vtaHdRM7WaRV3FHiBY+G
         XDeHWRbHqYsihDwgd138QeuYNzs71nRlyp4oyPJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 186/371] bnxt_en: Fix statistics context reservation logic for RDMA driver.
Date:   Wed, 24 Jul 2019 21:18:58 +0200
Message-Id: <20190724191739.054987764@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d77b1ad8e87dc5a6cd0d9158b097a4817946ca3b ]

The current logic assumes that the RDMA driver uses one statistics
context adjacent to the ones used by the network driver.  This
assumption is not true and the statistics context used by the
RDMA driver is tied to its MSIX base vector.  This wrong assumption
can cause RDMA driver failure after changing ethtool rings on the
network side.  Fix the statistics reservation logic accordingly.

Fixes: 780baad44f0f ("bnxt_en: Reserve 1 stat_ctx for RDMA driver.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bf1fd513fa02..09557bf49bb0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5481,7 +5481,16 @@ static int bnxt_cp_rings_in_use(struct bnxt *bp)
 
 static int bnxt_get_func_stat_ctxs(struct bnxt *bp)
 {
-	return bp->cp_nr_rings + bnxt_get_ulp_stat_ctxs(bp);
+	int ulp_stat = bnxt_get_ulp_stat_ctxs(bp);
+	int cp = bp->cp_nr_rings;
+
+	if (!ulp_stat)
+		return cp;
+
+	if (bnxt_nq_rings_in_use(bp) > cp + bnxt_get_ulp_msix_num(bp))
+		return bnxt_get_ulp_msix_base(bp) + ulp_stat;
+
+	return cp + ulp_stat;
 }
 
 static bool bnxt_need_reserve_rings(struct bnxt *bp)
@@ -7373,11 +7382,7 @@ unsigned int bnxt_get_avail_cp_rings_for_en(struct bnxt *bp)
 
 unsigned int bnxt_get_avail_stat_ctxs_for_en(struct bnxt *bp)
 {
-	unsigned int stat;
-
-	stat = bnxt_get_max_func_stat_ctxs(bp) - bnxt_get_ulp_stat_ctxs(bp);
-	stat -= bp->cp_nr_rings;
-	return stat;
+	return bnxt_get_max_func_stat_ctxs(bp) - bnxt_get_func_stat_ctxs(bp);
 }
 
 int bnxt_get_avail_msix(struct bnxt *bp, int num)
-- 
2.20.1



