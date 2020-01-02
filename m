Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4712F0FB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgABW5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgABWRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:17:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C39A22314;
        Thu,  2 Jan 2020 22:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003430;
        bh=FEU+wb56kXY41/LbKxx41Q+u86Vh8kPfLw7+5HaC4Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01GBSuv8yqSmg/qzIO62JyB+FM6o/x35COJ+1rAfDPplkqvLtr7+wW4ECzbDcV1q7
         sypVXBA7y/n+eP/3KAei0XO/aXXPfH44XKpdTBMwQnMq3UthmduvRa6dSrkQAm+Nyx
         fLPzJlBA2gDIkMmnv1pBbb9kVVGNCKKAJMiCe7nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 158/191] bnxt_en: Fix MSIX request logic for RDMA driver.
Date:   Thu,  2 Jan 2020 23:07:20 +0100
Message-Id: <20200102215846.336461084@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 0c722ec0a289c7f6b53f89bad1cfb7c4db3f7a62 ]

The logic needs to check both bp->total_irqs and the reserved IRQs in
hw_resc->resv_irqs if applicable and see if both are enough to cover
the L2 and RDMA requested vectors.  The current code is only checking
bp->total_irqs and can fail in some code paths, such as the TX timeout
code path with the RDMA driver requesting vectors after recovery.  In
this code path, we have not reserved enough MSIX resources for the
RDMA driver yet.

Fixes: 75720e6323a1 ("bnxt_en: Keep track of reserved IRQs.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -113,8 +113,10 @@ static int bnxt_req_msix_vecs(struct bnx
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
+	struct bnxt_hw_resc *hw_resc;
 	int max_idx, max_cp_rings;
 	int avail_msix, idx;
+	int total_vecs;
 	int rc = 0;
 
 	ASSERT_RTNL();
@@ -142,7 +144,10 @@ static int bnxt_req_msix_vecs(struct bnx
 	}
 	edev->ulp_tbl[ulp_id].msix_base = idx;
 	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
-	if (bp->total_irqs < (idx + avail_msix)) {
+	hw_resc = &bp->hw_resc;
+	total_vecs = idx + avail_msix;
+	if (bp->total_irqs < total_vecs ||
+	    (BNXT_NEW_RM(bp) && hw_resc->resv_irqs < total_vecs)) {
 		if (netif_running(dev)) {
 			bnxt_close_nic(bp, true, false);
 			rc = bnxt_open_nic(bp, true, false);
@@ -156,7 +161,6 @@ static int bnxt_req_msix_vecs(struct bnx
 	}
 
 	if (BNXT_NEW_RM(bp)) {
-		struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
 		int resv_msix;
 
 		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;


