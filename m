Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB07813906
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfEDK0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbfEDK0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 938DB2084A;
        Sat,  4 May 2019 10:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965572;
        bh=i4G+T7+1VNeRwDdYjfrazs21INpoB0rvKCLMQF7ScBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rFoq1BOzY67w4/25J4uCFI4icRmfggbWHcun43jb5ypINiUUnI/UtveM52dLoZcp
         KeFujdA8nDTmZkHbqUeIgDzWgGmMDYReJTyq5DCVMnvQjouJoAZKshADsKgnYKCTnY
         msyVHlNPB8F0bWS5VLJRiO3ZHkzdS0Biwv0l+PFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 22/32] bnxt_en: Fix possible crash in bnxt_hwrm_ring_free() under error conditions.
Date:   Sat,  4 May 2019 12:25:07 +0200
Message-Id: <20190504102453.183315150@linuxfoundation.org>
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

[ Upstream commit 1f83391bd6fc48f92f627b0ec0bce686d100c6a5 ]

If we encounter errors during open and proceed to clean up,
bnxt_hwrm_ring_free() may crash if the rings we try to free have never
been allocated.  bnxt_cp_ring_for_rx() or bnxt_cp_ring_for_tx()
may reference pointers that have not been allocated.

Fix it by checking for valid fw_ring_id first before calling
bnxt_cp_ring_for_rx() or bnxt_cp_ring_for_tx().

Fixes: 2c61d2117ecb ("bnxt_en: Add helper functions to get firmware CP ring ID.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5131,10 +5131,10 @@ static void bnxt_hwrm_ring_free(struct b
 	for (i = 0; i < bp->tx_nr_rings; i++) {
 		struct bnxt_tx_ring_info *txr = &bp->tx_ring[i];
 		struct bnxt_ring_struct *ring = &txr->tx_ring_struct;
-		u32 cmpl_ring_id;
 
-		cmpl_ring_id = bnxt_cp_ring_for_tx(bp, txr);
 		if (ring->fw_ring_id != INVALID_HW_RING_ID) {
+			u32 cmpl_ring_id = bnxt_cp_ring_for_tx(bp, txr);
+
 			hwrm_ring_free_send_msg(bp, ring,
 						RING_FREE_REQ_RING_TYPE_TX,
 						close_path ? cmpl_ring_id :
@@ -5147,10 +5147,10 @@ static void bnxt_hwrm_ring_free(struct b
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 		struct bnxt_ring_struct *ring = &rxr->rx_ring_struct;
 		u32 grp_idx = rxr->bnapi->index;
-		u32 cmpl_ring_id;
 
-		cmpl_ring_id = bnxt_cp_ring_for_rx(bp, rxr);
 		if (ring->fw_ring_id != INVALID_HW_RING_ID) {
+			u32 cmpl_ring_id = bnxt_cp_ring_for_rx(bp, rxr);
+
 			hwrm_ring_free_send_msg(bp, ring,
 						RING_FREE_REQ_RING_TYPE_RX,
 						close_path ? cmpl_ring_id :
@@ -5169,10 +5169,10 @@ static void bnxt_hwrm_ring_free(struct b
 		struct bnxt_rx_ring_info *rxr = &bp->rx_ring[i];
 		struct bnxt_ring_struct *ring = &rxr->rx_agg_ring_struct;
 		u32 grp_idx = rxr->bnapi->index;
-		u32 cmpl_ring_id;
 
-		cmpl_ring_id = bnxt_cp_ring_for_rx(bp, rxr);
 		if (ring->fw_ring_id != INVALID_HW_RING_ID) {
+			u32 cmpl_ring_id = bnxt_cp_ring_for_rx(bp, rxr);
+
 			hwrm_ring_free_send_msg(bp, ring, type,
 						close_path ? cmpl_ring_id :
 						INVALID_HW_RING_ID);


