Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4003A4A44F1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358969AbiAaLfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379048AbiAaL3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D52C061787;
        Mon, 31 Jan 2022 03:19:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4A4E61234;
        Mon, 31 Jan 2022 11:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FD7C340E8;
        Mon, 31 Jan 2022 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627946;
        bh=Bl3y2TZT6FTfVZqVwUb5pl7INuYM3zuP4HHkcvi/6/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBBWL/rJ8U8rUOJi8Cgiw7CIOjnydeA7EuTNtGjMh9bhP5Ityso9O5dDHgNyvt6Qj
         XL/MbtGe3RoQlEuobBVdafYi8ZS9id6Jhg5uR+5OtsDu4HSzTyK/FCov1Skh7wpJ5F
         qZOAss3ovYpG+dEJCCmcc9hzFZ+Grqx4AwI4Ve2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 058/200] KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time
Date:   Mon, 31 Jan 2022 11:55:21 +0100
Message-Id: <20220131105235.531217054@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
@@ -11065,8 +11065,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 
 		vcpu->arch.msr_misc_features_enables = 0;
 
-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
-		vcpu->arch.ia32_xss = 0;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
+		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */


