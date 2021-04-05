Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712A0354007
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhDEJPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240228AbhDEJOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C18EC611C1;
        Mon,  5 Apr 2021 09:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614089;
        bh=w5CaiRoGCXBxZeoCpWds1a2t4ujFb1T4GqnoBxxhFWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0nH8KBVAiDgdCIN8+XVhMtxb/36Tw2S0Jr6V8J7F4GBrChvUomu5IHYsVGTZ51tE
         zzPnC02Yx1BMT5Zj1azsdF+1cWLirDKZkEfYDkNq3Xr5jhltWDkpQ8sZU+I4uYz9Sx
         xxzpAGxcg+rjwirNZJ8KdrTkwLuQ1qI4GkWZBlnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 080/152] KVM: SVM: ensure that EFER.SVME is set when running nested guest or on nested vmexit
Date:   Mon,  5 Apr 2021 10:53:49 +0200
Message-Id: <20210405085036.856782354@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3c346c0c60ab06a021d1c0884a0ef494bc4ee3a7 upstream.

Fixing nested_vmcb_check_save to avoid all TOC/TOU races
is a bit harder in released kernels, so do the bare minimum
by avoiding that EFER.SVME is cleared.  This is problematic
because svm_set_efer frees the data structures for nested
virtualization if EFER.SVME is cleared.

Also check that EFER.SVME remains set after a nested vmexit;
clearing it could happen if the bit is zero in the save area
that is passed to KVM_SET_NESTED_STATE (the save area of the
nested state corresponds to the nested hypervisor's state
and is restored on the next nested vmexit).

Cc: stable@vger.kernel.org
Fixes: 2fcf4876ada ("KVM: nSVM: implement on demand allocation of the nested state")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -251,6 +251,13 @@ static bool nested_vmcb_check_save(struc
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool vmcb12_lma;
 
+	/*
+	 * FIXME: these should be done after copying the fields,
+	 * to avoid TOC/TOU races.  For these save area checks
+	 * the possible damage is limited since kvm_set_cr0 and
+	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
+	 * so it is force-set later in nested_prepare_vmcb_save.
+	 */
 	if ((vmcb12->save.efer & EFER_SVME) == 0)
 		return false;
 
@@ -396,7 +403,14 @@ static void nested_prepare_vmcb_save(str
 	svm->vmcb->save.gdtr = vmcb12->save.gdtr;
 	svm->vmcb->save.idtr = vmcb12->save.idtr;
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
+
+	/*
+	 * Force-set EFER_SVME even though it is checked earlier on the
+	 * VMCB12, because the guest can flip the bit between the check
+	 * and now.  Clearing EFER_SVME would call svm_free_nested.
+	 */
+	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+
 	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
 	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;
@@ -1209,6 +1223,8 @@ static int svm_set_nested_state(struct k
 	 */
 	if (!(save->cr0 & X86_CR0_PG))
 		goto out_free;
+	if (!(save->efer & EFER_SVME))
+		goto out_free;
 
 	/*
 	 * All checks done, we can enter guest mode.  L1 control fields


