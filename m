Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483A0272D75
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgIUQkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbgIUQj6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:39:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F92239A1;
        Mon, 21 Sep 2020 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706397;
        bh=GjfgUED+UOegiQwuYD4TwHF7x3AJrCwl1b2b4EYm5c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3+lXIOR3ST+JYy7OH7RjwvUZAGuSZBsyNC9Ljnvz0sOgJbZIBzyCatiSbI9oEGpW
         F52LbXNl8WDu0gucCjc5wm5PNxqpsxCij101jIsCKwJw7brCpYKT8V21o0grSQhsXH
         MGf8sUWwxiwwdr2yO9pggtGQYyshBuzlnQsitZNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Sebastian Sjoholm <ssjoholm@mac.com>,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 56/94] USB: serial: option: support dynamic Quectel USB compositions
Date:   Mon, 21 Sep 2020 18:27:43 +0200
Message-Id: <20200921162038.119311600@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

commit 2bb70f0a4b238323e4e2f392fc3ddeb5b7208c9e upstream.

The USB composition, defining the set of exported functions, is dynamic
in newer Quectel modems.  Default functions can be disabled and
alternative functions can be enabled instead.  The alternatives
includes class functions using interface pairs, which should be
handled by the respective class drivers.

Active interfaces are numbered consecutively, so static
blacklisting based on interface numbers will fail when the
composition changes.  An example of such an error, where the
option driver has bound to the CDC ECM data interface,
preventing cdc_ether from handling this function:

 T: Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 2 Spd=480 MxCh= 0
 D: Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 1
 P: Vendor=2c7c ProdID=0125 Rev= 3.18
 S: Manufacturer=Quectel
 S: Product=EC25-AF
 C:* #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
 A: FirstIf#= 4 IfCount= 2 Cls=02(comm.) Sub=06 Prot=00
 I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
 E: Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E: Ad=83(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
 E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E: Ad=85(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
 E: Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E: Ad=87(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
 E: Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 4 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=06 Prot=00 Driver=(none)
 E: Ad=89(I) Atr=03(Int.) MxPS= 16 Ivl=32ms
 I:* If#= 5 Alt= 0 #EPs= 0 Cls=0a(data ) Sub=00 Prot=00 Driver=option
 I: If#= 5 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=option
 E: Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Another device with the same id gets correct drivers, since the
interface of the network function happens to be blacklisted by option:

 T: Bus=01 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#= 3 Spd=480 MxCh= 0
 D: Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs= 1
 P: Vendor=2c7c ProdID=0125 Rev= 3.18
 S: Manufacturer=Android
 S: Product=Android
 C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
 I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
 E: Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E: Ad=83(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
 E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E: Ad=85(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
 E: Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
 E: Ad=87(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
 E: Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
 E: Ad=89(I) Atr=03(Int.) MxPS= 8 Ivl=32ms
 E: Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
 E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Change rules for EC21, EC25, BG96 and EG95 to match vendor specific
serial functions only, to prevent binding to class functions. Require
2 endpoints on ff/ff/ff functions, avoiding the 3 endpoint QMI/RMNET
network functions.

Cc: AceLan Kao <acelan.kao@canonical.com>
Cc: Sebastian Sjoholm <ssjoholm@mac.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1097,14 +1097,18 @@ static const struct usb_device_id option
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
 	/* Quectel products using Quectel vendor ID */
-	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21),
-	  .driver_info = RSVD(4) },
-	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25),
-	  .driver_info = RSVD(4) },
-	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95),
-	  .driver_info = RSVD(4) },
-	{ USB_DEVICE(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_BG96),
-	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_BG96, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_BG96, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) | RSVD(2) | RSVD(3) | RSVD(4) | NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EP06, 0xff, 0, 0) },


