Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848AC29D6B9
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgJ1WSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731760AbgJ1WRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E13922470C;
        Wed, 28 Oct 2020 12:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603887870;
        bh=L+B8zxjrA5EUfg8qcqe1TCBkrXEXb8AbQWiAlYkk3yg=;
        h=Subject:To:From:Date:From;
        b=ecIPNE4dG/dtCvCJCsRdtjH8m20bZuX/+m3hpApWwCYhMKm0p2FuIxQOHEOVVQp5D
         qFJ7bsI5JFEAzJmrndlVzuUNTnjs8YtnD7Z3+3EXJz8UPswaNAR8jzZSiXx/nnnZtL
         ELP5M+NT/uOxnn040qvpaVdKce8FulvTNhw6HQNo=
Subject: patch "USB: apple-mfi-fastcharge: don't probe unhandled devices" added to usb-linus
To:     hadess@hadess.net, gregkh@linuxfoundation.org, m.v.b@runbox.com,
        pany@fedoraproject.org, stable@vger.kernel.org,
        stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Oct 2020 13:25:14 +0100
Message-ID: <16038879141257@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: apple-mfi-fastcharge: don't probe unhandled devices

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0cb686692fd200db12dcfb8231e793c1c98aec41 Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Thu, 22 Oct 2020 09:55:21 -0400
Subject: USB: apple-mfi-fastcharge: don't probe unhandled devices

From: Bastien Nocera <hadess@hadess.net>

Contrary to the comment above the id table, we didn't implement a match
function. This meant that every single Apple device that was already
plugged in to the computer would have its device driver reprobed
when the apple-mfi-fastcharge driver was loaded, eg. the SD card reader
could be reprobed when the apple-mfi-fastcharge after pivoting root
during boot up and the module became available.

Make sure that the driver probe isn't being run for unsupported
devices by adding a match function that checks the product ID, in
addition to the id_table checking the vendor ID.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1878347
Link: https://lore.kernel.org/linux-usb/CAE3RAxt0WhBEz8zkHrVO5RiyEOasayy1QUAjsv-pB0fAbY1GSw@mail.gmail.com/
Fixes: 249fa8217b84 ("USB: Add driver to control USB fast charge for iOS devices")
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
[m.v.b: Add Link and Reported-by tags to the commit message]
Reported-by: Pany <pany@fedoraproject.org>
Tested-by: Pan (Pany) YUAN <pany@fedoraproject.org>
Tested-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Link: https://lore.kernel.org/r/20201022135521.375211-3-m.v.b@runbox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/apple-mfi-fastcharge.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/apple-mfi-fastcharge.c b/drivers/usb/misc/apple-mfi-fastcharge.c
index b403094a6b3a..579d8c84de42 100644
--- a/drivers/usb/misc/apple-mfi-fastcharge.c
+++ b/drivers/usb/misc/apple-mfi-fastcharge.c
@@ -163,17 +163,23 @@ static const struct power_supply_desc apple_mfi_fc_desc = {
 	.property_is_writeable  = apple_mfi_fc_property_is_writeable
 };
 
+static bool mfi_fc_match(struct usb_device *udev)
+{
+	int idProduct;
+
+	idProduct = le16_to_cpu(udev->descriptor.idProduct);
+	/* See comment above mfi_fc_id_table[] */
+	return (idProduct >= 0x1200 && idProduct <= 0x12ff);
+}
+
 static int mfi_fc_probe(struct usb_device *udev)
 {
 	struct power_supply_config battery_cfg = {};
 	struct mfi_device *mfi = NULL;
-	int err, idProduct;
+	int err;
 
-	idProduct = le16_to_cpu(udev->descriptor.idProduct);
-	/* See comment above mfi_fc_id_table[] */
-	if (idProduct < 0x1200 || idProduct > 0x12ff) {
+	if (!mfi_fc_match(udev))
 		return -ENODEV;
-	}
 
 	mfi = kzalloc(sizeof(struct mfi_device), GFP_KERNEL);
 	if (!mfi) {
@@ -220,6 +226,7 @@ static struct usb_device_driver mfi_fc_driver = {
 	.probe =	mfi_fc_probe,
 	.disconnect =	mfi_fc_disconnect,
 	.id_table =	mfi_fc_id_table,
+	.match =	mfi_fc_match,
 	.generic_subclass = 1,
 };
 
-- 
2.29.1


