Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D318F226B4D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbgGTPn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgGTPn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:43:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97CD122CE3;
        Mon, 20 Jul 2020 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259806;
        bh=R7PcGtApXb+A8urvYiYpVDWaNd2ykP9H4RWR7q5QJwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPnSZKb+tBvzQyDsQ9lzjitvZnCuMnelAH6/JmaZnMcTr18ZDVLUtS7uMLT6Ai5xx
         qEyqLHseCSMA51+dLuQWXL23PNvu0a5tysIFWCXPFQk7Rm19oPdflLYKdv48vSY/2n
         Eh2EAf19a+L2T38jNTlf7O03HMTL/Zdn+CMfwcO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.9 86/86] x86/cpu: Move x86_cache_bits settings
Date:   Mon, 20 Jul 2020 17:37:22 +0200
Message-Id: <20200720152757.605261721@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suraj Jitindar Singh <surajjs@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -849,6 +849,7 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	else if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
 		c->x86_phys_bits = 36;
 #endif
+	c->x86_cache_bits = c->x86_phys_bits;
 
 	if (c->extended_cpuid_level >= 0x8000000a)
 		c->x86_capability[CPUID_8000_000A_EDX] = cpuid_edx(0x8000000a);
@@ -888,7 +889,6 @@ static void identify_cpu_without_cpuid(s
 			}
 		}
 #endif
-	c->x86_cache_bits = c->x86_phys_bits;
 }
 
 #define NO_SPECULATION		BIT(0)


