Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D940D54B939
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbiFNSp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357557AbiFNSnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:43:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8724C427;
        Tue, 14 Jun 2022 11:42:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC5BF617B3;
        Tue, 14 Jun 2022 18:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE22C3411B;
        Tue, 14 Jun 2022 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232158;
        bh=BCQ+CBR2j0aI2tWAtEWTf0uFGj9R1Qr5poi6U2kqCaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1TkCgPf0xEdcrA22HbUK3iTp7chRiLIUGNguDm20dzZzcoQ/ia1L5tghnUYg1vPl
         3TCqejwNFgp146PNK6RB2id4VJP1Utt5mme4p3wBznM3lsGC96hJGwBnbxQbjCLsh3
         zfckUIM5fAowBvLuD4rZ1rYUqYruiZn+4jYCNbNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 16/20] x86/speculation/mmio: Add sysfs reporting for Processor MMIO Stale Data
Date:   Tue, 14 Jun 2022 20:40:07 +0200
Message-Id: <20220614183727.285136608@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183723.328825625@linuxfoundation.org>
References: <20220614183723.328825625@linuxfoundation.org>
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 
 arch/x86/kernel/cpu/bugs.c                         |   22 +++++++++++++++++++++
 drivers/base/cpu.c                                 |    8 +++++++
 include/linux/cpu.h                                |    3 ++
 4 files changed, 34 insertions(+)

--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -384,6 +384,7 @@ What:		/sys/devices/system/cpu/vulnerabi
 		/sys/devices/system/cpu/vulnerabilities/srbds
 		/sys/devices/system/cpu/vulnerabilities/tsx_async_abort
 		/sys/devices/system/cpu/vulnerabilities/itlb_multihit
+		/sys/devices/system/cpu/vulnerabilities/mmio_stale_data
 Date:		January 2018
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:	Information about CPU vulnerabilities
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1808,6 +1808,20 @@ static ssize_t tsx_async_abort_show_stat
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
@@ -1905,6 +1919,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_SRBDS:
 		return srbds_show_state(buf);
 
+	case X86_BUG_MMIO_STALE_DATA:
+		return mmio_stale_data_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1956,4 +1973,9 @@ ssize_t cpu_show_srbds(struct device *de
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
@@ -558,6 +558,12 @@ ssize_t __weak cpu_show_srbds(struct dev
 	return sprintf(buf, "Not affected\n");
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
@@ -567,6 +573,7 @@ static DEVICE_ATTR(mds, 0444, cpu_show_m
 static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
+static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -578,6 +585,7 @@ static struct attribute *cpu_root_vulner
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


