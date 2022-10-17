Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3821601715
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 21:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiJQTLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 15:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJQTLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 15:11:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873E76687B;
        Mon, 17 Oct 2022 12:11:27 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:11:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666033885;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zW1T/83Pu0OQGcVph7cu9a5DhVATEM5PoEDuRUkpZbA=;
        b=MTZ4NUPg4tl2hp3Uz2hRO7kYt1luwb2VNQ8c0JB9hKu70guBPZuOWer98yVEnL/kBftcGE
        xlfH3bTXKQ3RTOjwIW0TD9UXFdLtN+z4UHRl8VMqRHF3XQYnDNsveRW4CRAFlCEePHlsOy
        kqXcrAtcrBOs5ZACb2Yyc7oQ3yVFSex1iNarJi3RkOckYwFzH9BO0gECBVfciZOrrxTjPH
        fGub2yCT58npw0yNAgvXhhb6a0SrbeqTGJiRLJXYprftpAO/IJItDTDLAi6cnMj9zFH0CM
        G5ckN2Na/80ZNgW9k8yCyALNv42u8rqVzhf132xTMliZaQUcxqPLo1ULLcNOUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666033885;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zW1T/83Pu0OQGcVph7cu9a5DhVATEM5PoEDuRUkpZbA=;
        b=XrQqLmJ3wWF0YSv0WOq3aV8WXMsIOGXb6st/v4j9ltNX0krcKEN+xD/rjA3bmWDf/WdMFa
        OvGfHvbHGqX1ueDg==
From:   "tip-bot2 for Zhang Rui" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] hwmon/coretemp: Handle large core ID value
Cc:     Zhang Rui <rui.zhang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20221014090147.1836-3-rui.zhang@intel.com>
References: <20221014090147.1836-3-rui.zhang@intel.com>
MIME-Version: 1.0
Message-ID: <166603388384.401.11492904277823836791.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     7108b80a542b9d65e44b36d64a700a83658c0b73
Gitweb:        https://git.kernel.org/tip/7108b80a542b9d65e44b36d64a700a83658c0b73
Author:        Zhang Rui <rui.zhang@intel.com>
AuthorDate:    Fri, 14 Oct 2022 17:01:45 +08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Mon, 17 Oct 2022 11:58:52 -07:00

hwmon/coretemp: Handle large core ID value

The coretemp driver supports up to a hard-coded limit of 128 cores.

Today, the driver can not support a core with an ID above that limit.
Yet, the encoding of core ID's is arbitrary (BIOS APIC-ID) and so they
may be sparse and they may be large.

Update the driver to map arbitrary core ID numbers into appropriate
array indexes so that 128 cores can be supported, no matter the encoding
of core ID's.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Len Brown <len.brown@intel.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221014090147.1836-3-rui.zhang@intel.com
---
 drivers/hwmon/coretemp.c | 56 ++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index ccf0af5..8bf32c6 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -46,9 +46,6 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
-#define TO_CORE_ID(cpu)		(cpu_data(cpu).cpu_core_id)
-#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
-
 #ifdef CONFIG_SMP
 #define for_each_sibling(i, cpu) \
 	for_each_cpu(i, topology_sibling_cpumask(cpu))
@@ -91,6 +88,8 @@ struct temp_data {
 struct platform_data {
 	struct device		*hwmon_dev;
 	u16			pkg_id;
+	u16			cpu_map[NUM_REAL_CORES];
+	struct ida		ida;
 	struct cpumask		cpumask;
 	struct temp_data	*core_data[MAX_CORE_DATA];
 	struct device_attribute name_attr;
@@ -441,7 +440,7 @@ static struct temp_data *init_temp_data(unsigned int cpu, int pkg_flag)
 							MSR_IA32_THERM_STATUS;
 	tdata->is_pkg_data = pkg_flag;
 	tdata->cpu = cpu;
-	tdata->cpu_core_id = TO_CORE_ID(cpu);
+	tdata->cpu_core_id = topology_core_id(cpu);
 	tdata->attr_size = MAX_CORE_ATTRS;
 	mutex_init(&tdata->update_lock);
 	return tdata;
@@ -454,7 +453,7 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	u32 eax, edx;
-	int err, attr_no;
+	int err, index, attr_no;
 
 	/*
 	 * Find attr number for sysfs:
@@ -462,14 +461,26 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	 * The attr number is always core id + 2
 	 * The Pkgtemp will always show up as temp1_*, if available
 	 */
-	attr_no = pkg_flag ? PKG_SYSFS_ATTR_NO : TO_ATTR_NO(cpu);
+	if (pkg_flag) {
+		attr_no = PKG_SYSFS_ATTR_NO;
+	} else {
+		index = ida_alloc(&pdata->ida, GFP_KERNEL);
+		if (index < 0)
+			return index;
+		pdata->cpu_map[index] = topology_core_id(cpu);
+		attr_no = index + BASE_SYSFS_ATTR_NO;
+	}
 
-	if (attr_no > MAX_CORE_DATA - 1)
-		return -ERANGE;
+	if (attr_no > MAX_CORE_DATA - 1) {
+		err = -ERANGE;
+		goto ida_free;
+	}
 
 	tdata = init_temp_data(cpu, pkg_flag);
-	if (!tdata)
-		return -ENOMEM;
+	if (!tdata) {
+		err = -ENOMEM;
+		goto ida_free;
+	}
 
 	/* Test if we can access the status register */
 	err = rdmsr_safe_on_cpu(cpu, tdata->status_reg, &eax, &edx);
@@ -505,6 +516,9 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 exit_free:
 	pdata->core_data[attr_no] = NULL;
 	kfree(tdata);
+ida_free:
+	if (!pkg_flag)
+		ida_free(&pdata->ida, index);
 	return err;
 }
 
@@ -524,6 +538,9 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 
 	kfree(pdata->core_data[indx]);
 	pdata->core_data[indx] = NULL;
+
+	if (indx >= BASE_SYSFS_ATTR_NO)
+		ida_free(&pdata->ida, indx - BASE_SYSFS_ATTR_NO);
 }
 
 static int coretemp_probe(struct platform_device *pdev)
@@ -537,6 +554,7 @@ static int coretemp_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pdata->pkg_id = pdev->id;
+	ida_init(&pdata->ida);
 	platform_set_drvdata(pdev, pdata);
 
 	pdata->hwmon_dev = devm_hwmon_device_register_with_groups(dev, DRVNAME,
@@ -553,6 +571,7 @@ static int coretemp_remove(struct platform_device *pdev)
 		if (pdata->core_data[i])
 			coretemp_remove_core(pdata, i);
 
+	ida_destroy(&pdata->ida);
 	return 0;
 }
 
@@ -647,7 +666,7 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	struct platform_device *pdev = coretemp_get_pdev(cpu);
 	struct platform_data *pd;
 	struct temp_data *tdata;
-	int indx, target;
+	int i, indx = -1, target;
 
 	/*
 	 * Don't execute this on suspend as the device remove locks
@@ -660,12 +679,19 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	if (!pdev)
 		return 0;
 
-	/* The core id is too big, just return */
-	indx = TO_ATTR_NO(cpu);
-	if (indx > MAX_CORE_DATA - 1)
+	pd = platform_get_drvdata(pdev);
+
+	for (i = 0; i < NUM_REAL_CORES; i++) {
+		if (pd->cpu_map[i] == topology_core_id(cpu)) {
+			indx = i + BASE_SYSFS_ATTR_NO;
+			break;
+		}
+	}
+
+	/* Too many cores and this core is not populated, just return */
+	if (indx < 0)
 		return 0;
 
-	pd = platform_get_drvdata(pdev);
 	tdata = pd->core_data[indx];
 
 	cpumask_clear_cpu(cpu, &pd->cpumask);
