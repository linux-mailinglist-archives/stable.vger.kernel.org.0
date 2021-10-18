Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34807431AD9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhJRN30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231847AbhJRN3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415C16128E;
        Mon, 18 Oct 2021 13:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563567;
        bh=STnkt/xIU0VPOzpUtuhCxWxqWyr+6/JTMwLHg5CLYF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrWLR/g6lBmJdfjNc7+ojgZzTbE3uooGeaZL2t39wV5rWznqhk7SIBV2MU432RSgG
         p9ETyU8YgEpN1PzjzKJuTVgFjA+/UbKkJa1VRBNT/5nchxGZ9vYhHhm60W0SHmk8Gw
         AoNEIrE5UGjQ6MhqZXFyUFEeSe1RWVEWPGE/TaCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomaz Solc <tomaz.solc@tablix.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 17/39] USB: serial: option: add prod. id for Quectel EG91
Date:   Mon, 18 Oct 2021 15:24:26 +0200
Message-Id: <20211018132326.006152378@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomaz Solc <tomaz.solc@tablix.org>

commit c184accc4a42c7872dc8e8d0fc97a740dc61fe24 upstream.

Adding support for Quectel EG91 LTE module.

The interface layout is same as for EG95.

usb-devices output:
T:  Bus=01 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0191 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan

Interfaces:

0: Diag
1: GNSS
2: AT-command interface/modem
3: Modem
4: QMI

Signed-off-by: Tomaz Solc <tomaz.solc@tablix.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -249,6 +249,7 @@ static void option_instat_callback(struc
 /* These Quectel products use Quectel's vendor ID */
 #define QUECTEL_PRODUCT_EC21			0x0121
 #define QUECTEL_PRODUCT_EC25			0x0125
+#define QUECTEL_PRODUCT_EG91			0x0191
 #define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
@@ -1115,6 +1116,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },


