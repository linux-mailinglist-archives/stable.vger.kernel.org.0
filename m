Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625F0220060
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 00:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGNWFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 18:05:45 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:3044 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNWFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 18:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594764344; x=1626300344;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=udImvFldfNCPwC2YgZo5KnuFEHUlBz2nN+mwnYJGHwA=;
  b=iRjs/hS0rSV8rYMNuWPpMFNuGJ0558qHPvSagRp2nkAKqfuojQctFMuz
   Ak+lqJdR2KGPcRk7CbmvZiXMMof7gN7CJLbqAiNU+T2wo9m1cWiBqMFOa
   VFti3Fr0td8ct5PPZyq027LzQm3MOcUDtIhnwAmL2obeDekysCEFeujDC
   s=;
IronPort-SDR: zkJmyFIFK3mzKZu6G58UGtN+wkJuXtocGTYEjex3jdKNe0V1rD+L5GXDVlGrDZwgfFFWcHXbaN
 e0nQz7Jk5KEg==
X-IronPort-AV: E=Sophos;i="5.75,353,1589241600"; 
   d="scan'208";a="51639527"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 14 Jul 2020 22:05:33 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id C3970A1E87;
        Tue, 14 Jul 2020 22:05:32 +0000 (UTC)
Received: from EX13D30UWC004.ant.amazon.com (10.43.162.4) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 14 Jul 2020 22:05:31 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D30UWC004.ant.amazon.com (10.43.162.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 14 Jul 2020 22:05:31 +0000
Received: from dev-dsk-surajjs-2c-3edee245.us-west-2.amazon.com (172.19.3.110)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 14 Jul 2020 22:05:30 +0000
Received: by dev-dsk-surajjs-2c-3edee245.us-west-2.amazon.com (Postfix, from userid 10505755)
        id 4454381EF8; Tue, 14 Jul 2020 22:05:30 +0000 (UTC)
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <sjitindarsingh@gmail.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.9 4.14] x86/cpu: Move x86_cache_bits settings
Date:   Tue, 14 Jul 2020 22:05:28 +0000
Message-ID: <20200714220528.32534-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is to fix the backport of the upstream patch:
cc51e5428ea5 x86/speculation/l1tf: Increase l1tf memory limit for Nehalem+

When this was backported to the 4.9 and 4.14 stable branches the line
+       c->x86_cache_bits = c->x86_phys_bits;
was applied in the wrong place, being added to the
identify_cpu_without_cpuid() function instead of the get_cpu_cap()
function which it was correctly applied to in the 4.4 backport.

This means that x86_cache_bits is not set correctly resulting in the
following warning due to the cache bits being left uninitalised (zero).

 WARNING: CPU: 0 PID: 7566 at arch/x86/kvm/mmu.c:284 kvm_mmu_set_mmio_spte_mask+0x4e/0x60 [kvm
 Modules linked in: kvm_intel(+) kvm irqbypass ipv6 crc_ccitt binfmt_misc evdev lpc_ich mfd_core ioatdma pcc_cpufreq dca ena acpi_power_meter hwmon acpi_pad button ext4 crc16 mbcache jbd2 fscrypto nvme nvme_core dm_mirror dm_region_hash dm_log dm_mod dax
 Hardware name: Amazon EC2 i3.metal/Not Specified, BIOS 1.0 10/16/2017
 task: ffff88ff77704c00 task.stack: ffffc9000edac000
 RIP: 0010:kvm_mmu_set_mmio_spte_mask+0x4e/0x60 [kvm
 RSP: 0018:ffffc9000edafc60 EFLAGS: 00010206
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000ffffff45
 RDX: 000000000000002e RSI: 0008000000000001 RDI: 0008000000000001
 RBP: ffffffffa036f000 R08: ffffffffffffff80 R09: ffffe8ffffccb3c0
 R10: 0000000000000038 R11: 0000000000000000 R12: 0000000000005b80
 R13: ffffffffa0370e40 R14: 0000000000000001 R15: ffff88bf7c0927e0
 FS:  00007fa316f24740(0000) GS:ffff88bf7f600000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fa316ea0000 CR3: 0000003f7e986004 CR4: 00000000003606f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  kvm_mmu_module_init+0x166/0x230 [kvm
  kvm_arch_init+0x5d/0x150 [kvm
  kvm_init+0x1c/0x2d0 [kvm
  ? hardware_setup+0x4a6/0x4a6 [kvm_intel
  vmx_init+0x23/0x6aa [kvm_intel
  ? hardware_setup+0x4a6/0x4a6 [kvm_intel
  do_one_initcall+0x3e/0x15d
  do_init_module+0x5b/0x1e5
  load_module+0x19e6/0x1dc0
  ? SYSC_init_module+0x13b/0x170
  SYSC_init_module+0x13b/0x170
  do_syscall_64+0x67/0x110
  entry_SYSCALL_64_after_hwframe+0x41/0xa6
 RIP: 0033:0x7fa316828f3a
 RSP: 002b:00007ffc9d65c1f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000af
 RAX: ffffffffffffffda RBX: 00007fa316b08849 RCX: 00007fa316828f3a
 RDX: 00007fa316b08849 RSI: 0000000000071328 RDI: 00007fa316e37000
 RBP: 0000000000b47e80 R08: 0000000000000003 R09: 0000000000000000
 R10: 00007fa316822dba R11: 0000000000000246 R12: 0000000000b46340
 R13: 0000000000b464c0 R14: 0000000000000000 R15: 0000000000040000
 Code: e9 65 06 00 75 25 48 b8 00 00 00 00 00 00 00 40 48 09 c6 48 09 c7 48 89 35 f8 65 06 00 48 89 3d f9 65 06 00 c3 0f 0b 0f 0b eb d2 <0f> 0b eb d7 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44

Fixes: 4.9.x  ef3d45c95764 x86/speculation/l1tf: Increase l1tf memory limit for Nehalem+
Fixes: 4.14.x ec4034835eaf x86/speculation/l1tf: Increase l1tf memory limit for Nehalem+
Cc: stable@vger.kernel.org # 4.9.x-4.14.x
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Reviewed-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Reviewed-by: Frank van der Linden <fllinden@amazon.com>
---
 arch/x86/kernel/cpu/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4a760fa494ac..64066a2497e4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -854,6 +854,7 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
 		c->x86_phys_bits = 36;
 #endif
+	c->x86_cache_bits = c->x86_phys_bits;
 
 	if (c->extended_cpuid_level >= 0x8000000a)
 		c->x86_capability[CPUID_8000_000A_EDX] = cpuid_edx(0x8000000a);
@@ -894,7 +895,6 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 			}
 		}
 #endif
-	c->x86_cache_bits = c->x86_phys_bits;
 }
 
 #define NO_SPECULATION		BIT(0)
-- 
2.24.1.AMZN

