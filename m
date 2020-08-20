Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD1B24B8BF
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 13:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgHTL0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 07:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730655AbgHTKGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:06:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D93208E4;
        Thu, 20 Aug 2020 10:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917972;
        bh=068LKMYQZjA+IESANMRSpu0RwUD813OMYqEHLN141CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsczmMBvfiZZfxo6WXk+5HWzLGqtrLl8sZZPG7QC6fg5AZldYiEellfZtoGMvtdex
         egL9+t+aczDo9s9Zu//UwrGagj+v3zhT3Dw2APc3lofMYogp6vw4O6A9gECEC5kk7z
         WMfByTKKmkF+l/fiRGA2awcniXwaFkscu5jMmQtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Ekman <erik@kryo.se>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 001/228] USB: serial: qcserial: add EM7305 QDL product ID
Date:   Thu, 20 Aug 2020 11:19:36 +0200
Message-Id: <20200820091607.606558951@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Ekman <erik@kryo.se>

commit d2a4309c1ab6df424b2239fe2920d6f26f808d17 upstream.

When running qmi-firmware-update on the Sierra Wireless EM7305 in a Toshiba
laptop, it changed product ID to 0x9062 when entering QDL mode:

usb 2-4: new high-speed USB device number 78 using xhci_hcd
usb 2-4: New USB device found, idVendor=1199, idProduct=9062, bcdDevice= 0.00
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-4: Product: EM7305
usb 2-4: Manufacturer: Sierra Wireless, Incorporated

The upgrade could complete after running
 # echo 1199 9062 > /sys/bus/usb-serial/drivers/qcserial/new_id

qcserial 2-4:1.0: Qualcomm USB modem converter detected
usb 2-4: Qualcomm USB modem converter now attached to ttyUSB0

Signed-off-by: Erik Ekman <erik@kryo.se>
Link: https://lore.kernel.org/r/20200717185118.3640219-1-erik@kryo.se
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -159,6 +159,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x1199, 0x9056)},	/* Sierra Wireless Modem */
 	{DEVICE_SWI(0x1199, 0x9060)},	/* Sierra Wireless Modem */
 	{DEVICE_SWI(0x1199, 0x9061)},	/* Sierra Wireless Modem */
+	{DEVICE_SWI(0x1199, 0x9062)},	/* Sierra Wireless EM7305 QDL */
 	{DEVICE_SWI(0x1199, 0x9063)},	/* Sierra Wireless EM7305 */
 	{DEVICE_SWI(0x1199, 0x9070)},	/* Sierra Wireless MC74xx */
 	{DEVICE_SWI(0x1199, 0x9071)},	/* Sierra Wireless MC74xx */


