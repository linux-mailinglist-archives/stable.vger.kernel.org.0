Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C126B64A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgIPACM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgIOOaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:30:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1BB022265;
        Tue, 15 Sep 2020 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179714;
        bh=9pI4uv6hUNb9UQV7Vr10WMD6bP0LD4MqoWwF067Lm8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1krATw0PGkDRyeJosnoaVMTksF6k1YtfxR2p/jSJLh1l9iAdaw6BKT2TSejDBqlm
         Uh6Opjdrnct6yKkfahbtYveQurkb22l5Wg9AG7SnYrVElVUQEu6saceIEgwhGFcCS3
         Od1qgS+E7+zwsygpDxpmv5514urwlCM9WAt9PrYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Miell <nmiell@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/132] HID: microsoft: Add rumble support for the 8bitdo SN30 Pro+ controller
Date:   Tue, 15 Sep 2020 16:12:44 +0200
Message-Id: <20200915140647.206951160@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Miell <nmiell@gmail.com>

[ Upstream commit 724a419ea28f7514a391e80040230f69cf626707 ]

When operating in XInput mode, the 8bitdo SN30 Pro+ requires the same
quirk as the official Xbox One Bluetooth controllers for rumble to
function.

Other controllers like the N30 Pro 2, SF30 Pro, SN30 Pro, etc. probably
also need this quirk, but I do not have the hardware to test.

Signed-off-by: Nicholas Miell <nmiell@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h       | 1 +
 drivers/hid/hid-microsoft.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 076c20a7a6540..e03a4d794240c 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -846,6 +846,7 @@
 #define USB_DEVICE_ID_MS_POWER_COVER     0x07da
 #define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
+#define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 2d8b589201a4e..8cb1ca1936e42 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -451,6 +451,8 @@ static const struct hid_device_id ms_devices[] = {
 		.driver_data = MS_SURFACE_DIAL },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER),
 		.driver_data = MS_QUIRK_FF },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS),
+		.driver_data = MS_QUIRK_FF },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ms_devices);
-- 
2.25.1



