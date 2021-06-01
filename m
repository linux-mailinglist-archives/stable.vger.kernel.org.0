Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75033396203
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhEaOtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233821AbhEaOrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:47:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA86E60FE8;
        Mon, 31 May 2021 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469381;
        bh=+2DSCjZV3TyGT9kJq28+bHORX3ytUeD85NtTPmhdBK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUFKNSeWxVyZvgQOx2omXZhmowha1sanDG9SY6j5+nrM2lb0uuMekE3nxBeNa1rkz
         11ORWNgyu/H6W7vGbcT40oOFXvlldLrjqWSoQVUM5SQToKEL4WojzU5lV7vur8wMa2
         48TCs7Kf2oNPzXDwtjotVPIJ3DKWAlw7P39oJftk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 131/296] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
Date:   Mon, 31 May 2021 15:13:06 +0200
Message-Id: <20210531130708.302150806@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

commit ef4c9f4f654622fa15b7a94a9bd1f19e76bb7feb upstream.

vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
which causes the upper 32-bits of the max_gfn to get truncated.

Nobody noticed until now likely because vm_get_max_gfn() is only used
as a mechanism to create a memslot in an unused region of the guest
physical address space (the top), and the top of the 32-bit physical
address space was always good enough.

This fix reveals a bug in memslot_modification_stress_test which was
trying to create a dummy memslot past the end of guest physical memory.
Fix that by moving the dummy memslot lower.

Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210521173828.1180619-1-dmatlack@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/include/kvm_util.h                 |    2 -
 tools/testing/selftests/kvm/lib/kvm_util.c                     |    2 -
 tools/testing/selftests/kvm/lib/perf_test_util.c               |    4 +-
 tools/testing/selftests/kvm/memslot_modification_stress_test.c |   18 ++++++----
 4 files changed, 16 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -295,7 +295,7 @@ bool vm_is_unrestricted_guest(struct kvm
 
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
-unsigned int vm_get_max_gfn(struct kvm_vm *vm);
+uint64_t vm_get_max_gfn(struct kvm_vm *vm);
 int vm_get_fd(struct kvm_vm *vm);
 
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1969,7 +1969,7 @@ unsigned int vm_get_page_shift(struct kv
 	return vm->page_shift;
 }
 
-unsigned int vm_get_max_gfn(struct kvm_vm *vm)
+uint64_t vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
 }
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020, Google LLC.
  */
+#include <inttypes.h>
 
 #include "kvm_util.h"
 #include "perf_test_util.h"
@@ -80,7 +81,8 @@ struct kvm_vm *perf_test_create_vm(enum
 	 */
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
-		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
+		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
+		    " vcpus: %d wss: %" PRIx64 "]\n",
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
 		    vcpu_memory_bytes);
 
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -71,14 +71,22 @@ struct memslot_antagonist_args {
 };
 
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
-			      uint64_t nr_modifications, uint64_t gpa)
+			       uint64_t nr_modifications)
 {
+	const uint64_t pages = 1;
+	uint64_t gpa;
 	int i;
 
+	/*
+	 * Add the dummy memslot just below the perf_test_util memslot, which is
+	 * at the top of the guest physical address space.
+	 */
+	gpa = guest_test_phys_mem - pages * vm_get_page_size(vm);
+
 	for (i = 0; i < nr_modifications; i++) {
 		usleep(delay);
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
-					    DUMMY_MEMSLOT_INDEX, 1, 0);
+					    DUMMY_MEMSLOT_INDEX, pages, 0);
 
 		vm_mem_region_delete(vm, DUMMY_MEMSLOT_INDEX);
 	}
@@ -120,11 +128,7 @@ static void run_test(enum vm_guest_mode
 	pr_info("Started all vCPUs\n");
 
 	add_remove_memslot(vm, p->memslot_modification_delay,
-			   p->nr_memslot_modifications,
-			   guest_test_phys_mem +
-			   (guest_percpu_mem_size * nr_vcpus) +
-			   perf_test_args.host_page_size +
-			   perf_test_args.guest_page_size);
+			   p->nr_memslot_modifications);
 
 	run_vcpus = false;
 


