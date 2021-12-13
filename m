Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E0347242E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhLMJeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbhLMJeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:34:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB990C0698DC;
        Mon, 13 Dec 2021 01:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43117CE0B59;
        Mon, 13 Dec 2021 09:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBEC00446;
        Mon, 13 Dec 2021 09:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388041;
        bh=PLHJ28kK0huiOAHSs7CWRXqQtTBbKOj3IsXBCSih+eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jyrfKgxzF1hnR+xHPMyvExcSLYgSp3LvlbYZxpGXLmhrInJBhntKhZafet7hjS0i
         gXljGIS7UvPJiNoRkKKyuucaZamuM6/oI8P6qm6/TCua/4F6BzbAf+eGrxE+B1XCSm
         bWO4RZBcviWjpiSu4R6+e3/aRnAc5qH16f8mGmSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.9 01/42] HID: introduce hid_is_using_ll_driver
Date:   Mon, 13 Dec 2021 10:29:43 +0100
Message-Id: <20211213092926.625986930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit fc2237a724a9e448599076d7d23497f51e2f7441 upstream.

Although HID itself is transport-agnostic, occasionally a driver may
want to interact with the low-level transport that a device is connected
through. To do this, we need to know what kind of bus is in use. The
first guess may be to look at the 'bus' field of the 'struct hid_device',
but this field may be emulated in some cases (e.g. uhid).

More ideally, we can check which ll_driver a device is using. This
function introduces a 'hid_is_using_ll_driver' function and makes the
'struct hid_ll_driver' of the four most common transports accessible
through hid.h.

Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Acked-By: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c |    3 ++-
 drivers/hid/uhid.c                 |    3 ++-
 drivers/hid/usbhid/hid-core.c      |    3 ++-
 include/linux/hid.h                |   11 +++++++++++
 net/bluetooth/hidp/core.c          |    3 ++-
 5 files changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -875,7 +875,7 @@ static int i2c_hid_power(struct hid_devi
 	return 0;
 }
 
-static struct hid_ll_driver i2c_hid_ll_driver = {
+struct hid_ll_driver i2c_hid_ll_driver = {
 	.parse = i2c_hid_parse,
 	.start = i2c_hid_start,
 	.stop = i2c_hid_stop,
@@ -885,6 +885,7 @@ static struct hid_ll_driver i2c_hid_ll_d
 	.output_report = i2c_hid_output_report,
 	.raw_request = i2c_hid_raw_request,
 };
+EXPORT_SYMBOL_GPL(i2c_hid_ll_driver);
 
 static int i2c_hid_init_irq(struct i2c_client *client)
 {
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -372,7 +372,7 @@ static int uhid_hid_output_report(struct
 	return uhid_hid_output_raw(hid, buf, count, HID_OUTPUT_REPORT);
 }
 
-static struct hid_ll_driver uhid_hid_driver = {
+struct hid_ll_driver uhid_hid_driver = {
 	.start = uhid_hid_start,
 	.stop = uhid_hid_stop,
 	.open = uhid_hid_open,
@@ -381,6 +381,7 @@ static struct hid_ll_driver uhid_hid_dri
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
 };
+EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
 #ifdef CONFIG_COMPAT
 
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1272,7 +1272,7 @@ static int usbhid_idle(struct hid_device
 	return hid_set_idle(dev, ifnum, report, idle);
 }
 
-static struct hid_ll_driver usb_hid_driver = {
+struct hid_ll_driver usb_hid_driver = {
 	.parse = usbhid_parse,
 	.start = usbhid_start,
 	.stop = usbhid_stop,
@@ -1285,6 +1285,7 @@ static struct hid_ll_driver usb_hid_driv
 	.output_report = usbhid_output_report,
 	.idle = usbhid_idle,
 };
+EXPORT_SYMBOL_GPL(usb_hid_driver);
 
 static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -762,6 +762,17 @@ struct hid_ll_driver {
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
 };
 
+extern struct hid_ll_driver i2c_hid_ll_driver;
+extern struct hid_ll_driver hidp_hid_driver;
+extern struct hid_ll_driver uhid_hid_driver;
+extern struct hid_ll_driver usb_hid_driver;
+
+static inline bool hid_is_using_ll_driver(struct hid_device *hdev,
+		struct hid_ll_driver *driver)
+{
+	return hdev->ll_driver == driver;
+}
+
 #define	PM_HINT_FULLON	1<<5
 #define PM_HINT_NORMAL	1<<1
 
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -734,7 +734,7 @@ static void hidp_stop(struct hid_device
 	hid->claimed = 0;
 }
 
-static struct hid_ll_driver hidp_hid_driver = {
+struct hid_ll_driver hidp_hid_driver = {
 	.parse = hidp_parse,
 	.start = hidp_start,
 	.stop = hidp_stop,
@@ -743,6 +743,7 @@ static struct hid_ll_driver hidp_hid_dri
 	.raw_request = hidp_raw_request,
 	.output_report = hidp_output_report,
 };
+EXPORT_SYMBOL_GPL(hidp_hid_driver);
 
 /* This function sets up the hid device. It does not add it
    to the HID system. That is done in hidp_add_connection(). */


