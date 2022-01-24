Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11D9499199
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353481AbiAXUM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:12:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36716 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378969AbiAXUKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:10:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72FD60B89;
        Mon, 24 Jan 2022 20:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16EBC340E7;
        Mon, 24 Jan 2022 20:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055006;
        bh=q5rAvSQSqiGCGZnKtanoWi/vKTjCm/PgYIA9eIArUYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRe7LqORmN+Y2Nefu2huYh2MoSP56z9juy1N1T8bAkmuDwZNcwyMymO9FOyzwokS0
         lORuR+Ub/sRCSUDUxizvwluPp+9/o+7vo9tWgB+rVyENFXJchcaq2suan6ZJ35PpJV
         uMTcRTVIXa6uPlS56musmqN+W4eZvVLBsw3sCNQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karl Kurbjun <kkurbjun@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 003/846] HID: Ignore battery for Elan touchscreen on HP Envy X360 15t-dr100
Date:   Mon, 24 Jan 2022 19:32:00 +0100
Message-Id: <20220124184100.997110508@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -394,6 +394,7 @@
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
+#define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -327,6 +327,8 @@ static const struct hid_device_id hid_ba
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),


