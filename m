Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0685019B3F3
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388038AbgDAQ1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:27:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388032AbgDAQ1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:27:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6416C214D8;
        Wed,  1 Apr 2020 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758467;
        bh=zKvuJkpvTrMV1DlA6p6mT9CYfcRYC1VBuACGXS7i5uE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+5Vs9ucLy4xivlW8xyB/s2aKhybVLchKJzTXvix0nb1GGCmX74KbpaVi/juhJM5n
         hytVdLYQoG7nkv4y9WcstnWZgSe1HUGnW1dSiqeKGlCUkAS27YDNRHKWy4NWYtlcgD
         QKjcp5eu6wdehsk75AIbmi0YNRbJFEJqerkiGvPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Dembicki <paweldembicki@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 081/116] USB: serial: option: add Wistron Neweb D19Q1
Date:   Wed,  1 Apr 2020 18:17:37 +0200
Message-Id: <20200401161552.929448686@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161542.669484650@linuxfoundation.org>
References: <20200401161542.669484650@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Dembicki <paweldembicki@gmail.com>

commit dfee7e2f478346b12ea651d5c28b069f6a4af563 upstream.

This modem is embedded on dlink dwr-960 router.
The oem configuration states:

T: Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 2 Spd=480 MxCh= 0
D: Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs= 1
P: Vendor=1435 ProdID=d191 Rev=ff.ff
S: Manufacturer=Android
S: Product=Android
S: SerialNumber=0123456789ABCDEF
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E: Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
E: Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E: Ad=84(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
E: Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E: Ad=86(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
E: Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E: Ad=88(I) Atr=03(Int.) MxPS= 8 Ivl=32ms
E: Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=(none)
E: Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E: Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

Tested on openwrt distribution

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1992,6 +1992,8 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e01, 0xff, 0xff, 0xff) },	/* D-Link DWM-152/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x3e02, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/C1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x07d1, 0x7e11, 0xff, 0xff, 0xff) },	/* D-Link DWM-156/A3 */
+	{ USB_DEVICE_INTERFACE_CLASS(0x1435, 0xd191, 0xff),			/* Wistron Neweb D19Q1 */
+	  .driver_info = RSVD(1) | RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x1690, 0x7588, 0xff),			/* ASKEY WWHC050 */
 	  .driver_info = RSVD(1) | RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2020, 0x2031, 0xff),			/* Olicard 600 */


