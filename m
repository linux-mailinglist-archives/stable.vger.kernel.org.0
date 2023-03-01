Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13D56A730D
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjCASMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjCASMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61134BE8D
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BAFBB810C3
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046D7C433D2;
        Wed,  1 Mar 2023 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694324;
        bh=pTSRAXw7DYGKWZHU3UYXOHJQxgUkpC+l+eg/xofmgYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBxlq58pLH8Fb++qN6pqR7XEXvDI8KA6xOQNUt8kvnZ9Hhn8OkjbGosJWSdcWizNb
         +FTvaQkPOC4fVC9rxLa/qPQjzMjicq02KIvq9Dz1Q00rfo4GyEcybt91UpkbiHEf1e
         5B93NYPI1i7RbWXRNEOypkJ1sstKfFDKjGJXUfLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luka Guzenko <l.guzenko@web.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/42] HID: Ignore battery for ELAN touchscreen 29DF on HP
Date:   Wed,  1 Mar 2023 19:08:42 +0100
Message-Id: <20230301180658.012224300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



