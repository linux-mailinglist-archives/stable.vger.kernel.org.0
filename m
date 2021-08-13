Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F16E3EB8C1
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241757AbhHMPQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242698AbhHMPOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16239610CF;
        Fri, 13 Aug 2021 15:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867649;
        bh=wxC2BJHbVvWK0CrPHUrgXcHsT/DCnS0d6ToQ1p6AQrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvWz8NrZ7sIETBZLmfaKZkLSmMj7zZobgThSygHfdmROCVpC1MQGG+oElYy827MJU
         O07lofY49/AvDEAJ77D5o5ASaGEnWhtRWfN4tvdaW2OvYcxG8oeX/OuWQcEPy4hjF/
         8+Z5e68i4LirC22Qzhqz5M+Z5IZpXRs6PyisL3/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/19] KVM: SVM: Fix off-by-one indexing when nullifying last used SEV VMCB
Date:   Fri, 13 Aug 2021 17:07:18 +0200
Message-Id: <20210813150522.671018477@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
References: <20210813150522.623322501@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 179c6c27bf487273652efc99acd3ba512a23c137 ]

Use the raw ASID, not ASID-1, when nullifying the last used VMCB when
freeing an SEV ASID.  The consumer, pre_sev_run(), indexes the array by
the raw ASID, thus KVM could get a false negative when checking for a
different VMCB if KVM manages to reallocate the same ASID+VMCB combo for
a new VM.

Note, this cannot cause a functional issue _in the current code_, as
pre_sev_run() also checks which pCPU last did VMRUN for the vCPU, and
last_vmentry_cpu is initialized to -1 during vCPU creation, i.e. is
guaranteed to mismatch on the first VMRUN.  However, prior to commit
8a14fe4f0c54 ("kvm: x86: Move last_cpu into kvm_vcpu_arch as
last_vmentry_cpu"), SVM tracked pCPU on its own and zero-initialized the
last_cpu variable.  Thus it's theoretically possible that older versions
of KVM could miss a TLB flush if the first VMRUN is on pCPU0 and the ASID
and VMCB exactly match those of a prior VM.

Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 01547bdbfb06..6c82ef22985d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -124,7 +124,7 @@ static void sev_asid_free(int asid)
 
 	for_each_possible_cpu(cpu) {
 		sd = per_cpu(svm_data, cpu);
-		sd->sev_vmcbs[pos] = NULL;
+		sd->sev_vmcbs[asid] = NULL;
 	}
 
 	mutex_unlock(&sev_bitmap_lock);
-- 
2.30.2



