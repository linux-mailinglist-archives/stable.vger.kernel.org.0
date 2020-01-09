Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57F8135E6A
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 17:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgAIQhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 11:37:03 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54951 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgAIQhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 11:37:03 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ipanq-0007bb-QK; Thu, 09 Jan 2020 17:36:58 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 7596F1C2CE8;
        Thu,  9 Jan 2020 17:36:58 +0100 (CET)
Date:   Thu, 09 Jan 2020 16:36:58 -0000
From:   "tip-bot2 for Arnd Bergmann" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: smp/urgent] cpu/SMT: Fix x86 link error without CONFIG_SYSFS
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191210195614.786555-1-arnd@arndb.de>
References: <20191210195614.786555-1-arnd@arndb.de>
MIME-Version: 1.0
Message-ID: <157858781831.30329.9402583283109438334.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the smp/urgent branch of tip:

Commit-ID:     dc8d37ed304eeeea47e65fb9edc1c6c8b0093386
Gitweb:        https://git.kernel.org/tip/dc8d37ed304eeeea47e65fb9edc1c6c8b0093386
Author:        Arnd Bergmann <arnd@arndb.de>
AuthorDate:    Tue, 10 Dec 2019 20:56:04 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 09 Jan 2020 17:31:45 +01:00

cpu/SMT: Fix x86 link error without CONFIG_SYSFS

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

---
 kernel/cpu.c | 143 +++++++++++++++++++++++++-------------------------
 1 file changed, 72 insertions(+), 71 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a59cc98..4dc279e 100644
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
