Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D975054C5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbiDRNMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241634AbiDRNI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:08:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C324A2B274;
        Mon, 18 Apr 2022 05:47:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A3861267;
        Mon, 18 Apr 2022 12:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11624C385A1;
        Mon, 18 Apr 2022 12:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286069;
        bh=D0KhdQUtd4xsL/VSZoclQHtl4B5v9CRGQPzcl2JCxKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bT2pUjxHf1OL31atDgvzwcrGebLrhyZ28cMj8arYbq5UnFqrwxPmGCQ5K3FM6jdF/
         loJTxb5HmbEeRcJ5ON4eXDC7XBVgGvBjw+x9IiPiPndGpPV141nZDvAXPcmL+WIbAh
         urdjDJYy9M2RC8C+L+76Cc4d4lXAnwz+4NqUBmlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 002/284] USB: serial: simple: add Nokia phone driver
Date:   Mon, 18 Apr 2022 14:09:43 +0200
Message-Id: <20220418121210.763060320@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -65,6 +65,7 @@ config USB_SERIAL_SIMPLE
 		- Libtransistor USB console
 		- a number of Motorola phones
 		- Motorola Tetra devices
+		- Nokia mobile phones
 		- Novatel Wireless GPS receivers
 		- Siemens USB/MPI adapter.
 		- ViVOtech ViVOpay USB device.
--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -94,6 +94,11 @@ DEVICE(moto_modem, MOTO_IDS);
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
@@ -126,6 +131,7 @@ static struct usb_serial_driver * const
 	&vivopay_device,
 	&moto_modem_device,
 	&motorola_tetra_device,
+	&nokia_device,
 	&novatel_gps_device,
 	&hp4x_device,
 	&suunto_device,
@@ -143,6 +149,7 @@ static const struct usb_device_id id_tab
 	VIVOPAY_IDS(),
 	MOTO_IDS(),
 	MOTOROLA_TETRA_IDS(),
+	NOKIA_IDS(),
 	NOVATEL_IDS(),
 	HP4X_IDS(),
 	SUUNTO_IDS(),


