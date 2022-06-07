Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799B1541769
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377796AbiFGVDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379077AbiFGVCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB87511E484;
        Tue,  7 Jun 2022 11:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F2A56156D;
        Tue,  7 Jun 2022 18:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E332C385A2;
        Tue,  7 Jun 2022 18:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627584;
        bh=rpTWwyjktX7kqYmFTTv2lUiyxlshLEU5YxA/+fpgFro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkWOg/lMraIHHhm2xkeM6v3Oi60FnppCqE2S39ObQ676UJCcFLnp9xqJQRkdCS3rk
         hMh/re2dlbjRkNn21HwiJRzf+94S9QdAPF7wOJENhHWe7dVdWNfloayeig/DpTd3VW
         00pGKthLpNnUgH/hpBtHEfNSZfTqGeuJWiZmuxpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.18 003/879] parisc: fix a crash with multicore scheduler
Date:   Tue,  7 Jun 2022 18:52:01 +0200
Message-Id: <20220607165002.768275874@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 6ba688364856ad083be537f08e86ba97f433d405 upstream.

With the kernel 5.18, the system will hang on boot if it is compiled with
CONFIG_SCHED_MC. The last printed message is "Brought up 1 node, 1 CPU".

The crash happens in sd_init
tl->mask (which is cpu_coregroup_mask) returns an empty mask. This happens
	because cpu_topology[0].core_sibling is empty.
Consequently, sd_span is set to an empty mask
sd_id = cpumask_first(sd_span) sets sd_id == NR_CPUS (because the mask is
	empty)
sd->shared = *per_cpu_ptr(sdd->sds, sd_id); sets sd->shared to NULL
	because sd_id is out of range
atomic_inc(&sd->shared->ref); crashes without printing anything

We can fix it by calling reset_cpu_topology() from init_cpu_topology() -
this will initialize the sibling masks on CPUs, so that they're not empty.

This patch also removes the variable "dualcores_found", it is useless,
because during boot, init_cpu_topology is called before
store_cpu_topology. Thus, set_sched_topology(parisc_mc_topology) is never
called. We don't need to call it at all because default_topology in
kernel/sched/topology.c contains the same items as parisc_mc_topology.

Note that we should not call store_cpu_topology() from init_per_cpu()
because it is called too early in the kernel initialization process and it
results in the message "Failure to register CPU0 device". Before this
patch, store_cpu_topology() would exit immediatelly because
cpuid_topo->core id was uninitialized and it was 0.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.18
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/processor.c |  2 --
 arch/parisc/kernel/topology.c  | 16 +---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor.c
index 26eb568f8b96..dddaaa6e7a82 100644
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -327,8 +327,6 @@ int init_per_cpu(int cpunum)
 	set_firmware_width();
 	ret = pdc_coproc_cfg(&coproc_cfg);
 
-	store_cpu_topology(cpunum);
-
 	if(ret >= 0 && coproc_cfg.ccr_functional) {
 		mtctl(coproc_cfg.ccr_functional, 10);  /* 10 == Coprocessor Control Reg */
 
diff --git a/arch/parisc/kernel/topology.c b/arch/parisc/kernel/topology.c
index 9696e3cb6a2a..b9d845e314f8 100644
--- a/arch/parisc/kernel/topology.c
+++ b/arch/parisc/kernel/topology.c
@@ -20,8 +20,6 @@
 
 static DEFINE_PER_CPU(struct cpu, cpu_devices);
 
-static int dualcores_found;
-
 /*
  * store_cpu_topology is called at boot when only one cpu is running
  * and with the mutex cpu_hotplug.lock locked, when several cpus have booted,
@@ -60,7 +58,6 @@ void store_cpu_topology(unsigned int cpuid)
 			if (p->cpu_loc) {
 				cpuid_topo->core_id++;
 				cpuid_topo->package_id = cpu_topology[cpu].package_id;
-				dualcores_found = 1;
 				continue;
 			}
 		}
@@ -80,22 +77,11 @@ void store_cpu_topology(unsigned int cpuid)
 		cpu_topology[cpuid].package_id);
 }
 
-static struct sched_domain_topology_level parisc_mc_topology[] = {
-#ifdef CONFIG_SCHED_MC
-	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
-#endif
-
-	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
-	{ NULL, },
-};
-
 /*
  * init_cpu_topology is called at boot when only one cpu is running
  * which prevent simultaneous write access to cpu_topology array
  */
 void __init init_cpu_topology(void)
 {
-	/* Set scheduler topology descriptor */
-	if (dualcores_found)
-		set_sched_topology(parisc_mc_topology);
+	reset_cpu_topology();
 }
-- 
2.36.1



