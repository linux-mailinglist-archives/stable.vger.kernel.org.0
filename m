Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F9F4F28FB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiDEIYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbiDEISX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB495B716B;
        Tue,  5 Apr 2022 01:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3B9EB81B92;
        Tue,  5 Apr 2022 08:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF44C385A2;
        Tue,  5 Apr 2022 08:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146052;
        bh=EQrAZY2q0M74KnJ/fSrBJGErpAIvZF2o0xg69/q+tDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ipRBT5iTZTnP9ieHnU24R8tyJyP393qHoX9+rizer0eujCt686jJz4iABhB1Objq
         T2HEDzVroiB2qiie76W+E394ATc3YJefbP0aZ9+59pGP1ywENMnGw1JBvjTyK69F//
         J58FiYBd3ycIvghPZT+ngGwuPmk/lxDlfc1FWYic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0624/1126] KVM: SVM: Exit to userspace on ENOMEM/EFAULT GHCB errors
Date:   Tue,  5 Apr 2022 09:22:51 +0200
Message-Id: <20220405070425.952387054@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit aa9f58415a8e45598bf44befa90b9d5babe09601 ]

Exit to userspace if setup_vmgexit_scratch() fails due to OOM or because
copying data from guest (userspace) memory failed/faulted.  The OOM
scenario is clearcut, it's userspace's decision as to whether it should
terminate the guest, free memory, etc...

As for -EFAULT, arguably, any guest issue is a violation of the guest's
contract with userspace, and thus userspace needs to decide how to
proceed.  E.g. userspace defines what is RAM vs. MMIO and communicates
that directly to the guest, KVM is not involved in deciding what is/isn't
RAM nor in communicating that information to the guest.  If the scratch
GPA doesn't resolve to a memslot, then the guest is not honoring the
memory configuration as defined by userspace.

And if userspace unmaps an hva for whatever reason, then exiting to
userspace with -EFAULT is absolutely the right thing to do.  KVM's ABI
currently sucks and doesn't provide enough information to act on the
-EFAULT, but that will hopefully be remedied in the future as there are
multiple use cases, e.g. uffd and virtiofs truncation, that shouldn't
require any work in KVM beyond returning -EFAULT with a small amount of
metadata.

KVM could define its ABI such that failure to access the scratch area is
reflected into the guest, i.e. establish a contract with userspace, but
that's undesirable as it limits KVM's options in the future, e.g. in the
potential uffd case any failure on a uaccess needs to kick out to
userspace.  KVM does have several cases where it reflects these errors
into the guest, e.g. kvm_pv_clock_pairing() and Hyper-V emulation, but
KVM would preferably "fix" those instead of propagating the falsehood
that any memory failure is the guest's fault.

Lastly, returning a boolean as an "error" for that a helper that isn't
named accordingly never works out well.

Fixes: ad5b353240c8 ("KVM: SVM: Do not terminate SEV-ES guests on GHCB validation failure")
Cc: Alper Gun <alpergun@google.com>
Cc: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220225205209.3881130-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 17b53457d866..fef975852582 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2358,7 +2358,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu;
 	struct ghcb *ghcb;
@@ -2463,7 +2463,7 @@ static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
-	return true;
+	return 0;
 
 vmgexit_err:
 	vcpu = &svm->vcpu;
@@ -2486,7 +2486,8 @@ static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, reason);
 
-	return false;
+	/* Resume the guest to "return" the error code. */
+	return 1;
 }
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
@@ -2545,7 +2546,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct ghcb *ghcb = svm->sev_es.ghcb;
@@ -2598,14 +2599,14 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		}
 		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
-			goto e_scratch;
+			return -ENOMEM;
 
 		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
 			kvfree(scratch_va);
-			goto e_scratch;
+			return -EFAULT;
 		}
 
 		/*
@@ -2621,13 +2622,13 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	svm->sev_es.ghcb_sa = scratch_va;
 	svm->sev_es.ghcb_sa_len = len;
 
-	return true;
+	return 0;
 
 e_scratch:
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
 
-	return false;
+	return 1;
 }
 
 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
@@ -2765,17 +2766,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
-	if (!sev_es_validate_vmgexit(svm))
-		return 1;
+	ret = sev_es_validate_vmgexit(svm);
+	if (ret)
+		return ret;
 
 	sev_es_sync_from_ghcb(svm);
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
-	ret = 1;
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
-		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_read(vcpu,
@@ -2784,7 +2786,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					   svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
-		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_write(vcpu,
@@ -2817,6 +2820,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
+		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -2836,6 +2840,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
 	int count;
 	int bytes;
+	int r;
 
 	if (svm->vmcb->control.exit_info_2 > INT_MAX)
 		return -EINVAL;
@@ -2844,8 +2849,9 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
-	if (!setup_vmgexit_scratch(svm, in, bytes))
-		return 1;
+	r = setup_vmgexit_scratch(svm, in, bytes);
+	if (r)
+		return r;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->sev_es.ghcb_sa,
 				    count, in);
-- 
2.34.1



