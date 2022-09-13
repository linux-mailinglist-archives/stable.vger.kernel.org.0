Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27355B74A9
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbiIMP1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiIMP0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87D47D1E7;
        Tue, 13 Sep 2022 07:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60653B81012;
        Tue, 13 Sep 2022 14:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF512C433D6;
        Tue, 13 Sep 2022 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079787;
        bh=b65si5HoAEXck2HfEfAqj9RwQescYO6j4pI01pWjtYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ3jCKzy9jJOLN9w41MjcNF6BYf44VplZh0eTjYw5G1bKoZDkZQBq8zChVEZgLwg8
         Bo4ghOG34eKL3MXydP9cNelY3PyilsCFnIpG109e4uxr2D1GeXQuWlk5gNmcq7R4eg
         WN+WmTdQLYbITC5d1AgI8sA4gMYl8O9FzQzcXZzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thierry GUIBERT <thierry.guibert@croix-rouge.fr>,
        stable <stable@kernel.org>
Subject: [PATCH 4.9 13/42] USB: cdc-acm: Add Icom PMR F3400 support (0c26:0020)
Date:   Tue, 13 Sep 2022 16:07:44 +0200
Message-Id: <20220913140342.938657114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thierry GUIBERT <thierry.guibert@croix-rouge.fr>

commit a10bc71729b236fe36de0d8e4d35c959fd8dec3a upstream.

Supports for ICOM F3400 and ICOM F4400 PMR radios in CDC-ACM driver
enabling the AT serial port.
The Vendor Id is 0x0C26
The Product ID is 0x0020

Output of lsusb :
Bus 001 Device 009: ID 0c26:0020 Prolific Technology Inc. ICOM Radio
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            2 Communications
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0c26 Prolific Technology Inc.
  idProduct          0x0020
  bcdDevice            0.00
  iManufacturer           1 ICOM Inc.
  iProduct                2 ICOM Radio
  iSerial                 3 *obfuscated*
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0030
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                0mA
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              12
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

Signed-off-by: Thierry GUIBERT <thierry.guibert@croix-rouge.fr>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220819081702.84118-1-thierry.guibert@croix-rouge.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1774,6 +1774,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x09d8, 0x0320), /* Elatec GmbH TWN3 */
 	.driver_info = NO_UNION_NORMAL, /* has misplaced union descriptor */
 	},
+	{ USB_DEVICE(0x0c26, 0x0020), /* Icom ICF3400 Serie */
+	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
+	},
 	{ USB_DEVICE(0x0ca6, 0xa050), /* Castles VEGA3000 */
 	.driver_info = NO_UNION_NORMAL, /* reports zero length descriptor */
 	},


