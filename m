Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620D573F0A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388771AbfGXTdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388019AbfGXTdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:33:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9A420659;
        Wed, 24 Jul 2019 19:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996784;
        bh=fGViM72xunB7ZwdcjFaAKYyenVrGpIvI/BwNCmWQzEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpFajIzUa8AWJAya7xpwmNosQMNSeeE1QHwTEz9Qe5nZlHPB5aGywnAeVLlNttKJM
         vYkGagLBK+DdNaD4KOErEtWpHlUt+kIJCOatnKGLEe1uHvgXVk5dkORMuUPqEqDoRa
         XXQ0ViVOppQ632OEb+6HYDrJegeXkc6KkQNyRMHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 208/413] bnxt_en: Cap the returned MSIX vectors to the RDMA driver.
Date:   Wed, 24 Jul 2019 21:18:19 +0200
Message-Id: <20190724191749.380049060@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1dbc59fa4bbaa108b641cd65a54f662b75e4ed36 ]

In an earlier commit to improve NQ reservations on 57500 chips, we
set the resv_irqs on the 57500 VFs to the fixed value assigned by
the PF regardless of how many are actually used.  The current
code assumes that resv_irqs minus the ones used by the network driver
must be the ones for the RDMA driver.  This is no longer true and
we may return more MSIX vectors than requested, causing inconsistency.
Fix it by capping the value.

Fixes: 01989c6b69d9 ("bnxt_en: Improve NQ reservations.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index bfa342a98d08..fc77caf0a076 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -157,8 +157,10 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 
 	if (BNXT_NEW_RM(bp)) {
 		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
+		int resv_msix;
 
-		avail_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
+		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
+		avail_msix = min_t(int, resv_msix, avail_msix);
 		edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
 	}
 	bnxt_fill_msix_vecs(bp, ent);
-- 
2.20.1



