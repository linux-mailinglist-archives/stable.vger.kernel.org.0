Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901A637C2F0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhELPQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbhELPME (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8B1561925;
        Wed, 12 May 2021 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831823;
        bh=kluB8RU/e70WoIuBC0DmhMIFSSJuZ8GREZZBiaI4IrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqkZiplyfn+Cc8a6KG9/aWFHxk/bOlPDVC4+Mc3Rs1/jwxl1wO+XbFc78sEWOJpx6
         x4Us8/FCgIOYQ6rWItO0Ajwcm+SuISp2dBAKaIIOpzTtMgJzJdyBNC+USwWmyRvz5J
         w/L+1R6TzU2DzdiJk7mZKa8tV0m94/Je4X3LqRqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 029/530] KVM: x86: Defer the MMU unload to the normal path on an global INVPCID
Date:   Wed, 12 May 2021 16:42:19 +0200
Message-Id: <20210512144820.688292054@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
@@ -11290,7 +11290,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:


