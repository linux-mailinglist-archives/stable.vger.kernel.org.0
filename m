Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E5454071D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347438AbiFGRm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347650AbiFGRjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:39:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E31D3EF28;
        Tue,  7 Jun 2022 10:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABCB0B822B6;
        Tue,  7 Jun 2022 17:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC7FC385A5;
        Tue,  7 Jun 2022 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623186;
        bh=M+wO0gucsAXwhXB5py56e2MHX9Zk2IutE7e7PbRevos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9t6l4QnSJ9Q+lY9DGLuRryuknA3D/17YA86g+ghYhh/7c/UACPT5qcb5XuLbRYNS
         Jw7Msb6mVKG5CzltArfWcz8KBhpIrrX2U/5T8rau5jFMu/QGR+IR/5hYtFs4VLN4Md
         0FE7c4ECgQ70Kz1YxIH19DZzkyR1761wql1qV2yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Li <lizhi01@loongson.cn>,
        Guenter Roeck <linux@roeck-us.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/452] MIPS: Loongson: Use hwmon_device_register_with_groups() to register hwmon
Date:   Tue,  7 Jun 2022 19:03:02 +0200
Message-Id: <20220607164918.245455363@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit abae018a03821be2b65c01ebe2bef06fd7d85a4c ]

Calling hwmon_device_register_with_info() with NULL dev and/or chip
information parameters is an ABI abuse and not a real conversion to
the new API. Also, the code creates sysfs attributes _after_ creating
the hwmon device, which is racy and unsupported to start with. On top
of that, the removal code tries to remove the name attribute which is
owned by the hwmon core.

Use hwmon_device_register_with_groups() to register the hwmon device
instead.

In the future, the hwmon subsystem will reject calls to
hwmon_device_register_with_info with NULL dev or chip/info parameters.
Without this patch, the hwmon device will fail to register.

Fixes: f59dc5119192 ("MIPS: Loongson: Fix boot warning about hwmon_device_register()")
Cc: Zhi Li <lizhi01@loongson.cn>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mips/cpu_hwmon.c | 127 ++++++++++--------------------
 1 file changed, 41 insertions(+), 86 deletions(-)

diff --git a/drivers/platform/mips/cpu_hwmon.c b/drivers/platform/mips/cpu_hwmon.c
index 386389ffec41..d8c5f9195f85 100644
--- a/drivers/platform/mips/cpu_hwmon.c
+++ b/drivers/platform/mips/cpu_hwmon.c
@@ -55,55 +55,6 @@ int loongson3_cpu_temp(int cpu)
 static int nr_packages;
 static struct device *cpu_hwmon_dev;
 
-static SENSOR_DEVICE_ATTR(name, 0444, NULL, NULL, 0);
-
-static struct attribute *cpu_hwmon_attributes[] = {
-	&sensor_dev_attr_name.dev_attr.attr,
-	NULL
-};
-
-/* Hwmon device attribute group */
-static struct attribute_group cpu_hwmon_attribute_group = {
-	.attrs = cpu_hwmon_attributes,
-};
-
-static ssize_t get_cpu_temp(struct device *dev,
-			struct device_attribute *attr, char *buf);
-static ssize_t cpu_temp_label(struct device *dev,
-			struct device_attribute *attr, char *buf);
-
-static SENSOR_DEVICE_ATTR(temp1_input, 0444, get_cpu_temp, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp1_label, 0444, cpu_temp_label, NULL, 1);
-static SENSOR_DEVICE_ATTR(temp2_input, 0444, get_cpu_temp, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp2_label, 0444, cpu_temp_label, NULL, 2);
-static SENSOR_DEVICE_ATTR(temp3_input, 0444, get_cpu_temp, NULL, 3);
-static SENSOR_DEVICE_ATTR(temp3_label, 0444, cpu_temp_label, NULL, 3);
-static SENSOR_DEVICE_ATTR(temp4_input, 0444, get_cpu_temp, NULL, 4);
-static SENSOR_DEVICE_ATTR(temp4_label, 0444, cpu_temp_label, NULL, 4);
-
-static const struct attribute *hwmon_cputemp[4][3] = {
-	{
-		&sensor_dev_attr_temp1_input.dev_attr.attr,
-		&sensor_dev_attr_temp1_label.dev_attr.attr,
-		NULL
-	},
-	{
-		&sensor_dev_attr_temp2_input.dev_attr.attr,
-		&sensor_dev_attr_temp2_label.dev_attr.attr,
-		NULL
-	},
-	{
-		&sensor_dev_attr_temp3_input.dev_attr.attr,
-		&sensor_dev_attr_temp3_label.dev_attr.attr,
-		NULL
-	},
-	{
-		&sensor_dev_attr_temp4_input.dev_attr.attr,
-		&sensor_dev_attr_temp4_label.dev_attr.attr,
-		NULL
-	}
-};
-
 static ssize_t cpu_temp_label(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -121,24 +72,47 @@ static ssize_t get_cpu_temp(struct device *dev,
 	return sprintf(buf, "%d\n", value);
 }
 
-static int create_sysfs_cputemp_files(struct kobject *kobj)
-{
-	int i, ret = 0;
-
-	for (i = 0; i < nr_packages; i++)
-		ret = sysfs_create_files(kobj, hwmon_cputemp[i]);
+static SENSOR_DEVICE_ATTR(temp1_input, 0444, get_cpu_temp, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp1_label, 0444, cpu_temp_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_input, 0444, get_cpu_temp, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp2_label, 0444, cpu_temp_label, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp3_input, 0444, get_cpu_temp, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp3_label, 0444, cpu_temp_label, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp4_input, 0444, get_cpu_temp, NULL, 4);
+static SENSOR_DEVICE_ATTR(temp4_label, 0444, cpu_temp_label, NULL, 4);
 
-	return ret;
-}
+static struct attribute *cpu_hwmon_attributes[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_label.dev_attr.attr,
+	&sensor_dev_attr_temp4_input.dev_attr.attr,
+	&sensor_dev_attr_temp4_label.dev_attr.attr,
+	NULL
+};
 
-static void remove_sysfs_cputemp_files(struct kobject *kobj)
+static umode_t cpu_hwmon_is_visible(struct kobject *kobj,
+				    struct attribute *attr, int i)
 {
-	int i;
+	int id = i / 2;
 
-	for (i = 0; i < nr_packages; i++)
-		sysfs_remove_files(kobj, hwmon_cputemp[i]);
+	if (id < nr_packages)
+		return attr->mode;
+	return 0;
 }
 
+static struct attribute_group cpu_hwmon_group = {
+	.attrs = cpu_hwmon_attributes,
+	.is_visible = cpu_hwmon_is_visible,
+};
+
+static const struct attribute_group *cpu_hwmon_groups[] = {
+	&cpu_hwmon_group,
+	NULL
+};
+
 #define CPU_THERMAL_THRESHOLD 90000
 static struct delayed_work thermal_work;
 
@@ -159,50 +133,31 @@ static void do_thermal_timer(struct work_struct *work)
 
 static int __init loongson_hwmon_init(void)
 {
-	int ret;
-
 	pr_info("Loongson Hwmon Enter...\n");
 
 	if (cpu_has_csr())
 		csr_temp_enable = csr_readl(LOONGSON_CSR_FEATURES) &
 				  LOONGSON_CSRF_TEMP;
 
-	cpu_hwmon_dev = hwmon_device_register_with_info(NULL, "cpu_hwmon", NULL, NULL, NULL);
-	if (IS_ERR(cpu_hwmon_dev)) {
-		ret = PTR_ERR(cpu_hwmon_dev);
-		pr_err("hwmon_device_register fail!\n");
-		goto fail_hwmon_device_register;
-	}
-
 	nr_packages = loongson_sysconf.nr_cpus /
 		loongson_sysconf.cores_per_package;
 
-	ret = create_sysfs_cputemp_files(&cpu_hwmon_dev->kobj);
-	if (ret) {
-		pr_err("fail to create cpu temperature interface!\n");
-		goto fail_create_sysfs_cputemp_files;
+	cpu_hwmon_dev = hwmon_device_register_with_groups(NULL, "cpu_hwmon",
+							  NULL, cpu_hwmon_groups);
+	if (IS_ERR(cpu_hwmon_dev)) {
+		pr_err("hwmon_device_register fail!\n");
+		return PTR_ERR(cpu_hwmon_dev);
 	}
 
 	INIT_DEFERRABLE_WORK(&thermal_work, do_thermal_timer);
 	schedule_delayed_work(&thermal_work, msecs_to_jiffies(20000));
 
-	return ret;
-
-fail_create_sysfs_cputemp_files:
-	sysfs_remove_group(&cpu_hwmon_dev->kobj,
-				&cpu_hwmon_attribute_group);
-	hwmon_device_unregister(cpu_hwmon_dev);
-
-fail_hwmon_device_register:
-	return ret;
+	return 0;
 }
 
 static void __exit loongson_hwmon_exit(void)
 {
 	cancel_delayed_work_sync(&thermal_work);
-	remove_sysfs_cputemp_files(&cpu_hwmon_dev->kobj);
-	sysfs_remove_group(&cpu_hwmon_dev->kobj,
-				&cpu_hwmon_attribute_group);
 	hwmon_device_unregister(cpu_hwmon_dev);
 }
 
-- 
2.35.1



