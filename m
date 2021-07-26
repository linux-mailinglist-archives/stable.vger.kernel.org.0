Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3553D5D71
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235556AbhGZPBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235153AbhGZPB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD46B60E08;
        Mon, 26 Jul 2021 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314116;
        bh=f4mfrZjD23mN0xQWPX26uoGmS3hHf6AzGOfFjMd+GQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJS9e7B/9EEk/oI+GxvpF+Nz+qHKy9UfacgThBN4zAHppqwCMTrPCLQNIiuJXBSrB
         rHhx9XZNUqAeFw+t8DJhV8j7Ho5AWJ490bFeaUv0IDCiiAzkijjRzvfbfce3Lbo+Zq
         95YC8hkhz0W4nXiWLEZIfVPtl9SRp5csg/DxJrgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco De Marco <marco.demarco@posteo.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 39/47] USB: serial: option: add support for u-blox LARA-R6 family
Date:   Mon, 26 Jul 2021 17:38:57 +0200
Message-Id: <20210726153824.211241175@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
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


