Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B17A4D4BD4
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbiCJOee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344049AbiCJObj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD3CEC5F1;
        Thu, 10 Mar 2022 06:29:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B8EEB82544;
        Thu, 10 Mar 2022 14:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D53CC340E8;
        Thu, 10 Mar 2022 14:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922580;
        bh=Ebe6j7mF1Vi1ha8wvA/CYSV2TTwbIeu1/dDrKYmnmo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a4EhFlpvqK31OsHjrQpH6VEOPKGYlfwCFybpTOIWkyI7sFBRNbMK0vBB0e7N92Jit
         Vf8olXzcoypHNWyQS+t6k76RxCHM2wM2WYhliZR87MtomEd6/RUVq+JH4pOUtmbJ8A
         J2wbSbkTYU752egWzvLSLkAqMQ9TjTBj2txWXwVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 24/58] KVM: arm64: Allow indirect vectors to be used without SPECTRE_V3A
Date:   Thu, 10 Mar 2022 15:19:13 +0100
Message-Id: <20220310140813.679124853@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
References: <20220310140812.983088611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 5bdf3437603d4af87f9c7f424b0c8aeed2420745 upstream.

CPUs vulnerable to Spectre-BHB either need to make an SMC-CC firmware
call from the vectors, or run a sequence of branches. This gets added
to the hyp vectors. If there is no support for arch-workaround-1 in
firmware, the indirect vector will be used.

kvm_init_vector_slots() only initialises the two indirect slots if
the platform is vulnerable to Spectre-v3a. pKVM's hyp_map_vectors()
only initialises __hyp_bp_vect_base if the platform is vulnerable to
Spectre-v3a.

As there are about to more users of the indirect vectors, ensure
their entries in hyp_spectre_vector_selector[] are always initialised,
and __hyp_bp_vect_base defaults to the regular VA mapping.

The Spectre-v3a check is moved to a helper
kvm_system_needs_idmapped_vectors(), and merged with the code
that creates the hyp mappings.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    5 +++++
 arch/arm64/kvm/arm.c              |    5 +----
 arch/arm64/kvm/hyp/nvhe/mm.c      |    4 +++-
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -711,6 +711,11 @@ static inline void kvm_init_host_cpu_con
 	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
 }
 
+static inline bool kvm_system_needs_idmapped_vectors(void)
+{
+	return cpus_have_const_cap(ARM64_SPECTRE_V3A);
+}
+
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1458,10 +1458,7 @@ static int kvm_init_vector_slots(void)
 	base = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 	kvm_init_vector_slot(base, HYP_VECTOR_SPECTRE_DIRECT);
 
-	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A))
-		return 0;
-
-	if (!has_vhe()) {
+	if (kvm_system_needs_idmapped_vectors() && !has_vhe()) {
 		err = create_hyp_exec_mappings(__pa_symbol(__bp_harden_hyp_vecs),
 					       __BP_HARDEN_HYP_VECS_SZ, &base);
 		if (err)
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -146,8 +146,10 @@ int hyp_map_vectors(void)
 	phys_addr_t phys;
 	void *bp_base;
 
-	if (!cpus_have_const_cap(ARM64_SPECTRE_V3A))
+	if (!kvm_system_needs_idmapped_vectors()) {
+		__hyp_bp_vect_base = __bp_harden_hyp_vecs;
 		return 0;
+	}
 
 	phys = __hyp_pa(__bp_harden_hyp_vecs);
 	bp_base = (void *)__pkvm_create_private_mapping(phys,


