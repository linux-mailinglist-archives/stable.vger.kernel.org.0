Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CB594B69
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbiHPARf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350194AbiHPAOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A04FCD782;
        Mon, 15 Aug 2022 13:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBF5611CA;
        Mon, 15 Aug 2022 20:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0528C43143;
        Mon, 15 Aug 2022 20:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595436;
        bh=dU3Yp/V+6qpGDMr3f9HjjrsK2rxqAXzqXy9P4nzRVnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVesqC1SyUgOS/4/Cdeun9qXmzEvIb4YM8Evmjw6Ol+zPaPDZ0Pa51VNrUDVWP+/1
         1iedxom5eWY7bYUXGPH/zqKSQrE16sBajNOdgziQoGRwfpC3Fj8YDiBAsGO3kX70GY
         EHCbd6WcbZ/8U3FuI0S+AJx8AbuqMm5pR+4qKVI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0731/1157] KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test
Date:   Mon, 15 Aug 2022 20:01:27 +0200
Message-Id: <20220815180508.703859658@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3468fd7d883110e481dfb8c8c7b802dc252ab186 ]

Use vm_create_with_vcpus() in max_guest_memory_test and reference vCPUs
by their 'struct kvm_vcpu' object instead of their ID.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/kvm/max_guest_memory_test.c     | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 15f046e19cb2..d59918d5cbe2 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -28,8 +28,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 }
 
 struct vcpu_info {
-	struct kvm_vm *vm;
-	uint32_t id;
+	struct kvm_vcpu *vcpu;
 	uint64_t start_gpa;
 	uint64_t end_gpa;
 };
@@ -60,12 +59,13 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpu_id)
 
 static void *vcpu_worker(void *data)
 {
-	struct vcpu_info *vcpu = data;
+	struct vcpu_info *info = data;
+	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
 	struct kvm_sregs sregs;
 	struct kvm_regs regs;
 
-	vcpu_args_set(vm, vcpu->id, 3, vcpu->start_gpa, vcpu->end_gpa,
+	vcpu_args_set(vm, vcpu->id, 3, info->start_gpa, info->end_gpa,
 		      vm_get_page_size(vm));
 
 	/* Snapshot regs before the first run. */
@@ -89,8 +89,8 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
 
-static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
-				uint64_t end_gpa)
+static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
+				uint64_t start_gpa, uint64_t end_gpa)
 {
 	struct vcpu_info *info;
 	uint64_t gpa, nr_bytes;
@@ -108,8 +108,7 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, uint64_t start_gpa,
 	TEST_ASSERT(nr_bytes, "C'mon, no way you have %d CPUs", nr_vcpus);
 
 	for (i = 0, gpa = start_gpa; i < nr_vcpus; i++, gpa += nr_bytes) {
-		info[i].vm = vm;
-		info[i].id = i;
+		info[i].vcpu = vcpus[i];
 		info[i].start_gpa = gpa;
 		info[i].end_gpa = gpa + nr_bytes;
 		pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
@@ -172,6 +171,7 @@ int main(int argc, char *argv[])
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
+	struct kvm_vcpu **vcpus;
 	pthread_t *threads;
 	struct kvm_vm *vm;
 	void *mem;
@@ -215,7 +215,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
+	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
+	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
+
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
 
 	max_gpa = vm_get_max_gfn(vm) << vm_get_page_shift(vm);
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
@@ -252,7 +255,10 @@ int main(int argc, char *argv[])
 	}
 
 	atomic_set(&rendezvous, nr_vcpus + 1);
-	threads = spawn_workers(vm, start_gpa, gpa);
+	threads = spawn_workers(vm, vcpus, start_gpa, gpa);
+
+	free(vcpus);
+	vcpus = NULL;
 
 	pr_info("Running with %lugb of guest memory and %u vCPUs\n",
 		(gpa - start_gpa) / size_1gb, nr_vcpus);
-- 
2.35.1



