Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F154A4247
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359436AbiAaLLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42478 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376428AbiAaLIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC1C61035;
        Mon, 31 Jan 2022 11:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A991C340E8;
        Mon, 31 Jan 2022 11:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627304;
        bh=cxlwAG8PN2icPtViFxmJzy/czjZCygMgoVfmP6Msmxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfIIwEhSz9aFy8liR2/h/eQBAcGqfTlostUPbDpM0cs9MbOlByFU1GM0HjG2GUKvn
         DmrU47VO1FEzRyP8joGbG3A4DZCD7NTLULhPsz802qi4AmnzXDvREsHbvyqkA5jiM3
         laZ/m6KbJEiWTsSk/2f3gNxXu9J1XXd84TPO9aTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 041/171] KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time
Date:   Mon, 31 Jan 2022 11:55:06 +0100
Message-Id: <20220131105231.415485841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

commit 05a9e065059e566f218f8778c4d17ee75db56c55 upstream.

XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
also needs to update kvm_update_cpuid_runtime(). In the above cases, the
size in bytes of the XSAVE area containing all states enabled by XCR0 or
(XCRO | IA32_XSS) needs to be updated.

For simplicity and consistency, existing helpers are used to write values
and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Cc: stable@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220126172226.2298529-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10990,8 +10990,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 
 		vcpu->arch.msr_misc_features_enables = 0;
 
-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
-		vcpu->arch.ia32_xss = 0;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
+		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
 	}
 
 	memset(vcpu->arch.regs, 0, sizeof(vcpu->arch.regs));


