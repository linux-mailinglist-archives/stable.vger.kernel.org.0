Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84505CBA8D
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfJDMgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfJDMgl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:36:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B1320862;
        Fri,  4 Oct 2019 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192600;
        bh=x2rgJ2p4SJ4y7949sr5CIhk/dAQClysBBm32HgASTQI=;
        h=Subject:To:From:Date:From;
        b=RBe/LtwM6pcEecfRVtho1AhxvQ2tbkLDBqCEN/+udA7Qe8WDRsCsG/wOXE/8RSRdx
         WqJAVidLwN6+axBT7JVTWcYo0HxS2UcImVtvf3eyVCJRxs07yAAbQFWBAcQzYXLYY9
         +6NHMMHQHNS1y/YMAg/8urOiIqHmYjwc3LsI7juk=
Subject: patch "usb: renesas_usbhs: gadget: Do not discard queues in" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:36:38 +0200
Message-ID: <157019259821934@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: renesas_usbhs: gadget: Do not discard queues in

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1aae1394294cb71c6aa0bc904a94a7f2f1e75936 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 1 Oct 2019 19:10:32 +0900
Subject: usb: renesas_usbhs: gadget: Do not discard queues in
 usb_ep_set_{halt,wedge}()

The commit 97664a207bc2 ("usb: renesas_usbhs: shrink spin lock area")
had added a usbhsg_pipe_disable() calling into
__usbhsg_ep_set_halt_wedge() accidentally. But, this driver should
not call the usbhsg_pipe_disable() because the function discards
all queues. So, this patch removes it.

Fixes: 97664a207bc2 ("usb: renesas_usbhs: shrink spin lock area")
Cc: <stable@vger.kernel.org> # v3.1+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1569924633-322-2-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/mod_gadget.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 4d571a5205e2..2c7523a211c0 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -723,8 +723,6 @@ static int __usbhsg_ep_set_halt_wedge(struct usb_ep *ep, int halt, int wedge)
 	struct device *dev = usbhsg_gpriv_to_dev(gpriv);
 	unsigned long flags;
 
-	usbhsg_pipe_disable(uep);
-
 	dev_dbg(dev, "set halt %d (pipe %d)\n",
 		halt, usbhs_pipe_number(pipe));
 
-- 
2.23.0


