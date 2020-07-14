Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7421F9ED
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgGNSrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729813AbgGNSrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B75422AAA;
        Tue, 14 Jul 2020 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752465;
        bh=b/MpVVAJc2+RtAD7Rz7jIVft8p7AIFTO1t2b3ctl1eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+yKXURlYlAHLwfYikxX+6+y3ZhvRFdQfSX+P8Y+TyuPwp2qDou/w2zLiQ0gppxq6
         G9XcoIfT0FXYPNqKH5xhXpoZ2QLrdx3QlGBg3ev3JvCIGXnXvp+uOIipPSElmZdfRE
         heHUEcc3I/7r4B0aklYokgWZshO00NiUinZiJPAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 52/58] Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
Date:   Tue, 14 Jul 2020 20:44:25 +0200
Message-Id: <20200714184058.743710489@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bdf4d37b03dc410b91f318c8e097a41e732d1038 which is
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
@@ -643,9 +643,9 @@ err:
 
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
@@ -685,15 +685,14 @@ resubmit:
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
@@ -751,7 +750,6 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
-	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -797,7 +795,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(s
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -834,9 +832,8 @@ static void ath9k_hif_usb_dealloc_rx_urb
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct rx_buf *rx_buf = NULL;
-	struct sk_buff *skb = NULL;
 	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -844,12 +841,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 
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
@@ -864,14 +855,11 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
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
@@ -897,8 +885,6 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-	kfree(rx_buf);
-err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -910,21 +896,14 @@ static void ath9k_hif_usb_dealloc_reg_in
 
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
@@ -939,14 +918,11 @@ static int ath9k_hif_usb_alloc_reg_in_ur
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
@@ -972,8 +948,6 @@ err_submit:
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
@@ -86,11 +86,6 @@ struct tx_buf {
 	struct list_head list;
 };
 
-struct rx_buf {
-	struct sk_buff *skb;
-	struct hif_device_usb *hif_dev;
-};
-
 #define HIF_USB_TX_STOP  BIT(0)
 #define HIF_USB_TX_FLUSH BIT(1)
 


