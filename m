Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E6200CB8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389145AbgFSOsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389139AbgFSOsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:48:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34F820DD4;
        Fri, 19 Jun 2020 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578131;
        bh=ogbmqCevRe2ClNSpUsR/LvUM+p+ang283BvSS26zFLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/NI6DflDfipKb9aKkkC6M46E9dzxbc4JSvJgak00QWgn2Nap73YZBsW3srxmkK/i
         isybGvexsbXlIjbUkdkMArc2MyOS5QFSSeLkRIzrsfJVBwUipCCrQQiarPDplYGjQM
         PWY/AE8NUuc2jhu4+TqpeRhvJ/Yneqmu0vGHHgcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        syzbot+40d5d2e8a4680952f042@syzkaller.appspotmail.com
Subject: [PATCH 4.14 065/190] ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb
Date:   Fri, 19 Jun 2020 16:31:50 +0200
Message-Id: <20200619141636.824295698@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   48 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/hif_usb.h |    5 +++
 2 files changed, 42 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -641,9 +641,9 @@ err:
 
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
@@ -683,14 +683,15 @@ resubmit:
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
@@ -748,6 +749,7 @@ resubmit:
 	return;
 free:
 	kfree_skb(skb);
+	kfree(rx_buf);
 	urb->context = NULL;
 }
 
@@ -793,7 +795,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(s
 	init_usb_anchor(&hif_dev->mgmt_submitted);
 
 	for (i = 0; i < MAX_TX_URB_NUM; i++) {
-		tx_buf = kzalloc(sizeof(struct tx_buf), GFP_KERNEL);
+		tx_buf = kzalloc(sizeof(*tx_buf), GFP_KERNEL);
 		if (!tx_buf)
 			goto err;
 
@@ -830,8 +832,9 @@ static void ath9k_hif_usb_dealloc_rx_urb
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
-	struct urb *urb = NULL;
+	struct rx_buf *rx_buf = NULL;
 	struct sk_buff *skb = NULL;
+	struct urb *urb = NULL;
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
@@ -839,6 +842,12 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
 
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
@@ -853,11 +862,14 @@ static int ath9k_hif_usb_alloc_rx_urbs(s
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
@@ -883,6 +895,8 @@ err_submit:
 err_skb:
 	usb_free_urb(urb);
 err_urb:
+	kfree(rx_buf);
+err_rxb:
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 	return ret;
 }
@@ -894,14 +908,21 @@ static void ath9k_hif_usb_dealloc_reg_in
 
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
@@ -916,11 +937,14 @@ static int ath9k_hif_usb_alloc_reg_in_ur
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
@@ -946,6 +970,8 @@ err_submit:
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
 


