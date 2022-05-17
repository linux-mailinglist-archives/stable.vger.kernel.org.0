Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE9B52A7B8
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 18:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350800AbiEQQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 12:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiEQQRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 12:17:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3332C3A5D5;
        Tue, 17 May 2022 09:17:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAD73B81852;
        Tue, 17 May 2022 16:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720D1C385B8;
        Tue, 17 May 2022 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652804267;
        bh=PGOrd5teCrAeWFXQiRL2inqdYz68ew6fclBCZcn6LfI=;
        h=From:To:Cc:Subject:Date:From;
        b=hVyGgpz/J1ntQVjgyTm9nMpPl8n1sEwc0AI8BI7sgKQnthTaNePsHnm4RU3fhbVrG
         8I66u9NK2g2xV0DTYLkeYxrAinjcggo4OpeudvXJg5iMxV3P5Hj7Vr0vRiFLFIndoH
         NLrKXN+q9JTAIGVPLyQJj3XsOrlAgPCuTTtXd5P/jTH1mhl32NXCvc95Y35Y8byHcA
         fTgAAY8N5UGruh5F49IKbrHQxeQj5UW6vTCmoDsgFtRGAh97RudBVV5Wb7OsKfXGlg
         48m2/OsecwiJRyPOwzJEGzvY1C0dMlYgXuv6fwcwcTTbteZ7Pb3PCRtwxhh2slkvjo
         VwlHGaqeCU88w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nqztK-0003T0-Rq; Tue, 17 May 2022 18:17:47 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Gary van der Merwe <garyvdm@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] USB: serial: pl2303: fix type detection for odd device
Date:   Tue, 17 May 2022 18:17:36 +0200
Message-Id: <20220517161736.13313-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At least one pl2303 device has a bcdUSB of 1.0.1 which most likely was
was intended as 1.1.

Allow bcdDevice 1.0.1 but interpret it as 1.1.

Fixes: 1e9faef4d26d ("USB: serial: pl2303: fix HX type detection")
Cc: stable@vger.kernel.org      # 5.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Bus 001 Device 004: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.01
  bDeviceClass            0 
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x067b Prolific Technology, Inc.
  idProduct          0x2303 PL2303 Serial Port
  bcdDevice            3.00
  iManufacturer           1 Prolific Technology Inc.
  iProduct                2 USB-Serial Controller
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0027
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
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
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0020  1x 32 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

 drivers/usb/serial/pl2303.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1d878d05a658..3506c47e1eef 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -421,6 +421,9 @@ static int pl2303_detect_type(struct usb_serial *serial)
 	bcdUSB = le16_to_cpu(desc->bcdUSB);
 
 	switch (bcdUSB) {
+	case 0x101:
+		/* USB 1.0.1? Let's assume they meant 1.1... */
+		fallthrough;
 	case 0x110:
 		switch (bcdDevice) {
 		case 0x300:
-- 
2.35.1

