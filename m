Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F7D6D47D7
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbjDCOXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbjDCOXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AC7FF07
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:23:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BBC5B81BE7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A21FC433D2;
        Mon,  3 Apr 2023 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531818;
        bh=td8LU01P2HkjR5azhAjI921h76KTn+E6GI7tL2RUzYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xP0+sEgMLjjxZLONXtsc/ydcfFff9iQ2iEzjPWrjvUUcG1D9aX6mfks8zL67+2Q4g
         vyUqMt+T0HIK9fOQvMPQdM02ourFvHx5vX7r1/7Db31RvqcgHMTeXMqaZxZkxs8Xyi
         muwz+fAWOot8l79noTA8TjMeiH7TBklop1l/HqtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Venkatesh Srinivas <venkateshs@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/173] KVM: Clean up benign vcpu->cpu data races when kicking vCPUs
Date:   Mon,  3 Apr 2023 16:07:03 +0200
Message-Id: <20230403140414.501130173@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 85b640450ddcfa09cf72771b69a9c3daf0ddc772 ]

Fix a benign data race reported by syzbot+KCSAN[*] by ensuring vcpu->cpu
is read exactly once, and by ensuring the vCPU is booted from guest mode
if kvm_arch_vcpu_should_kick() returns true.  Fix a similar race in
kvm_make_vcpus_request_mask() by ensuring the vCPU is interrupted if
kvm_request_needs_ipi() returns true.

Reading vcpu->cpu before vcpu->mode (via kvm_arch_vcpu_should_kick() or
kvm_request_needs_ipi()) means the target vCPU could get migrated (change
vcpu->cpu) and enter !OUTSIDE_GUEST_MODE between reading vcpu->cpud and
reading vcpu->mode.  If that happens, the kick/IPI will be sent to the
old pCPU, not the new pCPU that is now running the vCPU or reading SPTEs.

Although failing to kick the vCPU is not exactly ideal, practically
speaking it cannot cause a functional issue unless there is also a bug in
the caller, and any such bug would exist regardless of kvm_vcpu_kick()'s
behavior.

The purpose of sending an IPI is purely to get a vCPU into the host (or
out of reading SPTEs) so that the vCPU can recognize a change in state,
e.g. a KVM_REQ_* request.  If vCPU's handling of the state change is
required for correctness, KVM must ensure either the vCPU sees the change
before entering the guest, or that the sender sees the vCPU as running in
guest mode.  All architectures handle this by (a) sending the request
before calling kvm_vcpu_kick() and (b) checking for requests _after_
setting vcpu->mode.

x86's READING_SHADOW_PAGE_TABLES has similar requirements; KVM needs to
ensure it kicks and waits for vCPUs that started reading SPTEs _before_
MMU changes were finalized, but any vCPU that starts reading after MMU
changes were finalized will see the new state and can continue on
uninterrupted.

For uses of kvm_vcpu_kick() that are not paired with a KVM_REQ_*, e.g.
x86's kvm_arch_sync_dirty_log(), the order of the kick must not be relied
upon for functional correctness, e.g. in the dirty log case, userspace
cannot assume it has a 100% complete log if vCPUs are still running.

All that said, eliminate the benign race since the cost of doing so is an
"extra" atomic cmpxchg() in the case where the target vCPU is loaded by
the current pCPU or is not loaded at all.  I.e. the kick will be skipped
due to kvm_vcpu_exiting_guest_mode() seeing a compatible vcpu->mode as
opposed to the kick being skipped because of the cpu checks.

Keep the "cpu != me" checks even though they appear useless/impossible at
first glance.  x86 processes guest IPI writes in a fast path that runs in
IN_GUEST_MODE, i.e. can call kvm_vcpu_kick() from IN_GUEST_MODE.  And
calling kvm_vm_bugged()->kvm_make_vcpus_request_mask() from IN_GUEST or
READING_SHADOW_PAGE_TABLES is perfectly reasonable.

Note, a race with the cpu_online() check in kvm_vcpu_kick() likely
persists, e.g. the vCPU could exit guest mode and get offlined between
the cpu_online() check and the sending of smp_send_reschedule().  But,
the online check appears to exist only to avoid a WARN in x86's
native_smp_send_reschedule() that fires if the target CPU is not online.
The reschedule WARN exists because CPU offlining takes the CPU out of the
scheduling pool, i.e. the WARN is intended to detect the case where the
kernel attempts to schedule a task on an offline CPU.  The actual sending
of the IPI is a non-issue as at worst it will simpy be dropped on the
floor.  In other words, KVM's usurping of the reschedule IPI could
theoretically trigger a WARN if the stars align, but there will be no
loss of functionality.

[*] https://syzkaller.appspot.com/bug?extid=cd4154e502f43f10808a

Cc: Venkatesh Srinivas <venkateshs@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: 97222cc83163 ("KVM: Emulate local APIC in kernel")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210827092516.1027264-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last thing during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 564d5c145fbe7..b5134f3046483 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -276,14 +276,26 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 			continue;
 
 		kvm_make_request(req, vcpu);
-		cpu = vcpu->cpu;
 
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;
 
-		if (tmp != NULL && cpu != -1 && cpu != me &&
-		    kvm_request_needs_ipi(vcpu, req))
-			__cpumask_set_cpu(cpu, tmp);
+		/*
+		 * Note, the vCPU could get migrated to a different pCPU at any
+		 * point after kvm_request_needs_ipi(), which could result in
+		 * sending an IPI to the previous pCPU.  But, that's ok because
+		 * the purpose of the IPI is to ensure the vCPU returns to
+		 * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
+		 * Entering READING_SHADOW_PAGE_TABLES after this point is also
+		 * ok, as the requirement is only that KVM wait for vCPUs that
+		 * were reading SPTEs _before_ any changes were finalized.  See
+		 * kvm_vcpu_kick() for more details on handling requests.
+		 */
+		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
+			cpu = READ_ONCE(vcpu->cpu);
+			if (cpu != -1 && cpu != me)
+				__cpumask_set_cpu(cpu, tmp);
+		}
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -2937,16 +2949,24 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
  */
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	int me;
-	int cpu = vcpu->cpu;
+	int me, cpu;
 
 	if (kvm_vcpu_wake_up(vcpu))
 		return;
 
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_arch_vcpu_should_kick(), which could result in sending an
+	 * IPI to the previous pCPU.  But, that's ok because the purpose of the
+	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
+	 * vCPU also requires it to leave IN_GUEST_MODE.
+	 */
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-		if (kvm_arch_vcpu_should_kick(vcpu))
+	if (kvm_arch_vcpu_should_kick(vcpu)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
+	}
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
-- 
2.39.2



