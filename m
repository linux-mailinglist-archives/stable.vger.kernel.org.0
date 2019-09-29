Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F52C157D
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfI2OCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729752AbfI2OCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFE572082F;
        Sun, 29 Sep 2019 14:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765765;
        bh=KKwCJ2Jhqo9yT3luONXGpSEQ/hHdZWM1lw6vCsJpMtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNd4kdNJWUOHCYc2vW+w6v4VM+ZytLnU7VVhI0mYLzTDDcBR73mJdXH/T/Dxk20K8
         fpWPDdmuQvXTotvl2fe/sCm//ZkeqvEWGRfUoYKZrEOWmoIJ8Xr+yCLkyo5Z2gEf9S
         JqWFcYVZw0iJUaOsmju+T1jc0GHSvy5l1naNuIfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 43/45] Bluetooth: btrtl: Additional Realtek 8822CE Bluetooth devices
Date:   Sun, 29 Sep 2019 15:56:11 +0200
Message-Id: <20190929135034.459828829@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit 6d0762b19c5963ff9e178e8af3626532ee04d93d ]

The ASUS X412FA laptop contains a Realtek RTL8822CE device with an
associated BT chip using a USB ID of 04ca:4005. This ID is added to the
driver.

The /sys/kernel/debug/usb/devices portion for this device is:

T:  Bus=01 Lev=01 Prnt=01 Port=09 Cnt=04 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=04ca ProdID=4005 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204707
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 0f4750322864a..aa6e2f9d48617 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -378,6 +378,9 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x13d3, 0x3526), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x0b05, 0x185c), .driver_info = BTUSB_REALTEK },
 
+	/* Additional Realtek 8822CE Bluetooth devices */
+	{ USB_DEVICE(0x04ca, 0x4005), .driver_info = BTUSB_REALTEK },
+
 	/* Silicon Wave based devices */
 	{ USB_DEVICE(0x0c10, 0x0000), .driver_info = BTUSB_SWAVE },
 
-- 
2.20.1



