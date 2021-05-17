Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD92A383145
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239696AbhEQOgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240277AbhEQOdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 064AF613DB;
        Mon, 17 May 2021 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260983;
        bh=19YmnsizSpk4vLMejuMPFuHXHYYERN4tMKKZofyBhic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKf6Y5LJGqGDCe9p+ayvCn8rBHGqZ3Ij7/HPA1VowAxOSHV8IaGvElmGhXR1hlw/H
         UUagNChz2mzvhTUBq9GJuUb7bWIvbu1jUnCxxUxbhj5GglRInKGdqzVV6nFVnnfW33
         uUoxPQp1226Yd9WcRvR+DTEQx+ZZGKZdBVdR0jnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 279/363] KVM: SVM: Move GHCB unmapping to fix RCU warning
Date:   Mon, 17 May 2021 16:02:25 +0200
Message-Id: <20210517140312.045000371@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit ce7ea0cfdc2e9ff31d12da31c3226deddb9644f5 ]

When an SEV-ES guest is running, the GHCB is unmapped as part of the
vCPU run support. However, kvm_vcpu_unmap() triggers an RCU dereference
warning with CONFIG_PROVE_LOCKING=y because the SRCU lock is released
before invoking the vCPU run support.

Move the GHCB unmapping into the prepare_guest_switch callback, which is
invoked while still holding the SRCU lock, eliminating the RCU dereference
warning.

Fixes: 291bd20d5d88 ("KVM: SVM: Add initial support for a VMGEXIT VMEXIT")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <b2f9b79d15166f2c3e4375c0d9bc3268b7696455.1620332081.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 5 +----
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ba56f677cc09..dbc6214d69de 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1668,7 +1668,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	return -EINVAL;
 }
 
-static void pre_sev_es_run(struct vcpu_svm *svm)
+void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 {
 	if (!svm->ghcb)
 		return;
@@ -1704,9 +1704,6 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
-	/* Perform any SEV-ES pre-run actions */
-	pre_sev_es_run(svm);
-
 	/* Assign the asid allocated with this SEV guest */
 	svm->asid = asid;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 276d3c728628..5364458cf60b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1416,6 +1416,9 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 	unsigned int i;
 
+	if (sev_es_guest(vcpu->kvm))
+		sev_es_unmap_ghcb(svm);
+
 	if (svm->guest_state_loaded)
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..98da0b91f273 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -571,6 +571,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_create_vcpu(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
+void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-- 
2.30.2



