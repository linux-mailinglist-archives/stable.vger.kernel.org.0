Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469126BB14B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjCOM0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjCOMZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EE196F1D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FB80B81E04
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE6EC433EF;
        Wed, 15 Mar 2023 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883101;
        bh=6DK8N1L+z6Zwo5eMi3dwocYX3a94r2RlS/jAB+/0AB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNunF94DBBC4ERa/2yUWh700YktC4XFrL/LtWm8ViTOZLy+UNC63VNroZ9XS3ZQOO
         OSXRK6BlNzGtI0oaY9v2xQEIyuWyD10wRIzoA8T6Mzbw6A4WPRFUMPQ2lmgX5V7Q+Y
         hoJxBOLE4G3DECJUpO7+us3+UV4h/i1ecyJKIsXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/145] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Date:   Wed, 15 Mar 2023 13:11:22 +0100
Message-Id: <20230315115739.530173118@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit ae0946cd3601752dc58f86d84258e5361e9c8cd4 ]

Iterating over set bits in 'vcpu_bitmap' should be faster than going
through all vCPUs, especially when just a few bits are set.

Drop kvm_make_vcpus_request_mask() call from kvm_make_all_cpus_request_except()
to avoid handling the special case when 'vcpu_bitmap' is NULL, move the
code to kvm_make_all_cpus_request_except() itself.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20210903075141.403071-5-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last thing during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 88 +++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3ffed093d3ea2..d08dbf0be2fce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -257,50 +257,57 @@ static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 	return true;
 }
 
+static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  unsigned int req, cpumask_var_t tmp,
+				  int current_cpu)
+{
+	int cpu;
+
+	kvm_make_request(req, vcpu);
+
+	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+		return;
+
+	/*
+	 * tmp can be "unavailable" if cpumasks are allocated off stack as
+	 * allocation of the mask is deliberately not fatal and is handled by
+	 * falling back to kicking all online CPUs.
+	 */
+	if (!cpumask_available(tmp))
+		return;
+
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_request_needs_ipi(), which could result in sending an IPI
+	 * to the previous pCPU.  But, that's OK because the purpose of the IPI
+	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
+	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
+	 * after this point is also OK, as the requirement is only that KVM wait
+	 * for vCPUs that were reading SPTEs _before_ any changes were
+	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
+	 */
+	if (kvm_request_needs_ipi(vcpu, req)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != -1 && cpu != current_cpu)
+			__cpumask_set_cpu(cpu, tmp);
+	}
+}
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
-	int i, cpu, me;
 	struct kvm_vcpu *vcpu;
+	int i, me;
 	bool called;
 
 	me = get_cpu();
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
-		    vcpu == except)
+	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (!vcpu || vcpu == except)
 			continue;
-
-		kvm_make_request(req, vcpu);
-
-		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
-			continue;
-
-		/*
-		 * tmp can be "unavailable" if cpumasks are allocated off stack
-		 * as allocation of the mask is deliberately not fatal and is
-		 * handled by falling back to kicking all online CPUs.
-		 */
-		if (!cpumask_available(tmp))
-			continue;
-
-		/*
-		 * Note, the vCPU could get migrated to a different pCPU at any
-		 * point after kvm_request_needs_ipi(), which could result in
-		 * sending an IPI to the previous pCPU.  But, that's ok because
-		 * the purpose of the IPI is to ensure the vCPU returns to
-		 * OUTSIDE_GUEST_MODE, which is satisfied if the vCPU migrates.
-		 * Entering READING_SHADOW_PAGE_TABLES after this point is also
-		 * ok, as the requirement is only that KVM wait for vCPUs that
-		 * were reading SPTEs _before_ any changes were finalized.  See
-		 * kvm_vcpu_kick() for more details on handling requests.
-		 */
-		if (kvm_request_needs_ipi(vcpu, req)) {
-			cpu = READ_ONCE(vcpu->cpu);
-			if (cpu != -1 && cpu != me)
-				__cpumask_set_cpu(cpu, tmp);
-		}
+		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -312,12 +319,23 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
+	struct kvm_vcpu *vcpu;
 	cpumask_var_t cpus;
 	bool called;
+	int i, me;
 
 	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
 
-	called = kvm_make_vcpus_request_mask(kvm, req, except, NULL, cpus);
+	me = get_cpu();
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu == except)
+			continue;
+		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+	}
+
+	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	put_cpu();
 
 	free_cpumask_var(cpus);
 	return called;
-- 
2.39.2



