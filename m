Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABCD37CB52
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242600AbhELQfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241663AbhELQ1q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E458561DFD;
        Wed, 12 May 2021 15:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834899;
        bh=rvSq1KI8Red3hqifqCv5ZElWq233O5USHbtZpzz6Fv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghm0CLXjr2/y5Sq97PpNfM15MILatbU/3sGqYwF4cvS389d9aTkJ5p+X/NUXPjKrC
         ax9w9Pd63ek3chrNtW2kueuADu8x1pN1ibm6s6I+JkbU6uUhdwEaxT15T28ykosdI0
         q3XcRVXJWUAdJBmoBpeqnFwQ5Z1aIYli+qRPNYpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>, Peter Xu <peterx@redhat.com>
Subject: [PATCH 5.12 128/677] KVM: selftests: Sync data verify of dirty logging with guest sync
Date:   Wed, 12 May 2021 16:42:54 +0200
Message-Id: <20210512144841.467308466@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 016ff1a442d9a8f36dcb3beca0bcdfc35e281e18 upstream.

This fixes a bug that can trigger with e.g. "taskset -c 0 ./dirty_log_test" or
when the testing host is very busy.

A similar previous attempt is done [1] but that is not enough, the reason is
stated in the reply [2].

As a summary (partly quotting from [2]):

The problem is I think one guest memory write operation (of this specific test)
contains a few micro-steps when page is during kvm dirty tracking (here I'm
only considering write-protect rather than pml but pml should be similar at
least when the log buffer is full):

  (1) Guest read 'iteration' number into register, prepare to write, page fault
  (2) Set dirty bit in either dirty bitmap or dirty ring
  (3) Return to guest, data written

When we verify the data, we assumed that all these steps are "atomic", say,
when (1) happened for this page, we assume (2) & (3) must have happened.  We
had some trick to workaround "un-atomicity" of above three steps, as previous
version of this patch wanted to fix atomicity of step (2)+(3) by explicitly
letting the main thread wait for at least one vmenter of vcpu thread, which
should work.  However what I overlooked is probably that we still have race
when (1) and (2) can be interrupted.

One example calltrace when it could happen that we read an old interation, got
interrupted before even setting the dirty bit and flushing data:

    __schedule+1742
    __cond_resched+52
    __get_user_pages+530
    get_user_pages_unlocked+197
    hva_to_pfn+206
    try_async_pf+132
    direct_page_fault+320
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68

It means iteration number cached in vcpu register can be very old when dirty
bit set and data flushed.

So far I don't see an easy way to guarantee all steps 1-3 atomicity but to sync
at the GUEST_SYNC() point of guest code when we do verification of the dirty
bits as what this patch does.

[1] https://lore.kernel.org/lkml/20210413213641.23742-1-peterx@redhat.com/
[2] https://lore.kernel.org/lkml/20210417140956.GV4440@xz-x1/

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Peter Xu <peterx@redhat.com>
Message-Id: <20210417143602.215059-2-peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c |   60 ++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <asm/barrier.h>
+#include <linux/atomic.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -137,12 +138,20 @@ static uint64_t host_clear_count;
 static uint64_t host_track_next_count;
 
 /* Whether dirty ring reset is requested, or finished */
-static sem_t dirty_ring_vcpu_stop;
-static sem_t dirty_ring_vcpu_cont;
+static sem_t sem_vcpu_stop;
+static sem_t sem_vcpu_cont;
+/*
+ * This is only set by main thread, and only cleared by vcpu thread.  It is
+ * used to request vcpu thread to stop at the next GUEST_SYNC, since GUEST_SYNC
+ * is the only place that we'll guarantee both "dirty bit" and "dirty data"
+ * will match.  E.g., SIG_IPI won't guarantee that if the vcpu is interrupted
+ * after setting dirty bit but before the data is written.
+ */
+static atomic_t vcpu_sync_stop_requested;
 /*
  * This is updated by the vcpu thread to tell the host whether it's a
  * ring-full event.  It should only be read until a sem_wait() of
- * dirty_ring_vcpu_stop and before vcpu continues to run.
+ * sem_vcpu_stop and before vcpu continues to run.
  */
 static bool dirty_ring_vcpu_ring_full;
 /*
@@ -234,6 +243,17 @@ static void clear_log_collect_dirty_page
 	kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
 
+/* Should only be called after a GUEST_SYNC */
+static void vcpu_handle_sync_stop(void)
+{
+	if (atomic_read(&vcpu_sync_stop_requested)) {
+		/* It means main thread is sleeping waiting */
+		atomic_set(&vcpu_sync_stop_requested, false);
+		sem_post(&sem_vcpu_stop);
+		sem_wait_until(&sem_vcpu_cont);
+	}
+}
+
 static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
@@ -244,6 +264,8 @@ static void default_after_vcpu_run(struc
 	TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC,
 		    "Invalid guest sync status: exit_reason=%s\n",
 		    exit_reason_str(run->exit_reason));
+
+	vcpu_handle_sync_stop();
 }
 
 static bool dirty_ring_supported(void)
@@ -301,13 +323,13 @@ static void dirty_ring_wait_vcpu(void)
 {
 	/* This makes sure that hardware PML cache flushed */
 	vcpu_kick();
-	sem_wait_until(&dirty_ring_vcpu_stop);
+	sem_wait_until(&sem_vcpu_stop);
 }
 
 static void dirty_ring_continue_vcpu(void)
 {
 	pr_info("Notifying vcpu to continue\n");
-	sem_post(&dirty_ring_vcpu_cont);
+	sem_post(&sem_vcpu_cont);
 }
 
 static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
@@ -361,11 +383,11 @@ static void dirty_ring_after_vcpu_run(st
 		/* Update the flag first before pause */
 		WRITE_ONCE(dirty_ring_vcpu_ring_full,
 			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
-		sem_post(&dirty_ring_vcpu_stop);
+		sem_post(&sem_vcpu_stop);
 		pr_info("vcpu stops because %s...\n",
 			dirty_ring_vcpu_ring_full ?
 			"dirty ring is full" : "vcpu is kicked out");
-		sem_wait_until(&dirty_ring_vcpu_cont);
+		sem_wait_until(&sem_vcpu_cont);
 		pr_info("vcpu continues now.\n");
 	} else {
 		TEST_ASSERT(false, "Invalid guest sync status: "
@@ -377,7 +399,7 @@ static void dirty_ring_after_vcpu_run(st
 static void dirty_ring_before_vcpu_join(void)
 {
 	/* Kick another round of vcpu just to make sure it will quit */
-	sem_post(&dirty_ring_vcpu_cont);
+	sem_post(&sem_vcpu_cont);
 }
 
 struct log_mode {
@@ -768,7 +790,25 @@ static void run_test(enum vm_guest_mode
 		usleep(p->interval * 1000);
 		log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
 					     bmap, host_num_pages);
+
+		/*
+		 * See vcpu_sync_stop_requested definition for details on why
+		 * we need to stop vcpu when verify data.
+		 */
+		atomic_set(&vcpu_sync_stop_requested, true);
+		sem_wait_until(&sem_vcpu_stop);
+		/*
+		 * NOTE: for dirty ring, it's possible that we didn't stop at
+		 * GUEST_SYNC but instead we stopped because ring is full;
+		 * that's okay too because ring full means we're only missing
+		 * the flush of the last page, and since we handle the last
+		 * page specially verification will succeed anyway.
+		 */
+		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
+		       atomic_read(&vcpu_sync_stop_requested) == false);
 		vm_dirty_log_verify(mode, bmap);
+		sem_post(&sem_vcpu_cont);
+
 		iteration++;
 		sync_global_to_guest(vm, iteration);
 	}
@@ -819,8 +859,8 @@ int main(int argc, char *argv[])
 	};
 	int opt, i;
 
-	sem_init(&dirty_ring_vcpu_stop, 0, 0);
-	sem_init(&dirty_ring_vcpu_cont, 0, 0);
+	sem_init(&sem_vcpu_stop, 0, 0);
+	sem_init(&sem_vcpu_cont, 0, 0);
 
 	guest_modes_append_default();
 


