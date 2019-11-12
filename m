Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150E5F9E85
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfKLXvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:51:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57308 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726970AbfKLXuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:35 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-0008I5-Lq; Tue, 12 Nov 2019 23:50:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00056t-II; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Mark Gross" <mgross@linux.intel.com>,
        "Borislav Petkov" <bp@suse.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Neelima Krishnan" <neelima.krishnan@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>
Date:   Tue, 12 Nov 2019 23:48:04 +0000
Message-ID: <lsq.1573602477.206197127@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/25] x86/speculation/taa: Add sysfs reporting for
 TSX Async  Abort
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 6608b45ac5ecb56f9e171252229c39580cc85f0f upstream.

Add the sysfs reporting file for TSX Async Abort. It exposes the
vulnerability and the mitigation state similar to the existing files for
the other hardware vulnerabilities.

Sysfs file path is:
/sys/devices/system/cpu/vulnerabilities/tsx_async_abort

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 23 +++++++++++++++++++++++
 drivers/base/cpu.c         |  9 +++++++++
 include/linux/cpu.h        |  3 +++
 3 files changed, 35 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1365,6 +1365,21 @@ static ssize_t mds_show_state(char *buf)
 		       sched_smt_active() ? "vulnerable" : "disabled");
 }
 
+static ssize_t tsx_async_abort_show_state(char *buf)
+{
+	if ((taa_mitigation == TAA_MITIGATION_TSX_DISABLED) ||
+	    (taa_mitigation == TAA_MITIGATION_OFF))
+		return sprintf(buf, "%s\n", taa_strings[taa_mitigation]);
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		return sprintf(buf, "%s; SMT Host state unknown\n",
+			       taa_strings[taa_mitigation]);
+	}
+
+	return sprintf(buf, "%s; SMT %s\n", taa_strings[taa_mitigation],
+		       sched_smt_active() ? "vulnerable" : "disabled");
+}
+
 static char *stibp_state(void)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
@@ -1430,6 +1445,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_MDS:
 		return mds_show_state(buf);
 
+	case X86_BUG_TAA:
+		return tsx_async_abort_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1466,4 +1484,9 @@ ssize_t cpu_show_mds(struct device *dev,
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_MDS);
 }
+
+ssize_t cpu_show_tsx_async_abort(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_TAA);
+}
 #endif
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -456,12 +456,20 @@ ssize_t __weak cpu_show_mds(struct devic
 	return sprintf(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
 static DEVICE_ATTR(spec_store_bypass, 0444, cpu_show_spec_store_bypass, NULL);
 static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
+static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -470,6 +478,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_spec_store_bypass.attr,
 	&dev_attr_l1tf.attr,
 	&dev_attr_mds.attr,
+	&dev_attr_tsx_async_abort.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -51,6 +51,9 @@ extern ssize_t cpu_show_l1tf(struct devi
 			     struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_mds(struct device *dev,
 			    struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_tsx_async_abort(struct device *dev,
+					struct device_attribute *attr,
+					char *buf);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);

