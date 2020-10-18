Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB02291E23
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgJRTul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729483AbgJRTVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B93DB222E8;
        Sun, 18 Oct 2020 19:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048894;
        bh=zlDNZx9rt71dhDzH3YzbXbl2z1FGcNMtbtHfolhdRjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8Q2Dw04/hCjTzFZb3PVntQnP+R0jnrIp7M2VNTl4iUYNkSqdHMIsecx6y1E4Hdjy
         d7vJFjoFxiK25p0qD67Vn6UG6n1s7wCGcGuumZdWaxOgtgQADJ0a6L6ML48KK+o9qd
         O6g9DBReDbdSO3kBhmaj/lZY1QNnpZEHYmI/aDp8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Mikael=20Wikstr=C3=B6m?= <leakim.wikstrom@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 056/101] HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons
Date:   Sun, 18 Oct 2020 15:19:41 -0400
Message-Id: <20201018192026.4053674-56-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikael Wikström <leakim.wikstrom@gmail.com>

[ Upstream commit 140958da9ab53a7df9e9ccc7678ea64655279ac1 ]

One more device that needs 40d5bb87 to resolve regression for the trackpoint
and three mouse buttons on the type cover of the Lenovo X1 Tablet Gen3.

It is probably also needed for the Lenovo X1 Tablet Gen2 with PID 0x60a3

Signed-off-by: Mikael Wikström <leakim.wikstrom@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b49ec7dde6457..0ca8906a6f839 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -726,6 +726,7 @@
 #define USB_DEVICE_ID_LENOVO_SCROLLPOINT_OPTICAL	0x6049
 #define USB_DEVICE_ID_LENOVO_TPPRODOCK	0x6067
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
+#define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D	0x608d
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019	0x6019
 #define USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_602E	0x602e
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e3152155c4b85..99f041afd5c0c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1973,6 +1973,12 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_GENERIC,
 			USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_7010) },
 
+	/* Lenovo X1 TAB Gen 3 */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
+
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
-- 
2.25.1

