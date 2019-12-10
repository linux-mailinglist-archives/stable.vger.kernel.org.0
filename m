Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6744711847D
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 11:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfLJKKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 05:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbfLJKKZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 05:10:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A69A207FF;
        Tue, 10 Dec 2019 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575972624;
        bh=Jp//akhUxjYVGAwjIKDKLeTsRV+zBVpynjyACNPGRAU=;
        h=Subject:To:From:Date:From;
        b=qeR8pfe9Ni39oazD/JupgdJC5rII6PKwSZdltHNLvSKwI9DwimIcuW5anBhxuvlyS
         6zpk2lzG56w7E4EP80/zX3wJ+8+2uL2DmsqZ8IgIsS5ODzqgaPL68jJ1RZ8ZZcQAbv
         9cr5CV23+ArRw9Jqaw9kcve5+E+/C3GcD4EGTXX0=
Subject: patch "staging: gigaset: fix general protection fault on probe" added to staging-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org, hjlipp@web.de,
        stable@vger.kernel.org, tilman@imap.cc
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Dec 2019 11:10:22 +0100
Message-ID: <1575972622203210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: gigaset: fix general protection fault on probe

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 53f35a39c3860baac1e5ca80bf052751cfb24a99 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 2 Dec 2019 09:56:08 +0100
Subject: staging: gigaset: fix general protection fault on probe

Fix a general protection fault when accessing the endpoint descriptors
which could be triggered by a malicious device due to missing sanity
checks on the number of endpoints.

Reported-by: syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Fixes: 07dc1f9f2f80 ("[PATCH] isdn4linux: Siemens Gigaset drivers - M105 USB DECT adapter")
Cc: stable <stable@vger.kernel.org>     # 2.6.17
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191202085610.12719-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/isdn/gigaset/usb-gigaset.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/isdn/gigaset/usb-gigaset.c b/drivers/staging/isdn/gigaset/usb-gigaset.c
index 1b9b43659bdf..5e393e7dde45 100644
--- a/drivers/staging/isdn/gigaset/usb-gigaset.c
+++ b/drivers/staging/isdn/gigaset/usb-gigaset.c
@@ -685,6 +685,11 @@ static int gigaset_probe(struct usb_interface *interface,
 		return -ENODEV;
 	}
 
+	if (hostif->desc.bNumEndpoints < 2) {
+		dev_err(&interface->dev, "missing endpoints\n");
+		return -ENODEV;
+	}
+
 	dev_info(&udev->dev, "%s: Device matched ... !\n", __func__);
 
 	/* allocate memory for our device state and initialize it */
-- 
2.24.0


