Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48295FFE6C
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 11:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJPJ2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 05:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJPJ2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 05:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D04F37192
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 02:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EDA460023
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6F4C43470;
        Sun, 16 Oct 2022 09:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665912488;
        bh=dq15e3UVCbV78eq8sWm20KADFiy429vKjM+ocrevzus=;
        h=Subject:To:Cc:From:Date:From;
        b=fH3tx3KUGWe72bfAxOxywuV2qhQIaaSGj+Rkhv3SHJOF0SPbgVBCDHDR5gL0d8Ehn
         hvNbFy6Gb1igw2ugJMKXUwSdz3+mQfx0u5t7H7Gi3ASBAjP4mz/BZGGE4wj6vxP5Vl
         t1y0Vaaf82/P9LfTSSy+6YREJDeadRLpsnRjrIT8=
Subject: FAILED: patch "[PATCH] riscv: topology: fix default topology reporting" failed to apply to 5.4-stable tree
To:     conor.dooley@microchip.com, Brice.Goglin@inria.fr,
        atishp@rivosinc.com, sudeep.holla@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 11:28:46 +0200
Message-ID: <16659125264751@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

fbd92809997a ("riscv: topology: fix default topology reporting")
4f0e8eef772e ("riscv: Add numa support for riscv64 platform")
cbd34f4bb37d ("riscv: Separate memory init from paging init")
00ab027a3b82 ("RISC-V: Add kernel image sections to the resource tree")
270315b8235e ("Merge tag 'riscv-for-linus-5.10-mw0' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fbd92809997a391f28075f1c8b5ee314c225557c Mon Sep 17 00:00:00 2001
From: Conor Dooley <conor.dooley@microchip.com>
Date: Fri, 15 Jul 2022 18:51:56 +0100
Subject: [PATCH] riscv: topology: fix default topology reporting

RISC-V has no sane defaults to fall back on where there is no cpu-map
in the devicetree.
Without sane defaults, the package, core and thread IDs are all set to
-1. This causes user-visible inaccuracies for tools like hwloc/lstopo
which rely on the sysfs cpu topology files to detect a system's
topology.

On a PolarFire SoC, which should have 4 harts with a thread each,
lstopo currently reports:

Machine (793MB total)
  Package L#0
    NUMANode L#0 (P#0 793MB)
    Core L#0
      L1d L#0 (32KB) + L1i L#0 (32KB) + PU L#0 (P#0)
      L1d L#1 (32KB) + L1i L#1 (32KB) + PU L#1 (P#1)
      L1d L#2 (32KB) + L1i L#2 (32KB) + PU L#2 (P#2)
      L1d L#3 (32KB) + L1i L#3 (32KB) + PU L#3 (P#3)

Adding calls to store_cpu_topology() in {boot,smp} hart bringup code
results in the correct topolgy being reported:

Machine (793MB total)
  Package L#0
    NUMANode L#0 (P#0 793MB)
    L1d L#0 (32KB) + L1i L#0 (32KB) + Core L#0 + PU L#0 (P#0)
    L1d L#1 (32KB) + L1i L#1 (32KB) + Core L#1 + PU L#1 (P#1)
    L1d L#2 (32KB) + L1i L#2 (32KB) + Core L#2 + PU L#2 (P#2)
    L1d L#3 (32KB) + L1i L#3 (32KB) + Core L#3 + PU L#3 (P#3)

CC: stable@vger.kernel.org # 456797da792f: arm64: topology: move store_cpu_topology() to shared code
Fixes: 03f11f03dbfe ("RISC-V: Parse cpu topology during boot.")
Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Link: https://github.com/open-mpi/hwloc/issues/536
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index ed66c31e4655..d557cc50295d 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -52,7 +52,7 @@ config RISCV
 	select COMMON_CLK
 	select CPU_PM if CPU_IDLE
 	select EDAC_SUPPORT
-	select GENERIC_ARCH_TOPOLOGY if SMP
+	select GENERIC_ARCH_TOPOLOGY
 	select GENERIC_ATOMIC64 if !64BIT
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_EARLY_IOREMAP
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index a752c7b41683..3373df413c88 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -49,6 +49,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	unsigned int curr_cpuid;
 
 	curr_cpuid = smp_processor_id();
+	store_cpu_topology(curr_cpuid);
 	numa_store_cpu_info(curr_cpuid);
 	numa_add_cpu(curr_cpuid);
 
@@ -162,9 +163,9 @@ asmlinkage __visible void smp_callin(void)
 	mmgrab(mm);
 	current->active_mm = mm;
 
+	store_cpu_topology(curr_cpuid);
 	notify_cpu_starting(curr_cpuid);
 	numa_add_cpu(curr_cpuid);
-	update_siblings_masks(curr_cpuid);
 	set_cpu_online(curr_cpuid, 1);
 
 	/*

