Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCCC42AECE
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 23:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhJLV0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 17:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbhJLV0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 17:26:09 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A59FC061570
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 14:24:07 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t4-20020a62ea04000000b0044b333f5d1bso295607pfh.20
        for <stable@vger.kernel.org>; Tue, 12 Oct 2021 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Fk9Xc4yx4FRlEZPM/PxyifjRQnzIl7D2v+UAZuEFymU=;
        b=ovnmzoXtj8x1i1N6aZPMYIJZELeMQteZJSdDAGmHK8ZPk4g7b05jLa5tBwSIx18WuZ
         zglO/Dz81lWJ96COiEvtD5+NZn3fdrAsVU7TxKUemIgm3SwKEKUyorHGP9Hi5UMmWSXM
         lBpT944rENO6kBF3LtXfLTZ+BZ/+eFKyeAfx62UJ1fYSCgl7VmSY5JQgbPGuA9FoGLqS
         yaYRNl83UNtnVnp4j/V9TLfRTtee+gF+N6Mb+kX9Rz+nPJEUiGmXQ/YfIJM/vz9gCVi0
         KabBrdesb9BolJmfBg7kG29UDQ4q9dVxPBRWU0oFHUVItlje5oWEyIgBa3h5CV3iSQAD
         /8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Fk9Xc4yx4FRlEZPM/PxyifjRQnzIl7D2v+UAZuEFymU=;
        b=xvEJLMkDuKGHjrZdRDd3r6BzoxdNjFjc3DAOLLjTLKmdfT17ktQsDVRHAml2Ff+iG/
         Hdmsf0MN9wwN56dFJY+ZK2M7miaN/g9WlFynoVQqOoG0PzymISavBqdYAU3jsFJj43mR
         Y1mTVJrwmfSi/V2LmmjNxDQXvktdHRtFsEkugdXUztoEkdAt1C6npqbVSOpCJFkmmqup
         hsj8YACMhLMxmgOKeR7HC9md/q0ieYFV9yc9YCsrWBHniXoRwwE/v7iomFZ77AnoHo2c
         E0PrjQ3zhDPh4Ro9ZY+TM/lQO7chppOPyxQQS7Mk/EosCOKFj1FoN6Vmyn122bWKTW3L
         L2fA==
X-Gm-Message-State: AOAM533gcS0sphsmgbsRak7jVhU1CkLx3h/SArwgzCzqKE56GIgKorc6
        8/ngkVRkDFz8OR11/mxNekM7VUqMeJ8=
X-Google-Smtp-Source: ABdhPJzUNd6X3fnJWFIj5LQq1wrKz7v+Lf0DkrpQJ5NNth+0+4D6rrh+G2utbI850CfwvWb4yY4GMuqYDAk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:bab5:e2c:2623:d2f8])
 (user=pgonda job=sendgmr) by 2002:aa7:92d0:0:b0:44c:ab24:cce7 with SMTP id
 k16-20020aa792d0000000b0044cab24cce7mr33818605pfa.6.1634073846954; Tue, 12
 Oct 2021 14:24:06 -0700 (PDT)
Date:   Tue, 12 Oct 2021 14:24:03 -0700
Message-Id: <20211012212403.3863482-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH V3] KVM: SEV: Acquire vcpu mutex when updating VMSA
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
V3
 *  Fixes bug with missing 'guest_state_protected = true' after
    refactor.

V2
 * Refactor per vcpu work to separate function.
 * Remove check to skip already initialized VMSAs.
 * Removed vmsa struct zeroing.

---
 arch/x86/kvm/svm/sev.c | 56 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..f192a6897c68 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -595,43 +595,55 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
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
+	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+	if (ret)
+	  return ret;
+
+	vcpu->arch.guest_state_protected = true;
+	return 0;
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
+		ret = __sev_launch_update_vmsa(kvm, vcpu, &argp->error);
 
-		vmsa.handle = sev->handle;
-		vmsa.address = __sme_pa(svm->vmsa);
-		vmsa.len = PAGE_SIZE;
-		ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa,
-				    &argp->error);
+		mutex_unlock(&vcpu->mutex);
 		if (ret)
 			return ret;
-
-		svm->vcpu.arch.guest_state_protected = true;
 	}
 
 	return 0;
-- 
2.33.0.882.g93a45727a2-goog

