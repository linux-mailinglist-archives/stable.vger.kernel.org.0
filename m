Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4C437C714
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhELP6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232993AbhELPvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE7D619D2;
        Wed, 12 May 2021 15:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833171;
        bh=Y4e1x8T3GEVKHcRwH1PJZFqp1k8mt0cFtu3XESu+s1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT5WDsr+sHG9Q8yohpVGGaoieL+mpsaEVdclhtpP3DvsL/3aT+bxxGGeJEZjiIDmp
         9jM9ppdxJD2iKs1iSUaZYO3kNCqENcpSNQmTOKqoQFWDSC4EtgfW6th+0lph9vk49z
         XRfjbaKXq7aQSgWbz4NqgvUeGwgIUVrbdas2vElc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 029/601] KVM: x86: Defer the MMU unload to the normal path on an global INVPCID
Date:   Wed, 12 May 2021 16:41:46 +0200
Message-Id: <20210512144828.782812882@linuxfoundation.org>
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

commit f66c53b3b94f658590e1012bf6d922f8b7e01bda upstream.

Defer unloading the MMU after a INVPCID until the instruction emulation
has completed, i.e. until after RIP has been updated.

On VMX, this is a benign bug as VMX doesn't touch the MMU when skipping
an emulated instruction.  However, on SVM, if nrip is disabled, the
emulator is used to skip an instruction, which would lead to fireworks
if the emulator were invoked without a valid MMU.

Fixes: eb4b248e152d ("kvm: vmx: Support INVPCID in shadow paging mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11407,7 +11407,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:


