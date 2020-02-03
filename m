Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B70150A00
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 16:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgBCPlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 10:41:44 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35012 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgBCPln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 10:41:43 -0500
Received: by mail-lj1-f193.google.com with SMTP id q8so15144199ljb.2;
        Mon, 03 Feb 2020 07:41:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GRwf1Zr0S0eqNXMesfKJOAZkJbyC2lJppiu9wQG+Y8s=;
        b=Laey+IaMXan2tceUk0VblietoCm1xK3X88GU4086cGZdmKu2AJlNsoQ7iNRUynVEqy
         Oi/GBcG9cFfI2dLlJ7Dg27dqRZQGPZs4UvaVvmvE55WXKP/lQivGS0tKZDnSMpjgculY
         qBWO0POF5f5QKtoKuwIvufuhlaySVSDpR22Q2Uno5rChUqtcK1Ec8FxjI/25ekLdMhPT
         87hrX08bopgnhuj3wl7JL44+uTqTkk67sfw6H0fu04Z9jr4Y+HZnb/jky1pK4hhNyFen
         YBWccPQ2RZzhfaP9EhX7gtGWqGlva5Qn2U/PLwVocggO3bhsjBTq/VdLfRlkr/Y55USV
         YQ2Q==
X-Gm-Message-State: APjAAAUzZiWDXSB9tLB125KPrzYkZqs3B0GieR4Gdj9WwB3HuILXh4oO
        INhVOvpTL5f1zHy1iE5iGfE=
X-Google-Smtp-Source: APXvYqxx/lAeWSRyRBOjWIkLaDqU8MM19yrEQepQKohv2/BLvwm9fgH1E3O7NpdY6Wk3L9Ce8AIvsg==
X-Received: by 2002:a2e:8e95:: with SMTP id z21mr14039355ljk.119.1580744500701;
        Mon, 03 Feb 2020 07:41:40 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id z205sm9010551lfa.52.2020.02.03.07.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 07:41:39 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iydrA-0006tG-Am; Mon, 03 Feb 2020 16:41:48 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>, edes <edes@gmx.net>,
        Takashi Iwai <tiwai@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] USB: quirks: blacklist duplicate ep on Sound Devices USBPre2
Date:   Mon,  3 Feb 2020 16:38:29 +0100
Message-Id: <20200203153830.26394-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203153830.26394-1-johan@kernel.org>
References: <20200203153830.26394-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/core/quirks.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 56c8dffaf5f5..f27468966a3d 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -354,6 +354,10 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0904, 0x6103), .driver_info =
 			USB_QUIRK_LINEAR_FRAME_INTR_BINTERVAL },
 
+	/* Sound Devices USBPre2 */
+	{ USB_DEVICE(0x0926, 0x0202), .driver_info =
+			USB_QUIRK_ENDPOINT_BLACKLIST },
+
 	/* Keytouch QWERTY Panel keyboard */
 	{ USB_DEVICE(0x0926, 0x3333), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
@@ -479,6 +483,7 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
  * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
  */
 static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ USB_DEVICE_INTERFACE_NUMBER(0x0926, 0x0202, 1), .driver_info = 0x85 },
 	{ }
 };
 
-- 
2.24.1

