Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738C965843D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiL1Q4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbiL1QzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6B81EEEB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07893B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46846C433D2;
        Wed, 28 Dec 2022 16:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246208;
        bh=7VuaGYkV0nDTDJVIDF2az2eEPos1FRhz67/jOmyknqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfoyxCdgBEaIU6QJA083RIOM8S4J9HIT9YY5KbnbEV1GaA1zMs8ZjpR3PJIsULIMS
         6L57g4M5veNXdUiCsi7UcXC3evxG2YXcZN96WatH8Az0jkwG/YfGrD3qksjXlW885u
         g6Gdgn4sxs9dn3czBzqHVPzYC++6TsCuNzXudwFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: [PATCH 6.0 1031/1073] HID: logitech-hidpp: Guard FF init code against non-USB devices
Date:   Wed, 28 Dec 2022 15:43:39 +0100
Message-Id: <20221228144356.196545215@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bastien Nocera <hadess@hadess.net>

commit 0e13e7b448005612972eae36c0f698c21d1e2f8a upstream.

The Force Feedback code assumes that all the devices passed to it will
be USB devices, but that might not be the case for emulated devices.
Guard against a crash by checking the device type before poking at USB
properties.

Cc: stable@vger.kernel.org # v5.16+
Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221215154416.111704-1-hadess@hadess.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-hidpp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2545,12 +2545,17 @@ static int hidpp_ff_init(struct hidpp_de
 	struct hid_device *hid = hidpp->hid_dev;
 	struct hid_input *hidinput;
 	struct input_dev *dev;
-	const struct usb_device_descriptor *udesc = &(hid_to_usb_dev(hid)->descriptor);
-	const u16 bcdDevice = le16_to_cpu(udesc->bcdDevice);
+	struct usb_device_descriptor *udesc;
+	u16 bcdDevice;
 	struct ff_device *ff;
 	int error, j, num_slots = data->num_effects;
 	u8 version;
 
+	if (!hid_is_usb(hid)) {
+		hid_err(hid, "device is not USB\n");
+		return -ENODEV;
+	}
+
 	if (list_empty(&hid->inputs)) {
 		hid_err(hid, "no inputs found\n");
 		return -ENODEV;
@@ -2564,6 +2569,8 @@ static int hidpp_ff_init(struct hidpp_de
 	}
 
 	/* Get firmware release */
+	udesc = &(hid_to_usb_dev(hid)->descriptor);
+	bcdDevice = le16_to_cpu(udesc->bcdDevice);
 	version = bcdDevice & 255;
 
 	/* Set supported force feedback capabilities */


