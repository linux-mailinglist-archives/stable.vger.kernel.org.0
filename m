Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4563C5283
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346261AbhGLHqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349829AbhGLHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4166B61208;
        Mon, 12 Jul 2021 07:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075696;
        bh=EmkJoLqBohe+PVaqyZeF2xK1fCFmH2jeoI8hDM/ba9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzZ1YRK3fSFvuSNaXaGdL0MpUAn3EEK+u/a461XCmIqT92an5D2Z4V24H23iEKM2q
         kbVR4CwojiUKxKm1V7YlVEILozczKS1+ysSwZWjdGnAq5mVwZdBYiMF+xcfY7EtKsi
         nRWesF03jiBvBpOEJLV+VzXLBiCjrVJ1pNlHU3pc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 324/800] KVM: nVMX: Add a return code to vmx_complete_nested_posted_interrupt
Date:   Mon, 12 Jul 2021 08:05:47 +0200
Message-Id: <20210712061000.636816370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 650293c3de6b042c4a2e87b2bc678efcff3843e8 ]

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Message-Id: <20210604172611.281819-4-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4ceadec6aeb6..5677cef81642 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3682,7 +3682,7 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
+static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int max_irr;
@@ -3690,17 +3690,17 @@ static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	u16 status;
 
 	if (!vmx->nested.pi_desc || !vmx->nested.pi_pending)
-		return;
+		return 0;
 
 	vmx->nested.pi_pending = false;
 	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
-		return;
+		return 0;
 
 	max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
 	if (max_irr != 256) {
 		vapic_page = vmx->nested.virtual_apic_map.hva;
 		if (!vapic_page)
-			return;
+			return 0;
 
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3713,6 +3713,7 @@ static void vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	}
 
 	nested_mark_vmcs12_pages_dirty(vcpu);
+	return 0;
 }
 
 static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
@@ -3887,8 +3888,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	}
 
 no_vmexit:
-	vmx_complete_nested_posted_interrupt(vcpu);
-	return 0;
+	return vmx_complete_nested_posted_interrupt(vcpu);
 }
 
 static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
-- 
2.30.2



