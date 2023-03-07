Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35F16AF376
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjCGTFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCGTE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:04:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6F9BF8FC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5421B819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FBCC433EF;
        Tue,  7 Mar 2023 18:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214993;
        bh=F6XYqSR6v/O/e5ouIKShapQd254Flxlej2BjKmLuWTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQUvVPIElvChvvFIH+xYmSqr7jiBisLw9OGmZnU4qcBmUJJKh9/91UxiYcYodWBrb
         2WBfXKiC7Z7QS3uM+Nu2v6SbEghSOuAFbbxUn1iMkwcj+Pn5+DQZiTiuxfG0yAB4c9
         pkNTRZqThFBWDcsCPRocUbDjdUWSx44jpoibcoWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/567] x86/microcode: Default-disable late loading
Date:   Tue,  7 Mar 2023 17:57:31 +0100
Message-Id: <20230307165910.899232186@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

[ Upstream commit a77a94f86273ce42a39cb479217dd8d68acfe0ff ]

It is dangerous and it should not be used anyway - there's a nice early
loading already.

Requested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220525161232.14924-3-bp@alien8.de
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig                     | 11 +++++++++++
 arch/x86/kernel/cpu/common.c         |  2 ++
 arch/x86/kernel/cpu/microcode/core.c |  7 ++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da87b3bfc9132..a08ce6360382a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1320,6 +1320,17 @@ config MICROCODE_AMD
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
 
+config MICROCODE_LATE_LOADING
+	bool "Late microcode loading (DANGEROUS)"
+	default n
+	depends on MICROCODE
+	help
+	  Loading microcode late, when the system is up and executing instructions
+	  is a tricky business and should be avoided if possible. Just the sequence
+	  of synchronizing all cores and SMT threads is one fragile dance which does
+	  not guarantee that cores might not softlock after the loading. Therefore,
+	  use this at your own risk. Late loading taints the kernel too.
+
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
 	help
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1698470dbea5f..6b71f40cd52d6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2149,6 +2149,7 @@ void cpu_init_secondary(void)
 }
 #endif
 
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 /*
  * The microcode loader calls this upon late microcode load to recheck features,
  * only when microcode has been updated. Caller holds microcode_mutex and CPU
@@ -2178,6 +2179,7 @@ void microcode_check(void)
 	pr_warn("x86/CPU: CPU features have changed after loading microcode, but might not take effect.\n");
 	pr_warn("x86/CPU: Please consider either early loading through initrd/built-in or a potential BIOS update.\n");
 }
+#endif
 
 /*
  * Invoked from core CPU hotplug code after hotplug operations
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 951677121c77d..dc346bbb06777 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -393,6 +393,7 @@ static int apply_microcode_on_target(int cpu)
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 /*
  * Late loading dance. Why the heavy-handed stomp_machine effort?
  *
@@ -560,6 +561,9 @@ static ssize_t reload_store(struct device *dev,
 	return ret;
 }
 
+static DEVICE_ATTR_WO(reload);
+#endif
+
 static ssize_t version_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -576,7 +580,6 @@ static ssize_t pf_show(struct device *dev,
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
 }
 
-static DEVICE_ATTR_WO(reload);
 static DEVICE_ATTR(version, 0444, version_show, NULL);
 static DEVICE_ATTR(processor_flags, 0444, pf_show, NULL);
 
@@ -729,7 +732,9 @@ static int mc_cpu_down_prep(unsigned int cpu)
 }
 
 static struct attribute *cpu_root_microcode_attrs[] = {
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 	&dev_attr_reload.attr,
+#endif
 	NULL
 };
 
-- 
2.39.2



