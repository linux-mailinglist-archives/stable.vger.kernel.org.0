Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87A757ABEA
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiGTBSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbiGTBRd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:17:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBD66758F;
        Tue, 19 Jul 2022 18:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF0B6CE1E8E;
        Wed, 20 Jul 2022 01:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE900C341C6;
        Wed, 20 Jul 2022 01:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279659;
        bh=BespFZcRqK0G5uAgaO6UKyB84yAB17sYhBH0t2dgorA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaxrKwv5yIlamPD7DQkrCGvLg9a56aBEFzCqha0aSYzVkap8nLtbOs3tXVkMp254Z
         BOO24Tvf6fh19gEEqquWAGPgDZ4PwIcVHjD9sizyYtwJnZBOm8p1EkaLyJP0vYU/U0
         s4+OrzTtMh/6SVddqo7WvOn/HXkGBQSB/uhTL84CrDPleXkWL9C9xHeXnYWN+GQF4K
         Al3zr78GBKM/0iKdX+zL2/5GH5cn4fmJtAR7LY38KRqEicqnp3NBaopqQ8V4g6QmjY
         piePQtSAOE/OjzN4gTcEzSy7UP1zsy5Vbt/ySZEMlEr9AtK4t/YYSXDfGH5b8SK21e
         +AM7wS3jRO97w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, gregkh@linuxfoundation.org, babu.moger@amd.com,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        jmattson@google.com, jing2.liu@intel.com, sandipan.das@amd.com,
        sblbir@amazon.com, keescook@chromium.org, tony.luck@intel.com,
        jane.malalane@citrix.com, bigeasy@linutronix.de
Subject: [PATCH AUTOSEL 5.15 09/42] x86/bugs: Report AMD retbleed vulnerability
Date:   Tue, 19 Jul 2022 21:13:17 -0400
Message-Id: <20220720011350.1024134-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Chartre <alexandre.chartre@oracle.com>

[ Upstream commit 6b80b59b3555706508008f1f127b5412c89c7fd8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/bugs.c         | 13 +++++++++++++
 arch/x86/kernel/cpu/common.c       | 19 +++++++++++++++++++
 drivers/base/cpu.c                 |  8 ++++++++
 include/linux/cpu.h                |  2 ++
 5 files changed, 43 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 57dc9f822e8b..fd93c0a5f85a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -441,5 +441,6 @@
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
+#define X86_BUG_RETBLEED		X86_BUG(26) /* CPU is affected by RETBleed */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 2c512ff2ee10..c62ea37ca38a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1987,6 +1987,11 @@ static ssize_t srbds_show_state(char *buf)
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
@@ -2032,6 +2037,9 @@ static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr
 	case X86_BUG_MMIO_STALE_DATA:
 		return mmio_stale_data_show_state(buf);
 
+	case X86_BUG_RETBLEED:
+		return retbleed_show_state(buf);
+
 	default:
 		break;
 	}
@@ -2088,4 +2096,9 @@ ssize_t cpu_show_mmio_stale_data(struct device *dev, struct device_attribute *at
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_MMIO_STALE_DATA);
 }
+
+ssize_t cpu_show_retbleed(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_RETBLEED);
+}
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bd390c56e551..d5488cff3e01 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1095,16 +1095,27 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
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
@@ -1137,6 +1148,11 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
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
 
@@ -1238,6 +1254,9 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !arch_cap_mmio_immune(ia32_cap))
 		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
 
+	if (cpu_matches(cpu_vuln_blacklist, RETBLEED))
+		setup_force_cpu_bug(X86_BUG_RETBLEED);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index fddd08e482fc..55405ebf23ab 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -570,6 +570,12 @@ ssize_t __weak cpu_show_mmio_stale_data(struct device *dev,
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
@@ -580,6 +586,7 @@ static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 static DEVICE_ATTR(itlb_multihit, 0444, cpu_show_itlb_multihit, NULL);
 static DEVICE_ATTR(srbds, 0444, cpu_show_srbds, NULL);
 static DEVICE_ATTR(mmio_stale_data, 0444, cpu_show_mmio_stale_data, NULL);
+static DEVICE_ATTR(retbleed, 0444, cpu_show_retbleed, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -592,6 +599,7 @@ static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_itlb_multihit.attr,
 	&dev_attr_srbds.attr,
 	&dev_attr_mmio_stale_data.attr,
+	&dev_attr_retbleed.attr,
 	NULL
 };
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index eb3394f5b109..6102a21a01d9 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -68,6 +68,8 @@ extern ssize_t cpu_show_srbds(struct device *dev, struct device_attribute *attr,
 extern ssize_t cpu_show_mmio_stale_data(struct device *dev,
 					struct device_attribute *attr,
 					char *buf);
+extern ssize_t cpu_show_retbleed(struct device *dev,
+				 struct device_attribute *attr, char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,
-- 
2.35.1

