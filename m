Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70443C51E2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349543AbhGLHn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348198AbhGLHkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA72601FE;
        Mon, 12 Jul 2021 07:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075481;
        bh=BIu+qtv5hhbidYX/HPZHCOaj3iIlpzXP9dYH1XAO6Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LY46iVKyAi2Pc8RIOeoBiI1GtrbkgDtyCpLA3UOW/5I0LftDhYqjJetDQhWj2ZWjz
         oq52WPxcTugWE7FsYU6EQfUY5MiYnOZd9BMU63kp7gIVJdDJc011N8grDtLW3egC7j
         1i6DPN4UojGenwFOj6MmrterJNRZMr9ofbv6POcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zoltan Tamas Vajda <zoltan.tamas.vajda@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 234/800] HID: hid-input: add Surface Go battery quirk
Date:   Mon, 12 Jul 2021 08:04:17 +0200
Message-Id: <20210712060946.720816347@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



