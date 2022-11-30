Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205EA63DD9C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiK3S3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiK3S26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:28:58 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C61427B3C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:28:57 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DED39D6E;
        Wed, 30 Nov 2022 10:29:03 -0800 (PST)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.197.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 829F03F73B;
        Wed, 30 Nov 2022 10:28:56 -0800 (PST)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sami Lee <sami.lee@mediatek.com>
Subject: [stable:PATCH v5.4.225 1/2] arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate KVM vectors
Date:   Wed, 30 Nov 2022 18:28:18 +0000
Message-Id: <20221130182819.739068-2-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130182819.739068-1-james.morse@arm.com>
References: <20221130182819.739068-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sami reports that linux panic()s when resuming from suspend to RAM. This
is because when CPUs are brought back online, they re-enable any
necessary mitigations.

The Spectre-v2 and Spectre-BHB mitigations interact as both need to
done by KVM when exiting a guest. Slots KVM can use as vectors are
allocated, and templates for the mitigation are patched into the vector.

This fails if a new slot needs to be allocated once the kernel has finished
booting as it is no-longer possible to modify KVM's vectors:
| root@adam:/sys/devices/system/cpu/cpu1# echo 1 > online
| Unable to handle kernel write to read-only memory at virtual add>
| Mem abort info:
|   ESR = 0x9600004e
|   Exception class = DABT (current EL), IL = 32 bits
|   SET = 0, FnV = 0
|   EA = 0, S1PTW = 0
| Data abort info:
|   ISV = 0, ISS = 0x0000004e
|   CM = 0, WnR = 1
| swapper pgtable: 4k pages, 48-bit VAs, pgdp = 000000000f07a71c
| [ffff800000b4b800] pgd=00000009ffff8803, pud=00000009ffff7803, p>
| Internal error: Oops: 9600004e [#1] PREEMPT SMP
| Modules linked in:
| Process swapper/1 (pid: 0, stack limit = 0x0000000063153c53)
| CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.19.252-dirty #14
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno De>
| pstate: 000001c5 (nzcv dAIF -PAN -UAO)
| pc : __memcpy+0x48/0x180
| lr : __copy_hyp_vect_bpi+0x64/0x90

| Call trace:
|  __memcpy+0x48/0x180
|  kvm_setup_bhb_slot+0x204/0x2a8
|  spectre_bhb_enable_mitigation+0x1b8/0x1d0
|  __verify_local_cpu_caps+0x54/0xf0
|  check_local_cpu_capabilities+0xc4/0x184
|  secondary_start_kernel+0xb0/0x170
| Code: b8404423 b80044c3 36180064 f8408423 (f80084c3)
| ---[ end trace 859bcacb09555348 ]---
| Kernel panic - not syncing: Attempted to kill the idle task!
| SMP: stopping secondary CPUs
| Kernel Offset: disabled
| CPU features: 0x10,25806086
| Memory Limit: none
| ---[ end Kernel panic - not syncing: Attempted to kill the idle ]

This is only a problem on platforms where there is only one CPU that is
vulnerable to both Spectre-v2 and Spectre-BHB.

The Spectre-v2 mitigation identifies the slot it can re-use by the CPU's
'fn'. It unconditionally writes the slot number and 'template_start'
pointer. The Spectre-BHB mitigation identifies slots it can re-use by
the CPU's template_start pointer, which was previously clobbered by the
Spectre-v2 mitigation.

When there is only one CPU that is vulnerable to both issues, this causes
Spectre-v2 to try to allocate a new slot, which fails.

Change both mitigations to check whether they are changing the slot this
CPU uses before writing the percpu variables again.

This issue only exists in the stable backports for Spectre-BHB which have
to use totally different infrastructure to mainline.

Reported-by: Sami Lee <sami.lee@mediatek.com>
Fixes: 9013fd4bc958 ("arm64: Mitigate spectre style branch history side channels")
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/cpu_errata.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 4c7545cf5a02..2a7c05640b38 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -170,9 +170,12 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.fn, fn);
-	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	if (fn != __this_cpu_read(bp_hardening_data.fn)) {
+		__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+		__this_cpu_write(bp_hardening_data.fn, fn);
+		__this_cpu_write(bp_hardening_data.template_start,
+				 hyp_vecs_start);
+	}
 	raw_spin_unlock(&bp_lock);
 }
 #else
@@ -1320,8 +1323,11 @@ static void kvm_setup_bhb_slot(const char *hyp_vecs_start)
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	if (hyp_vecs_start != __this_cpu_read(bp_hardening_data.template_start)) {
+		__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+		__this_cpu_write(bp_hardening_data.template_start,
+				 hyp_vecs_start);
+	}
 	raw_spin_unlock(&bp_lock);
 }
 #else
-- 
2.30.2

