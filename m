Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21C82834CE
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 13:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgJELT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 07:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgJELT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 07:19:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C530A20774;
        Mon,  5 Oct 2020 11:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601896765;
        bh=onXExF87+ULxyrRgkpmcwjE1zxDUaP1y63poQ8aUC9Y=;
        h=Subject:To:From:Date:From;
        b=fn897dtC8lAv1iBCmGTMv008mtNkIqDmRPJ8lrzZuxak7sTrsHtPHAntrXvaW6bQ9
         ZG2GEhWDOQK9hWAZF/KB/leuqs6LDvXtuAbgdvjFRrFO2VWjUXOO/wjqwhOWLV87cn
         yryMoeCQlPHVKoQWyVuG08LdnmJO/7sF40QNUEcw=
Subject: patch "usb: cdc-acm: add quirk to blacklist ETAS ES58X devices" added to usb-testing
To:     mailhol.vincent@wanadoo.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Oct 2020 13:20:10 +0200
Message-ID: <1601896810199151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From a4f88430af896bf34ec25a7a5f0e053fb3d928e0 Mon Sep 17 00:00:00 2001
From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Date: Sat, 3 Oct 2020 00:41:51 +0900
Subject: usb: cdc-acm: add quirk to blacklist ETAS ES58X devices

The ES58X devices has a CDC ACM interface (used for debug
purpose). During probing, the device is thus recognized as USB Modem
(CDC ACM), preventing the etas-es58x module to load:
  usbcore: registered new interface driver etas_es58x
  usb 1-1.1: new full-speed USB device number 14 using xhci_hcd
  usb 1-1.1: New USB device found, idVendor=108c, idProduct=0159, bcdDevice= 1.00
  usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 1-1.1: Product: ES581.4
  usb 1-1.1: Manufacturer: ETAS GmbH
  usb 1-1.1: SerialNumber: 2204355
  cdc_acm 1-1.1:1.0: No union descriptor, testing for castrated device
  cdc_acm 1-1.1:1.0: ttyACM0: USB ACM device

Thus, these have been added to the ignore list in
drivers/usb/class/cdc-acm.c

N.B. Future firmware release of the ES58X will remove the CDC-ACM
interface.

`lsusb -v` of the three devices variant (ES581.4, ES582.1 and
ES584.1):

  Bus 001 Device 011: ID 108c:0159 Robert Bosch GmbH ES581.4
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               1.10
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    idVendor           0x108c Robert Bosch GmbH
    idProduct          0x0159
    bcdDevice            1.00
    iManufacturer           1 ETAS GmbH
    iProduct                2 ES581.4
    iSerial                 3 2204355
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0035
      bNumInterfaces          1
      bConfigurationValue     1
      iConfiguration          5 Bus Powered Configuration
      bmAttributes         0x80
        (Bus Powered)
      MaxPower              100mA
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        0
        bAlternateSetting       0
        bNumEndpoints           3
        bInterfaceClass         2 Communications
        bInterfaceSubClass      2 Abstract (modem)
        bInterfaceProtocol      0
        iInterface              4 ACM Control Interface
        CDC Header:
          bcdCDC               1.10
        CDC Call Management:
          bmCapabilities       0x01
            call management
          bDataInterface          0
        CDC ACM:
          bmCapabilities       0x06
            sends break
            line coding and serial state
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x81  EP 1 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0010  1x 16 bytes
          bInterval              10
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
          bEndpointAddress     0x03  EP 3 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval               0
  Device Status:     0x0000
    (Bus Powered)

  Bus 001 Device 012: ID 108c:0168 Robert Bosch GmbH ES582
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    idVendor           0x108c Robert Bosch GmbH
    idProduct          0x0168
    bcdDevice            1.00
    iManufacturer           1 ETAS GmbH
    iProduct                2 ES582
    iSerial                 3 0108933
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0043
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
        bNumEndpoints           1
        bInterfaceClass         2 Communications
        bInterfaceSubClass      2 Abstract (modem)
        bInterfaceProtocol      1 AT-commands (v.25ter)
        iInterface              0
        CDC Header:
          bcdCDC               1.10
        CDC ACM:
          bmCapabilities       0x02
            line coding and serial state
        CDC Union:
          bMasterInterface        0
          bSlaveInterface         1
        CDC Call Management:
          bmCapabilities       0x03
            call management
            use DataInterface
          bDataInterface          1
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x83  EP 3 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval              16
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        1
        bAlternateSetting       0
        bNumEndpoints           2
        bInterfaceClass        10 CDC Data
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
          bEndpointAddress     0x02  EP 2 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0200  1x 512 bytes
          bInterval               0
  Device Qualifier (for other device speed):
    bLength                10
    bDescriptorType         6
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    bNumConfigurations      1
  Device Status:     0x0000
    (Bus Powered)

  Bus 001 Device 013: ID 108c:0169 Robert Bosch GmbH ES584.1
  Device Descriptor:
    bLength                18
    bDescriptorType         1
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    idVendor           0x108c Robert Bosch GmbH
    idProduct          0x0169
    bcdDevice            1.00
    iManufacturer           1 ETAS GmbH
    iProduct                2 ES584.1
    iSerial                 3 0100320
    bNumConfigurations      1
    Configuration Descriptor:
      bLength                 9
      bDescriptorType         2
      wTotalLength       0x0043
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
        bNumEndpoints           1
        bInterfaceClass         2 Communications
        bInterfaceSubClass      2 Abstract (modem)
        bInterfaceProtocol      1 AT-commands (v.25ter)
        iInterface              0
        CDC Header:
          bcdCDC               1.10
        CDC ACM:
          bmCapabilities       0x02
            line coding and serial state
        CDC Union:
          bMasterInterface        0
          bSlaveInterface         1
        CDC Call Management:
          bmCapabilities       0x03
            call management
            use DataInterface
          bDataInterface          1
        Endpoint Descriptor:
          bLength                 7
          bDescriptorType         5
          bEndpointAddress     0x83  EP 3 IN
          bmAttributes            3
            Transfer Type            Interrupt
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0040  1x 64 bytes
          bInterval              16
      Interface Descriptor:
        bLength                 9
        bDescriptorType         4
        bInterfaceNumber        1
        bAlternateSetting       0
        bNumEndpoints           2
        bInterfaceClass        10 CDC Data
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
          bEndpointAddress     0x02  EP 2 OUT
          bmAttributes            2
            Transfer Type            Bulk
            Synch Type               None
            Usage Type               Data
          wMaxPacketSize     0x0200  1x 512 bytes
          bInterval               0
  Device Qualifier (for other device speed):
    bLength                10
    bDescriptorType         6
    bcdUSB               2.00
    bDeviceClass            2 Communications
    bDeviceSubClass         0
    bDeviceProtocol         0
    bMaxPacketSize0        64
    bNumConfigurations      1
  Device Status:     0x0000
    (Bus Powered)

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201002154219.4887-8-mailhol.vincent@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 1d301b92de2d..30ef946a8e1a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1900,6 +1900,17 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = IGNORE_DEVICE,
 	},
 
+	/* Exclude ETAS ES58x */
+	{ USB_DEVICE(0x108c, 0x0159), /* ES581.4 */
+	.driver_info = IGNORE_DEVICE,
+	},
+	{ USB_DEVICE(0x108c, 0x0168), /* ES582.1 */
+	.driver_info = IGNORE_DEVICE,
+	},
+	{ USB_DEVICE(0x108c, 0x0169), /* ES584.1 */
+	.driver_info = IGNORE_DEVICE,
+	},
+
 	{ USB_DEVICE(0x1bc7, 0x0021), /* Telit 3G ACM only composition */
 	.driver_info = SEND_ZERO_PACKET,
 	},
-- 
2.28.0


