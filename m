Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE24FD55A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355847AbiDLH32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242334AbiDLHWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5752C13B;
        Mon, 11 Apr 2022 23:59:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AB5560B65;
        Tue, 12 Apr 2022 06:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B12C385A8;
        Tue, 12 Apr 2022 06:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746784;
        bh=ucfA2C2SWIQgzh8yu0sdw5aNdUWtqQHKO/aIHM0aMUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DFwyjwR9IVH2Ptit6GoNWZlJZHEbJjaKgcnPwOOKGP86AtQ4s3if/ZukIeXPGmJ8l
         Jgd7g4GmoHTAuS2s4nfzV1g0MBXtBLtVGZVAJTFxE0OsnqUVqj3/aYCN98kzhXq1YM
         t71hweJ4zAOdOHRGofqAz3kUig0WcjVkK52/Kx8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Jin <joe.jin@oracle.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 130/285] xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32
Date:   Tue, 12 Apr 2022 08:29:47 +0200
Message-Id: <20220412062947.417506603@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

[ Upstream commit eed05744322da07dd7e419432dcedf3c2e017179 ]

The sched_clock() can be used very early since commit 857baa87b642
("sched/clock: Enable sched clock early"). In addition, with commit
38669ba205d1 ("x86/xen/time: Output xen sched_clock time from 0"), kdump
kernel in Xen HVM guest may panic at very early stage when accessing
&__this_cpu_read(xen_vcpu)->time as in below:

setup_arch()
 -> init_hypervisor_platform()
     -> x86_init.hyper.init_platform = xen_hvm_guest_init()
         -> xen_hvm_init_time_ops()
             -> xen_clocksource_read()
                 -> src = &__this_cpu_read(xen_vcpu)->time;

This is because Xen HVM supports at most MAX_VIRT_CPUS=32 'vcpu_info'
embedded inside 'shared_info' during early stage until xen_vcpu_setup() is
used to allocate/relocate 'vcpu_info' for boot cpu at arbitrary address.

However, when Xen HVM guest panic on vcpu >= 32, since
xen_vcpu_info_reset(0) would set per_cpu(xen_vcpu, cpu) = NULL when
vcpu >= 32, xen_clocksource_read() on vcpu >= 32 would panic.

This patch calls xen_hvm_init_time_ops() again later in
xen_hvm_smp_prepare_boot_cpu() after the 'vcpu_info' for boot vcpu is
registered when the boot vcpu is >= 32.

This issue can be reproduced on purpose via below command at the guest
side when kdump/kexec is enabled:

"taskset -c 33 echo c > /proc/sysrq-trigger"

The bugfix for PVM is not implemented due to the lack of testing
environment.

[boris: xen_hvm_init_time_ops() returns on errors instead of jumping to end]

Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20220302164032.14569-3-dongli.zhang@oracle.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp_hvm.c |  6 ++++++
 arch/x86/xen/time.c    | 24 +++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp_hvm.c b/arch/x86/xen/smp_hvm.c
index 6ff3c887e0b9..b70afdff419c 100644
--- a/arch/x86/xen/smp_hvm.c
+++ b/arch/x86/xen/smp_hvm.c
@@ -19,6 +19,12 @@ static void __init xen_hvm_smp_prepare_boot_cpu(void)
 	 */
 	xen_vcpu_setup(0);
 
+	/*
+	 * Called again in case the kernel boots on vcpu >= MAX_VIRT_CPUS.
+	 * Refer to comments in xen_hvm_init_time_ops().
+	 */
+	xen_hvm_init_time_ops();
+
 	/*
 	 * The alternative logic (which patches the unlock/lock) runs before
 	 * the smp bootup up code is activated. Hence we need to set this up
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index d9c945ee1100..9ef0a5cca96e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -558,6 +558,11 @@ static void xen_hvm_setup_cpu_clockevents(void)
 
 void __init xen_hvm_init_time_ops(void)
 {
+	static bool hvm_time_initialized;
+
+	if (hvm_time_initialized)
+		return;
+
 	/*
 	 * vector callback is needed otherwise we cannot receive interrupts
 	 * on cpu > 0 and at this point we don't know how many cpus are
@@ -567,7 +572,22 @@ void __init xen_hvm_init_time_ops(void)
 		return;
 
 	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
-		pr_info("Xen doesn't support pvclock on HVM, disable pv timer");
+		pr_info_once("Xen doesn't support pvclock on HVM, disable pv timer");
+		return;
+	}
+
+	/*
+	 * Only MAX_VIRT_CPUS 'vcpu_info' are embedded inside 'shared_info'.
+	 * The __this_cpu_read(xen_vcpu) is still NULL when Xen HVM guest
+	 * boots on vcpu >= MAX_VIRT_CPUS (e.g., kexec), To access
+	 * __this_cpu_read(xen_vcpu) via xen_clocksource_read() will panic.
+	 *
+	 * The xen_hvm_init_time_ops() should be called again later after
+	 * __this_cpu_read(xen_vcpu) is available.
+	 */
+	if (!__this_cpu_read(xen_vcpu)) {
+		pr_info("Delay xen_init_time_common() as kernel is running on vcpu=%d\n",
+			xen_vcpu_nr(0));
 		return;
 	}
 
@@ -577,6 +597,8 @@ void __init xen_hvm_init_time_ops(void)
 	x86_cpuinit.setup_percpu_clockev = xen_hvm_setup_cpu_clockevents;
 
 	x86_platform.set_wallclock = xen_set_wallclock;
+
+	hvm_time_initialized = true;
 }
 #endif
 
-- 
2.35.1



