Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356AC40CB82
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 19:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhIORTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIORTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 13:19:18 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A46C061575
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 10:17:59 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z7-20020a63c047000000b0026b13e40309so2252959pgi.19
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 10:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=r8HJUwu+ryJ7nGO/o5ObN7ZG57DnEl80AhMlVx8YKrw=;
        b=OhxQgrQGX2IxTWw2nx1ea95CmDC6zFPVX/tes5tJfOxJtHTnlR+hdx6SzCTGntvE7A
         kJbhe9eTq+55s2OK0ma7fUwJh0H+JMVSW9KA97xm10Uq26ObdWpa2Ie0ixVOeWL4ZTXf
         K9chFqEW6J2dXjyvTRfqMHlo7YBV/0yNOcJ9fl1qfX/wiq+Q8eMXTxzRoAT8Wmclj5Rw
         E79jdHo2FHBuYVQGLdlEQSpxOcSCOiBMw3ZXtCqbEbkO32y6PkpJbZDxcFi1zxFX00cl
         0soJCge27mVw0cUF3m6JuSvtfc1VuRC2HLIXMhgCjtGbSeBmvxURdOw3CwW6HCAEEksO
         Nwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=r8HJUwu+ryJ7nGO/o5ObN7ZG57DnEl80AhMlVx8YKrw=;
        b=rH1nbsLKG44++bBpAQegyVnXBAMBF6RfJ9dFIjDUU20qI0/jYw2bWB56ZzEMAUC4ij
         6GJb+HoUKix6+x+KgInqUGP0w2HjcDxZMmgF4nezVZApULrpuACUbth7InTkButBGSr9
         0l9K6E+VgorcStbtDkAZft800vE48Ft7ggLKKsaTsYcHz1upDXuTbQHsYh8WnWf6RICc
         y1N/deqJ6W0CVIJbbebGSwzel2oJD/fbH0HQUyvFN9syS8TIMNOtaktY6jA/zA7HU8Df
         TiWkTsuUF2/ypEscinGbTey6zGtx6tpC4qXJ5Sg2q8CaEN3nLzJaxwbQOu6cBSEWo9bK
         utKA==
X-Gm-Message-State: AOAM533NCzuZbxulUkWObsbE4j+MDbjZF9l4MoFT0BRZgYDqOssEa43Z
        IsghvibZjtV6BPhSO9kaYlTCL7cnYOE=
X-Google-Smtp-Source: ABdhPJx3oPusIcEI63lSFHTu8CTZnjejnRB+WtLO2ePsPEe2W9YW9GjGOpf+qWWkKbAcn4svKE0grwu4PhI=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:4d5e:3ba7:52f7:ec45])
 (user=pgonda job=sendgmr) by 2002:a17:90a:fd85:: with SMTP id
 cx5mr9728475pjb.168.1631726278586; Wed, 15 Sep 2021 10:17:58 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:17:55 -0700
Message-Id: <20210915171755.3773766-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH V2] KVM: SEV: Acquire vcpu mutex when updating VMSA
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

V2
 * Refactor per vcpu work to separate function.
 * Remove check to skip already initialized VMSAs.
 * Removed vmsa struct zeroing.

---
 arch/x86/kvm/svm/sev.c | 53 ++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..766510fe3abb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -595,43 +595,50 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
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
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		struct vcpu_svm *svm = to_svm(vcpu);
-
-		/* Perform some pre-encryption checks against the VMSA */
-		ret = sev_es_sync_vmsa(svm);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
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
2.33.0.464.g1972c5931b-goog

