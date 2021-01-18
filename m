Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896112FA9F1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437167AbhARTQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390471AbhARLip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 601C8222B3;
        Mon, 18 Jan 2021 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969870;
        bh=8kkp7B4d9ty+rjkwJdPvxKiK/3/Ji9Q5zYOxvqMkQ5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIrA7g0ElOyhaqQq2fWp7pWtyyUZNCVQaU9k+H/HGDlN5T9CuYojeOyHLqQzJc8Qb
         5PPQ4DriLQjZkdUW8ABUA+WQ3i0wPMnreeLI2W8aqIKUW8lh0NYoa8v627TQKHaQeP
         wdW4sNiT1J9oFYb8zPypAUlrI20CFDWZBTC1veiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Schuermann <leon@is.currently.online>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 17/76] r8152: Add Lenovo Powered USB-C Travel Hub
Date:   Mon, 18 Jan 2021 12:34:17 +0100
Message-Id: <20210118113341.816773991@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Schuermann <leon@is.currently.online>

commit cb82a54904a99df9e8f9e9d282046055dae5a730 upstream.

This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
use the cdc_ether driver. However, using this driver, with the system
suspended the device constantly sends pause-frames as soon as the
receive buffer fills up. This causes issues with other devices, where
some Ethernet switches stop forwarding packets altogether.

Using the Realtek driver (r8152) fixes this issue. Pause frames are no
longer sent while the host system is suspended.

Signed-off-by: Leon Schuermann <leon@is.currently.online>
Tested-by: Leon Schuermann <leon@is.currently.online>
Link: https://lore.kernel.org/r/20210111190312.12589-2-leon@is.currently.online
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/cdc_ether.c |    7 +++++++
 drivers/net/usb/r8152.c     |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -787,6 +787,13 @@ static const struct usb_device_id	produc
 	.driver_info = 0,
 },
 
+/* Lenovo Powered USB-C Travel Hub (4X90S92381, based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x721e, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5845,6 +5845,7 @@ static const struct usb_device_id rtl815
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},


