Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE372A522C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgKCUr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgKCUrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74AC7223FD;
        Tue,  3 Nov 2020 20:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436444;
        bh=xXW6lvY6PaBRATMkfm5HyvrMwBlEn47zbSQ9JAX5Uus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1A8tPcJ2PXPv/PGbfS62X0EoOPc6umvW8dXvtPuhrmYVJSpr6AQ1qVqYkMD9MpyY
         POGhGQlPyAjbpJ6XpYmImYzjiW/TeKuG2DyWr/gLEERwiLVfdGRnCzoEGvQHJ9AUNt
         9znsAHdeBTbNSKaXxdLnt/9oTW/PoPoybsvXQDkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Pany <pany@fedoraproject.org>,
        Bastien Nocera <hadess@hadess.net>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 5.9 252/391] USB: apple-mfi-fastcharge: dont probe unhandled devices
Date:   Tue,  3 Nov 2020 21:35:03 +0100
Message-Id: <20201103203404.022427295@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

commit 0cb686692fd200db12dcfb8231e793c1c98aec41 upstream.

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
 drivers/usb/misc/apple-mfi-fastcharge.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/usb/misc/apple-mfi-fastcharge.c
+++ b/drivers/usb/misc/apple-mfi-fastcharge.c
@@ -163,17 +163,23 @@ static const struct power_supply_desc ap
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
@@ -220,6 +226,7 @@ static struct usb_device_driver mfi_fc_d
 	.probe =	mfi_fc_probe,
 	.disconnect =	mfi_fc_disconnect,
 	.id_table =	mfi_fc_id_table,
+	.match =	mfi_fc_match,
 	.generic_subclass = 1,
 };
 


