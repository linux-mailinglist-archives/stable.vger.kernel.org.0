Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36F85F5368
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJELdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJELdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:33:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26515733F3;
        Wed,  5 Oct 2022 04:33:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB65561644;
        Wed,  5 Oct 2022 11:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0649DC433C1;
        Wed,  5 Oct 2022 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969593;
        bh=qq3RoIDloIilSZvKPjVCt/4T8Vzd7BWbega5B7xoWdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDfSULf5igADRzTSv+q3I1O1M5MX7L2OL1jUNrgt8cgzOyCAUS6hS+JW4LbivSiEF
         QzDcMnm6zhHfIbstbZ8G2xLSMARvriJTIpOfyc9SrYkK2WDRA5OGg90KmmK6AKCIkr
         BD/hEzwQvUOBrbCfN1Zq/E6gsJokyXJRnLbbyoAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 08/51] x86/bugs: Report AMD retbleed vulnerability
Date:   Wed,  5 Oct 2022 13:31:56 +0200
Message-Id: <20221005113210.647100502@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Chartre <alexandre.chartre@oracle.com>

commit 6b80b59b3555706508008f1f127b5412c89c7fd8 upstream.

Report that AMD x86 CPUs are vulnerable to the RETBleed (Arbitrary
Speculative Code Execution with Return Instructions) attack.

  [peterz: add hygon]
  [kim: invert parity; fam15h]

Co-developed-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: adjusted BUG numbers to match upstream]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    3 ++-
 arch/x86/kernel/cpu/bugs.c         |   13 +++++++++++++
 arch/x86/kernel/cpu/common.c       |   19 +++++++++++++++++++
 drivers/base/cpu.c                 |    8 ++++++++
 include/linux/cpu.h                |    2 ++
 5 files changed, 44 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -408,6 +408,7 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
-#define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
+#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
+#define X86_BUG_MMIO_UNKNOWN		X86_BUG(28) /* CPU is too old and its MMIO Stale Data status is unknown */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1911,6 +1911,11 @@ static ssize_t srbds_show_state(char *bu
 	return sprintf(buf, "%s\n", srbds_strings[srbds_mitigation]);
 }
 
+static ssize_t retbleed_show_state(char *buf)
+{
+	return sprintf(buf, "Vulnerable\n");
+}
+
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,
 			       char *buf, unsigned int bug)
 {
@@ -1957,6 +1962,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_MMIO_UNKNOWN:
 		return mmio_stale_data_show_state(buf);
 
+	case X86_BUG_RETBLEED:
+		return retbleed_show_state(buf);
+
 	default:
 		break;
 	}
@@ -2016,4 +2024,9 @@ ssize_t cpu_show_mmio_stale_data(struct
 	else
 		return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
+
+ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_RETBLEED);
+}
 #endif
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1099,16 +1099,27 @@ static const __initconst struct x86_cpu_
 	{}
 };
 
+#define VULNBL(vendor, family, model, blacklist)	\
+	X86_MATCH_VENDOR_FAM_MODEL(vendor, family, model, blacklist)
+
 #define VULNBL_INTEL_STEPPINGS(model, steppings, issues)		   \
 	X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE(INTEL, 6,		   \
 					    INTEL_FAM6_##model, steppings, \
 					    X86_FEATURE_ANY, issues)
 
+#define VULNBL_AMD(family, blacklist)		\
+	VULNBL(AMD, family, X86_MODEL_ANY, blacklist)
+
+#define VULNBL_HYGON(family, blacklist)		\
+	VULNBL(HYGON, family, X86_MODEL_ANY, blacklist)
+
 #define SRBDS		BIT(0)
 /* CPU is affected by X86_BUG_MMIO_STALE_DATA */
 #define MMIO		BIT(1)
 /* CPU is affected by Shared Buffers Data Sampling (SBDS), a variant of X86_BUG_MMIO_STALE_DATA */
 #define MMIO_SBDS	BIT(2)
+/* CPU is affected by RETbleed, speculating where you would not expect it */
+#define RETBLEED	BIT(3)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
@@ -1141,6 +1152,11 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
+
+	VULNBL_AMD(0x15, RETBLEED),
+	VULNBL_AMD(0x16, RETBLEED),
+	VULNBL_AMD(0x17, RETBLEED),
+	VULNBL_HYGON(0x18, RETBLEED),
 	{}
 };
 
@@ -1248,6 +1264,9 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
+	if (cpu_matches(cpu_vuln_blacklist, RETBLEED))
+		setup_force_cpu_bug(X86_BUG_RETBLEED);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -574,6 +574,12 @@ ssize_t __weak cpu_show_mmio_stale_data(
 	return sysfs_emit(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
@@ -584,6 +590,7 @@ static DEVICE_ATTR(tsx_async_abort, 0444
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
 static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
+static DEVICE_ATTR(retbleed, 0444, cpu_show_retbleed, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -596,6 +603,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_itlb_multihit.attr,
 	&dev_attr_srbds.attr,
 	&dev_attr_mmio_stale_data.attr,
+	&dev_attr_retbleed.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -68,6 +68,8 @@ extern ssize_t cpu_show_srbds(struct dev
 extern ssize_t cpu_show_mmio_stale_data(struct device *dev,
 					struct device_attribute *attr,
 					char *buf);
+extern ssize_t cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


