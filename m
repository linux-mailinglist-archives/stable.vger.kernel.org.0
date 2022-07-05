Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED6C566E1D
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbiGEMbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237972AbiGEM0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B820A18B10;
        Tue,  5 Jul 2022 05:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76E6DB8170A;
        Tue,  5 Jul 2022 12:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D031BC341C7;
        Tue,  5 Jul 2022 12:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023524;
        bh=NiSSpyarBbFv1XaYutcUFHqtHs2VRzhfBYt+R7BAnt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyVanX24wekk9N4th79ybKO9RfEM7SqNRHEUUaArdgBaIHSjAFQbN8hTURP+kbi6m
         oXCNA4DJxD8T0LFwyOxJs3UdXSlWVkC7uob7xIXzFgOzgS5rt437kohU05wdVyvsWj
         EjZDMDLazzyYunqYUpsW3IslMnm9UAoxvL0pGByQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Kenneth Chan <kenneth.t.chan@gmail.com>
Subject: [PATCH 5.18 092/102] platform/x86: panasonic-laptop: filter out duplicate volume up/down/mute keypresses
Date:   Tue,  5 Jul 2022 13:58:58 +0200
Message-Id: <20220705115621.033015535@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit aacb455dfe01b7a24a792a2fbe7a04112ce8321d ]

On some Panasonic models the volume up/down/mute keypresses get
reported both through the Panasonic ACPI HKEY interface as well as
through the atkbd device.

Filter out the atkbd scan-codes for these to avoid reporting presses
twice.

Note normally we would leave the filtering of these to userspace by mapping
the scan-codes to KEY_UNKNOWN through /lib/udev/hwdb.d/60-keyboard.hwdb.
However in this case that would cause regressions since we were filtering
the Panasonic ACPI HKEY events before, so filter these in the kernel.

Fixes: ed83c9171829 ("platform/x86: panasonic-laptop: Resolve hotkey double trigger bug")
Reported-and-tested-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Reported-and-tested-by: Kenneth Chan <kenneth.t.chan@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220624112340.10130-7-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig            |  1 +
 drivers/platform/x86/panasonic-laptop.c | 41 +++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 634a6c1eb2d3..ddb8f14247c0 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -946,6 +946,7 @@ config PANASONIC_LAPTOP
 	depends on INPUT && ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on ACPI_VIDEO=n || ACPI_VIDEO
+	depends on SERIO_I8042 || SERIO_I8042 = n
 	select INPUT_SPARSEKMAP
 	help
 	  This driver adds support for access to backlight control and hotkeys
diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index d65e6c2372ca..615e39cbbbf1 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -122,6 +122,7 @@
 #include <linux/acpi.h>
 #include <linux/backlight.h>
 #include <linux/ctype.h>
+#include <linux/i8042.h>
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
@@ -129,6 +130,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/seq_file.h>
+#include <linux/serio.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
@@ -241,6 +243,42 @@ struct pcc_acpi {
 	struct platform_device	*platform;
 };
 
+/*
+ * On some Panasonic models the volume up / down / mute keys send duplicate
+ * keypress events over the PS/2 kbd interface, filter these out.
+ */
+static bool panasonic_i8042_filter(unsigned char data, unsigned char str,
+				   struct serio *port)
+{
+	static bool extended;
+
+	if (str & I8042_STR_AUXDATA)
+		return false;
+
+	if (data == 0xe0) {
+		extended = true;
+		return true;
+	} else if (extended) {
+		extended = false;
+
+		switch (data & 0x7f) {
+		case 0x20: /* e0 20 / e0 a0, Volume Mute press / release */
+		case 0x2e: /* e0 2e / e0 ae, Volume Down press / release */
+		case 0x30: /* e0 30 / e0 b0, Volume Up press / release */
+			return true;
+		default:
+			/*
+			 * Report the previously filtered e0 before continuing
+			 * with the next non-filtered byte.
+			 */
+			serio_interrupt(port, 0xe0, 0);
+			return false;
+		}
+	}
+
+	return false;
+}
+
 /* method access functions */
 static int acpi_pcc_write_sset(struct pcc_acpi *pcc, int func, int val)
 {
@@ -1006,6 +1044,7 @@ static int acpi_pcc_hotkey_add(struct acpi_device *device)
 		pcc->platform = NULL;
 	}
 
+	i8042_install_filter(panasonic_i8042_filter);
 	return 0;
 
 out_platform:
@@ -1029,6 +1068,8 @@ static int acpi_pcc_hotkey_remove(struct acpi_device *device)
 	if (!device || !pcc)
 		return -EINVAL;
 
+	i8042_remove_filter(panasonic_i8042_filter);
+
 	if (pcc->platform) {
 		device_remove_file(&pcc->platform->dev, &dev_attr_cdpower);
 		platform_device_unregister(pcc->platform);
-- 
2.35.1



