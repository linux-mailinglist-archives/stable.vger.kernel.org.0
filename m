Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCDF30CC79
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbhBBT5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232940AbhBBNuB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FFCB64FA1;
        Tue,  2 Feb 2021 13:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273354;
        bh=eR1JmH0TvrXwgf4kwoQSnDl0DgSldxgKUcc90l88V0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9tVjt2y7k4iPnEZOcdAeXnnXcE8isGpm1zCM+/v/v7NUNsOjIaQhJP8IVWkud0Ee
         KPTXm+zSJal6ZmKl0PsBCQWkMSQ1WW09ffYcwh3TEMb/Zg0lM7tBVE8i3VKGcTDRI9
         +7clEBCgw8Zhmcm2zrRGcFUz/k9q2D4IyeIr8mUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 044/142] KVM: nVMX: Sync unsyncd vmcs02 state to vmcs12 on migration
Date:   Tue,  2 Feb 2021 14:36:47 +0100
Message-Id: <20210202132959.545200167@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit d51e1d3f6b4236e0352407d8a63f5c5f71ce193d upstream.

Even when we are outside the nested guest, some vmcs02 fields
may not be in sync vs vmcs12.  This is intentional, even across
nested VM-exit, because the sync can be delayed until the nested
hypervisor performs a VMCLEAR or a VMREAD/VMWRITE that affects those
rarely accessed fields.

However, during KVM_GET_NESTED_STATE, the vmcs12 has to be up to date to
be able to restore it.  To fix that, call copy_vmcs02_to_vmcs12_rare()
before the vmcs12 contents are copied to userspace.

Fixes: 7952d769c29ca ("KVM: nVMX: Sync rarely accessed guest fields only when needed")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210114205449.8715-2-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6070,11 +6070,14 @@ static int vmx_get_nested_state(struct k
 	if (is_guest_mode(vcpu)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
 		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
-	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
-		if (vmx->nested.hv_evmcs)
-			copy_enlightened_to_vmcs12(vmx);
-		else if (enable_shadow_vmcs)
-			copy_shadow_to_vmcs12(vmx);
+	} else  {
+		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
+		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
+			if (vmx->nested.hv_evmcs)
+				copy_enlightened_to_vmcs12(vmx);
+			else if (enable_shadow_vmcs)
+				copy_shadow_to_vmcs12(vmx);
+		}
 	}
 
 	BUILD_BUG_ON(sizeof(user_vmx_nested_state->vmcs12) < VMCS12_SIZE);


