Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C865FD13D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbiJMAft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbiJMAeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:34:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE686DFC14;
        Wed, 12 Oct 2022 17:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C55FB616DE;
        Thu, 13 Oct 2022 00:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D631C433D6;
        Thu, 13 Oct 2022 00:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620889;
        bh=I8tDkkhVlI0xI5B8QOSYoWRpdNrVeD0qfzp2Xv/pGWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIJOdJLjxPj6JjG0q93AFj98fGiADNyGBe3kUDXzLEcUAB8hoZb3v0jb/6yjGk4vV
         zEYebmvcf52qTM4/QBP6C/UffsYO5Gxq0q8uxaHZ29eL+ELdYxw87Myi3O4KFllt6I
         BHMWHcy0ckvakkXZWrNKD/NdQmnuDOQJP/QNa0KNfGlch+RCr1QRjfaAvcLKC4Eyfh
         fSYAdsLtGK+UYICoK5DgGc+QKfxOifyIXyHW7rbKYfjlU7nZxEAzODCQY1hI3nGxoz
         fn/nz74w4SRXV9ZpOlUjwlv+Zrkt+yoptrCeL0WuICD1IYz5qD41J0Hd4Pur/1de+5
         B3+tQSVa4eZTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harry Stern <harry@harrystern.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/10] hid: topre: Add driver fixing report descriptor
Date:   Wed, 12 Oct 2022 20:27:50 -0400
Message-Id: <20221013002802.1896096-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002802.1896096-1-sashal@kernel.org>
References: <20221013002802.1896096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Stern <harry@harrystern.net>

[ Upstream commit a109d5c45b3d6728b9430716b915afbe16eef27c ]

The Topre REALFORCE R2 firmware incorrectly reports that interface
descriptor number 1, input report descriptor 2's events are array events
rather than variable events. That particular report descriptor is used
to report keypresses when there are more than 6 keys held at a time.
This bug prevents events from this interface from being registered
properly, so only 6 keypresses (from a different interface) can be
registered at once, rather than full n-key rollover.

This commit fixes the bug by setting the correct value in a report_fixup
function.

The original bug report can be found here:
Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/804

Thanks to Benjamin Tissoires for diagnosing the issue with the report
descriptor.

Signed-off-by: Harry Stern <harry@harrystern.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20220911003614.297613-1-harry@harrystern.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig     |  6 +++++
 drivers/hid/Makefile    |  1 +
 drivers/hid/hid-ids.h   |  3 +++
 drivers/hid/hid-topre.c | 49 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)
 create mode 100644 drivers/hid/hid-topre.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 2b5ae00f8df2..80c54cd437db 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -837,6 +837,12 @@ config HID_TOPSEED
 	Say Y if you have a TopSeed Cyberlink or BTC Emprex or Conceptronic
 	CLLRCMCE remote control.
 
+config HID_TOPRE
+	tristate "Topre REALFORCE keyboards"
+	depends on HID
+	help
+	  Say Y for N-key rollover support on Topre REALFORCE R2 108 key keyboards.
+
 config HID_THINGM
 	tristate "ThingM blink(1) USB RGB LED"
 	depends on HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 86b2b5785fd2..245878158850 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
 obj-$(CONFIG_HID_TIVO)		+= hid-tivo.o
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
+obj-$(CONFIG_HID_TOPRE)	+= hid-topre.o
 obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
 obj-$(CONFIG_HID_UCLOGIC)	+= hid-uclogic.o
 obj-$(CONFIG_HID_LED)		+= hid-led.o
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1f641870d860..3ae9f6489f8f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1001,6 +1001,9 @@
 #define USB_DEVICE_ID_TIVO_SLIDE	0x1201
 #define USB_DEVICE_ID_TIVO_SLIDE_PRO	0x1203
 
+#define USB_VENDOR_ID_TOPRE			0x0853
+#define USB_DEVICE_ID_TOPRE_REALFORCE_R2_108			0x0148
+
 #define USB_VENDOR_ID_TOPSEED		0x0766
 #define USB_DEVICE_ID_TOPSEED_CYBERLINK	0x0204
 
diff --git a/drivers/hid/hid-topre.c b/drivers/hid/hid-topre.c
new file mode 100644
index 000000000000..88a91cdad5f8
--- /dev/null
+++ b/drivers/hid/hid-topre.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ *  HID driver for Topre REALFORCE Keyboards
+ *
+ *  Copyright (c) 2022 Harry Stern <harry@harrystern.net>
+ *
+ *  Based on the hid-macally driver
+ */
+
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+MODULE_AUTHOR("Harry Stern <harry@harrystern.net>");
+MODULE_DESCRIPTION("REALFORCE R2 Keyboard driver");
+MODULE_LICENSE("GPL");
+
+/*
+ * Fix the REALFORCE R2's non-boot interface's report descriptor to match the
+ * events it's actually sending. It claims to send array events but is instead
+ * sending variable events.
+ */
+static __u8 *topre_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+				 unsigned int *rsize)
+{
+	if (*rsize >= 119 && rdesc[69] == 0x29 && rdesc[70] == 0xe7 &&
+						 rdesc[71] == 0x81 && rdesc[72] == 0x00) {
+		hid_info(hdev,
+			"fixing up Topre REALFORCE keyboard report descriptor\n");
+		rdesc[72] = 0x02;
+	}
+	return rdesc;
+}
+
+static const struct hid_device_id topre_id_table[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPRE,
+			 USB_DEVICE_ID_TOPRE_REALFORCE_R2_108) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, topre_id_table);
+
+static struct hid_driver topre_driver = {
+	.name			= "topre",
+	.id_table		= topre_id_table,
+	.report_fixup		= topre_report_fixup,
+};
+
+module_hid_driver(topre_driver);
-- 
2.35.1

