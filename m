Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944B73BCEA6
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhGFL0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:26:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232538AbhGFLXG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:23:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAAA461CE8;
        Tue,  6 Jul 2021 11:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570284;
        bh=uukFyebvLjMkKGfyTL+jcY1K9MuCKoKq1HHkshqZF1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asABJulQJUBuAamn5gPAM2dSs/t/+fEdZ+R4DIjRWpV/5/7zCIxWbNOCtWAo6Nz2i
         9IKT55YvtMF0Jk1+P3bDM2Q4GaX4vTZCoBycc/kTrXwHSZhpdFMyvbKiUs0FREJWwM
         sOXxFmIqwJP/4YGmnuluflXwYB9XbePz09lh+K86plO2b1RPgkZb5idKQgFdQqYHrS
         PrSXmN5MkUKTBPUsIBz2jw/JKZZJnzhFdQWAN7HnX4KyG65uWTIPTHzMiLuewaftq4
         6AmI34syZCu67M127EIjcCkGmnfofjp8H/A0BjeEJOHGAN4VAH6LDPWlmYr/I6TzVQ
         Xd6lxzzLZqzkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Lenski <dlenski@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 175/189] Bluetooth: btusb: Add a new QCA_ROME device (0cf3:e500)
Date:   Tue,  6 Jul 2021 07:13:55 -0400
Message-Id: <20210706111409.2058071-175-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Lenski <dlenski@gmail.com>

[ Upstream commit 0324d19cb99804d99e42c990b8b1e191575a091b ]

This patch adds the 0cf3:e500 Bluetooth device (from a QCA9377 board) as a
QCA_ROME device.  It appears to be functionally identical to another device
ID, also from a QCA9377 board, which was previously marked as QCA_ROME in
0a03f98b98c201191e3ba15a0e33f46d8660e1fd
("Bluetooth: Add a new 04ca:3015 QCA_ROME device").

Without this patch, the WiFi side of the QCA9377 board is slow or unusable
when the Bluetooth side is in use.

See https://askubuntu.com/a/1137852 for another report of QCA_ROME fixing
this issue for this device ID.

/sys/kernel/debug/usb/devices:

T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12   MxCh= 0
D:  Ver= 2.01 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0cf3 ProdID=e500 Rev= 0.01
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Daniel Lenski <dlenski@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 99fd88f7653d..90872099d9c3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -270,6 +270,8 @@ static const struct usb_device_id blacklist_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0cf3, 0xe360), .driver_info = BTUSB_QCA_ROME |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0cf3, 0xe500), .driver_info = BTUSB_QCA_ROME |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe092), .driver_info = BTUSB_QCA_ROME |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe09f), .driver_info = BTUSB_QCA_ROME |
-- 
2.30.2

