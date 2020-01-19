Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C2B141E98
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 15:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgASOkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 09:40:17 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47411 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASOkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 09:40:16 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B41D25CA;
        Sun, 19 Jan 2020 09:40:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 09:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Moffb2
        ueJYQiwlRIaEA73qu5pKjg0Yvur2vIX9/Rx0Q=; b=BD6BdHCqdacNq9pEenSJz5
        A3Tj5SpeVBdb+m/gvJbbuDJ5KcMNeYXeVo+yOJL2Lfl86rOApAMoA8obcqrxQp/g
        kGrMB3l9R9DXxCejhw5b8iyN0gGORQBBCHlFk2F5vGLzXm63tOrieOpTPVT7tUhd
        pgqTyTd/MErqRCgtiGrnqVsEqEGf1g3MEFNWikI1KWeLxoY3k/Ore/CaeTU7Xrhf
        W+Hqvo9JPUeuIRfxrONuQzycuh2oJEyyh0SqUt3/ndnwiTTxkwO+DSWcRqKbPCUa
        gB9VwQbGT80qcNx4j4hNkpSoaJEnY0xl4R9mQtGrPTBBhdra87gO7HZl3ynvSu9Q
        ==
X-ME-Sender: <xms:T2okXtwkd2agz5T98rwINgEfPUKjUS-5_mUDOArTPkNe39BJI_JEBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvdeguddrudelje
    drieejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:T2okXgN4qX7tnnaHXJrao9200PhfQEAuvuWUqF1Zr23t1OED43_41g>
    <xmx:T2okXvgfh8k-ilNwMwiv7A8C6nz__q4htVFW5lX3Mz3lnXpB_Jccew>
    <xmx:T2okXuUQ21ojtukYelSFm0Bj0Ux6WbSGfxdO8U5UReM8PfXNWEQ6Lw>
    <xmx:T2okXoK8nwEebTdvVCo2tN785kNvUXTc69dLy-N3RvFD_uOE4tYo0Q>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6E5A3060ACE;
        Sun, 19 Jan 2020 09:40:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] cpu/SMT: Fix x86 link error without CONFIG_SYSFS" failed to apply to 4.14-stable tree
To:     arnd@arndb.de, jkosina@suse.cz, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 15:40:10 +0100
Message-ID: <157944481075214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dc8d37ed304eeeea47e65fb9edc1c6c8b0093386 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 10 Dec 2019 20:56:04 +0100
Subject: [PATCH] cpu/SMT: Fix x86 link error without CONFIG_SYSFS

When CONFIG_SYSFS is disabled, but CONFIG_HOTPLUG_SMT is enabled,
the kernel fails to link:

arch/x86/power/cpu.o: In function `hibernate_resume_nonboot_cpu_disable':
(.text+0x38d): undefined reference to `cpuhp_smt_enable'
arch/x86/power/hibernate.o: In function `arch_resume_nosmt':
hibernate.c:(.text+0x291): undefined reference to `cpuhp_smt_enable'
hibernate.c:(.text+0x29c): undefined reference to `cpuhp_smt_disable'

Move the exported functions out of the #ifdef section into its
own with the correct conditions.

The patch that caused this is marked for stable backports, so
this one may need to be backported as well.

Fixes: ec527c318036 ("x86/power: Fix 'nosmt' vs hibernation triple fault during resume")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191210195614.786555-1-arnd@arndb.de

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a59cc980adad..4dc279ed3b2d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1909,6 +1909,78 @@ void __cpuhp_remove_state(enum cpuhp_state state, bool invoke)
 }
 EXPORT_SYMBOL(__cpuhp_remove_state);
 
+#ifdef CONFIG_HOTPLUG_SMT
+static void cpuhp_offline_cpu_device(unsigned int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
+
+	dev->offline = true;
+	/* Tell user space about the state change */
+	kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+}
+
+static void cpuhp_online_cpu_device(unsigned int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
+
+	dev->offline = false;
+	/* Tell user space about the state change */
+	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+}
+
+int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
+{
+	int cpu, ret = 0;
+
+	cpu_maps_update_begin();
+	for_each_online_cpu(cpu) {
+		if (topology_is_primary_thread(cpu))
+			continue;
+		ret = cpu_down_maps_locked(cpu, CPUHP_OFFLINE);
+		if (ret)
+			break;
+		/*
+		 * As this needs to hold the cpu maps lock it's impossible
+		 * to call device_offline() because that ends up calling
+		 * cpu_down() which takes cpu maps lock. cpu maps lock
+		 * needs to be held as this might race against in kernel
+		 * abusers of the hotplug machinery (thermal management).
+		 *
+		 * So nothing would update device:offline state. That would
+		 * leave the sysfs entry stale and prevent onlining after
+		 * smt control has been changed to 'off' again. This is
+		 * called under the sysfs hotplug lock, so it is properly
+		 * serialized against the regular offline usage.
+		 */
+		cpuhp_offline_cpu_device(cpu);
+	}
+	if (!ret)
+		cpu_smt_control = ctrlval;
+	cpu_maps_update_done();
+	return ret;
+}
+
+int cpuhp_smt_enable(void)
+{
+	int cpu, ret = 0;
+
+	cpu_maps_update_begin();
+	cpu_smt_control = CPU_SMT_ENABLED;
+	for_each_present_cpu(cpu) {
+		/* Skip online CPUs and CPUs on offline nodes */
+		if (cpu_online(cpu) || !node_online(cpu_to_node(cpu)))
+			continue;
+		ret = _cpu_up(cpu, 0, CPUHP_ONLINE);
+		if (ret)
+			break;
+		/* See comment in cpuhp_smt_disable() */
+		cpuhp_online_cpu_device(cpu);
+	}
+	cpu_maps_update_done();
+	return ret;
+}
+#endif
+
 #if defined(CONFIG_SYSFS) && defined(CONFIG_HOTPLUG_CPU)
 static ssize_t show_cpuhp_state(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -2063,77 +2135,6 @@ static const struct attribute_group cpuhp_cpu_root_attr_group = {
 
 #ifdef CONFIG_HOTPLUG_SMT
 
-static void cpuhp_offline_cpu_device(unsigned int cpu)
-{
-	struct device *dev = get_cpu_device(cpu);
-
-	dev->offline = true;
-	/* Tell user space about the state change */
-	kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
-}
-
-static void cpuhp_online_cpu_device(unsigned int cpu)
-{
-	struct device *dev = get_cpu_device(cpu);
-
-	dev->offline = false;
-	/* Tell user space about the state change */
-	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
-}
-
-int cpuhp_smt_disable(enum cpuhp_smt_control ctrlval)
-{
-	int cpu, ret = 0;
-
-	cpu_maps_update_begin();
-	for_each_online_cpu(cpu) {
-		if (topology_is_primary_thread(cpu))
-			continue;
-		ret = cpu_down_maps_locked(cpu, CPUHP_OFFLINE);
-		if (ret)
-			break;
-		/*
-		 * As this needs to hold the cpu maps lock it's impossible
-		 * to call device_offline() because that ends up calling
-		 * cpu_down() which takes cpu maps lock. cpu maps lock
-		 * needs to be held as this might race against in kernel
-		 * abusers of the hotplug machinery (thermal management).
-		 *
-		 * So nothing would update device:offline state. That would
-		 * leave the sysfs entry stale and prevent onlining after
-		 * smt control has been changed to 'off' again. This is
-		 * called under the sysfs hotplug lock, so it is properly
-		 * serialized against the regular offline usage.
-		 */
-		cpuhp_offline_cpu_device(cpu);
-	}
-	if (!ret)
-		cpu_smt_control = ctrlval;
-	cpu_maps_update_done();
-	return ret;
-}
-
-int cpuhp_smt_enable(void)
-{
-	int cpu, ret = 0;
-
-	cpu_maps_update_begin();
-	cpu_smt_control = CPU_SMT_ENABLED;
-	for_each_present_cpu(cpu) {
-		/* Skip online CPUs and CPUs on offline nodes */
-		if (cpu_online(cpu) || !node_online(cpu_to_node(cpu)))
-			continue;
-		ret = _cpu_up(cpu, 0, CPUHP_ONLINE);
-		if (ret)
-			break;
-		/* See comment in cpuhp_smt_disable() */
-		cpuhp_online_cpu_device(cpu);
-	}
-	cpu_maps_update_done();
-	return ret;
-}
-
-
 static ssize_t
 __store_smt_control(struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)

