Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195EA3C4D63
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241820AbhGLHM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244264AbhGLHKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAA99610E6;
        Mon, 12 Jul 2021 07:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073662;
        bh=AzMPsqT9r/REwDJokux7T6+lZ1DOZvDeChBWVHFA898=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIqx2JGCBf24ICY6TTKb0qUFiqY/YVjguq5nQ6m+XTubP0VYlwqL+UGeXTcxSZTjR
         ntpU2SkCZlaqlO5WV8prZuQOPHzJbQrrOCoWG5BSdTAGc9VFRV3ERGigreE+2oQFV2
         h72LQUvJ5n3JJFJWxDzFX/7kYLS67uNUt1/z0aiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 318/700] KVM: selftests: fix triple fault if ept=0 in dirty_log_test
Date:   Mon, 12 Jul 2021 08:06:41 +0200
Message-Id: <20210712061010.204316686@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

[ Upstream commit e5830fb13b8cad5e3bdf84f0f7a3dcb4f4d9bcbb ]

Commit 22f232d134e1 ("KVM: selftests: x86: Set supported CPUIDs on
default VM") moved vcpu_set_cpuid into vm_create_with_vcpus, but
dirty_log_test doesn't use it to create vm. So vcpu's CPUIDs is
not set, the guest's pa_bits in kvm would be smaller than the
value queried by userspace.

However, the dirty track memory slot is in the highest GPA, the
reserved bits in gpte would be set with wrong pa_bits.
For shadow paging, page fault would fail in permission_fault and
be injected into guest. Since guest doesn't have idt, it finally
leads to vm_exit for triple fault.

Move vcpu_set_cpuid into vm_vcpu_add_default to set supported
CPUIDs on default vcpu, since almost all tests need it.

Fixes: 22f232d134e1 ("KVM: selftests: x86: Set supported CPUIDs on default VM")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Message-Id: <411ea2173f89abce56fc1fca5af913ed9c5a89c9.1624351343.git.houwenlong93@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/kvm_util.c           | 4 ----
 tools/testing/selftests/kvm/lib/x86_64/processor.c   | 3 +++
 tools/testing/selftests/kvm/steal_time.c             | 2 --
 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 2 --
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8b90256bca96..03e13938fd07 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -310,10 +310,6 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
 
 		vm_vcpu_add_default(vm, vcpuid, guest_code);
-
-#ifdef __x86_64__
-		vcpu_set_cpuid(vm, vcpuid, kvm_get_supported_cpuid());
-#endif
 	}
 
 	return vm;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..09cc685599a2 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -600,6 +600,9 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	/* Setup the MP state */
 	mp_state.mp_state = 0;
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+
+	/* Setup supported CPUIDs */
+	vcpu_set_cpuid(vm, vcpuid, kvm_get_supported_cpuid());
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index fcc840088c91..a6fe75cb9a6e 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -73,8 +73,6 @@ static void steal_time_init(struct kvm_vm *vm)
 	for (i = 0; i < NR_VCPUS; ++i) {
 		int ret;
 
-		vcpu_set_cpuid(vm, i, kvm_get_supported_cpuid());
-
 		/* ST_GPA_BASE is identity mapped */
 		st_gva[i] = (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
 		sync_global_to_guest(vm, st_gva[i]);
diff --git a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
index 12c558fc8074..c8d2bbe202d0 100644
--- a/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
+++ b/tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c
@@ -106,8 +106,6 @@ static void add_x86_vcpu(struct kvm_vm *vm, uint32_t vcpuid, bool bsp_code)
 		vm_vcpu_add_default(vm, vcpuid, guest_bsp_vcpu);
 	else
 		vm_vcpu_add_default(vm, vcpuid, guest_not_bsp_vcpu);
-
-	vcpu_set_cpuid(vm, vcpuid, kvm_get_supported_cpuid());
 }
 
 static void run_vm_bsp(uint32_t bsp_vcpu)
-- 
2.30.2



