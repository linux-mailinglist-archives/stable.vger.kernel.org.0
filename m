Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403D2420F51
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhJDNdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237185AbhJDNbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CB2F61BA2;
        Mon,  4 Oct 2021 13:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353261;
        bh=fgpLNK0QJX5G7bMV1QQIBI+1zCB4DxuGWwDN6fjnozQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUXqn+ZlYge3ioQAKKhiUpZof36dvazghLsJXbVaN0r3cG6PxPRrhedUdvVvZNEnw
         1NvVTn5R+bOEUQtjiWFBLhXhEt/QVtYhOSrbQD7hT1RWMjiwLbGQg2cPO/TzqjNxPU
         eQhZm+mLitUaFcDPZXIFMktrlFvANMOCyfselwPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org
Subject: [PATCH 5.14 057/172] KVM: SEV: Acquire vcpu mutex when updating VMSA
Date:   Mon,  4 Oct 2021 14:51:47 +0200
Message-Id: <20211004125046.837857428@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

commit bb18a677746543e7f5eeb478129c92cedb0f9658 upstream.

The update-VMSA ioctl touches data stored in struct kvm_vcpu, and
therefore should not be performed concurrently with any VCPU ioctl
that might cause KVM or the processor to use the same data.

Adds vcpu mutex guard to the VMSA updating code. Refactors out
__sev_launch_update_vmsa() function to deal with per vCPU parts
of sev_launch_update_vmsa().

Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-Id: <20210915171755.3773766-1-pgonda@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   53 +++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -596,43 +596,50 @@ static int sev_es_sync_vmsa(struct vcpu_
 	return 0;
 }
 
-static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				    int *error)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa vmsa;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int ret;
+
+	/* Perform some pre-encryption checks against the VMSA */
+	ret = sev_es_sync_vmsa(svm);
+	if (ret)
+		return ret;
+
+	/*
+	 * The LAUNCH_UPDATE_VMSA command will perform in-place encryption of
+	 * the VMSA memory content (i.e it will write the same memory region
+	 * with the guest's key), so invalidate it first.
+	 */
+	clflush_cache_range(svm->vmsa, PAGE_SIZE);
+
+	vmsa.reserved = 0;
+	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
+	vmsa.address = __sme_pa(svm->vmsa);
+	vmsa.len = PAGE_SIZE;
+	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+}
+
+static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
 	struct kvm_vcpu *vcpu;
 	int i, ret;
 
 	if (!sev_es_guest(kvm))
 		return -ENOTTY;
 
-	vmsa.reserved = 0;
-
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct vcpu_svm *svm = to_svm(vcpu);
-
-		/* Perform some pre-encryption checks against the VMSA */
-		ret = sev_es_sync_vmsa(svm);
+		ret = mutex_lock_killable(&vcpu->mutex);
 		if (ret)
 			return ret;
 
-		/*
-		 * The LAUNCH_UPDATE_VMSA command will perform in-place
-		 * encryption of the VMSA memory content (i.e it will write
-		 * the same memory region with the guest's key), so invalidate
-		 * it first.
-		 */
-		clflush_cache_range(svm->vmsa, PAGE_SIZE);
-
-		vmsa.handle = sev->handle;
-		vmsa.address = __sme_pa(svm->vmsa);
-		vmsa.len = PAGE_SIZE;
-		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
-				    &argp->error);
+		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
+
+		mutex_unlock(&vcpu->mutex);
 		if (ret)
 			return ret;
-
-		svm->vcpu.arch.guest_state_protected = true;
 	}
 
 	return 0;


