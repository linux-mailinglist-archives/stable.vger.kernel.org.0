Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7CB19100D
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgCXNY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729233AbgCXNY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E414208E0;
        Tue, 24 Mar 2020 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056296;
        bh=SS6RLiMo0jFYr42pYCr78pjA4ugLbtmxkVg8LS6xGeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwwJ1eewdftP+i7OGlc3U4Tazym9yU4Si4DnBbBb6o9RR6oV3HW9IGlnmf8p+/99K
         mbmqEkVpV5CxULYcTFjaSGBzpn8nLIlW0ooaHTql8K7iwjHfvMhFZ7DS3W3H10NvUp
         0LYyZjIoW2IeRQuveAbo+8rFkJb/LBLs5EyEvDtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.5 045/119] usb: chipidea: udc: fix sleeping function called from invalid context
Date:   Tue, 24 Mar 2020 14:10:30 +0100
Message-Id: <20200324130812.827356401@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 7368760d1bcdabf515c41a502568b489de3da683 upstream.

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
 drivers/usb/chipidea/udc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1530,18 +1530,19 @@ static const struct usb_ep_ops usb_ep_op
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


