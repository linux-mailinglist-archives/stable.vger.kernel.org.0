Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE5F61F289
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfEOLMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729681AbfEOLMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85C8720862;
        Wed, 15 May 2019 11:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918719;
        bh=iIXhTBrELIFGVGyTy3Qr4A+q+0U8bq/Rf92oayRGSrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpptItNUfsoRzbMlpOxuTyAZiS3X08Y7DDEfhBSoIWe+KzQWvJ/M6TRgTmtAINJAn
         EVvKsvBS4x2568vDkt6WnrN2zDlhhFAAkexIhHEzbPxypKo9PZ8QkxZYnylBK1a9d0
         hrLh610aa7MvN5qSAO/QGkSlCbaMUjUvKB8NhwVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 238/266] x86/speculation/mds: Add sysfs reporting for MDS
Date:   Wed, 15 May 2019 12:55:45 +0200
Message-Id: <20190515090731.052470288@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4:
 - Test x86_hyper instead of using hypervisor_is_type()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 
 arch/x86/kernel/cpu/bugs.c                         |   27 +++++++++++++++++++++
 drivers/base/cpu.c                                 |    8 ++++++
 include/linux/cpu.h                                |    2 +
 4 files changed, 38 insertions(+)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -278,6 +278,7 @@ What:		/sys/devices/system/cpu/vulnerabi
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
@@ -1066,6 +1067,24 @@ static void __init l1tf_select_mitigatio
 
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
@@ -1128,6 +1147,9 @@ static ssize_t cpu_show_common(struct de
 			return sprintf(buf, "Mitigation: Page Table Inversion\n");
 		break;
 
+	case X86_BUG_MDS:
+		return mds_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1159,4 +1181,9 @@ ssize_t cpu_show_l1tf(struct device *dev
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
@@ -530,11 +530,18 @@ ssize_t __weak cpu_show_l1tf(struct devi
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
@@ -542,6 +549,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_spectre_v2.attr,
 	&dev_attr_spec_store_bypass.attr,
 	&dev_attr_l1tf.attr,
+	&dev_attr_mds.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -50,6 +50,8 @@ extern ssize_t cpu_show_spec_store_bypas
 					  struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_l1tf(struct device *dev,
 			     struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_mds(struct device *dev,
+			    struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


