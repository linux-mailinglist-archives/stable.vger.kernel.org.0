Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCED937CB48
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbhELQfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241631AbhELQ1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BAF361DF8;
        Wed, 12 May 2021 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834875;
        bh=EnObv8xYKv+69Vej1JTRTlBUA33xvcqzKGHFgrThe2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNAwB6wdyE3cjJKZWndHY/fNS6XcH88dGZOzgRlSdenHI4Y+DQ8uIlTjFS6PICNhv
         VYlXPHG2eaihWhLIQfnRXNTtutlCtLZDf119qvsOurcEeiY1IkE0RzuHUpPvyMHuni
         Me+0qorpdmA7Ve58RkQRZB/+jhOfrXYziS1t2tO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 119/677] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit mode
Date:   Wed, 12 May 2021 16:42:45 +0200
Message-Id: <20210512144841.159275417@linuxfoundation.org>
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

commit d8971344f5739a9cc53f91f1f593ddd82265b93b upstream.

Drop bits 63:32 when storing a DR/CR to a GPR when the vCPU is not in
64-bit mode.  Per the SDM:

  The operand size for these instructions is always 32 bits in non-64-bit
  modes, regardless of the operand-size attribute.

CR8 technically isn't affected as CR8 isn't accessible outside of 64-bit
mode, but fix it up for consistency and to allow for future cleanup.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5062,12 +5062,12 @@ static int handle_cr(struct kvm_vcpu *vc
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
 			val = kvm_read_cr3(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5140,7 +5140,7 @@ static int handle_dr(struct kvm_vcpu *vc
 		unsigned long val;
 
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 		err = 0;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));


