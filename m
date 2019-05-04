Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE2E13908
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfEDK0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfEDK0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22262084A;
        Sat,  4 May 2019 10:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965577;
        bh=jWL0UKG3S/YIXsrtiuGqqtGgOMDIEcDHKHDF/CcUshM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0B2sQd4XvCxZRJef+Xwk/KPTyAe24UsTpKqdjzIaf5jt6xb1eQYWVUxr8BBiInUrj
         8Q1SNqdA/9AkCFYVUnacR7BnOrfcOj+bLeXIF/j9SDOCbADj0hX6ZoEDm6p7u5c1Kh
         0jdlMKXTgenyL8DbbakipiVaQ5EaDDLHdCA4vqDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 24/32] bnxt_en: Fix statistics context reservation logic.
Date:   Sat,  4 May 2019 12:25:09 +0200
Message-Id: <20190504102453.236799604@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 3f93cd3f098e284c851acb89265ebe35b994a5c8 ]

In an earlier commit that fixes the number of stats contexts to
reserve for the RDMA driver, we added a function parameter to pass in
the number of stats contexts to all the relevant functions.  The passed
in parameter should have been used to set the enables field of the
firmware message.

Fixes: 780baad44f0f ("bnxt_en: Reserve 1 stat_ctx for RDMA driver.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5311,17 +5311,16 @@ __bnxt_hwrm_reserve_pf_rings(struct bnxt
 	req->num_tx_rings = cpu_to_le16(tx_rings);
 	if (BNXT_NEW_RM(bp)) {
 		enables |= rx_rings ? FUNC_CFG_REQ_ENABLES_NUM_RX_RINGS : 0;
+		enables |= stats ? FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS : 0;
 		if (bp->flags & BNXT_FLAG_CHIP_P5) {
 			enables |= cp_rings ? FUNC_CFG_REQ_ENABLES_NUM_MSIX : 0;
 			enables |= tx_rings + ring_grps ?
-				   FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS |
-				   FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS : 0;
+				   FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS : 0;
 			enables |= rx_rings ?
 				FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS : 0;
 		} else {
 			enables |= cp_rings ?
-				   FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS |
-				   FUNC_CFG_REQ_ENABLES_NUM_STAT_CTXS : 0;
+				   FUNC_CFG_REQ_ENABLES_NUM_CMPL_RINGS : 0;
 			enables |= ring_grps ?
 				   FUNC_CFG_REQ_ENABLES_NUM_HW_RING_GRPS |
 				   FUNC_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS : 0;
@@ -5361,14 +5360,13 @@ __bnxt_hwrm_reserve_vf_rings(struct bnxt
 	enables |= tx_rings ? FUNC_VF_CFG_REQ_ENABLES_NUM_TX_RINGS : 0;
 	enables |= rx_rings ? FUNC_VF_CFG_REQ_ENABLES_NUM_RX_RINGS |
 			      FUNC_VF_CFG_REQ_ENABLES_NUM_RSSCOS_CTXS : 0;
+	enables |= stats ? FUNC_VF_CFG_REQ_ENABLES_NUM_STAT_CTXS : 0;
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		enables |= tx_rings + ring_grps ?
-			   FUNC_VF_CFG_REQ_ENABLES_NUM_CMPL_RINGS |
-			   FUNC_VF_CFG_REQ_ENABLES_NUM_STAT_CTXS : 0;
+			   FUNC_VF_CFG_REQ_ENABLES_NUM_CMPL_RINGS : 0;
 	} else {
 		enables |= cp_rings ?
-			   FUNC_VF_CFG_REQ_ENABLES_NUM_CMPL_RINGS |
-			   FUNC_VF_CFG_REQ_ENABLES_NUM_STAT_CTXS : 0;
+			   FUNC_VF_CFG_REQ_ENABLES_NUM_CMPL_RINGS : 0;
 		enables |= ring_grps ?
 			   FUNC_VF_CFG_REQ_ENABLES_NUM_HW_RING_GRPS : 0;
 	}


