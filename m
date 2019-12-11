Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902AC11B1CA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbfLKP2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387715AbfLKP2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C942465B;
        Wed, 11 Dec 2019 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078127;
        bh=pY+YQzGqpx1xXwp9mQ5O1lTfNALdPm0LfjKNW7N+IIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MGTHn3OJKOEPEOMpcAGFEr/PIFGnBGiKv8lQ1kUXu8Xsi7nchUv/oKhplgAusGjio
         OMXbZVEmkgTm5ne0UNVet0RZ8xmEp1QmyZw45DlDScDzOaeZGUube3DZEf3fsqXFIS
         eh5a/uklBwgt35O458Zm8GgXVJ3y6zsrL6A2fgzU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 15/58] powerpc/book3s64/hash: Add cond_resched to avoid soft lockup warning
Date:   Wed, 11 Dec 2019 10:27:48 -0500
Message-Id: <20191211152831.23507-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152831.23507-1-sashal@kernel.org>
References: <20191211152831.23507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

[ Upstream commit 16f6b67cf03cb43db7104acb2ca877bdc2606c92 ]

With large memory (8TB and more) hotplug, we can get soft lockup
warnings as below. These were caused by a long loop without any
explicit cond_resched which is a problem for !PREEMPT kernels.

Avoid this using cond_resched() while inserting hash page table
entries. We already do similar cond_resched() in __add_pages(), see
commit f64ac5e6e306 ("mm, memory_hotplug: add scheduling point to
__add_pages").

  rcu:     3-....: (24002 ticks this GP) idle=13e/1/0x4000000000000002 softirq=722/722 fqs=12001
   (t=24003 jiffies g=4285 q=2002)
  NMI backtrace for cpu 3
  CPU: 3 PID: 3870 Comm: ndctl Not tainted 5.3.0-197.18-default+ #2
  Call Trace:
    dump_stack+0xb0/0xf4 (unreliable)
    nmi_cpu_backtrace+0x124/0x130
    nmi_trigger_cpumask_backtrace+0x1ac/0x1f0
    arch_trigger_cpumask_backtrace+0x28/0x3c
    rcu_dump_cpu_stacks+0xf8/0x154
    rcu_sched_clock_irq+0x878/0xb40
    update_process_times+0x48/0x90
    tick_sched_handle.isra.16+0x4c/0x80
    tick_sched_timer+0x68/0xe0
    __hrtimer_run_queues+0x180/0x430
    hrtimer_interrupt+0x110/0x300
    timer_interrupt+0x108/0x2f0
    decrementer_common+0x114/0x120
  --- interrupt: 901 at arch_add_memory+0xc0/0x130
      LR = arch_add_memory+0x74/0x130
    memremap_pages+0x494/0x650
    devm_memremap_pages+0x3c/0xa0
    pmem_attach_disk+0x188/0x750
    nvdimm_bus_probe+0xac/0x2c0
    really_probe+0x148/0x570
    driver_probe_device+0x19c/0x1d0
    device_driver_attach+0xcc/0x100
    bind_store+0x134/0x1c0
    drv_attr_store+0x44/0x60
    sysfs_kf_write+0x64/0x90
    kernfs_fop_write+0x1a0/0x270
    __vfs_write+0x3c/0x70
    vfs_write+0xd0/0x260
    ksys_write+0xdc/0x130
    system_call+0x5c/0x68

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191001084656.31277-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/hash_utils_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index cf1d76e036359..387600ecea60a 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -303,6 +303,7 @@ int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 		if (ret < 0)
 			break;
 
+		cond_resched();
 #ifdef CONFIG_DEBUG_PAGEALLOC
 		if (debug_pagealloc_enabled() &&
 			(paddr >> PAGE_SHIFT) < linear_map_hash_count)
-- 
2.20.1

