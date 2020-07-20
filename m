Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1EB2263CC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgGTPkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbgGTPkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:40:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721BA2064B;
        Mon, 20 Jul 2020 15:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259631;
        bh=izjrBbcPacig1HJUfWaGdFHqBAsWwG7kbUdziTZVpQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trGGkDCWbsjb3zvgMdBwNR92jXhVAwy5V3NhzR4OiZAOMy2zqwB5mzmyNYFwzSs/L
         PN0horKG1hMFDgDNaNQ2vDgukX0cC/R3uN0IaXq7/7EO04ktdvt9pIX5IRXLDpbjyS
         vFstUzFchIW19kJclOsdqNOxC0MZUBBLie+wDCP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 21/86] Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
Date:   Mon, 20 Jul 2020 17:36:17 +0200
Message-Id: <20200720152754.210764551@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 5317abc46279d900c7e63cc122682d819da658bd which is
commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.

It is being reverted upstream, just hasn't made it there yet and is
causing lots of problems.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Cc: Qiujun Huang <hqjagain@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   48 +++++++------------------------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    5 ---
 2 files changed, 11 insertions(+), 42 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -641,9 +641,9 @@ err:
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
 {
-	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
-	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
-	struct sk_buff *skb = rx_buf->skb;
+	struct sk_buff *skb = (struct sk_buff *) urb->context;
+	struct hif_device_usb *hif_dev =
+		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
 	if (!skb)
@@ -683,15 +683,14 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
-	kfree(rx_buf);
 }
 
 static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 {
-	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
-	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
-	struct sk_buff *skb = rx_buf->skb;
+	struct sk_buff *skb = (struct sk_buff *) urb->context;
 	struct sk_buff *nskb;
+	struct hif_device_usb *hif_dev =
+		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
 	if (!skb)
@@ -749,7 +748,6 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
-	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -795,7 +793,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(s
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -832,9 +830,8 @@ static void ath9k_hif_usb_dealloc_rx_urb
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct rx_buf *rx_buf = NULL;
-	struct sk_buff *skb = NULL;
 	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -842,12 +839,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 
 	for (i = 0; i < MAX_RX_URB_NUM; i++) {
 
-		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
-		if (!rx_buf) {
-			ret = -ENOMEM;
-			goto err_rxb;
-		}
-
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -862,14 +853,11 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 			goto err_skb;
 		}
 
-		rx_buf->hif_dev = hif_dev;
-		rx_buf->skb = skb;
-
 		usb_fill_bulk_urb(urb, hif_dev->udev,
 				  usb_rcvbulkpipe(hif_dev->udev,
 						  USB_WLAN_RX_PIPE),
 				  skb->data, MAX_RX_BUF_SIZE,
-				  ath9k_hif_usb_rx_cb, rx_buf);
+				  ath9k_hif_usb_rx_cb, skb);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->rx_submitted);
@@ -895,8 +883,6 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-	kfree(rx_buf);
-err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -908,21 +894,14 @@ static void ath9k_hif_usb_dealloc_reg_in
 
 static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-	struct rx_buf *rx_buf = NULL;
-	struct sk_buff *skb = NULL;
 	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->reg_in_submitted);
 
 	for (i = 0; i < MAX_REG_IN_URB_NUM; i++) {
 
-		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
-		if (!rx_buf) {
-			ret = -ENOMEM;
-			goto err_rxb;
-		}
-
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -937,14 +916,11 @@ static int ath9k_hif_usb_alloc_reg_in_ur
 			goto err_skb;
 		}
 
-		rx_buf->hif_dev = hif_dev;
-		rx_buf->skb = skb;
-
 		usb_fill_int_urb(urb, hif_dev->udev,
 				  usb_rcvintpipe(hif_dev->udev,
 						  USB_REG_IN_PIPE),
 				  skb->data, MAX_REG_IN_BUF_SIZE,
-				  ath9k_hif_usb_reg_in_cb, rx_buf, 1);
+				  ath9k_hif_usb_reg_in_cb, skb, 1);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
@@ -970,8 +946,6 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-	kfree(rx_buf);
-err_rxb:
 	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
 	return ret;
 }
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -84,11 +84,6 @@ struct tx_buf {
 	struct list_head list;
 };
 
-struct rx_buf {
-	struct sk_buff *skb;
-	struct hif_device_usb *hif_dev;
-};
-
 #define HIF_USB_TX_STOP  BIT(0)
 #define HIF_USB_TX_FLUSH BIT(1)
 


