Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8C420E0A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhJDNVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236720AbhJDNSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF0961A50;
        Mon,  4 Oct 2021 13:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352885;
        bh=+NuMV9BUgtpHB0g8l38pZksZHURkRwyr2lYuWLq+wFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7THWcc6194uAYYNhEDFr/qTgrWkuBMhIHgKVZ/3jM1MMWVO4YxEin5meWXiaEkAO
         BZW7dyc2mn/lalo0PrY8lEyTKKpoiJVSosP3s8BJVb5NUPI+roVrvgWukEENsFKp9S
         +Nt/ZsHApQaMWWQgyK8NUsdgDYGoZS/3n35LCzho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+47b26cd837ececfc666d@syzkaller.appspotmail.com,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 55/56] HID: usbhid: free raw_report buffers in usbhid_stop
Date:   Mon,  4 Oct 2021 14:53:15 +0200
Message-Id: <20211004125031.746730974@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit f7744fa16b96da57187dc8e5634152d3b63d72de upstream.

Free the unsent raw_report buffers when the device is removed.

Fixes a memory leak reported by syzbot at:
https://syzkaller.appspot.com/bug?id=7b4fa7cb1a7c2d3342a2a8a6c53371c8c418ab47

Reported-by: syzbot+47b26cd837ececfc666d@syzkaller.appspotmail.com
Tested-by: syzbot+47b26cd837ececfc666d@syzkaller.appspotmail.com
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-core.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -503,7 +503,7 @@ static void hid_ctrl(struct urb *urb)
 
 	if (unplug) {
 		usbhid->ctrltail = usbhid->ctrlhead;
-	} else {
+	} else if (usbhid->ctrlhead != usbhid->ctrltail) {
 		usbhid->ctrltail = (usbhid->ctrltail + 1) & (HID_CONTROL_FIFO_SIZE - 1);
 
 		if (usbhid->ctrlhead != usbhid->ctrltail &&
@@ -1221,9 +1221,20 @@ static void usbhid_stop(struct hid_devic
 	mutex_lock(&usbhid->mutex);
 
 	clear_bit(HID_STARTED, &usbhid->iofl);
+
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	while (usbhid->ctrltail != usbhid->ctrlhead) {
+		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_OUT) {
+			kfree(usbhid->ctrl[usbhid->ctrltail].raw_report);
+			usbhid->ctrl[usbhid->ctrltail].raw_report = NULL;
+		}
+
+		usbhid->ctrltail = (usbhid->ctrltail + 1) &
+			(HID_CONTROL_FIFO_SIZE - 1);
+	}
 	spin_unlock_irq(&usbhid->lock);
+
 	usb_kill_urb(usbhid->urbin);
 	usb_kill_urb(usbhid->urbout);
 	usb_kill_urb(usbhid->urbctrl);


