Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B71119133
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 20:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfLJT4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 14:56:46 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:34351 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJT4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 14:56:45 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MmUYD-1hwKB739ZR-00iX84; Tue, 10 Dec 2019 20:56:16 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cpu/SMT: fix x86 link error without CONFIG_SYSFS
Date:   Tue, 10 Dec 2019 20:56:04 +0100
Message-Id: <20191210195614.786555-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Lhgy+TLPrpKC+p8I+nsIjWlONz8OSO3TvN92ptxLdXyz9obROae
 ByqClpbAdmQNpjwA2Pr1tCObgRX1Pp1Rd9CKU5LQOr4PXmSNN6A3DhLMJ3IQFcUS9yQCFFa
 TPhTYkLm5/bxaOUTAnT4fnhkVC4lK/B7v7WFhAOnMYA266yWgzoxqC+cG4RjUg5YpD8PQT+
 HosTCOJg7UsTXHD8BT1rA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HcbRH5zs0c0=:6E1UYLaT8aHUO/MrY2mlNx
 0NzoaNqqIgVPdltQDBVOKxqwvWl3ZkUX+jd6iMoCkveqKKCVZ5ssLkNamQ8nvW3ssPb9racW5
 EHg8DGRz6Q5V0VvC28fq80TNsIdwfRpkQDFVii7oiL8TOV3LDiG6GPhtwiQmSWwL8bVD9Ks2n
 4DvDh2fSJE7Xf1bhHBPYkDj5ENho+OwjwYI7dkqsgHbqiK0ELDlwmsptLyw8Tr2v/N4phS9gH
 PUsRSKYWRHoMVpGQLTcpC1hMA3kMzomYjytbXzqATr91X2jKqyuypmQuKjEkdlvnvEWr9GvHe
 aWW6B0mt1OUDQ8/2Bm0HGNpWwXUnZggr/jUZeodD73QvzbFtQfQ8GVqW+V1MSwzx6lQnpr7X3
 ApRtu9erBouYCoP2+CbMD3r+wN/LnTVD9DyfbQ5fzhhM9rjIQ14oj+JNFcW5P9LRGHkfzKp7N
 5OzWM0XrfcSLUR+peOt0IjRUNrPiTSieMMFmxfr1l3sAhcnOu0sf6MkCXO/RPYrrRE+O3/XCh
 Mrm620NkO98c3TeidlTOhe9AoYHwUo3p+706klPrINHxE7L49Y0tTBDt8cCVIl1qZV2GcBxEb
 3aVdok5TsG+ndH3lo70xRWJQAulSwLgpbufwwYPQsOyZB0q1oFkANMAL6UOSX7bI6gHt1BlfB
 Ajdi/XHvj5MNMwjdae4HrL03mfRvt4NKdr23VUlsUz+czMGaDey/u4IQcae64qMoNM2WHZthe
 p7BcmpL6fq0GVydEy5qjkAg/c9WkJ3z0rFnsD4toqNGOxaLNkiY3Xmy2NLvZOfKWZ1MgfbFAB
 ssWgElNrObgMlNb1zzpuIOUQ4LqhVAhqoixNaGgEGFjJc6X8KgSY5eHYYeIMPyYj7M2cTdhlU
 +EBE07nlNt9NhVGHKHxA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/cpu.c | 143 ++++++++++++++++++++++++++-------------------------
 1 file changed, 72 insertions(+), 71 deletions(-)

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
-- 
2.20.0

