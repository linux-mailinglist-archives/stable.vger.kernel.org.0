Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D806AF361
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjCGTE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbjCGTED (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:04:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DD02D61
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:49:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 947EEB819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0409C433EF;
        Tue,  7 Mar 2023 18:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214987;
        bh=7jJBllfddU9d+icJLBF9xUNOfsKc23VPluoMBBSbsh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf4gZiOgLujmG09YEgpFhVhIKfwFdQrC0PEsKiB+cse5MbTMNHCR0MEyLko0t34w3
         3kUVWXWDvSSed7hHRQ/FtyLktm44ix9jDOmAGMgbdDyVmnfa0GqGTKVcyg0RoUKDFo
         j1V0ONTGfaVgbeHREQOZQOn+Qv0XfkLKOiyar4mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/567] x86/microcode: Rip out the OLD_INTERFACE
Date:   Tue,  7 Mar 2023 17:57:30 +0100
Message-Id: <20230307165910.859875051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 181b6f40e9ea80c76756d4d0cdeed396016c487e ]

Everything should be using the early initrd loading by now.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220525161232.14924-2-bp@alien8.de
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig                     |  12 ----
 arch/x86/kernel/cpu/microcode/core.c | 100 ---------------------------
 2 files changed, 112 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0f2234cd8453c..da87b3bfc9132 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1320,18 +1320,6 @@ config MICROCODE_AMD
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
 
-config MICROCODE_OLD_INTERFACE
-	bool "Ancient loading interface (DEPRECATED)"
-	default n
-	depends on MICROCODE
-	help
-	  DO NOT USE THIS! This is the ancient /dev/cpu/microcode interface
-	  which was used by userspace tools like iucode_tool and microcode.ctl.
-	  It is inadequate because it runs too late to be able to properly
-	  load microcode on a machine and it needs special tools. Instead, you
-	  should've switched to the early loading method with the initrd or
-	  builtin microcode by now: Documentation/x86/microcode.rst
-
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
 	help
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 150ebfb8c12ed..951677121c77d 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -390,98 +390,6 @@ static int apply_microcode_on_target(int cpu)
 	return ret;
 }
 
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-static int do_microcode_update(const void __user *buf, size_t size)
-{
-	int error = 0;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-		enum ucode_state ustate;
-
-		if (!uci->valid)
-			continue;
-
-		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
-		if (ustate == UCODE_ERROR) {
-			error = -1;
-			break;
-		} else if (ustate == UCODE_NEW) {
-			apply_microcode_on_target(cpu);
-		}
-	}
-
-	return error;
-}
-
-static int microcode_open(struct inode *inode, struct file *file)
-{
-	return capable(CAP_SYS_RAWIO) ? stream_open(inode, file) : -EPERM;
-}
-
-static ssize_t microcode_write(struct file *file, const char __user *buf,
-			       size_t len, loff_t *ppos)
-{
-	ssize_t ret = -EINVAL;
-	unsigned long nr_pages = totalram_pages();
-
-	if ((len >> PAGE_SHIFT) > nr_pages) {
-		pr_err("too much data (max %ld pages)\n", nr_pages);
-		return ret;
-	}
-
-	cpus_read_lock();
-	mutex_lock(&microcode_mutex);
-
-	if (do_microcode_update(buf, len) == 0)
-		ret = (ssize_t)len;
-
-	if (ret > 0)
-		perf_check_microcode();
-
-	mutex_unlock(&microcode_mutex);
-	cpus_read_unlock();
-
-	return ret;
-}
-
-static const struct file_operations microcode_fops = {
-	.owner			= THIS_MODULE,
-	.write			= microcode_write,
-	.open			= microcode_open,
-	.llseek		= no_llseek,
-};
-
-static struct miscdevice microcode_dev = {
-	.minor			= MICROCODE_MINOR,
-	.name			= "microcode",
-	.nodename		= "cpu/microcode",
-	.fops			= &microcode_fops,
-};
-
-static int __init microcode_dev_init(void)
-{
-	int error;
-
-	error = misc_register(&microcode_dev);
-	if (error) {
-		pr_err("can't misc_register on minor=%d\n", MICROCODE_MINOR);
-		return error;
-	}
-
-	return 0;
-}
-
-static void __exit microcode_dev_exit(void)
-{
-	misc_deregister(&microcode_dev);
-}
-#else
-#define microcode_dev_init()	0
-#define microcode_dev_exit()	do { } while (0)
-#endif
-
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
@@ -873,10 +781,6 @@ static int __init microcode_init(void)
 		goto out_driver;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		goto out_ucode_group;
-
 	register_syscore_ops(&mc_syscore_ops);
 	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:starting",
 				  mc_cpu_starting, NULL);
@@ -887,10 +791,6 @@ static int __init microcode_init(void)
 
 	return 0;
 
- out_ucode_group:
-	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
-			   &cpu_root_microcode_group);
-
  out_driver:
 	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
-- 
2.39.2



