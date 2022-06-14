Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD0754B99F
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357725AbiFNStJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357992AbiFNSsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:48:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D6A4D621;
        Tue, 14 Jun 2022 11:44:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61DF261800;
        Tue, 14 Jun 2022 18:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677B4C3411B;
        Tue, 14 Jun 2022 18:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232287;
        bh=CmyhU/IDMuy9B8H9R6X+AB5qlp9UcBq0JVmIZVXcHwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ3qAzqT21M0VMfa3cJRPi7i338l9XiqeIQLDHFT0M6kqA82JXp1B7W6ED9vAJZBl
         SIWDLMdaKhg+KNcij0jYzSJsHjqTBqusa8/zWrx9jY7QzWog7xtTnKrQvQfn0GVBxY
         Q/vXF8wown50Xclr5J7rqD/wxx/niSJG/9vnSv08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 07/11] x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data
Date:   Tue, 14 Jun 2022 20:40:29 +0200
Message-Id: <20220614183721.688944916@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
References: <20220614183719.878453780@linuxfoundation.org>
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 8d50cdf8b8341770bc6367bce40c0c1bb0e1d5b3 upstream

Add the sysfs reporting file for Processor MMIO Stale Data
vulnerability. It exposes the vulnerability and mitigation state similar
to the existing files for the other hardware vulnerabilities.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 
 arch/x86/kernel/cpu/bugs.c                         |   22 +++++++++++++++++++++
 drivers/base/cpu.c                                 |    8 +++++++
 include/linux/cpu.h                                |    3 ++
 4 files changed, 34 insertions(+)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -510,6 +510,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/srbds
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
+		/sys/devices/system/cpu/vulnerabilities/mmio_stale_data
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1832,6 +1832,20 @@ static ssize_t tsx_async_abort_show_stat
 		       sched_smt_active() ? "vulnerable" : "disabled");
 }
 
+static ssize_t mmio_stale_data_show_state(char *buf)
+{
+	if (mmio_mitigation == MMIO_MITIGATION_OFF)
+		return sysfs_emit(buf, "%s\n", mmio_strings[mmio_mitigation]);
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		return sysfs_emit(buf, "%s; SMT Host state unknown\n",
+				  mmio_strings[mmio_mitigation]);
+	}
+
+	return sysfs_emit(buf, "%s; SMT %s\n", mmio_strings[mmio_mitigation],
+			  sched_smt_active() ? "vulnerable" : "disabled");
+}
+
 static char *stibp_state(void)
 {
 	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
@@ -1932,6 +1946,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_SRBDS:
 		return srbds_show_state(buf);
 
+	case X86_BUG_MMIO_STALE_DATA:
+		return mmio_stale_data_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1983,4 +2000,9 @@ ssize_t cpu_show_srbds(struct device *de
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_SRBDS);
 }
+
+ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
+}
 #endif
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -566,6 +566,12 @@ ssize_t __weak cpu_show_srbds(struct dev
 	return sysfs_emit(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_mmio_stale_data(struct device *dev,
+					struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -575,6 +581,7 @@ static DEVICE_ATTR(mds, 0444, cpu_show_m
 static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
+static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -586,6 +593,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_tsx_async_abort.attr,
 	&dev_attr_itlb_multihit.attr,
 	&dev_attr_srbds.attr,
+	&dev_attr_mmio_stale_data.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -65,6 +65,9 @@ extern ssize_t cpu_show_tsx_async_abort(
 extern ssize_t cpu_show_itlb_multihit(struct device *dev,
 				      struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_mmio_stale_data(struct device *dev,
+					struct device_attribute *attr,
+					char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


