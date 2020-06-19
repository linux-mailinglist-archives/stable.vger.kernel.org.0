Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F7D201294
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393036AbgFSPxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393026AbgFSPWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1721720B80;
        Fri, 19 Jun 2020 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580156;
        bh=gIPMWsm4ABPCize5QULWOmfap6esL9krjFHVmOk7eLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05ayz8jT4vdfng7a/A/46tb3GgjNZTm3LcpJ+H2niPPkO87FJAe6VsvfaN9WZt++6
         GihE5US4yjR6FiDOtq0qYRqwZ79m5DAabEA2aRLEKlGCmcAmA7lVPJkx4Pa10qEhWp
         WMoN3/PDsVrbyoNMXlQsU650Bm2Vw0Plw3xf6zMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 142/376] ice: Fix error return code in ice_add_prof()
Date:   Fri, 19 Jun 2020 16:31:00 +0200
Message-Id: <20200619141717.055532750@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit f8d530ac29fe9248f5e58ca5bcf4c368f8393ccf ]

Fix to return a error code from the error handling case
instead of 0, as done elsewhere in this function.

Fixes: 31ad4e4ee1e4 ("ice: Allocate flow profile")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 42bac3ec5526..e7a2671222d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2962,8 +2962,10 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 
 	/* add profile info */
 	prof = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*prof), GFP_KERNEL);
-	if (!prof)
+	if (!prof) {
+		status = ICE_ERR_NO_MEMORY;
 		goto err_ice_add_prof;
+	}
 
 	prof->profile_cookie = id;
 	prof->prof_id = prof_id;
-- 
2.25.1



