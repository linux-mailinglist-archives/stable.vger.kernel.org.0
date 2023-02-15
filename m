Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDCC69860E
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBOUr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjBOUrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:47:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD15842DCC;
        Wed, 15 Feb 2023 12:46:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8CF2B823BB;
        Wed, 15 Feb 2023 20:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B781C433D2;
        Wed, 15 Feb 2023 20:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493989;
        bh=pTSRAXw7DYGKWZHU3UYXOHJQxgUkpC+l+eg/xofmgYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBN5vt/1jEftW1K1+cGaz1z8NtRDr8gFNjfxjD7f2nU/r/Ip81IzaJ0O8ZShM9EhA
         To6Ys4uWKqhr5eIkRnMYxRlZQQHEsSQLqIeVd/3pua5v7KRaUffrJzRMMBijAVAOI7
         6Pd20xifQ2IHnt3MQknbv83TyfyTfObonqQ3RsYIwGOqvE/4ylxgR3zuLquOeMuS9T
         JkZfLsXxleaZ3pK1TpRm9OWgk6T331pqmAIxwfrDewcEiwfWRsE7SkU1byx7COokJZ
         gCKz4ieDprJ6LEc6R7bfQp8OR8ZY9sfx+QsRmYYD9dqE/x3fQM3pR0jcAT4/+WqIKy
         0TD9gtWCAynFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luka Guzenko <l.guzenko@web.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/24] HID: Ignore battery for ELAN touchscreen 29DF on HP
Date:   Wed, 15 Feb 2023 15:45:44 -0500
Message-Id: <20230215204547.2760761-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luka Guzenko <l.guzenko@web.de>

[ Upstream commit ebebf05a4b06a1be49788ca0edf990de01c4b0d0 ]

The touchscreen reports a battery status of 0% and jumps to 1% when a
stylus is used. The device ID was added and the battery ignore quirk was
enabled for it.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Link: https://lore.kernel.org/r/20230120223741.3007-1-l.guzenko@web.de
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 46c0ce4203c08..9e36b4cd905ee 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -413,6 +413,7 @@
 #define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
 #define I2C_DEVICE_ID_HP_ENVY_X360_EU0009NV	0x2CF9
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
+#define I2C_DEVICE_ID_HP_SPECTRE_X360_13_AW0020NG  0x29DF
 #define I2C_DEVICE_ID_ASUS_TP420IA_TOUCHSCREEN 0x2BC8
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 3736b0afbff73..7e94ca1822afb 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -386,6 +386,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_13_AW0020NG),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
-- 
2.39.0

