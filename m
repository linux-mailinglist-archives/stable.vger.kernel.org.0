Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7239B20C3E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfEPQDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42624 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zx-FA; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001S4-PM; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jon Masters" <jcm@redhat.com>, "Borislav Petkov" <bp@suse.de>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.642614377@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 71/86] x86/speculation/mds: Add sysfs reporting for MDS
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 8a4b06d391b0a42a373808979b5028f5c84d9c6a upstream.

Add the sysfs reporting file for MDS. It exposes the vulnerability and
mitigation state similar to the existing files for the other speculative
hardware vulnerabilities.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 3.16:
 - Test x86_hyper instead of using hypervisor_is_type()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -231,6 +231,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/spectre_v2
 		/sys/devices/system/cpu/vulnerabilities/spec_store_bypass
 		/sys/devices/system/cpu/vulnerabilities/l1tf
+		/sys/devices/system/cpu/vulnerabilities/mds
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -24,6 +24,7 @@
 #include <asm/msr.h>
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
+#include <asm/hypervisor.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/intel-family.h>
@@ -1131,6 +1132,24 @@ static void __init l1tf_select_mitigatio
 
 #ifdef CONFIG_SYSFS
 
+static ssize_t mds_show_state(char *buf)
+{
+#ifdef CONFIG_HYPERVISOR_GUEST
+	if (x86_hyper) {
+		return sprintf(buf, "%s; SMT Host state unknown\n",
+			       mds_strings[mds_mitigation]);
+	}
+#endif
+
+	if (boot_cpu_has(X86_BUG_MSBDS_ONLY)) {
+		return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
+			       sched_smt_active() ? "mitigated" : "disabled");
+	}
+
+	return sprintf(buf, "%s; SMT %s\n", mds_strings[mds_mitigation],
+		       sched_smt_active() ? "vulnerable" : "disabled");
+}
+
 static char *stibp_state(void)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
@@ -1193,6 +1212,9 @@ static ssize_t cpu_show_common(struct de
 			return sprintf(buf, "Mitigation: Page Table Inversion\n");
 		break;
 
+	case X86_BUG_MDS:
+		return mds_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1224,4 +1246,9 @@ ssize_t cpu_show_l1tf(struct device *dev
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_L1TF);
 }
+
+ssize_t cpu_show_mds(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_MDS);
+}
 #endif
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -450,11 +450,18 @@ ssize_t __weak cpu_show_l1tf(struct devi
 	return sprintf(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_mds(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
 static DEVICE_ATTR(spec_store_bypass, 0444, cpu_show_spec_store_bypass, NULL);
 static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
+static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -462,6 +469,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_spectre_v2.attr,
 	&dev_attr_spec_store_bypass.attr,
 	&dev_attr_l1tf.attr,
+	&dev_attr_mds.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -49,6 +49,8 @@ extern ssize_t cpu_show_spec_store_bypas
 					  struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_l1tf(struct device *dev,
 			     struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_mds(struct device *dev,
+			    struct device_attribute *attr, char *buf);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);

