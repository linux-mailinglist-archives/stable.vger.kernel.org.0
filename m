Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F94924FC93
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHXLa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 07:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgHXLan (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 07:30:43 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F022087D;
        Mon, 24 Aug 2020 11:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598268642;
        bh=8Yfq5qTV6c1/WBV0unXr4bFQfGW0fL0bt3AzhOicE7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=In0oELhSw0ijotQ85+aFN80YmkG2o6ZaZYk6l6Gd1C60Cg49K9QhOdunubinZxmG6
         1oSWKMwgoqQvb4n8Sh8lUPNV48DXxOKXaUbYKDSB/4RAP9o92UdBWcsfziORHf0cuD
         8CFFKacNlS0g0Q7qs38+N2D5V4D9DDT1BL3bJ2zc=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, maz@kernel.org,
        suzuki.poulose@arm.com, james.morse@arm.com, pbonzini@redhat.com,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH stable-5.7.y backport 2/2] KVM: arm64: Only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is not set
Date:   Mon, 24 Aug 2020 12:30:36 +0100
Message-Id: <20200824113036.24910-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824113036.24910-1-will@kernel.org>
References: <20200824113036.24910-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b5331379bc62611d1026173a09c73573384201d9 upstream.

When an MMU notifier call results in unmapping a range that spans multiple
PGDs, we end up calling into cond_resched_lock() when crossing a PGD boundary,
since this avoids running into RCU stalls during VM teardown. Unfortunately,
if the VM is destroyed as a result of OOM, then blocking is not permitted
and the call to the scheduler triggers the following BUG():

 | BUG: sleeping function called from invalid context at arch/arm64/kvm/mmu.c:394
 | in_atomic(): 1, irqs_disabled(): 0, non_block: 1, pid: 36, name: oom_reaper
 | INFO: lockdep is turned off.
 | CPU: 3 PID: 36 Comm: oom_reaper Not tainted 5.8.0 #1
 | Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
 | Call trace:
 |  dump_backtrace+0x0/0x284
 |  show_stack+0x1c/0x28
 |  dump_stack+0xf0/0x1a4
 |  ___might_sleep+0x2bc/0x2cc
 |  unmap_stage2_range+0x160/0x1ac
 |  kvm_unmap_hva_range+0x1a0/0x1c8
 |  kvm_mmu_notifier_invalidate_range_start+0x8c/0xf8
 |  __mmu_notifier_invalidate_range_start+0x218/0x31c
 |  mmu_notifier_invalidate_range_start_nonblock+0x78/0xb0
 |  __oom_reap_task_mm+0x128/0x268
 |  oom_reap_task+0xac/0x298
 |  oom_reaper+0x178/0x17c
 |  kthread+0x1e4/0x1fc
 |  ret_from_fork+0x10/0x30

Use the new 'flags' argument to kvm_unmap_hva_range() to ensure that we
only reschedule if MMU_NOTIFIER_RANGE_BLOCKABLE is set in the notifier
flags.

Cc: <stable@vger.kernel.org> # v5.7 only
Fixes: 8b3405e345b5 ("kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd")
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20200811102725.7121-3-will@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 virt/kvm/arm/mmu.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 9510965789e3..b005685a6de4 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -331,7 +331,8 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
  * destroying the VM), otherwise another faulting VCPU may come in and mess
  * with things behind our backs.
  */
-static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+static void __unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size,
+				 bool may_block)
 {
 	pgd_t *pgd;
 	phys_addr_t addr = start, end = start + size;
@@ -356,11 +357,16 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 		 * If the range is too large, release the kvm->mmu_lock
 		 * to prevent starvation and lockup detector warnings.
 		 */
-		if (next != end)
+		if (may_block && next != end)
 			cond_resched_lock(&kvm->mmu_lock);
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
+{
+	__unmap_stage2_range(kvm, start, size, true);
+}
+
 static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 			      phys_addr_t addr, phys_addr_t end)
 {
@@ -2041,7 +2047,10 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 
 static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(kvm, gpa, size);
+	unsigned flags = *(unsigned *)data;
+	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
+
+	__unmap_stage2_range(kvm, gpa, size, may_block);
 	return 0;
 }
 
@@ -2052,7 +2061,7 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 		return 0;
 
 	trace_kvm_unmap_hva_range(start, end);
-	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
+	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
 	return 0;
 }
 
-- 
2.28.0.297.g1956fa8f8d-goog

