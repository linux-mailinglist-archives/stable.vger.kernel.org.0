Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8973A0ED5
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhFIIma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhFIIma (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1793961359;
        Wed,  9 Jun 2021 08:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623228023;
        bh=+7C7e/GvEXzVtBIUpu7Ytye+6udl3LOfR2QjK0EU4KQ=;
        h=Subject:To:From:Date:From;
        b=KZC1ShrEl2ZDRBWWTG+P//bW8acdT2q0ClKXBno4KSE1nkTXotSC0RDia/0TltcPe
         0VJ4Hq0iod5j3I3THifYdfKJOqaOVjphGC6fHT0g5CLRY+phELYnfqr9Mv86f1/fjm
         QfD+Leu5vwyolFTI/D1Sfrih5l9tiO16KfyFSXzI=
Subject: patch "usb: fix various gadget panics on 10gbps cabling" added to usb-linus
To:     maze@google.com, balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Jun 2021 10:40:21 +0200
Message-ID: <162322802125252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: fix various gadget panics on 10gbps cabling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 032e288097a553db5653af552dd8035cd2a0ba96 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Date: Tue, 8 Jun 2021 19:44:59 -0700
Subject: usb: fix various gadget panics on 10gbps cabling
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

usb_assign_descriptors() is called with 5 parameters,
the last 4 of which are the usb_descriptor_header for:
  full-speed (USB1.1 - 12Mbps [including USB1.0 low-speed @ 1.5Mbps),
  high-speed (USB2.0 - 480Mbps),
  super-speed (USB3.0 - 5Gbps),
  super-speed-plus (USB3.1 - 10Gbps).

The differences between full/high/super-speed descriptors are usually
substantial (due to changes in the maximum usb block size from 64 to 512
to 1024 bytes and other differences in the specs), while the difference
between 5 and 10Gbps descriptors may be as little as nothing
(in many cases the same tuning is simply good enough).

However if a gadget driver calls usb_assign_descriptors() with
a NULL descriptor for super-speed-plus and is then used on a max 10gbps
configuration, the kernel will crash with a null pointer dereference,
when a 10gbps capable device port + cable + host port combination shows up.
(This wouldn't happen if the gadget max-speed was set to 5gbps, but
it of course defaults to the maximum, and there's no real reason to
artificially limit it)

The fix is to simply use the 5gbps descriptor as the 10gbps descriptor,
if a 10gbps descriptor wasn't provided.

Obviously this won't fix the problem if the 5gbps descriptor is also
NULL, but such cases can't be so trivially solved (and any such gadgets
are unlikely to be used with USB3 ports any way).

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210609024459.1126080-1-zenczykowski@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/config.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/gadget/config.c b/drivers/usb/gadget/config.c
index 8bb25773b61e..05507606b2b4 100644
--- a/drivers/usb/gadget/config.c
+++ b/drivers/usb/gadget/config.c
@@ -164,6 +164,14 @@ int usb_assign_descriptors(struct usb_function *f,
 {
 	struct usb_gadget *g = f->config->cdev->gadget;
 
+	/* super-speed-plus descriptor falls back to super-speed one,
+	 * if such a descriptor was provided, thus avoiding a NULL
+	 * pointer dereference if a 5gbps capable gadget is used with
+	 * a 10gbps capable config (device port + cable + host port)
+	 */
+	if (!ssp)
+		ssp = ss;
+
 	if (fs) {
 		f->fs_descriptors = usb_copy_descriptors(fs);
 		if (!f->fs_descriptors)
-- 
2.32.0


