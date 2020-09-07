Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2597926016A
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 19:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgIGREo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 13:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbgIGQdJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F220A21775;
        Mon,  7 Sep 2020 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496388;
        bh=7kfMXVWrXLnU/OBvt23uMLhrzPlBrRM7MJEEVR6nPs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZ/By3KSSPlUNDICFOG+ekSagJDyZCTwSJPmXRawDXEJH9nNWYEk+/tnDrWeR1C5b
         YKs5mHsNs/HpilW8UccCscMFudXJdH1W52IfZ7wBWvqfCKvGbB6FRioAbmyY2NdneU
         r5e3WLqeCZynhM1+m9D8QqVoI7rLsCrpzFI+7XzI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Miell <nmiell@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 38/53] HID: microsoft: Add rumble support for the 8bitdo SN30 Pro+ controller
Date:   Mon,  7 Sep 2020 12:32:04 -0400
Message-Id: <20200907163220.1280412-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 476cb99bd61b7..95f9d285b3c6b 100644
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

