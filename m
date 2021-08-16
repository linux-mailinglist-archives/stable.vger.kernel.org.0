Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E7A3ED69D
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240120AbhHPNW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240946AbhHPNUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3C3632D0;
        Mon, 16 Aug 2021 13:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119739;
        bh=c+B2Q63swed6lgVACd+RD2REdEKCYunUhrIZzk7deD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQuAOFU171sGiS4vKeyMdqGcuExr/4FISchhLZL4lMSY0s6Vj3v8arqM7nMvpGZaN
         6cd9Ybj7ya1VqPzrYMfYy68WnbGm6js5jREiBZTPtPYv28yPLaYAbS5OUkcU/yMJjG
         cpZC0zuQp0SIGaoGJR6ZD96OublLQijJhM2uCd9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 144/151] KVM: VMX: Use current VMCS to query WAITPKG support for MSR emulation
Date:   Mon, 16 Aug 2021 15:02:54 +0200
Message-Id: <20210816125448.816970866@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 7b9cae027ba3aaac295ae23a62f47876ed97da73 upstream.

Use the secondary_exec_controls_get() accessor in vmx_has_waitpkg() to
effectively get the controls for the current VMCS, as opposed to using
vmx->secondary_exec_controls, which is the cached value of KVM's desired
controls for vmcs01 and truly not reflective of any particular VMCS.

While the waitpkg control is not dynamic, i.e. vmcs01 will always hold
the same waitpkg configuration as vmx->secondary_exec_controls, the same
does not hold true for vmcs02 if the L1 VMM hides the feature from L2.
If L1 hides the feature _and_ does not intercept MSR_IA32_UMWAIT_CONTROL,
L2 could incorrectly read/write L1's virtual MSR instead of taking a #GP.

Fixes: 6e3ba4abcea5 ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210810171952.2758100-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -538,7 +538,7 @@ static inline void decache_tsc_multiplie
 
 static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
 {
-	return vmx->secondary_exec_control &
+	return secondary_exec_controls_get(vmx) &
 		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 }
 


