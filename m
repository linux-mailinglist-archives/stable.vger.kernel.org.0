Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0CD635519
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbiKWJPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237281AbiKWJPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:15:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39106107E65
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83103CE0FC8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA21C433C1;
        Wed, 23 Nov 2022 09:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194895;
        bh=b1kF5cuNi0SbDvcZDMzB7nyjX93xC82F6z5iT3/dUYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUImUy7ZKgcwkkVFWar0sVZkCwRlNYg0I/5qqtcZ65YU7WbkcKmMJDMQyiKTqH1RJ
         tZHjmhC0QDE+mYp15GsYb+taKMFz4CX0A4zoznKh742TdKZBOA9m6APuiul7gE1p+W
         mx9vXEWMMORfpjdiRrS8t2l3zPWxOvwh1mHf+wvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 063/156] x86/cpu: Restore AMDs DE_CFG MSR after resume
Date:   Wed, 23 Nov 2022 09:50:20 +0100
Message-Id: <20221123084600.227600717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit 2632daebafd04746b4b96c2f26a6021bc38f6209 upstream.

DE_CFG contains the LFENCE serializing bit, restore it on resume too.
This is relevant to older families due to the way how they do S3.

Unify and correct naming while at it.

Fixes: e4d0e84e4907 ("x86/cpu/AMD: Make LFENCE a serializing instruction")
Reported-by: Andrew Cooper <Andrew.Cooper3@citrix.com>
Reported-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h                       |    8 +++++---
 arch/x86/kernel/cpu/amd.c                              |    6 ++----
 arch/x86/kernel/cpu/hygon.c                            |    4 ++--
 arch/x86/kvm/svm.c                                     |   10 +++++-----
 arch/x86/kvm/x86.c                                     |    2 +-
 arch/x86/power/cpu.c                                   |    1 +
 tools/testing/selftests/kvm/include/x86_64/processor.h |    8 +++++---
 7 files changed, 21 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -454,6 +454,11 @@
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+
+#define MSR_AMD64_DE_CFG		0xc0011029
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	 1
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE	BIT_ULL(MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)
+
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
@@ -522,9 +527,6 @@
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -794,8 +794,6 @@ static void init_amd_gh(struct cpuinfo_x
 		set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 }
 
-#define MSR_AMD64_DE_CFG	0xC0011029
-
 static void init_amd_ln(struct cpuinfo_x86 *c)
 {
 	/*
@@ -965,8 +963,8 @@ static void init_amd(struct cpuinfo_x86
 		 * msr_set_bit() uses the safe accessors, too, even if the MSR
 		 * is not present.
 		 */
-		msr_set_bit(MSR_F10H_DECFG,
-			    MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT);
+		msr_set_bit(MSR_AMD64_DE_CFG,
+			    MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT);
 
 		/* A serializing LFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -335,8 +335,8 @@ static void init_hygon(struct cpuinfo_x8
 		 * msr_set_bit() uses the safe accessors, too, even if the MSR
 		 * is not present.
 		 */
-		msr_set_bit(MSR_F10H_DECFG,
-			    MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT);
+		msr_set_bit(MSR_AMD64_DE_CFG,
+			    MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT);
 
 		/* A serializing LFENCE stops RDTSC speculation */
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4180,9 +4180,9 @@ static int svm_get_msr_feature(struct kv
 	msr->data = 0;
 
 	switch (msr->index) {
-	case MSR_F10H_DECFG:
-		if (boot_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			msr->data |= MSR_F10H_DECFG_LFENCE_SERIALIZE;
+	case MSR_AMD64_DE_CFG:
+		if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	default:
 		return 1;
@@ -4284,7 +4284,7 @@ static int svm_get_msr(struct kvm_vcpu *
 			msr_info->data = 0x1E;
 		}
 		break;
-	case MSR_F10H_DECFG:
+	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
 	default:
@@ -4451,7 +4451,7 @@ static int svm_set_msr(struct kvm_vcpu *
 	case MSR_VM_IGNNE:
 		vcpu_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
-	case MSR_F10H_DECFG: {
+	case MSR_AMD64_DE_CFG: {
 		struct kvm_msr_entry msr_entry;
 
 		msr_entry.index = msr->index;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1337,7 +1337,7 @@ static const u32 msr_based_features_all[
 	MSR_IA32_VMX_EPT_VPID_CAP,
 	MSR_IA32_VMX_VMFUNC,
 
-	MSR_F10H_DECFG,
+	MSR_AMD64_DE_CFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
 };
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -528,6 +528,7 @@ static void pm_save_spec_msr(void)
 		MSR_TSX_FORCE_ABORT,
 		MSR_IA32_MCU_OPT_CTRL,
 		MSR_AMD64_LS_CFG,
+		MSR_AMD64_DE_CFG,
 	};
 
 	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -635,6 +635,11 @@ void kvm_get_cpu_address_width(unsigned
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+
+#define MSR_AMD64_DE_CFG		0xc0011029
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	1
+#define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE	BIT_ULL(MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)
+
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
 #define MSR_AMD64_IBSFETCHLINAD		0xc0011031
@@ -685,9 +690,6 @@ void kvm_get_cpu_address_width(unsigned
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffffULL
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
 #define MSR_FAM10H_NODE_ID		0xc001100c
-#define MSR_F10H_DECFG			0xc0011029
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT	1
-#define MSR_F10H_DECFG_LFENCE_SERIALIZE		BIT_ULL(MSR_F10H_DECFG_LFENCE_SERIALIZE_BIT)
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a


