Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D37171ED8
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbgB0OE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387671AbgB0OE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9DAF24697;
        Thu, 27 Feb 2020 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812298;
        bh=eXF2rV6X3gjuGXC82hTXXdpx13WqeW4mL0pDL5T2YyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+Ih1VpPAI7oY9OkH3++lpQbZdwxcgiQLOhUwllNvs2P7ZAiZFNcSxHQcV4Acgjox
         MZHwROIiOJvbiFQJBExNr/KatmRGbuavPhhrC2/RRW3R8Z46oadMA+38/aTZGvT4dj
         v6CE/4p7oZ1F02podzPn8V/HC96G0mkJUbVMzyPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, edes <edes@gmx.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 24/97] USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
Date:   Thu, 27 Feb 2020 14:36:32 +0100
Message-Id: <20200227132218.539987473@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit bdd1b147b8026df0e4260b387026b251d888ed01 upstream.

This device has a broken vendor-specific altsetting for interface 1,
where endpoint 0x85 is declared as an isochronous endpoint despite being
used by interface 2 for audio capture.

Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x0926
  idProduct          0x0202
  bcdDevice            1.00
  iManufacturer           1 Sound Devices
  iProduct                2 USBPre2
  iSerial                 3 [...]
  bNumConfigurations      1

[...]

    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0126  1x 294 bytes
        bInterval               1

[...]

    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           4
        bDelay                  1 frames
        wFormatTag         0x0001 PCM
      AudioStreaming Interface Descriptor:
        bLength                26
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            6 Discrete
        tSamFreq[ 0]         8000
        tSamFreq[ 1]        16000
        tSamFreq[ 2]        24000
        tSamFreq[ 3]        32000
        tSamFreq[ 4]        44100
        tSamFreq[ 5]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0126  1x 294 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioStreaming Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         2 Decoded PCM samples
          wLockDelay         0x0000

Since commit 3e4f8e21c4f2 ("USB: core: fix check for duplicate
endpoints") USB core ignores any duplicate endpoints found during
descriptor parsing, but in this case we need to ignore the first
instance in order to avoid breaking the audio capture interface.

Fixes: 3e4f8e21c4f2 ("USB: core: fix check for duplicate endpoints")
Cc: stable <stable@vger.kernel.org>
Reported-by: edes <edes@gmx.net>
Tested-by: edes <edes@gmx.net>
Link: https://lore.kernel.org/r/20200201105829.5682c887@acme7.acmenet
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200203153830.26394-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -354,6 +354,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0904, 0x6103), .driver_info =
 			USB_QUIRK_LINEAR_FRAME_INTR_BINTERVAL },
 
+	/* Sound Devices USBPre2 */
+	{ USB_DEVICE(0x0926, 0x0202), .driver_info =
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Keytouch QWERTY Panel keyboard */
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
@@ -479,6 +483,7 @@ static const struct usb_device_id usb_am
  * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
  */
 static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info = 0x85 },
 	{ }
 };
 


