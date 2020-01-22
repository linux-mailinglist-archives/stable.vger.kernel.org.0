Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E08214511E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgAVJhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732283AbgAVJhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:37:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E203824693;
        Wed, 22 Jan 2020 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685821;
        bh=c+I0YrXZ+ySONA2pY/RlMnaMzzVIzdvUQX6zX+euRoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8m9dGes6xxjtGA2dteKWCy4qhomuyxGZdJtVRnGABxxDFJxISCdfu+gxsvR+mY8g
         a9VrADHH/q4tKKqFRpO4RfIE66HzxlmlNMmhqB74r7den1hLlgEoGs7EYObH9oYpCn
         L6DbBBxdQPypbmmP66K5j9sdV0/KWnRTlR2tUXGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jer=C3=B3nimo=20Borque?= <jeronimo@borque.com.ar>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 57/97] USB: serial: simple: Add Motorola Solutions TETRA MTP3xxx and MTP85xx
Date:   Wed, 22 Jan 2020 10:29:01 +0100
Message-Id: <20200122092805.588542909@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerónimo Borque <jeronimo@borque.com.ar>

commit 260e41ac4dd3e5acb90be624c03ba7f019615b75 upstream.

Add device-ids for the Motorola Solutions TETRA radios MTP3xxx series
and MTP85xx series

$ lsusb -vd 0cad:

Bus 001 Device 009: ID 0cad:9015 Motorola CGISS TETRA PEI interface
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0cad Motorola CGISS
  idProduct          0x9015
  bcdDevice           24.16
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0037
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          3
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
      bInterfaceSubClass      0
      bInterfaceProtocol      0
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
      bInterfaceSubClass      0
      bInterfaceProtocol      0
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

Bus 001 Device 010: ID 0cad:9013 Motorola CGISS TETRA PEI interface
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0cad Motorola CGISS
  idProduct          0x9013
  bcdDevice           24.16
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0037
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          3
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
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0

Signed-off-by: Jerónimo Borque <jeronimo@borque.com.ar>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial-simple.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -89,6 +89,8 @@ DEVICE(moto_modem, MOTO_IDS);
 #define MOTOROLA_TETRA_IDS()			\
 	{ USB_DEVICE(0x0cad, 0x9011) },	/* Motorola Solutions TETRA PEI */ \
 	{ USB_DEVICE(0x0cad, 0x9012) },	/* MTP6550 */ \
+	{ USB_DEVICE(0x0cad, 0x9013) },	/* MTP3xxx */ \
+	{ USB_DEVICE(0x0cad, 0x9015) },	/* MTP85xx */ \
 	{ USB_DEVICE(0x0cad, 0x9016) }	/* TPG2200 */
 DEVICE(motorola_tetra, MOTOROLA_TETRA_IDS);
 


