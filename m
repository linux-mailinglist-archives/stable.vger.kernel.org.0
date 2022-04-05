Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A925A4F2EF6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245693AbiDEKje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238739AbiDEJcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31FCFDB;
        Tue,  5 Apr 2022 02:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C8AE615E5;
        Tue,  5 Apr 2022 09:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EBDC385A0;
        Tue,  5 Apr 2022 09:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150395;
        bh=j5OThtCkKw8wixPROr3bHPlF7VL+nQO2b6T38K84FyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPuZYEbDFkjZHgQmZwVXy2Ij8BIZJDJURDv6ajsc74PqCje/R0/cHgDygaMCwTwhE
         hV3bmko1ZO1+xVVvIlPziu7447xJgw3jIfI31shjqHwqDIThOleT9PCMbBfbjuzbtj
         BUHdWWaP+h58s7hhxTmXtJ9Eiqpxsv3WnjWeWRWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 005/913] USB: serial: simple: add Nokia phone driver
Date:   Tue,  5 Apr 2022 09:17:47 +0200
Message-Id: <20220405070339.972994154@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit c4b9c570965f75d0d55e639747f1e5ccdad2fae0 upstream.

Add a new "simple" driver for certain Nokia phones, including Nokia 130
(RM-1035) which exposes two serial ports in "charging only" mode:

Bus 001 Device 009: ID 0421:069a Nokia Mobile Phones 130 [RM-1035] (Charging only)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0421 Nokia Mobile Phones
  idProduct          0x069a 130 [RM-1035] (Charging only)
  bcdDevice            1.00
  iManufacturer           1 Nokia
  iProduct                2 Nokia 130 (RM-1035)
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0037
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220228084919.10656-1-johan@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/Kconfig             |    1 +
 drivers/usb/serial/usb-serial-simple.c |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -66,6 +66,7 @@ config USB_SERIAL_SIMPLE
 		- Libtransistor USB console
 		- a number of Motorola phones
 		- Motorola Tetra devices
+		- Nokia mobile phones
 		- Novatel Wireless GPS receivers
 		- Siemens USB/MPI adapter.
 		- ViVOtech ViVOpay USB device.
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -91,6 +91,11 @@ DEVICE(moto_modem, MOTO_IDS);
 	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
 
+/* Nokia mobile phone driver */
+#define NOKIA_IDS()			\
+	{ USB_DEVICE(0x0421, 0x069a) }	/* Nokia 130 (RM-1035) */
+DEVICE(nokia, NOKIA_IDS);
+
 /* Novatel Wireless GPS driver */
 #define NOVATEL_IDS()			\
 	{ USB_DEVICE(0x09d7, 0x0100) }	/* NovAtel FlexPack GPS */
@@ -123,6 +128,7 @@ static struct usb_serial_driver * const
 	&vivopay_device,
 	&moto_modem_device,
 	&motorola_tetra_device,
+	&nokia_device,
 	&novatel_gps_device,
 	&hp4x_device,
 	&suunto_device,
@@ -140,6 +146,7 @@ static const struct usb_device_id id_tab
 	VIVOPAY_IDS(),
 	MOTO_IDS(),
 	MOTOROLA_TETRA_IDS(),
+	NOKIA_IDS(),
 	NOVATEL_IDS(),
 	HP4X_IDS(),
 	SUUNTO_IDS(),


