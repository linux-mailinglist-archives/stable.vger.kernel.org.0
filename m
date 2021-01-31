Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7517309DA9
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 16:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhAaPhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 10:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhAaM6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Jan 2021 07:58:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFAAB64DFA;
        Sun, 31 Jan 2021 12:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612097634;
        bh=sDGlOhdfTaRMzu6jizyY0clQL+fua1/EwaQPwWNPtoU=;
        h=Subject:To:From:Date:From;
        b=Gvwscv0TBCZjUmf0UM5oy8j3ckEbOreho7+YcOZuzMost523Yo4iKlMZ2AgOwpX6D
         AFcO1QG0jc/hJZ1YUHKTYy83YCPJRGC7Uy8SJEgwZpQP9HQ5xvI3+d2pa5askRabjf
         f1XIiBDFP4YaFLqHKFGDGFNvdFS/C+DrNzP/gadM=
Subject: patch "USB: gadget: legacy: fix an error code in eth_bind()" added to usb-linus
To:     dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 13:53:51 +0100
Message-ID: <16120976318645@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: legacy: fix an error code in eth_bind()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3e1f4a2e1184ae6ad7f4caf682ced9554141a0f4 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 28 Jan 2021 12:33:42 +0300
Subject: USB: gadget: legacy: fix an error code in eth_bind()

This code should return -ENOMEM if the allocation fails but it currently
returns success.

Fixes: 9b95236eebdb ("usb: gadget: ether: allocate and init otg descriptor by otg capabilities")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YBKE9rqVuJEOUWpW@mwanda
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/ether.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/ether.c b/drivers/usb/gadget/legacy/ether.c
index 30313b233680..99c7fc0d1d59 100644
--- a/drivers/usb/gadget/legacy/ether.c
+++ b/drivers/usb/gadget/legacy/ether.c
@@ -403,8 +403,10 @@ static int eth_bind(struct usb_composite_dev *cdev)
 		struct usb_descriptor_header *usb_desc;
 
 		usb_desc = usb_otg_descriptor_alloc(gadget);
-		if (!usb_desc)
+		if (!usb_desc) {
+			status = -ENOMEM;
 			goto fail1;
+		}
 		usb_otg_descriptor_init(gadget, usb_desc);
 		otg_desc[0] = usb_desc;
 		otg_desc[1] = NULL;
-- 
2.30.0


