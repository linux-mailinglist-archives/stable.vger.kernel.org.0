Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CC760FEAD
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbiJ0RHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiJ0RHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:07:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681CD12FFAB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D68BB825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75965C433D7;
        Thu, 27 Oct 2022 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890437;
        bh=AtF4Mi2InvisdSykzG6sobYUEekNmM8bDGxBxNlebA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VN6kgL1/XBBW9cDkM4+sAj3tHGTDUNQhjD6yxfPgzuE/6+Pvw7FQESRjIk/HHcJtk
         eSZwaVrUoRX9GkJauwkVPoMXx+Z+Eg5kdiyaRkorMpf9ziaCIetubDjx2ywIG4tP00
         RvfkDFXrGlxw+mgpcSKWZupZm7EoNTgejmYNAm6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brice Goglin <Brice.Goglin@inria.fr>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Atish Patra <atishp@rivosinc.com>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.10 71/79] riscv: topology: fix default topology reporting
Date:   Thu, 27 Oct 2022 18:56:21 +0200
Message-Id: <20221027165056.718557592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

commit fbd92809997a391f28075f1c8b5ee314c225557c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig          |    2 +-
 arch/riscv/kernel/smpboot.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -35,7 +35,7 @@ config RISCV
 	select CLINT_TIMER if !MMU
 	select COMMON_CLK
 	select EDAC_SUPPORT
-	select GENERIC_ARCH_TOPOLOGY if SMP
+	select GENERIC_ARCH_TOPOLOGY
 	select GENERIC_ATOMIC64 if !64BIT
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_EARLY_IOREMAP
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -46,6 +46,8 @@ void __init smp_prepare_cpus(unsigned in
 	int cpuid;
 	int ret;
 
+	store_cpu_topology(smp_processor_id());
+
 	/* This covers non-smp usecase mandated by "nosmp" option */
 	if (max_cpus == 0)
 		return;
@@ -152,8 +154,8 @@ asmlinkage __visible void smp_callin(voi
 	mmgrab(mm);
 	current->active_mm = mm;
 
+	store_cpu_topology(curr_cpuid);
 	notify_cpu_starting(curr_cpuid);
-	update_siblings_masks(curr_cpuid);
 	set_cpu_online(curr_cpuid, 1);
 
 	/*


