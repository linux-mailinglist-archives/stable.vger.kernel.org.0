Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF55E2567FC
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgH2N4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 09:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgH2N4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Aug 2020 09:56:18 -0400
X-Greylist: delayed 776 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Aug 2020 06:56:17 PDT
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DF8C061236
        for <stable@vger.kernel.org>; Sat, 29 Aug 2020 06:56:16 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 07TDgreI023204
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 29 Aug 2020 15:42:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1598708574; bh=ZtyrvREL7GVT04vkTRU4w8IaZCoP+AHWmOpkFJx71tE=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=mAhVkHduzohvtspeDMsNRog3tLO1GeT5KafFahaYT/jtPDr/61eWevIU2F7cQ0DDp
         HVWhjL/KOJaJ2o0wG0kpA8QNz/oT2gqZeMhbKXManebsJFwj0OMLF1z76fD8PWV5VQ
         TclOC1hB0veXgngx64+c543IGyqUgQeSumyekvGM=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1kC188-000FOG-N3; Sat, 29 Aug 2020 15:42:52 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        AceLan Kao <acelan.kao@canonical.com>,
        Sebastian Sjoholm <ssjoholm@mac.com>,
        Dan Williams <dcbw@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] USB: serial: option: support dynamic Quectel USB compositions
Date:   Sat, 29 Aug 2020 15:42:50 +0200
Message-Id: <20200829134250.59118-1-bjorn@mork.no>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/serial/option.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 89b3192af326..6c3ece5dd9c9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1094,14 +1094,18 @@ static const struct usb_device_id option_ids[] = {
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
-- 
2.28.0

