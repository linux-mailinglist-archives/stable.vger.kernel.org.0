Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F2537CB07
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242265AbhELQd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241365AbhELQ1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BF5461DB9;
        Wed, 12 May 2021 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834706;
        bh=4lgVH1WQGgO1Fcb8xTyrWdI0sCjeqGs79YiglJ0iMuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Epy3xOg56siaVxVMTDYv+0G9DKqMw/uQsbmxBmPNcr9C43E9uLgOt7Tx2xxlRwCj2
         gfSTzzyhlKuvSIUKZZFtfPLtUDgm7ubD1ot8oXUFBZG+IB8uR2ZYSanIhnaXGcaz+I
         uVi6LCtUv0y3DYcxQoAVnSF/wuRTG019cg7Vp8CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 034/677] KVM: x86: Defer the MMU unload to the normal path on an global INVPCID
Date:   Wed, 12 May 2021 16:41:20 +0200
Message-Id: <20210512144838.352178664@linuxfoundation.org>
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
@@ -11539,7 +11539,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:


