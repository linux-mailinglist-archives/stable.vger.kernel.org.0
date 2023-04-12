Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661B16DEE07
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjDLIjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjDLIjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B9383ED
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1838162FD3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA5DC433EF;
        Wed, 12 Apr 2023 08:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288532;
        bh=2aZKfhnBmLxKu17DkLyVIaMOiOhGJ6Zjj+QcSaKiKIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qxzs1peUcar272DwooCSDhOPFtSzfpfnRK5S5ikmXcdi+3wcMBNuddc99+hvSUCxo
         de/0otOLiXuzHHLwYqghWvi/N+n0OUTshCZGbMq7QrQhxRI5uDTM/NaSHTpn9+v9Qh
         QAkSpPdiBQBTQjgh0Oa4l6mXD7BnVhrcGJWWwZEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/93] platform/x86: int3472: Split into 2 drivers
Date:   Wed, 12 Apr 2023 10:33:15 +0200
Message-Id: <20230412082823.645923238@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a2f9fbc247eea0ad1b0b59bc29bec144c5ead03c ]

The intel_skl_int3472.ko module contains 2 separate drivers,
the int3472_discrete platform driver and the int3472_tps68470
I2C-driver.

These 2 drivers contain very little shared code, only
skl_int3472_get_acpi_buffer() and skl_int3472_fill_cldb() are
shared.

Split the module into 2 drivers, linking the little shared code
directly into both.

This will allow us to add soft-module dependencies for the
tps68470 clk, gpio and regulator drivers to the new
intel_skl_int3472_tps68470.ko to help with probe ordering issues
without causing these modules to get loaded on boards which only
use the int3472_discrete platform driver.

While at it also rename the .c and .h files to remove the
cumbersome intel_skl_int3472_ prefix.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211203102857.44539-8-hdegoede@redhat.com
Stable-dep-of: cf5ac2d45f6e ("platform/x86: int3472/discrete: Ensure the clk/power enable pins are in output mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/Makefile   |   9 +-
 ...lk_and_regulator.c => clk_and_regulator.c} |   2 +-
 drivers/platform/x86/intel/int3472/common.c   |  54 +++++++++
 .../{intel_skl_int3472_common.h => common.h}  |   3 -
 ...ntel_skl_int3472_discrete.c => discrete.c} |  28 ++++-
 .../intel/int3472/intel_skl_int3472_common.c  | 106 ------------------
 ...ntel_skl_int3472_tps68470.c => tps68470.c} |  23 +++-
 7 files changed, 105 insertions(+), 120 deletions(-)
 rename drivers/platform/x86/intel/int3472/{intel_skl_int3472_clk_and_regulator.c => clk_and_regulator.c} (99%)
 create mode 100644 drivers/platform/x86/intel/int3472/common.c
 rename drivers/platform/x86/intel/int3472/{intel_skl_int3472_common.h => common.h} (94%)
 rename drivers/platform/x86/intel/int3472/{intel_skl_int3472_discrete.c => discrete.c} (93%)
 delete mode 100644 drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c
 rename drivers/platform/x86/intel/int3472/{intel_skl_int3472_tps68470.c => tps68470.c} (85%)

diff --git a/drivers/platform/x86/intel/int3472/Makefile b/drivers/platform/x86/intel/int3472/Makefile
index 2362e04db18d5..771e720528a06 100644
--- a/drivers/platform/x86/intel/int3472/Makefile
+++ b/drivers/platform/x86/intel/int3472/Makefile
@@ -1,5 +1,4 @@
-obj-$(CONFIG_INTEL_SKL_INT3472)		+= intel_skl_int3472.o
-intel_skl_int3472-y			:= intel_skl_int3472_common.o \
-					   intel_skl_int3472_discrete.o \
-					   intel_skl_int3472_tps68470.o \
-					   intel_skl_int3472_clk_and_regulator.o
+obj-$(CONFIG_INTEL_SKL_INT3472)		+= intel_skl_int3472_discrete.o \
+					   intel_skl_int3472_tps68470.o
+intel_skl_int3472_discrete-y		:= discrete.o clk_and_regulator.o common.o
+intel_skl_int3472_tps68470-y		:= tps68470.o common.o
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
similarity index 99%
rename from drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c
rename to drivers/platform/x86/intel/int3472/clk_and_regulator.c
index 1700e7557a824..1cf958983e868 100644
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_clk_and_regulator.c
+++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
@@ -9,7 +9,7 @@
 #include <linux/regulator/driver.h>
 #include <linux/slab.h>
 
-#include "intel_skl_int3472_common.h"
+#include "common.h"
 
 /*
  * The regulators have to have .ops to be valid, but the only ops we actually
diff --git a/drivers/platform/x86/intel/int3472/common.c b/drivers/platform/x86/intel/int3472/common.c
new file mode 100644
index 0000000000000..350655a9515b1
--- /dev/null
+++ b/drivers/platform/x86/intel/int3472/common.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dan Scally <djrscally@gmail.com> */
+
+#include <linux/acpi.h>
+#include <linux/slab.h>
+
+#include "common.h"
+
+union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev, char *id)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_handle handle = adev->handle;
+	union acpi_object *obj;
+	acpi_status status;
+
+	status = acpi_evaluate_object(handle, id, NULL, &buffer);
+	if (ACPI_FAILURE(status))
+		return ERR_PTR(-ENODEV);
+
+	obj = buffer.pointer;
+	if (!obj)
+		return ERR_PTR(-ENODEV);
+
+	if (obj->type != ACPI_TYPE_BUFFER) {
+		acpi_handle_err(handle, "%s object is not an ACPI buffer\n", id);
+		kfree(obj);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return obj;
+}
+
+int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb)
+{
+	union acpi_object *obj;
+	int ret;
+
+	obj = skl_int3472_get_acpi_buffer(adev, "CLDB");
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	if (obj->buffer.length > sizeof(*cldb)) {
+		acpi_handle_err(adev->handle, "The CLDB buffer is too large\n");
+		ret = -EINVAL;
+		goto out_free_obj;
+	}
+
+	memcpy(cldb, obj->buffer.pointer, obj->buffer.length);
+	ret = 0;
+
+out_free_obj:
+	kfree(obj);
+	return ret;
+}
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h b/drivers/platform/x86/intel/int3472/common.h
similarity index 94%
rename from drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h
rename to drivers/platform/x86/intel/int3472/common.h
index 714fde73b5247..d14944ee85861 100644
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.h
+++ b/drivers/platform/x86/intel/int3472/common.h
@@ -105,9 +105,6 @@ struct int3472_discrete_device {
 	struct gpiod_lookup_table gpios;
 };
 
-int skl_int3472_discrete_probe(struct platform_device *pdev);
-int skl_int3472_discrete_remove(struct platform_device *pdev);
-int skl_int3472_tps68470_probe(struct i2c_client *client);
 union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev,
 					       char *id);
 int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb);
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
similarity index 93%
rename from drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c
rename to drivers/platform/x86/intel/int3472/discrete.c
index e59d79c7e82f8..d2e8a87a077e7 100644
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -14,7 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/uuid.h>
 
-#include "intel_skl_int3472_common.h"
+#include "common.h"
 
 /*
  * 79234640-9e10-4fea-a5c1-b5aa8b19756f
@@ -332,7 +332,9 @@ static int skl_int3472_parse_crs(struct int3472_discrete_device *int3472)
 	return 0;
 }
 
-int skl_int3472_discrete_probe(struct platform_device *pdev)
+static int skl_int3472_discrete_remove(struct platform_device *pdev);
+
+static int skl_int3472_discrete_probe(struct platform_device *pdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 	struct int3472_discrete_device *int3472;
@@ -395,7 +397,7 @@ int skl_int3472_discrete_probe(struct platform_device *pdev)
 	return ret;
 }
 
-int skl_int3472_discrete_remove(struct platform_device *pdev)
+static int skl_int3472_discrete_remove(struct platform_device *pdev)
 {
 	struct int3472_discrete_device *int3472 = platform_get_drvdata(pdev);
 
@@ -411,3 +413,23 @@ int skl_int3472_discrete_remove(struct platform_device *pdev)
 
 	return 0;
 }
+
+static const struct acpi_device_id int3472_device_id[] = {
+	{ "INT3472", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, int3472_device_id);
+
+static struct platform_driver int3472_discrete = {
+	.driver = {
+		.name = "int3472-discrete",
+		.acpi_match_table = int3472_device_id,
+	},
+	.probe = skl_int3472_discrete_probe,
+	.remove = skl_int3472_discrete_remove,
+};
+module_platform_driver(int3472_discrete);
+
+MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
+MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c b/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c
deleted file mode 100644
index 497e74fba75fb..0000000000000
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_common.c
+++ /dev/null
@@ -1,106 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Author: Dan Scally <djrscally@gmail.com> */
-
-#include <linux/acpi.h>
-#include <linux/i2c.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-
-#include "intel_skl_int3472_common.h"
-
-union acpi_object *skl_int3472_get_acpi_buffer(struct acpi_device *adev, char *id)
-{
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	acpi_handle handle = adev->handle;
-	union acpi_object *obj;
-	acpi_status status;
-
-	status = acpi_evaluate_object(handle, id, NULL, &buffer);
-	if (ACPI_FAILURE(status))
-		return ERR_PTR(-ENODEV);
-
-	obj = buffer.pointer;
-	if (!obj)
-		return ERR_PTR(-ENODEV);
-
-	if (obj->type != ACPI_TYPE_BUFFER) {
-		acpi_handle_err(handle, "%s object is not an ACPI buffer\n", id);
-		kfree(obj);
-		return ERR_PTR(-EINVAL);
-	}
-
-	return obj;
-}
-
-int skl_int3472_fill_cldb(struct acpi_device *adev, struct int3472_cldb *cldb)
-{
-	union acpi_object *obj;
-	int ret;
-
-	obj = skl_int3472_get_acpi_buffer(adev, "CLDB");
-	if (IS_ERR(obj))
-		return PTR_ERR(obj);
-
-	if (obj->buffer.length > sizeof(*cldb)) {
-		acpi_handle_err(adev->handle, "The CLDB buffer is too large\n");
-		ret = -EINVAL;
-		goto out_free_obj;
-	}
-
-	memcpy(cldb, obj->buffer.pointer, obj->buffer.length);
-	ret = 0;
-
-out_free_obj:
-	kfree(obj);
-	return ret;
-}
-
-static const struct acpi_device_id int3472_device_id[] = {
-	{ "INT3472", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(acpi, int3472_device_id);
-
-static struct platform_driver int3472_discrete = {
-	.driver = {
-		.name = "int3472-discrete",
-		.acpi_match_table = int3472_device_id,
-	},
-	.probe = skl_int3472_discrete_probe,
-	.remove = skl_int3472_discrete_remove,
-};
-
-static struct i2c_driver int3472_tps68470 = {
-	.driver = {
-		.name = "int3472-tps68470",
-		.acpi_match_table = int3472_device_id,
-	},
-	.probe_new = skl_int3472_tps68470_probe,
-};
-
-static int skl_int3472_init(void)
-{
-	int ret;
-
-	ret = platform_driver_register(&int3472_discrete);
-	if (ret)
-		return ret;
-
-	ret = i2c_register_driver(THIS_MODULE, &int3472_tps68470);
-	if (ret)
-		platform_driver_unregister(&int3472_discrete);
-
-	return ret;
-}
-module_init(skl_int3472_init);
-
-static void skl_int3472_exit(void)
-{
-	platform_driver_unregister(&int3472_discrete);
-	i2c_del_driver(&int3472_tps68470);
-}
-module_exit(skl_int3472_exit);
-
-MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Device Driver");
-MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c b/drivers/platform/x86/intel/int3472/tps68470.c
similarity index 85%
rename from drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c
rename to drivers/platform/x86/intel/int3472/tps68470.c
index c05b4cf502fef..fd3bef449137c 100644
--- a/drivers/platform/x86/intel/int3472/intel_skl_int3472_tps68470.c
+++ b/drivers/platform/x86/intel/int3472/tps68470.c
@@ -7,7 +7,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 
-#include "intel_skl_int3472_common.h"
+#include "common.h"
 
 #define DESIGNED_FOR_CHROMEOS		1
 #define DESIGNED_FOR_WINDOWS		2
@@ -95,7 +95,7 @@ static int skl_int3472_tps68470_calc_type(struct acpi_device *adev)
 	return DESIGNED_FOR_WINDOWS;
 }
 
-int skl_int3472_tps68470_probe(struct i2c_client *client)
+static int skl_int3472_tps68470_probe(struct i2c_client *client)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&client->dev);
 	struct regmap *regmap;
@@ -135,3 +135,22 @@ int skl_int3472_tps68470_probe(struct i2c_client *client)
 
 	return ret;
 }
+
+static const struct acpi_device_id int3472_device_id[] = {
+	{ "INT3472", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, int3472_device_id);
+
+static struct i2c_driver int3472_tps68470 = {
+	.driver = {
+		.name = "int3472-tps68470",
+		.acpi_match_table = int3472_device_id,
+	},
+	.probe_new = skl_int3472_tps68470_probe,
+};
+module_i2c_driver(int3472_tps68470);
+
+MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
+MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
+MODULE_LICENSE("GPL v2");
-- 
2.39.2



