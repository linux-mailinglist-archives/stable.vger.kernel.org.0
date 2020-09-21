Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7007D272F17
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgIUQxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbgIUQrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D85902389F;
        Mon, 21 Sep 2020 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706829;
        bh=XfNvyuXbk8WgXnXBwVcqG11TLOMTrjllh+bn567fnBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnOxb8CUCaHgizk6q2u6hpGReppFlOUm4xYjjHvptwMHcq6k4gwzO/AwzJRX6IsZo
         SvFgQ/mRGKE/0HVhgFfj3B9Px+WxtPArFYpBiV9xe4A9f+01eZomqXKY8NWmQnUsXO
         mdHmODa+G1R5yFgtsAkmoKcNBnWMC4Y6frEImk1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.8 110/118] arm64: paravirt: Initialize steal time when cpu is online
Date:   Mon, 21 Sep 2020 18:28:42 +0200
Message-Id: <20200921162041.493431183@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

commit 75df529bec9110dad43ab30e2d9490242529e8b8 upstream.

Steal time initialization requires mapping a memory region which
invokes a memory allocation. Doing this at CPU starting time results
in the following trace when CONFIG_DEBUG_ATOMIC_SLEEP is enabled:

BUG: sleeping function called from invalid context at mm/slab.h:498
in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/1
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.9.0-rc5+ #1
Call trace:
 dump_backtrace+0x0/0x208
 show_stack+0x1c/0x28
 dump_stack+0xc4/0x11c
 ___might_sleep+0xf8/0x130
 __might_sleep+0x58/0x90
 slab_pre_alloc_hook.constprop.101+0xd0/0x118
 kmem_cache_alloc_node_trace+0x84/0x270
 __get_vm_area_node+0x88/0x210
 get_vm_area_caller+0x38/0x40
 __ioremap_caller+0x70/0xf8
 ioremap_cache+0x78/0xb0
 memremap+0x9c/0x1a8
 init_stolen_time_cpu+0x54/0xf0
 cpuhp_invoke_callback+0xa8/0x720
 notify_cpu_starting+0xc8/0xd8
 secondary_start_kernel+0x114/0x180
CPU1: Booted secondary processor 0x0000000001 [0x431f0a11]

However we don't need to initialize steal time at CPU starting time.
We can simply wait until CPU online time, just sacrificing a bit of
accuracy by returning zero for steal time until we know better.

While at it, add __init to the functions that are only called by
pv_time_init() which is __init.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Fixes: e0685fa228fd ("arm64: Retrieve stolen time as paravirtualized guest")
Cc: stable@vger.kernel.org
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20200916154530.40809-1-drjones@redhat.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/paravirt.c |   26 +++++++++++++++-----------
 include/linux/cpuhotplug.h   |    1 -
 2 files changed, 15 insertions(+), 12 deletions(-)

--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -50,16 +50,19 @@ static u64 pv_steal_clock(int cpu)
 	struct pv_time_stolen_time_region *reg;
 
 	reg = per_cpu_ptr(&stolen_time_region, cpu);
-	if (!reg->kaddr) {
-		pr_warn_once("stolen time enabled but not configured for cpu %d\n",
-			     cpu);
+
+	/*
+	 * paravirt_steal_clock() may be called before the CPU
+	 * online notification callback runs. Until the callback
+	 * has run we just return zero.
+	 */
+	if (!reg->kaddr)
 		return 0;
-	}
 
 	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
 }
 
-static int stolen_time_dying_cpu(unsigned int cpu)
+static int stolen_time_cpu_down_prepare(unsigned int cpu)
 {
 	struct pv_time_stolen_time_region *reg;
 
@@ -73,7 +76,7 @@ static int stolen_time_dying_cpu(unsigne
 	return 0;
 }
 
-static int init_stolen_time_cpu(unsigned int cpu)
+static int stolen_time_cpu_online(unsigned int cpu)
 {
 	struct pv_time_stolen_time_region *reg;
 	struct arm_smccc_res res;
@@ -103,19 +106,20 @@ static int init_stolen_time_cpu(unsigned
 	return 0;
 }
 
-static int pv_time_init_stolen_time(void)
+static int __init pv_time_init_stolen_time(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
-				"hypervisor/arm/pvtime:starting",
-				init_stolen_time_cpu, stolen_time_dying_cpu);
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+				"hypervisor/arm/pvtime:online",
+				stolen_time_cpu_online,
+				stolen_time_cpu_down_prepare);
 	if (ret < 0)
 		return ret;
 	return 0;
 }
 
-static bool has_pv_steal_clock(void)
+static bool __init has_pv_steal_clock(void)
 {
 	struct arm_smccc_res res;
 
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -141,7 +141,6 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
-	CPUHP_AP_ARM_KVMPV_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_CTI_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,


