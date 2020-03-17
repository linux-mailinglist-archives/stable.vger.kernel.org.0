Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F673188DEA
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 20:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgCQTYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 15:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQTYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 15:24:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59EF620738;
        Tue, 17 Mar 2020 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584473089;
        bh=pdJHuYbIIOKdIrFLbk39DmzKg71ZTwyqVWJAwVVWNQY=;
        h=Subject:To:From:Date:From;
        b=xF0Ucz4yaYRyOSb7JudP+u2eEbiLJHU5WG4R2VvkbEKv2fNzY9m7rCJQS+NC19pvl
         oezLQIkcR4ok5Cj4JD+Rf0KGw7Bm6AZAtj6TODDGne7GNTk1MX4U0fbzWvAyY81MDH
         1Wat+CZQpJJ8Pb2NtKlULaK0dNjtYvyXOWGtuWA8=
Subject: patch "usb: chipidea: udc: fix sleeping function called from invalid context" added to usb-linus
To:     peter.chen@nxp.com, digetx@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Mar 2020 20:24:47 +0100
Message-ID: <1584473087222170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: udc: fix sleeping function called from invalid context

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7368760d1bcdabf515c41a502568b489de3da683 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Mon, 16 Mar 2020 11:10:34 +0800
Subject: usb: chipidea: udc: fix sleeping function called from invalid context

The code calls pm_runtime_get_sync with irq disabled, it causes below
warning:

BUG: sleeping function called from invalid context at
wer/runtime.c:1075
in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid:
er/u8:1
CPU: 1 PID: 37 Comm: kworker/u8:1 Not tainted
20200304-00181-gbebfd2a5be98 #1588
Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
Workqueue: ci_otg ci_otg_work
[<c010e8bd>] (unwind_backtrace) from [<c010a315>]
1/0x14)
[<c010a315>] (show_stack) from [<c0987d29>]
5/0x94)
[<c0987d29>] (dump_stack) from [<c013e77f>]
+0xeb/0x118)
[<c013e77f>] (___might_sleep) from [<c052fa1d>]
esume+0x75/0x78)
[<c052fa1d>] (__pm_runtime_resume) from [<c0627a33>]
0x23/0x74)
[<c0627a33>] (ci_udc_pullup) from [<c062fb93>]
nect+0x2b/0xcc)
[<c062fb93>] (usb_gadget_connect) from [<c062769d>]
_connect+0x59/0x104)
[<c062769d>] (ci_hdrc_gadget_connect) from [<c062778b>]
ssion+0x43/0x48)
[<c062778b>] (ci_udc_vbus_session) from [<c062f997>]
s_connect+0x17/0x9c)
[<c062f997>] (usb_gadget_vbus_connect) from [<c062634d>]
bd/0x128)
[<c062634d>] (ci_otg_work) from [<c0134719>]
rk+0x149/0x404)
[<c0134719>] (process_one_work) from [<c0134acb>]
0xf7/0x3bc)
[<c0134acb>] (worker_thread) from [<c0139433>]
x118)
[<c0139433>] (kthread) from [<c01010bd>]
(ret_from_fork+0x11/0x34)

Tested-by: Dmitry Osipenko <digetx@gmail.com>
Cc: <stable@vger.kernel.org> #v5.5
Fixes: 72dc8df7920f ("usb: chipidea: udc: protect usb interrupt enable")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200316031034.17847-2-peter.chen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/udc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index ffaf46f5d062..4c4ac30db498 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1530,18 +1530,19 @@ static const struct usb_ep_ops usb_ep_ops = {
 static void ci_hdrc_gadget_connect(struct usb_gadget *_gadget, int is_active)
 {
 	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
-	unsigned long flags;
 
 	if (is_active) {
 		pm_runtime_get_sync(&_gadget->dev);
 		hw_device_reset(ci);
-		spin_lock_irqsave(&ci->lock, flags);
+		spin_lock_irq(&ci->lock);
 		if (ci->driver) {
 			hw_device_state(ci, ci->ep0out->qh.dma);
 			usb_gadget_set_state(_gadget, USB_STATE_POWERED);
+			spin_unlock_irq(&ci->lock);
 			usb_udc_vbus_handler(_gadget, true);
+		} else {
+			spin_unlock_irq(&ci->lock);
 		}
-		spin_unlock_irqrestore(&ci->lock, flags);
 	} else {
 		usb_udc_vbus_handler(_gadget, false);
 		if (ci->driver)
-- 
2.25.1


