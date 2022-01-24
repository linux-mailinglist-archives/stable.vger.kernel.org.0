Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7C9499602
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391587AbiAXU6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50036 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358894AbiAXUxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D732AB80FA3;
        Mon, 24 Jan 2022 20:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BB8C340E5;
        Mon, 24 Jan 2022 20:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057581;
        bh=KIinkNyzt4ugcO55WTubE68+yAEKo88iRuWUobe4O7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWqZ7aoKx2+JCdiS6tSLs00XHfrkZ/ShzHpXAdYrrcGXd23bddO2ueMPCZeoRX/xJ
         Cd/Ho9kJBgodvqhIw86kpgHtB8s6D7x9DOf446WUff7N4hr+Rv2qvnmCGBQHJ51Iek
         KvVNV86hRoq+B8pcS8coiVHiE+wOpBpuJeYS9bzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karl Kurbjun <kkurbjun@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.16 0003/1039] HID: Ignore battery for Elan touchscreen on HP Envy X360 15t-dr100
Date:   Mon, 24 Jan 2022 19:29:52 +0100
Message-Id: <20220124184125.251451486@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karl Kurbjun <kkurbjun@gmail.com>

commit f3193ea1b6779023334faa72b214ece457e02656 upstream.

Battery status on Elan tablet driver is reported for the HP ENVY x360
15t-dr100. There is no separate battery for the Elan controller resulting in a
battery level report of 0% or 1% depending on whether a stylus has interacted
with the screen. These low battery level reports causes a variety of bad
behavior in desktop environments. This patch adds the appropriate quirk to
indicate that the batery status is unused for this target.

Cc: stable@vger.kernel.org
Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h   |    1 +
 drivers/hid/hid-input.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -398,6 +398,7 @@
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_HP_ENVY_X360_15	0x2d05
+#define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -329,6 +329,8 @@ static const struct hid_device_id hid_ba
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),


