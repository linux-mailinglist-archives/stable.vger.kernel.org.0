Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA3337C73A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhELQAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237839AbhELP41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F4BB61C20;
        Wed, 12 May 2021 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833319;
        bh=iPWMtOqSOEUZ+knKNQb2opfs8ZhuF2ad8nP3569KvG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPqdEFrFtwl0f/wqd1rdCLvjqXZRCcu6dlXrHXcx0UCOXClJan5sKjfHdeNq2z8FA
         6YV3cZZ9duZzzEXgpCyB7L5PFjifH7aLR/C+hIaxgDcCbl7GJWxEZSZpGDYUs3CxcX
         gS3Yalrypr/4zjAQjngyit7EBFRkCWi0JE9n1IeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 101/601] KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs
Date:   Wed, 12 May 2021 16:42:58 +0200
Message-Id: <20210512144831.162797653@linuxfoundation.org>
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

commit c36b16d29f3af5f32fc1b2a3401bf48f71cabee1 upstream.

Use the kvm_for_each_vcpu() helper to iterate over vCPUs when encrypting
VMSAs for SEV, which effectively switches to use online_vcpus instead of
created_vcpus.  This fixes a possible null-pointer dereference as
created_vcpus does not guarantee a vCPU exists, since it is updated at
the very beginning of KVM_CREATE_VCPU.  created_vcpus exists to allow the
bulk of vCPU creation to run in parallel, while still correctly
restricting the max number of max vCPUs.

Fixes: ad73109ae7ec ("KVM: SVM: Provide support to launch and run an SEV-ES guest")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210331031936.2495277-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -563,6 +563,7 @@ static int sev_launch_update_vmsa(struct
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa *vmsa;
+	struct kvm_vcpu *vcpu;
 	int i, ret;
 
 	if (!sev_es_guest(kvm))
@@ -572,8 +573,8 @@ static int sev_launch_update_vmsa(struct
 	if (!vmsa)
 		return -ENOMEM;
 
-	for (i = 0; i < kvm->created_vcpus; i++) {
-		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
 
 		/* Perform some pre-encryption checks against the VMSA */
 		ret = sev_es_sync_vmsa(svm);


