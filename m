Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8166629607B
	for <lists+stable@lfdr.de>; Thu, 22 Oct 2020 15:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895101AbgJVNzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Oct 2020 09:55:48 -0400
Received: from aibo.runbox.com ([91.220.196.211]:54286 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2443376AbgJVNzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Oct 2020 09:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
         s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
        :Message-Id:Date:Subject:Cc:To:From;
        bh=dwydMXV798nhciCIFQ/gte+aPSvBA0iFTXl8RFK4Cx4=; b=hNqwVXzGsLM879CRLqo7vbFSmL
        9AD/XCUxnDAWHTP4tT61cCBrlQA00txU4cdgAN32aVImTfHlvhHB+wxnB2Egyyvevr5FB5qXmqA3Q
        bZpdVet/Suf1T5ZWqndbrBFhTFgxUF5gLXLprcG90qvjgxvVplhzPCqRle6RN2NDjuJD6wueNg8S6
        3LzAetKGpJ96kOIbEMZb2Grzv/x4Upr0X8M35Rc4laTlzM9d+tY++WME0kGbPBLjF8wBy2TYAnFLx
        I2Ql14cnrbQYg3kLMTRPebSS1mdbgL+cDbvEYb8nonDr3hbh05UFZ+xnO28yXJCOkyDGX03SJD7rq
        gtpszkzQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <m.v.b@runbox.com>)
        id 1kVb4C-0001Z9-7V; Thu, 22 Oct 2020 15:55:44 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated alias (536975)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1kVb44-0008Qw-6o; Thu, 22 Oct 2020 15:55:36 +0200
From:   "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     linux-usb@vger.kernel.org
Cc:     Bastien Nocera <hadess@hadess.net>, Pany <pany@fedoraproject.org>,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "M . Vefa Bicakci" <m.v.b@runbox.com>
Subject: [PATCH 2/2] USB: apple-mfi-fastcharge: don't probe unhandled devices
Date:   Thu, 22 Oct 2020 09:55:21 -0400
Message-Id: <20201022135521.375211-3-m.v.b@runbox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201022135521.375211-1-m.v.b@runbox.com>
References: <4cc0e162-c607-3fdf-30c9-1b3a77f6cf20@runbox.com>
 <20201022135521.375211-1-m.v.b@runbox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

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

Fixes: 249fa8217b84 ("USB: Add driver to control USB fast charge for iOS devices")
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Reported-by: Pany <pany@fedoraproject.org>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1878347
Link: https://lore.kernel.org/linux-usb/CAE3RAxt0WhBEz8zkHrVO5RiyEOasayy1QUAjsv-pB0fAbY1GSw@mail.gmail.com/
Cc: <stable@vger.kernel.org> # 5.8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
[m.v.b: Add Link and Reported-by tags to the commit message]
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
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
2.26.2

