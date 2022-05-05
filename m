Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1502851BD7F
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 12:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbiEEKxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 06:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356098AbiEEKxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 06:53:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF67C1704C;
        Thu,  5 May 2022 03:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B291B82C20;
        Thu,  5 May 2022 10:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01EEC385A8;
        Thu,  5 May 2022 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651747789;
        bh=4wRC8CnMoukaVD03+2+C4OVAxYGmYnDtIw/bitID6EY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CEw6KXM4WlzscfjsuYVJyYEL3Q63NuQRaiaHJ5ly7tGrQUo6I1oBYRuQcIi9Fj/cG
         7og9sIAzrtRP/geXRB4SsDzIuzrzt740Ig0ZDJVIqyTh6ueJLpjmtzBblm9W/EkK/B
         wkVddlNxgXQP5sITTn6ergpsBeE/XAYsql0zwJlNYrqh3WJ07i+BldCtxwy9cJr5KU
         R2t1tSoAeJ3T0z6AChj71OAVNUMgeEc20190RZlMhJyNUK5w6S6g09hZBANbvHumQF
         T8OaQgLTqx7hcFdS1vLo6SzlEZu1U2rnSSlk2V9mc9V9oRHxT54QAq66SVlbdIWs1Y
         I1Hd7/R6BDosw==
Date:   Thu, 5 May 2022 11:49:43 +0100
From:   Will Deacon <will@kernel.org>
To:     Elliot Berman <quic_eberman@quicinc.com>
Cc:     Juergen Gross <jgross@suse.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Murali Nalajala <quic_mnalajal@quicinc.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: paravirt: Use RCU read locks to guard
 stolen_time
Message-ID: <20220505104942.GA21596@willie-the-truck>
References: <20220428183536.2866667-1-quic_eberman@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428183536.2866667-1-quic_eberman@quicinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Elliot,

On Thu, Apr 28, 2022 at 11:35:36AM -0700, Elliot Berman wrote:
> From: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
> 
> During hotplug, the stolen time data structure is unmapped and memset.
> There is a possibility of the timer IRQ being triggered before memset
> and stolen time is getting updated as part of this timer IRQ handler. This
> causes the below crash in timer handler -
> 
>   [ 3457.473139][    C5] Unable to handle kernel paging request at virtual address ffffffc03df05148
>   ...
>   [ 3458.154398][    C5] Call trace:
>   [ 3458.157648][    C5]  para_steal_clock+0x30/0x50
>   [ 3458.162319][    C5]  irqtime_account_process_tick+0x30/0x194
>   [ 3458.168148][    C5]  account_process_tick+0x3c/0x280
>   [ 3458.173274][    C5]  update_process_times+0x5c/0xf4
>   [ 3458.178311][    C5]  tick_sched_timer+0x180/0x384
>   [ 3458.183164][    C5]  __run_hrtimer+0x160/0x57c
>   [ 3458.187744][    C5]  hrtimer_interrupt+0x258/0x684
>   [ 3458.192698][    C5]  arch_timer_handler_virt+0x5c/0xa0
>   [ 3458.198002][    C5]  handle_percpu_devid_irq+0xdc/0x414
>   [ 3458.203385][    C5]  handle_domain_irq+0xa8/0x168
>   [ 3458.208241][    C5]  gic_handle_irq.34493+0x54/0x244
>   [ 3458.213359][    C5]  call_on_irq_stack+0x40/0x70
>   [ 3458.218125][    C5]  do_interrupt_handler+0x60/0x9c
>   [ 3458.223156][    C5]  el1_interrupt+0x34/0x64
>   [ 3458.227560][    C5]  el1h_64_irq_handler+0x1c/0x2c
>   [ 3458.232503][    C5]  el1h_64_irq+0x7c/0x80
>   [ 3458.236736][    C5]  free_vmap_area_noflush+0x108/0x39c
>   [ 3458.242126][    C5]  remove_vm_area+0xbc/0x118
>   [ 3458.246714][    C5]  vm_remove_mappings+0x48/0x2a4
>   [ 3458.251656][    C5]  __vunmap+0x154/0x278
>   [ 3458.255796][    C5]  stolen_time_cpu_down_prepare+0xc0/0xd8
>   [ 3458.261542][    C5]  cpuhp_invoke_callback+0x248/0xc34
>   [ 3458.266842][    C5]  cpuhp_thread_fun+0x1c4/0x248
>   [ 3458.271696][    C5]  smpboot_thread_fn+0x1b0/0x400
>   [ 3458.276638][    C5]  kthread+0x17c/0x1e0
>   [ 3458.280691][    C5]  ret_from_fork+0x10/0x20
> 
> As a fix, introduce rcu lock to update stolen time structure.
> 
> Fixes: 75df529bec91 ("arm64: paravirt: Initialize steal time when cpu is online")
> Cc: stable@vger.kernel.org
> Signed-off-by: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
> Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> ---
> Changes since v1: https://lore.kernel.org/all/20220420204417.155194-1-quic_eberman@quicinc.com/
>  - Use RCU instead of disabling interrupts
> 
>  arch/arm64/kernel/paravirt.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)

I applied this locally, but sparse is complaining because the 'kaddr' field
of 'struct pv_time_stolen_time_region' is missing an '__rcu' annotation:

 | arch/arm64/kernel/paravirt.c:112:9: warning: cast adds address space '__rcu' to expression [sparse]
 | arch/arm64/kernel/paravirt.c:112:9: error: incompatible types in comparison expression (different address spaces): [sparse]
 | arch/arm64/kernel/paravirt.c:112:9:    struct pvclock_vcpu_stolen_time [noderef] __rcu * [sparse]
 | arch/arm64/kernel/paravirt.c:112:9:    struct pvclock_vcpu_stolen_time * [sparse]
 | arch/arm64/kernel/paravirt.c:67:17: warning: cast adds address space '__rcu' to expression [sparse]
 | arch/arm64/kernel/paravirt.c:67:17: error: incompatible types in comparison expression (different address spaces): [sparse]
 | arch/arm64/kernel/paravirt.c:67:17:    struct pvclock_vcpu_stolen_time [noderef] __rcu * [sparse]
 | arch/arm64/kernel/paravirt.c:67:17:    struct pvclock_vcpu_stolen_time * [sparse]
 | arch/arm64/kernel/paravirt.c:88:9: warning: cast adds address space '__rcu' to expression [sparse]
 | arch/arm64/kernel/paravirt.c:88:9: error: incompatible types in comparison expression (different address spaces): [sparse]
 | arch/arm64/kernel/paravirt.c:88:9:    struct pvclock_vcpu_stolen_time [noderef] __rcu * [sparse]
 | arch/arm64/kernel/paravirt.c:88:9:    struct pvclock_vcpu_stolen_time * [sparse]

The diff below seems to make it happy again, but please can you take a
look?

Cheers,

Will

--->8

diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
index e724ea3d86f0..57c7c211f8c7 100644
--- a/arch/arm64/kernel/paravirt.c
+++ b/arch/arm64/kernel/paravirt.c
@@ -35,7 +35,7 @@ static u64 native_steal_clock(int cpu)
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
 
 struct pv_time_stolen_time_region {
-       struct pvclock_vcpu_stolen_time *kaddr;
+       struct pvclock_vcpu_stolen_time __rcu *kaddr;
 };
 
 static DEFINE_PER_CPU(struct pv_time_stolen_time_region, stolen_time_region);
@@ -84,8 +84,7 @@ static int stolen_time_cpu_down_prepare(unsigned int cpu)
        if (!reg->kaddr)
                return 0;
 
-       kaddr = reg->kaddr;
-       rcu_assign_pointer(reg->kaddr, NULL);
+       kaddr = rcu_replace_pointer(reg->kaddr, NULL, true);
        synchronize_rcu();
        memunmap(kaddr);
 
@@ -116,8 +115,8 @@ static int stolen_time_cpu_online(unsigned int cpu)
                return -ENOMEM;
        }
 
-       if (le32_to_cpu(reg->kaddr->revision) != 0 ||
-           le32_to_cpu(reg->kaddr->attributes) != 0) {
+       if (le32_to_cpu(kaddr->revision) != 0 ||
+           le32_to_cpu(kaddr->attributes) != 0) {
                pr_warn_once("Unexpected revision or attributes in stolen time data\n");
                return -ENXIO;
        }

