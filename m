Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00814226C38
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgGTPhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgGTPhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:37:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6318F22CB2;
        Mon, 20 Jul 2020 15:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259456;
        bh=E08lDlh6V93dEvsOrYKLRfVWmdjojdaKLl2b2tVs94U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peSmDfjOsZ+hdzVi4xWMP1mmeVFHng8zjG3DB3r9WzuNW1FPkF2Q+vJDpiG1Z4z9Z
         wVrrqDqSCeUdEo3E6dvBbYlPdjyRnKqUoaru4zc7S8TqsrAX1Reix94vBxsMsOTiCo
         kTYZYCEJWsXoWXctZwpDu7qMcfBDn2UWpmC5dDHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 14/58] Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
Date:   Mon, 20 Jul 2020 17:36:30 +0200
Message-Id: <20200720152747.854506724@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 90ecba9f1041f436ed2b35ba7a970c7cc5d0df23 which is
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
@@ -639,9 +639,9 @@ err:
 
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
@@ -681,15 +681,14 @@ resubmit:
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
@@ -747,7 +746,6 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
-	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -793,7 +791,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(s
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -830,9 +828,8 @@ static void ath9k_hif_usb_dealloc_rx_urb
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct rx_buf *rx_buf = NULL;
-	struct sk_buff *skb = NULL;
 	struct urb *urb = NULL;
+	struct sk_buff *skb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -840,12 +837,6 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 
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
@@ -860,14 +851,11 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
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
@@ -893,8 +881,6 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
-	kfree(rx_buf);
-err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -906,21 +892,14 @@ static void ath9k_hif_usb_dealloc_reg_in
 
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
@@ -935,14 +914,11 @@ static int ath9k_hif_usb_alloc_reg_in_ur
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
@@ -968,8 +944,6 @@ err_submit:
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
 


