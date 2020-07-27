Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29AF22F0B1
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbgG0O0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731829AbgG0O0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54E342070A;
        Mon, 27 Jul 2020 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859995;
        bh=GA44kHr1uHOcIhyuj8ab60+o5lfmvjI8RRbla3WfXHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDilsJDKDL5/Wte65XuVzmP/dcHRo+9YAoIjNA7CGB04M731tq+c57ocKHCmSbVH+
         Mqt4mvSvQkxKk0CBWs8MShZjQV0VNcm8nHKyJOHX822mmgCWiAOWKN4zGWpFVIZbgu
         TkIynbeEdyx15oWxI9NDHd/1mXi/xloEYopjemvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Viktor=20J=C3=A4gersk=C3=BCpper?= 
        <viktor_jaegerskuepper@freenet.de>,
        syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
Subject: [PATCH 5.7 178/179] ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
Date:   Mon, 27 Jul 2020 16:05:53 +0200
Message-Id: <20200727134941.329559708@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 upstream.

In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
usb_ifnum_to_if(urb->dev, 0)
But it isn't always true.

The case reported by syzbot:
https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.com
usb 2-1: new high-speed USB device number 2 using dummy_hcd
usb 2-1: config 1 has an invalid interface number: 2 but max is 0
usb 2-1: config 1 has no interface number 0
usb 2-1: New USB device found, idVendor=0cf3, idProduct=9271, bcdDevice=
1.08
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
general protection fault, probably for non-canonical address
0xdffffc0000000015: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0

Call Trace
__usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
expire_timers kernel/time/timer.c:1449 [inline]
__run_timers kernel/time/timer.c:1773 [inline]
__run_timers kernel/time/timer.c:1740 [inline]
run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
__do_softirq+0x21e/0x950 kernel/softirq.c:292
invoke_softirq kernel/softirq.c:373 [inline]
irq_exit+0x178/0x1a0 kernel/softirq.c:413
exiting_irq arch/x86/include/asm/apic.h:546 [inline]
smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829

Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200404041838.10426-6-hqjagain@gmail.com
Cc: Viktor Jägersküpper <viktor_jaegerskuepper@freenet.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   48 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    5 +++
 2 files changed, 42 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -643,9 +643,9 @@ err:
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
 {
-	struct sk_buff *skb = (struct sk_buff *) urb->context;
-	struct hif_device_usb *hif_dev =
-		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
+	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
+	struct sk_buff *skb = rx_buf->skb;
 	int ret;
 
 	if (!skb)
@@ -685,14 +685,15 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
+	kfree(rx_buf);
 }
 
 static void ath9k_hif_usb_reg_in_cb(struct urb *urb)
 {
-	struct sk_buff *skb = (struct sk_buff *) urb->context;
+	struct rx_buf *rx_buf = (struct rx_buf *)urb->context;
+	struct hif_device_usb *hif_dev = rx_buf->hif_dev;
+	struct sk_buff *skb = rx_buf->skb;
 	struct sk_buff *nskb;
-	struct hif_device_usb *hif_dev =
-		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
 	int ret;
 
 	if (!skb)
@@ -750,6 +751,7 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
+	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -795,7 +797,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(s
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -832,8 +834,9 @@ static void ath9k_hif_usb_dealloc_rx_urb
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct urb *urb = NULL;
+	struct rx_buf *rx_buf = NULL;
 	struct sk_buff *skb = NULL;
+	struct urb *urb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -841,6 +844,12 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 
 	for (i = 0; i < MAX_RX_URB_NUM; i++) {
 
+		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
+		if (!rx_buf) {
+			ret = -ENOMEM;
+			goto err_rxb;
+		}
+
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -855,11 +864,14 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 			goto err_skb;
 		}
 
+		rx_buf->hif_dev = hif_dev;
+		rx_buf->skb = skb;
+
 		usb_fill_bulk_urb(urb, hif_dev->udev,
 				  usb_rcvbulkpipe(hif_dev->udev,
 						  USB_WLAN_RX_PIPE),
 				  skb->data, MAX_RX_BUF_SIZE,
-				  ath9k_hif_usb_rx_cb, skb);
+				  ath9k_hif_usb_rx_cb, rx_buf);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->rx_submitted);
@@ -885,6 +897,8 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
+	kfree(rx_buf);
+err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -896,14 +910,21 @@ static void ath9k_hif_usb_dealloc_reg_in
 
 static int ath9k_hif_usb_alloc_reg_in_urbs(struct hif_device_usb *hif_dev)
 {
-	struct urb *urb = NULL;
+	struct rx_buf *rx_buf = NULL;
 	struct sk_buff *skb = NULL;
+	struct urb *urb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->reg_in_submitted);
 
 	for (i = 0; i < MAX_REG_IN_URB_NUM; i++) {
 
+		rx_buf = kzalloc(sizeof(*rx_buf), GFP_KERNEL);
+		if (!rx_buf) {
+			ret = -ENOMEM;
+			goto err_rxb;
+		}
+
 		/* Allocate URB */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (urb == NULL) {
@@ -918,11 +939,14 @@ static int ath9k_hif_usb_alloc_reg_in_ur
 			goto err_skb;
 		}
 
+		rx_buf->hif_dev = hif_dev;
+		rx_buf->skb = skb;
+
 		usb_fill_int_urb(urb, hif_dev->udev,
 				  usb_rcvintpipe(hif_dev->udev,
 						  USB_REG_IN_PIPE),
 				  skb->data, MAX_REG_IN_BUF_SIZE,
-				  ath9k_hif_usb_reg_in_cb, skb, 1);
+				  ath9k_hif_usb_reg_in_cb, rx_buf, 1);
 
 		/* Anchor URB */
 		usb_anchor_urb(urb, &hif_dev->reg_in_submitted);
@@ -948,6 +972,8 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
+	kfree(rx_buf);
+err_rxb:
 	ath9k_hif_usb_dealloc_reg_in_urbs(hif_dev);
 	return ret;
 }
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -86,6 +86,11 @@ struct tx_buf {
 	struct list_head list;
 };
 
+struct rx_buf {
+	struct sk_buff *skb;
+	struct hif_device_usb *hif_dev;
+};
+
 #define HIF_USB_TX_STOP  BIT(0)
 #define HIF_USB_TX_FLUSH BIT(1)
 


