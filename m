Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA346AEE97
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCGSNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjCGSNM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19EB9AFE7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:08:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 686B8B81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8632EC433D2;
        Tue,  7 Mar 2023 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212522;
        bh=awsNsIErIoPI2JM7xhkuip8vkdgdGfSHx5k7v+5DwBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVbEh97EmbrVJZdKoavcueeRy0wEHHiIPyVWs6a+JTW1YS3SK6hXcaC2sY8DIKSSr
         BmeNnCKWanPVMH+eOw+9fEufecSyZG7cafAseaV/zjcAFXUSXW3ltS42YsyMFYVfJU
         9BP+MYyZ/UVzlQgsEPZxbFMmoGXoxfiRaoXxBJaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/885] x86/microcode: Check CPU capabilities after late microcode update correctly
Date:   Tue,  7 Mar 2023 17:51:54 +0100
Message-Id: <20230307170009.806086258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit c0dd9245aa9e25a697181f6085692272c9ec61bc ]

The kernel caches each CPU's feature bits at boot in an x86_capability[]
structure. However, the capabilities in the BSP's copy can be turned off
as a result of certain command line parameters or configuration
restrictions, for example the SGX bit. This can cause a mismatch when
comparing the values before and after the microcode update.

Another example is X86_FEATURE_SRBDS_CTRL which gets added only after
microcode update:

#  --- cpuid.before	2023-01-21 14:54:15.652000747 +0100
#  +++ cpuid.after	2023-01-21 14:54:26.632001024 +0100
#  @@ -10,7 +10,7 @@ CPU:
#      0x00000004 0x04: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
#      0x00000005 0x00: eax=0x00000040 ebx=0x00000040 ecx=0x00000003 edx=0x11142120
#      0x00000006 0x00: eax=0x000027f7 ebx=0x00000002 ecx=0x00000001 edx=0x00000000
#  -   0x00000007 0x00: eax=0x00000000 ebx=0x029c6fbf ecx=0x40000000 edx=0xbc002400
#  +   0x00000007 0x00: eax=0x00000000 ebx=0x029c6fbf ecx=0x40000000 edx=0xbc002e00
  									     ^^^

and which proves for a gazillionth time that late loading is a bad bad
idea.

microcode_check() is called after an update to report any previously
cached CPUID bits which might have changed due to the update.

Therefore, store the cached CPU caps before the update and compare them
with the CPU caps after the microcode update has succeeded.

Thus, the comparison is done between the CPUID *hardware* bits before
and after the upgrade instead of using the cached, possibly runtime
modified values in BSP's boot_cpu_data copy.

As a result, false warnings about CPUID bits changes are avoided.

  [ bp:
  	- Massage.
	- Add SRBDS_CTRL example.
	- Add kernel-doc.
	- Incorporate forgotten review feedback from dhansen.
	]

Fixes: 1008c52c09dc ("x86/CPU: Add a microcode loader callback")
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230109153555.4986-3-ashok.raj@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h     |  1 +
 arch/x86/kernel/cpu/common.c         | 36 ++++++++++++++++++----------
 arch/x86/kernel/cpu/microcode/core.c |  6 +++++
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2288ef4ba17c5..d8277eec1bcd6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -836,6 +836,7 @@ bool xen_set_default_idle(void);
 
 void __noreturn stop_this_cpu(void *dummy);
 void microcode_check(struct cpuinfo_x86 *prev_info);
+void store_cpu_caps(struct cpuinfo_x86 *info);
 
 enum l1tf_mitigations {
 	L1TF_MITIGATION_OFF,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3c08985ed70c9..c34bdba57993a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2311,6 +2311,25 @@ void cpu_init_secondary(void)
 #endif
 
 #ifdef CONFIG_MICROCODE_LATE_LOADING
+/**
+ * store_cpu_caps() - Store a snapshot of CPU capabilities
+ * @curr_info: Pointer where to store it
+ *
+ * Returns: None
+ */
+void store_cpu_caps(struct cpuinfo_x86 *curr_info)
+{
+	/* Reload CPUID max function as it might've changed. */
+	curr_info->cpuid_level = cpuid_eax(0);
+
+	/* Copy all capability leafs and pick up the synthetic ones. */
+	memcpy(&curr_info->x86_capability, &boot_cpu_data.x86_capability,
+	       sizeof(curr_info->x86_capability));
+
+	/* Get the hardware CPUID leafs */
+	get_cpu_cap(curr_info);
+}
+
 /**
  * microcode_check() - Check if any CPU capabilities changed after an update.
  * @prev_info:	CPU capabilities stored before an update.
@@ -2323,22 +2342,13 @@ void cpu_init_secondary(void)
  */
 void microcode_check(struct cpuinfo_x86 *prev_info)
 {
-	perf_check_microcode();
-
-	/* Reload CPUID max function as it might've changed. */
-	prev_info->cpuid_level = cpuid_eax(0);
+	struct cpuinfo_x86 curr_info;
 
-	/*
-	 * Copy all capability leafs to pick up the synthetic ones so that
-	 * memcmp() below doesn't fail on that. The ones coming from CPUID will
-	 * get overwritten in get_cpu_cap().
-	 */
-	memcpy(&prev_info->x86_capability, &boot_cpu_data.x86_capability,
-	       sizeof(prev_info->x86_capability));
+	perf_check_microcode();
 
-	get_cpu_cap(prev_info);
+	store_cpu_caps(&curr_info);
 
-	if (!memcmp(&prev_info->x86_capability, &boot_cpu_data.x86_capability,
+	if (!memcmp(&prev_info->x86_capability, &curr_info.x86_capability,
 		    sizeof(prev_info->x86_capability)))
 		return;
 
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 9d006ff58edc9..755aab64872c8 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -500,6 +500,12 @@ static int microcode_reload_late(void)
 	atomic_set(&late_cpus_in,  0);
 	atomic_set(&late_cpus_out, 0);
 
+	/*
+	 * Take a snapshot before the microcode update in order to compare and
+	 * check whether any bits changed after an update.
+	 */
+	store_cpu_caps(&prev_info);
+
 	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
 	if (ret == 0)
 		microcode_check(&prev_info);
-- 
2.39.2



