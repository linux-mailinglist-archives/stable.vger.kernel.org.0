Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88DAD15C15E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgBMPWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:32904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgBMPWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:52 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821C92469C;
        Thu, 13 Feb 2020 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607371;
        bh=ImnbD9F25e9BycBbdnfihLcvYJC4fBuKP6FR6RfChZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghOB+xU9bYbVFGu6LnO9rYJUyXtdf+M5TlQbFH6856lxWzS4PoIE/qcOXtsNAlzUS
         OvvNBDmNegoMUoV/J20/WoONt0QK+vUwCBp2BtyBGjqVjpWkdDUyoJ8rmhg6Pnyo6a
         Kin9c/4SUsPKFsDjtQxT+B0oojTkMPSQP+0CLAQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 46/91] KVM: x86: Free wbinvd_dirty_mask if vCPU creation fails
Date:   Thu, 13 Feb 2020 07:20:03 -0800
Message-Id: <20200213151839.364525463@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 16be9ddea268ad841457a59109963fff8c9de38d upstream.

Free the vCPU's wbinvd_dirty_mask if vCPU creation fails after
kvm_arch_vcpu_init(), e.g. when installing the vCPU's file descriptor.
Do the freeing by calling kvm_arch_vcpu_free() instead of open coding
the freeing.  This adds a likely superfluous, but ultimately harmless,
call to kvmclock_reset(), which only clears vcpu->arch.pv_time_enabled.
Using kvm_arch_vcpu_free() allows for additional cleanup in the future.

Fixes: f5f48ee15c2ee ("KVM: VMX: Execute WBINVD to keep data consistency with assigned devices")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7498,7 +7498,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
 
-	kvm_x86_ops->vcpu_free(vcpu);
+	kvm_arch_vcpu_free(vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)


