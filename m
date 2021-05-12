Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D904137CBAD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhELQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241753AbhELQ17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 734A661453;
        Wed, 12 May 2021 15:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834952;
        bh=mPBr2DQYz5le/EbWWWevrphQpFPvfrb6H/hKl//R41c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXbKK/AZ5GR0fcrMNpe3epygAUicYMX50753aSHr4FWP6s3IQGdc/Aa8HHVcVXMnl
         lhiveXr20BUVVGL9/9l8EikXuPHirMvDtWCXrrpw1l6gw8qzelitK4Aoq21gzJeqZ1
         7iQdgJtENQZ+lELsqfO3gohD9QumxpHpt4e2qucM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 114/677] KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs
Date:   Wed, 12 May 2021 16:42:40 +0200
Message-Id: <20210512144841.003634107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
@@ -564,6 +564,7 @@ static int sev_launch_update_vmsa(struct
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_launch_update_vmsa *vmsa;
+	struct kvm_vcpu *vcpu;
 	int i, ret;
 
 	if (!sev_es_guest(kvm))
@@ -573,8 +574,8 @@ static int sev_launch_update_vmsa(struct
 	if (!vmsa)
 		return -ENOMEM;
 
-	for (i = 0; i < kvm->created_vcpus; i++) {
-		struct vcpu_svm *svm = to_svm(kvm->vcpus[i]);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct vcpu_svm *svm = to_svm(vcpu);
 
 		/* Perform some pre-encryption checks against the VMSA */
 		ret = sev_es_sync_vmsa(svm);


