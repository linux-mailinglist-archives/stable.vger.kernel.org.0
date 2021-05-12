Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E784C37C7A8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhELQBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237986AbhELP46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D6961C2F;
        Wed, 12 May 2021 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833369;
        bh=cq5qPy48V/531d3zpmLUJEhZpG60JBeVN8crghx57FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sP2uDMLU/77BDZutQogS0xvvlisK4VxeBu9JgA5nfuFTvA9rUhyd8cTAO25/v6V6j
         VoIq+qScQ2DjWuih386r9Cl/cOfRHGXXLAGsAXRnW6IR0GqhMDwgVaXx1Vq34JQTTN
         NMWC+n39cuhUp7PehW3+M1jWWeviEthPNnMHud1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 105/601] KVM: nVMX: Defer the MMU reload to the normal path on an EPTP switch
Date:   Wed, 12 May 2021 16:43:02 +0200
Message-Id: <20210512144831.304869029@linuxfoundation.org>
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

commit c805f5d5585ab5e0cdac6b1ccf7086eb120fb7db upstream.

Defer reloading the MMU after a EPTP successful EPTP switch.  The VMFUNC
instruction itself is executed in the previous EPTP context, any side
effects, e.g. updating RIP, should occur in the old context.  Practically
speaking, this bug is benign as VMX doesn't touch the MMU when skipping
an emulated instruction, nor does queuing a single-step #DB.  No other
post-switch side effects exist.

Fixes: 41ab93727467 ("KVM: nVMX: Emulate EPTP switching for the L1 hypervisor")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-14-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5517,16 +5517,11 @@ static int nested_vmx_eptp_switching(str
 		if (!nested_vmx_check_eptp(vcpu, new_eptp))
 			return 1;
 
-		kvm_mmu_unload(vcpu);
 		mmu->ept_ad = accessed_dirty;
 		mmu->mmu_role.base.ad_disabled = !accessed_dirty;
 		vmcs12->ept_pointer = new_eptp;
-		/*
-		 * TODO: Check what's the correct approach in case
-		 * mmu reload fails. Currently, we just let the next
-		 * reload potentially fail
-		 */
-		kvm_mmu_reload(vcpu);
+
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 	}
 
 	return 0;


