Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB841187E3
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 13:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfLJMQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 07:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727242AbfLJMQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 07:16:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B222073D;
        Tue, 10 Dec 2019 12:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575980214;
        bh=vzbqWy0WZHItEkDX58vtHFdIfgolK2Z2lilYlCJ22Vw=;
        h=Subject:To:From:Date:From;
        b=ydPm3ezGr8mKuf/xnRjVEOb5xhqTxApFouTbq9g5n2ZC5v03d0hKlrulsto2nb634
         UyAzLyjPgjIWEAFsW5hFqyfdVOJPqzmjZHZWetgR4VuBRvp6CBl6duSrFZjcdbUHbr
         HZvXgCrsWu8JnJvvD1RhXzYDtxfI8HD626Z/oMMM=
Subject: patch "USB: adutux: fix interface sanity check" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 13:16:44 +0100
Message-ID: <157598020414898@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: adutux: fix interface sanity check

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3c11c4bed02b202e278c0f5c319ae435d7fb9815 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 10 Dec 2019 12:25:59 +0100
Subject: USB: adutux: fix interface sanity check

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 03270634e242 ("USB: Add ADU support for Ontrak ADU devices")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210112601.3561-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/adutux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 6f5edb9fc61e..d8d157c4c271 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -669,7 +669,7 @@ static int adu_probe(struct usb_interface *interface,
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 
-	res = usb_find_common_endpoints_reverse(&interface->altsetting[0],
+	res = usb_find_common_endpoints_reverse(interface->cur_altsetting,
 			NULL, NULL,
 			&dev->interrupt_in_endpoint,
 			&dev->interrupt_out_endpoint);
-- 
2.24.0


