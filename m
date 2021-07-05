Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6696C3BBF21
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhGEPbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhGEPb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85F8461991;
        Mon,  5 Jul 2021 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498931;
        bh=BIu+qtv5hhbidYX/HPZHCOaj3iIlpzXP9dYH1XAO6Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpRTPUrnaH0XckOlC0o8Rt1H1NWLyL+6uhB5my+BOTPVImy8F4o+y/Swm60lu4lFg
         vfQKm0Xcp2RBl8E8DbDH/29qjZ1Ackj6vnQeq5C6hSUp8fSMD0PG+/2hholPH2m8uB
         TmIQkIqzKK0EV4waxZScDDhJygNGmrJIdA4EoYGL8F2HEB3PPxl2bnHaXLgv5nBYlK
         BKG9lMOkrq6QJcNWl4pvRc9QiXzFoxaF9HzVkkAGo47DpUk35ISs18oFR7TDOYKF7A
         jhmrI+p8O8RvLHfw0MM9qHy6QH2WMtWSJHa5woxH7SJ0bG6JeFZMPnayY+u0dwMhxA
         6TTAw0r/cFXLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zoltan Tamas Vajda <zoltan.tamas.vajda@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 27/59] HID: hid-input: add Surface Go battery quirk
Date:   Mon,  5 Jul 2021 11:27:43 -0400
Message-Id: <20210705152815.1520546-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zoltan Tamas Vajda <zoltan.tamas.vajda@gmail.com>

[ Upstream commit b5539722eb832441f309642fe5102cc3536f92b8 ]

The Elantech touchscreen/digitizer in the Surface Go mistakenly reports
having a battery. This results in a low battery message every time you
try to use the pen.

This patch adds a quirk to ignore the non-existent battery and
gets rid of the false low battery messages.

Signed-off-by: Zoltan Tamas Vajda <zoltan.tamas.vajda@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b84a0a11e05b..63ca5959dc67 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -396,6 +396,7 @@
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
+#define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index abbfa91e73e4..68c8644234a4 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -326,6 +326,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.30.2

