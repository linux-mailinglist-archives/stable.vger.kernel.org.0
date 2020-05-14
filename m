Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E481D3D2E
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgENTMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgENSv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:51:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2780206A5;
        Thu, 14 May 2020 18:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482317;
        bh=Om4qUhkrqn5Bl8iRXgSgjseT1e2RCOZ1/6fy8F6f00g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSrClWS8g3C8Oqv3xmPHF5VQ4SjLoKZ4V74FZo6PBmtGLw//KG+netCzRSglpk1Ft
         KN2waf67ycy696DdI4WdseKoY+0DExozcEAIP5280pfF+LM6yN5KnVPYMH8zPWIH9r
         8OffHn+Me/uMOJalGbo6VWVbu3+Zb3IKH6Kt7n58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabian Schindlatz <fabian.schindlatz@fau.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 06/62] HID: logitech: Add support for Logitech G11 extra keys
Date:   Thu, 14 May 2020 14:50:51 -0400
Message-Id: <20200514185147.19716-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabian Schindlatz <fabian.schindlatz@fau.de>

[ Upstream commit b1bd0f75288f60e8d142a1b3e979ed0192c04931 ]

The Logitech G11 keyboard is a cheap variant of the G15 without the LCD
screen. It uses the same layout for its extra and macro keys (G1 - G18,
M1-M3, MR) and - from the input subsystem's perspective - behaves just
like the G15, so we can treat it as such.

Tested it with my own keyboard.

Signed-off-by: Fabian Schindlatz <fabian.schindlatz@fau.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-lg-g15.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 309510a72c5e1..40697af0ca358 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -756,6 +756,7 @@
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2	0xc218
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2_2	0xc219
 #define USB_DEVICE_ID_LOGITECH_G15_LCD		0xc222
+#define USB_DEVICE_ID_LOGITECH_G11		0xc225
 #define USB_DEVICE_ID_LOGITECH_G15_V2_LCD	0xc227
 #define USB_DEVICE_ID_LOGITECH_G510		0xc22d
 #define USB_DEVICE_ID_LOGITECH_G510_USB_AUDIO	0xc22e
diff --git a/drivers/hid/hid-lg-g15.c b/drivers/hid/hid-lg-g15.c
index ad4b5412a9f49..ef0cbcd7540d5 100644
--- a/drivers/hid/hid-lg-g15.c
+++ b/drivers/hid/hid-lg-g15.c
@@ -872,6 +872,10 @@ static int lg_g15_probe(struct hid_device *hdev, const struct hid_device_id *id)
 }
 
 static const struct hid_device_id lg_g15_devices[] = {
+	/* The G11 is a G15 without the LCD, treat it as a G15 */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		USB_DEVICE_ID_LOGITECH_G11),
+		.driver_data = LG_G15 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 			 USB_DEVICE_ID_LOGITECH_G15_LCD),
 		.driver_data = LG_G15 },
-- 
2.20.1

