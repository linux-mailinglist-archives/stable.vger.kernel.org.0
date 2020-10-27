Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894E029B398
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752262AbgJ0Oxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1772997AbgJ0Ous (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:50:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52DAF20709;
        Tue, 27 Oct 2020 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810248;
        bh=wAwUV958LU8bHx875DfGLCK3nKrFyDCPa9vQFyPV5ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fv3mRTg649YEsDjT7mUQQf0szoxapl40IN9fGt8Fy8YRfdDTwP8JBtZtt0u5CE+Wd
         KTpVmsiloTQ9dhGSRCMFNmyyI55McwOnQtuOkD2pcddH15iMfYMS+Lxdh41V0HPSKX
         /G9yFFhm1k3phJerQl+V36/W+gjFKZfw3wKODMxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Cross <dcross@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.8 071/633] KVM: nVMX: Reload vmcs01 if getting vmcs12s pages fails
Date:   Tue, 27 Oct 2020 14:46:54 +0100
Message-Id: <20201027135526.034984129@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b89d5ad00e789967a5e2c5335f75c48755bebd88 upstream.

Reload vmcs01 when bailing from nested_vmx_enter_non_root_mode() as KVM
expects vmcs01 to be loaded when is_guest_mode() is false.

Fixes: 671ddc700fd08 ("KVM: nVMX: Don't leak L1 MMIO regions to L2")
Cc: stable@vger.kernel.org
Cc: Dan Cross <dcross@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200923184452.980-3-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3297,8 +3297,10 @@ enum nvmx_vmentry_status nested_vmx_ente
 	prepare_vmcs02_early(vmx, vmcs12);
 
 	if (from_vmentry) {
-		if (unlikely(!nested_get_vmcs12_pages(vcpu)))
+		if (unlikely(!nested_get_vmcs12_pages(vcpu))) {
+			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
+		}
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);


