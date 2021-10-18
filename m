Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EBF431DDA
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhJRNzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234180AbhJRNxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6392619BB;
        Mon, 18 Oct 2021 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564343;
        bh=5XQC/5gA2VzzjIOsTD3/VrSSjs40RAnchdlV1WviRlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWUZwhsGRXVtuQdnML1YcTWi3NmEklUdUZXU++Mzp6i4LIY7Pjaw3SP5ZUTqFdI2j
         dVSEWiwTU36vP+P13ThMButb5J8kyEYp49ccVg8NnRbs1QfLo4vdOROuoCM5xchTTU
         nAO/OqoHxIsaomX+Bae1dbCASNb5LLoZvZig8wmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomaz Solc <tomaz.solc@tablix.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 053/151] USB: serial: option: add prod. id for Quectel EG91
Date:   Mon, 18 Oct 2021 15:23:52 +0200
Message-Id: <20211018132342.415769765@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -246,6 +246,7 @@ static void option_instat_callback(struc
 /* These Quectel products use Quectel's vendor ID */
 #define QUECTEL_PRODUCT_EC21			0x0121
 #define QUECTEL_PRODUCT_EC25			0x0125
+#define QUECTEL_PRODUCT_EG91			0x0191
 #define QUECTEL_PRODUCT_EG95			0x0195
 #define QUECTEL_PRODUCT_BG96			0x0296
 #define QUECTEL_PRODUCT_EP06			0x0306
@@ -1112,6 +1113,9 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC25, 0xff, 0, 0) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0xff, 0xff),
+	  .driver_info = NUMEP2 },
+	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG91, 0xff, 0, 0) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EG95, 0xff, 0, 0) },


