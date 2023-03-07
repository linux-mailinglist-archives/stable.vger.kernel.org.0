Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D6F6AF3F7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjCGTMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjCGTLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:11:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2CC28D2F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FDE261520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B57C433D2;
        Tue,  7 Mar 2023 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215349;
        bh=NT5Bnc1VaDpFGOrTZM1mA03QqJgEc3yGNA9i2YFbNK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xj4kBfEkOK8rFJSE7gesdWezGEpL24Vom1nglvZcuvdK8D/AdLXxMpDh+xtzRA0x7
         enHQvUEZlkR602SwiMzFazuQfOlfdRxhet7JQXZ4F1xAlRhQ0X3dwGm03epQdlradq
         aWGMnwphv++pAEKYC0jPUITp2QXSfkLvIk9AJnaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>,
        Allen Ballway <ballway@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/567] HID: retain initial quirks set up when creating HID devices
Date:   Tue,  7 Mar 2023 17:59:29 +0100
Message-Id: <20230307165916.023499551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 03a86105556e23650e4470c09f91cf7c360d5e28 ]

In certain circumstances, such as when creating I2C-connected HID
devices, we want to pass and retain some quirks (axis inversion, etc).
The source of such quirks may be device tree, or DMI data, or something
else not readily available to the HID core itself and therefore cannot
be reconstructed easily. To allow this, introduce "initial_quirks" field
in hid_device structure and use it when determining the final set of
quirks.

This fixes the problem with i2c-hid setting up device-tree sourced
quirks too late and losing them on device rebind, and also allows to
sever the tie between hid-code and i2c-hid when applying DMI-based
quirks.

Fixes: b60d3c803d76 ("HID: i2c-hid-of: Expose the touchscreen-inverted properties")
Fixes: a2f416bf062a ("HID: multitouch: Add quirks for flipped axes")
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Tested-by: Allen Ballway <ballway@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Alistair Francis <alistair@alistair23.me>
Link: https://lore.kernel.org/r/Y+LYwu3Zs13hdVDy@google.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c                 | 8 +-------
 drivers/hid/i2c-hid/i2c-hid-core.c       | 6 ++++--
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c | 1 -
 include/linux/hid.h                      | 1 +
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index bad1c1e3adec4..c7c06aa958c4d 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -19,7 +19,6 @@
 #include <linux/input/elan-i2c-ids.h>
 
 #include "hid-ids.h"
-#include "i2c-hid/i2c-hid.h"
 
 /*
  * Alphabetically sorted by vendor then product.
@@ -1218,7 +1217,7 @@ EXPORT_SYMBOL_GPL(hid_quirks_exit);
 static unsigned long hid_gets_squirk(const struct hid_device *hdev)
 {
 	const struct hid_device_id *bl_entry;
-	unsigned long quirks = 0;
+	unsigned long quirks = hdev->initial_quirks;
 
 	if (hid_match_id(hdev, hid_ignore_list))
 		quirks |= HID_QUIRK_IGNORE;
@@ -1279,11 +1278,6 @@ unsigned long hid_lookup_quirk(const struct hid_device *hdev)
 		quirks = hid_gets_squirk(hdev);
 	mutex_unlock(&dquirks_lock);
 
-	/* Get quirks specific to I2C devices */
-	if (IS_ENABLED(CONFIG_I2C_DMI_CORE) && IS_ENABLED(CONFIG_DMI) &&
-	    hdev->bus == BUS_I2C)
-		quirks |= i2c_hid_get_dmi_quirks(hdev->vendor, hdev->product);
-
 	return quirks;
 }
 EXPORT_SYMBOL_GPL(hid_lookup_quirk);
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 65c1f20ec420a..7c61bb9291e4e 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1012,6 +1012,10 @@ int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
 	hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
 	hid->product = le16_to_cpu(ihid->hdesc.wProductID);
 
+	hid->initial_quirks = quirks;
+	hid->initial_quirks |= i2c_hid_get_dmi_quirks(hid->vendor,
+						      hid->product);
+
 	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X",
 		 client->name, (u16)hid->vendor, (u16)hid->product);
 	strlcpy(hid->phys, dev_name(&client->dev), sizeof(hid->phys));
@@ -1025,8 +1029,6 @@ int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
 		goto err_mem_free;
 	}
 
-	hid->quirks |= quirks;
-
 	return 0;
 
 err_mem_free:
diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index 554a7dc285365..210f17c3a0be0 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -492,4 +492,3 @@ u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product)
 
 	return quirks;
 }
-EXPORT_SYMBOL_GPL(i2c_hid_get_dmi_quirks);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 26742ca14609a..3cfbffd94a058 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -599,6 +599,7 @@ struct hid_device {							/* device report descriptor */
 	unsigned long status;						/* see STAT flags above */
 	unsigned claimed;						/* Claimed by hidinput, hiddev? */
 	unsigned quirks;						/* Various quirks the device can pull on us */
+	unsigned initial_quirks;					/* Initial set of quirks supplied when creating device */
 	bool io_started;						/* If IO has started */
 
 	struct list_head inputs;					/* The list of inputs */
-- 
2.39.2



