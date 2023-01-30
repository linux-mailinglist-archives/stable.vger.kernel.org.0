Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9A6810DD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbjA3OHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237129AbjA3OHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:07:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF9A3BD80
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:07:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE2FBCE16BA
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA66EC433D2;
        Mon, 30 Jan 2023 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087647;
        bh=PtAuXWgnXXdw5oqeuV6B6C6pLVpDlBDs++FN8X33Z9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xD4BZhwBKBCuIusp4SCwWth8a/+JIQTN6F7f9ku1WMeVibEUl6DdLB6ISpLXnh0bQ
         1ZVvUZ0HHOy7Xm0yC+ah/0BWxwslQH7S2DstlRNUmtlk0g0uur5FpCLfmGihsjP25r
         IOLj5Ib7j0mq+0ADVaHvQA5mYTjM7SdlReVYd308=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emmanouil Kouroupakis <kartebi@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/313] platform/x86: apple-gmux: Add apple_gmux_detect() helper
Date:   Mon, 30 Jan 2023 14:51:53 +0100
Message-Id: <20230130134349.681278811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d143908f80f3e5d164ac3342f73d6b9f536e8b4d ]

Add a new (static inline) apple_gmux_detect() helper to apple-gmux.h
which can be used for gmux detection instead of apple_gmux_present().

The latter is not really reliable since an ACPI device with a HID
of APP000B is present on some devices without a gmux at all, as well
as on devices with a newer (unsupported) MMIO based gmux model.

This causes apple_gmux_present() to return false-positives on
a number of different Apple laptop models.

This new helper uses the same probing as the actual apple-gmux
driver, so that it does not return false positives.

To avoid code duplication the gmux_probe() function of the actual
driver is also moved over to using the new apple_gmux_detect() helper.

This avoids false positives (vs _HID + IO region detection) on:

MacBookPro5,4
https://pastebin.com/8Xjq7RhS

MacBookPro8,1
https://linux-hardware.org/?probe=e513cfbadb&log=dmesg

MacBookPro9,2
https://bugzilla.kernel.org/attachment.cgi?id=278961

MacBookPro10,2
https://lkml.org/lkml/2014/9/22/657

MacBookPro11,2
https://forums.fedora-fr.org/viewtopic.php?id=70142

MacBookPro11,4
https://raw.githubusercontent.com/im-0/investigate-card-reader-suspend-problem-on-mbp11.4/master/test-16/dmesg

Fixes: 21245df307cb ("ACPI: video: Add Apple GMUX brightness control detection")
Link: https://lore.kernel.org/platform-driver-x86/20230123113750.462144-1-hdegoede@redhat.com/
Reported-by: Emmanouil Kouroupakis <kartebi@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230124105754.62167-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/apple-gmux.c | 70 +++++++------------------
 include/linux/apple-gmux.h        | 86 ++++++++++++++++++++++++++++++-
 2 files changed, 102 insertions(+), 54 deletions(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index a0af01f6a0fd..9333f82cfa8a 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -226,23 +226,6 @@ static void gmux_write32(struct apple_gmux_data *gmux_data, int port,
 		gmux_pio_write32(gmux_data, port, val);
 }
 
-static bool gmux_is_indexed(struct apple_gmux_data *gmux_data)
-{
-	u16 val;
-
-	outb(0xaa, gmux_data->iostart + 0xcc);
-	outb(0x55, gmux_data->iostart + 0xcd);
-	outb(0x00, gmux_data->iostart + 0xce);
-
-	val = inb(gmux_data->iostart + 0xcc) |
-		(inb(gmux_data->iostart + 0xcd) << 8);
-
-	if (val == 0x55aa)
-		return true;
-
-	return false;
-}
-
 /**
  * DOC: Backlight control
  *
@@ -582,60 +565,43 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	int ret = -ENXIO;
 	acpi_status status;
 	unsigned long long gpe;
+	bool indexed = false;
+	u32 version;
 
 	if (apple_gmux_data)
 		return -EBUSY;
 
+	if (!apple_gmux_detect(pnp, &indexed)) {
+		pr_info("gmux device not present\n");
+		return -ENODEV;
+	}
+
 	gmux_data = kzalloc(sizeof(*gmux_data), GFP_KERNEL);
 	if (!gmux_data)
 		return -ENOMEM;
 	pnp_set_drvdata(pnp, gmux_data);
 
 	res = pnp_get_resource(pnp, IORESOURCE_IO, 0);
-	if (!res) {
-		pr_err("Failed to find gmux I/O resource\n");
-		goto err_free;
-	}
-
 	gmux_data->iostart = res->start;
 	gmux_data->iolen = resource_size(res);
 
-	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
-		pr_err("gmux I/O region too small (%lu < %u)\n",
-		       gmux_data->iolen, GMUX_MIN_IO_LEN);
-		goto err_free;
-	}
-
 	if (!request_region(gmux_data->iostart, gmux_data->iolen,
 			    "Apple gmux")) {
 		pr_err("gmux I/O already in use\n");
 		goto err_free;
 	}
 
-	/*
-	 * Invalid version information may indicate either that the gmux
-	 * device isn't present or that it's a new one that uses indexed
-	 * io
-	 */
-
-	ver_major = gmux_read8(gmux_data, GMUX_PORT_VERSION_MAJOR);
-	ver_minor = gmux_read8(gmux_data, GMUX_PORT_VERSION_MINOR);
-	ver_release = gmux_read8(gmux_data, GMUX_PORT_VERSION_RELEASE);
-	if (ver_major == 0xff && ver_minor == 0xff && ver_release == 0xff) {
-		if (gmux_is_indexed(gmux_data)) {
-			u32 version;
-			mutex_init(&gmux_data->index_lock);
-			gmux_data->indexed = true;
-			version = gmux_read32(gmux_data,
-				GMUX_PORT_VERSION_MAJOR);
-			ver_major = (version >> 24) & 0xff;
-			ver_minor = (version >> 16) & 0xff;
-			ver_release = (version >> 8) & 0xff;
-		} else {
-			pr_info("gmux device not present\n");
-			ret = -ENODEV;
-			goto err_release;
-		}
+	if (indexed) {
+		mutex_init(&gmux_data->index_lock);
+		gmux_data->indexed = true;
+		version = gmux_read32(gmux_data, GMUX_PORT_VERSION_MAJOR);
+		ver_major = (version >> 24) & 0xff;
+		ver_minor = (version >> 16) & 0xff;
+		ver_release = (version >> 8) & 0xff;
+	} else {
+		ver_major = gmux_read8(gmux_data, GMUX_PORT_VERSION_MAJOR);
+		ver_minor = gmux_read8(gmux_data, GMUX_PORT_VERSION_MINOR);
+		ver_release = gmux_read8(gmux_data, GMUX_PORT_VERSION_RELEASE);
 	}
 	pr_info("Found gmux version %d.%d.%d [%s]\n", ver_major, ver_minor,
 		ver_release, (gmux_data->indexed ? "indexed" : "classic"));
diff --git a/include/linux/apple-gmux.h b/include/linux/apple-gmux.h
index 80efaaf89e07..1f68b49bcd68 100644
--- a/include/linux/apple-gmux.h
+++ b/include/linux/apple-gmux.h
@@ -8,6 +8,8 @@
 #define LINUX_APPLE_GMUX_H
 
 #include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/pnp.h>
 
 #define GMUX_ACPI_HID "APP000B"
 
@@ -35,14 +37,89 @@
 #define GMUX_MIN_IO_LEN			(GMUX_PORT_BRIGHTNESS + 4)
 
 #if IS_ENABLED(CONFIG_APPLE_GMUX)
+static inline bool apple_gmux_is_indexed(unsigned long iostart)
+{
+	u16 val;
+
+	outb(0xaa, iostart + 0xcc);
+	outb(0x55, iostart + 0xcd);
+	outb(0x00, iostart + 0xce);
+
+	val = inb(iostart + 0xcc) | (inb(iostart + 0xcd) << 8);
+	if (val == 0x55aa)
+		return true;
+
+	return false;
+}
 
 /**
- * apple_gmux_present() - detect if gmux is built into the machine
+ * apple_gmux_detect() - detect if gmux is built into the machine
+ *
+ * @pnp_dev:     Device to probe or NULL to use the first matching device
+ * @indexed_ret: Returns (by reference) if the gmux is indexed or not
+ *
+ * Detect if a supported gmux device is present by actually probing it.
+ * This avoids the false positives returned on some models by
+ * apple_gmux_present().
+ *
+ * Return: %true if a supported gmux ACPI device is detected and the kernel
+ * was configured with CONFIG_APPLE_GMUX, %false otherwise.
+ */
+static inline bool apple_gmux_detect(struct pnp_dev *pnp_dev, bool *indexed_ret)
+{
+	u8 ver_major, ver_minor, ver_release;
+	struct device *dev = NULL;
+	struct acpi_device *adev;
+	struct resource *res;
+	bool indexed = false;
+	bool ret = false;
+
+	if (!pnp_dev) {
+		adev = acpi_dev_get_first_match_dev(GMUX_ACPI_HID, NULL, -1);
+		if (!adev)
+			return false;
+
+		dev = get_device(acpi_get_first_physical_node(adev));
+		acpi_dev_put(adev);
+		if (!dev)
+			return false;
+
+		pnp_dev = to_pnp_dev(dev);
+	}
+
+	res = pnp_get_resource(pnp_dev, IORESOURCE_IO, 0);
+	if (!res || resource_size(res) < GMUX_MIN_IO_LEN)
+		goto out;
+
+	/*
+	 * Invalid version information may indicate either that the gmux
+	 * device isn't present or that it's a new one that uses indexed io.
+	 */
+	ver_major = inb(res->start + GMUX_PORT_VERSION_MAJOR);
+	ver_minor = inb(res->start + GMUX_PORT_VERSION_MINOR);
+	ver_release = inb(res->start + GMUX_PORT_VERSION_RELEASE);
+	if (ver_major == 0xff && ver_minor == 0xff && ver_release == 0xff) {
+		indexed = apple_gmux_is_indexed(res->start);
+		if (!indexed)
+			goto out;
+	}
+
+	if (indexed_ret)
+		*indexed_ret = indexed;
+
+	ret = true;
+out:
+	put_device(dev);
+	return ret;
+}
+
+/**
+ * apple_gmux_present() - check if gmux ACPI device is present
  *
  * Drivers may use this to activate quirks specific to dual GPU MacBook Pros
  * and Mac Pros, e.g. for deferred probing, runtime pm and backlight.
  *
- * Return: %true if gmux is present and the kernel was configured
+ * Return: %true if gmux ACPI device is present and the kernel was configured
  * with CONFIG_APPLE_GMUX, %false otherwise.
  */
 static inline bool apple_gmux_present(void)
@@ -57,6 +134,11 @@ static inline bool apple_gmux_present(void)
 	return false;
 }
 
+static inline bool apple_gmux_detect(struct pnp_dev *pnp_dev, bool *indexed_ret)
+{
+	return false;
+}
+
 #endif /* !CONFIG_APPLE_GMUX */
 
 #endif /* LINUX_APPLE_GMUX_H */
-- 
2.39.0



