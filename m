Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D246604672
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiJSNKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbiJSNJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:09:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158483C151;
        Wed, 19 Oct 2022 05:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666184087; x=1697720087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7nRf7HpxMobG7tiEk47jyd5TdB9jkpmn4TMYC/GrBxo=;
  b=kF9ta+x1WnAiEXygYvMRuXHrCN2NCqcEM1p41a4Y/5yH/u2nuxr+yBKd
   epoyTV27AlgqgRr31J3ebcHnXBW1Dl2wiqgNvQwZ77n6uIehc0REZluE7
   6aIFitQe2v/08CjpmVTUGHDauTqwg2sBbCV0+9NwD2UvFerF0VCi3jLWu
   /a9joFziU4rlJ6taZE/tfIm7Ya6xIA5ul9vNuuyu1tp8svc3aoH9+QSED
   HteZp502xs4CW2pUF05mJb8Hxv9OIWZ/H1dqxqPZZhVlpo7guNXgzGzwQ
   L7VS+DUN2KyHal2LBzFFwZW04u3lSGY0/lrCmZxBK5c8XBkU3c4qyM2z/
   w==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="185504889"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 05:53:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 05:53:31 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 19 Oct 2022 05:53:29 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <stable@vger.kernel.org>
CC:     <conor.dooley@microchip.com>, <Brice.Goglin@inria.fr>,
        <atishp@atishpatra.org>, <catalin.marinas@arm.com>,
        <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <palmer@dabbelt.com>, <sudeep.holla@arm.com>, <will@kernel.org>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH 5.10 2/2] riscv: topology: fix default topology reporting
Date:   Wed, 19 Oct 2022 13:53:03 +0100
Message-ID: <20221019125303.2845522-2-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019125303.2845522-1-conor.dooley@microchip.com>
References: <20221019125303.2845522-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
I just resolved the conflicts, which was mainly removing mentions of
NUMA. Tested in QEMU only.
---
 arch/riscv/Kconfig          | 2 +-
 arch/riscv/kernel/smpboot.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 1b894c327578..557c4a8c4087 100644
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
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index 0b04e0eae3ab..0e0aed380e28 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -46,6 +46,8 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	int cpuid;
 	int ret;
 
+	store_cpu_topology(smp_processor_id());
+
 	/* This covers non-smp usecase mandated by "nosmp" option */
 	if (max_cpus == 0)
 		return;
@@ -152,8 +154,8 @@ asmlinkage __visible void smp_callin(void)
 	mmgrab(mm);
 	current->active_mm = mm;
 
+	store_cpu_topology(curr_cpuid);
 	notify_cpu_starting(curr_cpuid);
-	update_siblings_masks(curr_cpuid);
 	set_cpu_online(curr_cpuid, 1);
 
 	/*
-- 
2.38.0

