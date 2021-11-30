Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BDF463730
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242549AbhK3OwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:52:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56886 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbhK3Ovl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:51:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0AD9CE1A4C;
        Tue, 30 Nov 2021 14:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39ACC53FD1;
        Tue, 30 Nov 2021 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283698;
        bh=TVJWxzNijEhbJED7/Sdij2uqBXatVDjJBZILNO0AOAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQ8JxrKZk0O7aVRuVNPa1bs9WSpHyfsM8VqB6oirJjG9Spo8rWkmqpGS4W30AELlj
         B9w0a+LftPUQUR7Zkgt6BDE/i4CX2t2dNtZE3gOvgzHbsu6U99D97PRnGP6TJHH4ku
         OlqUiT9iJGDyW8i0GM0K41vrTLP1/Q/znJ8bPaYvMpE6leJGALzIk+SIztCFw01f2v
         Yw11veLgVKGuVVJ6LG6Etb6pH0wH3WWB0uAxFEQ1j/FcZeqAzKV59UbpV7HY8lp64e
         Vaw9IQ7KjKp8GjT3l1dYUB2lwSI6gFn7ZltxS+1spq8EFSrz8XkVVkSxWxRWHco0L1
         svlx5PB/7Vw2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trevor Davenport <trevor.davenport@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 24/68] HID: Ignore battery for Elan touchscreen on HP Envy X360 15-eu0xxx
Date:   Tue, 30 Nov 2021 09:46:20 -0500
Message-Id: <20211130144707.944580-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trevor Davenport <trevor.davenport@gmail.com>

[ Upstream commit b74edf9bfbc11a7d0d0d756f06b17beb213ad5ca ]

Battery status is reported for the HP Envy X360 Convertible 15-eu0xxx
even if it does not have a battery. Prevent it from always reporting the
battery as low.

Signed-off-by: Trevor Davenport <trevor.davenport@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3706c635b12ee..3c5564038c969 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -393,6 +393,7 @@
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
+#define I2C_DEVICE_ID_HP_ENVY_X360_15	0x2d05
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 4b5ebeacd2836..e31041ae3e435 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -324,6 +324,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
-- 
2.33.0

