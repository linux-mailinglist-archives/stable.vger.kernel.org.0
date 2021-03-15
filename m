Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A000D33B816
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhCOOCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhCON76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F03064F33;
        Mon, 15 Mar 2021 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816781;
        bh=c42JkQYN7HQ2N5lTs5IwB6B2pKsBaTe1kHYP5e7/gr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKkSq2mHIsHoMGsxm1KdHHNfsz3kP3Mau7Dkt0YA5QKS2m/3i4LU1HxGZyEP5PaVI
         E47YVRvGG2eO3anUjZTBKkuFftm1YCBNTbOfAaMzg7t/ldURPKuoK+UhSRCOJQIo5+
         qZpofxsTSkqQy3xCtMWWu3obSNxUcl2o9vGu4m7s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niv Sardi <xaiki@evilgiggle.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 57/95] USB: serial: ch341: add new Product ID
Date:   Mon, 15 Mar 2021 14:57:27 +0100
Message-Id: <20210315135742.149103409@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Niv Sardi <xaiki@evilgiggle.com>

commit 5563b3b6420362c8a1f468ca04afe6d5f0a8d0a3 upstream.

Add PID for CH340 that's found on cheap programmers.

The driver works flawlessly as soon as the new PID (0x9986) is added to it.
These look like ANU232MI but ship with a ch341 inside. They have no special
identifiers (mine only has the string "DB9D20130716" printed on the PCB and
nothing identifiable on the packaging. The merchant i bought it from
doesn't sell these anymore).

the lsusb -v output is:
Bus 001 Device 009: ID 9986:7523
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x9986
  idProduct          0x7523
  bcdDevice            2.54
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0027
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower               96mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      2
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               1

Signed-off-by: Niv Sardi <xaiki@evilgiggle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -88,6 +88,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
 	{ USB_DEVICE(0x4348, 0x5523) },
+	{ USB_DEVICE(0x9986, 0x7523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


