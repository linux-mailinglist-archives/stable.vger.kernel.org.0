Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8C46B47FD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjCJO4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbjCJOzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:55:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506A21B332
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E86F7B822E9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A64DC4339B;
        Fri, 10 Mar 2023 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459744;
        bh=XhZ90e8ar16bhI2QIgaANQ5FYkACPq3oKMapshah+Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/FK6dsLKh5qEUxQs0ux6Ix+9SMeUiI6wtn0MT9hfSOHDmSFEEj1LeQ7a0PltCht7
         6mWHk9MbTl/FV7wfR8ZOVFFJKaG5wwnK2vj1usBwOQI0lz63Cf4bkdoJMAH6zkQt8S
         kkuadjJywzNd1adIkOPAEmwXgIfDBlBaXWB0+Ooc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ashok Raj <ashok.raj@intel.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/529] x86/microcode: Add a parameter to microcode_check() to store CPU capabilities
Date:   Fri, 10 Mar 2023 14:34:08 +0100
Message-Id: <20230310133809.842169982@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ashok Raj <ashok.raj@intel.com>

[ Upstream commit ab31c74455c64e69342ddab21fd9426fcbfefde7 ]

Add a parameter to store CPU capabilities before performing a microcode
update so that CPU capabilities can be compared before and after update.

  [ bp: Massage. ]

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230109153555.4986-2-ashok.raj@intel.com
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h     |  2 +-
 arch/x86/kernel/cpu/common.c         | 21 +++++++++++++--------
 arch/x86/kernel/cpu/microcode/core.c |  3 ++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 01bcbf8a25b29..6d40c409ebc16 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -840,7 +840,7 @@ bool xen_set_default_idle(void);
 #endif
 
 void __noreturn stop_this_cpu(void *dummy);
-void microcode_check(void);
+void microcode_check(struct cpuinfo_x86 *prev_info);
 
 enum l1tf_mitigations {
 	L1TF_MITIGATION_OFF,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 95f52540db378..f724002adbfc3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2130,30 +2130,35 @@ void cpu_init_secondary(void)
 #endif
 
 #ifdef CONFIG_MICROCODE_LATE_LOADING
-/*
+/**
+ * microcode_check() - Check if any CPU capabilities changed after an update.
+ * @prev_info:	CPU capabilities stored before an update.
+ *
  * The microcode loader calls this upon late microcode load to recheck features,
  * only when microcode has been updated. Caller holds microcode_mutex and CPU
  * hotplug lock.
+ *
+ * Return: None
  */
-void microcode_check(void)
+void microcode_check(struct cpuinfo_x86 *prev_info)
 {
-	struct cpuinfo_x86 info;
-
 	perf_check_microcode();
 
 	/* Reload CPUID max function as it might've changed. */
-	info.cpuid_level = cpuid_eax(0);
+	prev_info->cpuid_level = cpuid_eax(0);
 
 	/*
 	 * Copy all capability leafs to pick up the synthetic ones so that
 	 * memcmp() below doesn't fail on that. The ones coming from CPUID will
 	 * get overwritten in get_cpu_cap().
 	 */
-	memcpy(&info.x86_capability, &boot_cpu_data.x86_capability, sizeof(info.x86_capability));
+	memcpy(&prev_info->x86_capability, &boot_cpu_data.x86_capability,
+	       sizeof(prev_info->x86_capability));
 
-	get_cpu_cap(&info);
+	get_cpu_cap(prev_info);
 
-	if (!memcmp(&info.x86_capability, &boot_cpu_data.x86_capability, sizeof(info.x86_capability)))
+	if (!memcmp(&prev_info->x86_capability, &boot_cpu_data.x86_capability,
+		    sizeof(prev_info->x86_capability)))
 		return;
 
 	pr_warn("x86/CPU: CPU features have changed after loading microcode, but might not take effect.\n");
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 707a385943b41..2c70f3cfae68e 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -509,13 +509,14 @@ static int __reload_late(void *info)
 static int microcode_reload_late(void)
 {
 	int old = boot_cpu_data.microcode, ret;
+	struct cpuinfo_x86 prev_info;
 
 	atomic_set(&late_cpus_in,  0);
 	atomic_set(&late_cpus_out, 0);
 
 	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
 	if (ret == 0)
-		microcode_check();
+		microcode_check(&prev_info);
 
 	pr_info("Reload completed, microcode revision: 0x%x -> 0x%x\n",
 		old, boot_cpu_data.microcode);
-- 
2.39.2



