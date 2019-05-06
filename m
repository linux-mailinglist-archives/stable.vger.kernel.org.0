Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E739514D88
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfEFOwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729006AbfEFOsY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:48:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB9C205ED;
        Mon,  6 May 2019 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154104;
        bh=V0HXgS5cL9B9SvKB1cc/CEQhrIEe7EaGF/Yh0vHBp2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCyKQwK6Wk3a4kre1wzPSTMPZbwN4gQDv3kPjRagi5sL0VFvYZqpua5MVYL0Prl1Y
         creFsfDFTG7p5BfjAIIMA5osL4saK13FGJ2WRRa9ulKTqS6FxdZmN/YFFSiT3z/ral
         4eukFCAhmT2FZq7XgKvqbtgKE3Jub46/FXPDagJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 06/62] bnxt_en: Improve multicast address setup logic.
Date:   Mon,  6 May 2019 16:32:37 +0200
Message-Id: <20190506143051.646342236@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit b4e30e8e7ea1d1e35ffd64ca46f7d9a7f227b4bf ]

The driver builds a list of multicast addresses and sends it to the
firmware when the driver's ndo_set_rx_mode() is called.  In rare
cases, the firmware can fail this call if internal resources to
add multicast addresses are exhausted.  In that case, we should
try the call again by setting the ALL_MCAST flag which is more
guaranteed to succeed.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5954,8 +5954,15 @@ static int bnxt_cfg_rx_mode(struct bnxt
 
 skip_uc:
 	rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);
+	if (rc && vnic->mc_list_count) {
+		netdev_info(bp->dev, "Failed setting MC filters rc: %d, turning on ALL_MCAST mode\n",
+			    rc);
+		vnic->rx_mask |= CFA_L2_SET_RX_MASK_REQ_MASK_ALL_MCAST;
+		vnic->mc_list_count = 0;
+		rc = bnxt_hwrm_cfa_l2_set_rx_mask(bp, 0);
+	}
 	if (rc)
-		netdev_err(bp->dev, "HWRM cfa l2 rx mask failure rc: %x\n",
+		netdev_err(bp->dev, "HWRM cfa l2 rx mask failure rc: %d\n",
 			   rc);
 
 	return rc;


