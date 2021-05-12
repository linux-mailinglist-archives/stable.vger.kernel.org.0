Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D458C37C7C2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhELQCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238178AbhELP53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EEC56193A;
        Wed, 12 May 2021 15:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833433;
        bh=Lbn0cnLWpCAAcVlZ4aN63HVDM4nHBlmQK3j4bK53M+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6m76RspyIq9AloHWFpxVblDEaUuWdmR/qM+knKnsBsm4VWTOwSJjS18GLyaSjYPX
         krvjosybWenT4Cpt64yXAiwTzSSaGC3qX/YczYKgSMJZHYIoYEWdWo4XHIZdXQILre
         RUraXUu9dnPwRo6GewIZxPMj4cDtylvSQ2G+NcAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 103/601] KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs are created
Date:   Wed, 12 May 2021 16:43:00 +0200
Message-Id: <20210512144831.237873782@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 8727906fde6ea665b52e68ddc58833772537f40a upstream.

Reject KVM_SEV_INIT and KVM_SEV_ES_INIT if they are attempted after one
or more vCPUs have been created.  KVM assumes a VM is tagged SEV/SEV-ES
prior to vCPU creation, e.g. init_vmcb() needs to mark the VMCB as SEV
enabled, and svm_create_vcpu() needs to allocate the VMSA.  At best,
creating vCPUs before SEV/SEV-ES init will lead to unexpected errors
and/or behavior, and at worst it will crash the host, e.g.
sev_launch_update_vmsa() will dereference a null svm->vmsa pointer.

Fixes: 1654efcbc431 ("KVM: SVM: Add KVM_SEV_INIT command")
Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210331031936.2495277-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -181,6 +181,9 @@ static int sev_guest_init(struct kvm *kv
 	bool es_active = argp->id == KVM_SEV_ES_INIT;
 	int asid, ret;
 
+	if (kvm->created_vcpus)
+		return -EINVAL;
+
 	ret = -EBUSY;
 	if (unlikely(sev->active))
 		return ret;


