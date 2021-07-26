Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25DB3D5DE8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhGZPEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhGZPEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:04:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FD7560F22;
        Mon, 26 Jul 2021 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314290;
        bh=f4mfrZjD23mN0xQWPX26uoGmS3hHf6AzGOfFjMd+GQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxNpfS5YEX1FwIOH3BOmsqzfAIT9TwXyy1aC9foa7M6IYQzht/sIhkWkGA/gyShE0
         93ckXvZOygj5NPy0nDZQQehOvTockOktCWYzUbrPEJuSRurbhnrRrZIz+HAHBogBEB
         YpDk3/ikMHTgXtDUVLNnHPWAmHmWCNQH1raZjAjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco De Marco <marco.demarco@posteo.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 52/60] USB: serial: option: add support for u-blox LARA-R6 family
Date:   Mon, 26 Jul 2021 17:39:06 +0200
Message-Id: <20210726153826.506496580@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco De Marco <marco.demarco@posteo.net>

commit 94b619a07655805a1622484967754f5848640456 upstream.

The patch is meant to support LARA-R6 Cat 1 module family.

Module USB ID:
Vendor  ID: 0x05c6
Product ID: 0x90fA

Interface layout:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: QMI wwan (not available in all versions)

Signed-off-by: Marco De Marco <marco.demarco@posteo.net>
Link: https://lore.kernel.org/r/49260184.kfMIbaSn9k@mars
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -241,6 +241,7 @@ static void option_instat_callback(struc
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
+#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -1098,6 +1099,8 @@ static const struct usb_device_id option
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	  .driver_info = RSVD(3) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21),
 	  .driver_info = RSVD(4) },


