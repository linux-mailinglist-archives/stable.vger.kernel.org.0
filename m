Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EC938329A
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbhEQOuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241120AbhEQOq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:46:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04B9B613CB;
        Mon, 17 May 2021 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261316;
        bh=A006AgdxBXRnoTPPBJocUkBUCbHkMSo6a8novqhFVXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UyTMQ4i+oLfrUhcRWmJAr1TFDIhwYgLpBCgVMCwMDOnUxAAYSVBxTBI1Bl7sSOydR
         iF+5ll1I6DWaOT5uuDBWxhhdWlMEyj8Q2c+hglHWU3Ofo/ft349hLADTID4dKrMMu1
         DsBb8fUEORoFddKFuaPB6aNjvxh2i0R51gYg7/sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 333/363] KVM: VMX: Do not advertise RDPID if ENABLE_RDTSCP control is unsupported
Date:   Mon, 17 May 2021 16:03:19 +0200
Message-Id: <20210517140313.865730287@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 8aec21c04caa2000f91cf8822ae0811e4b0c3971 upstream.

Clear KVM's RDPID capability if the ENABLE_RDTSCP secondary exec control is
unsupported.  Despite being enumerated in a separate CPUID flag, RDPID is
bundled under the same VMCS control as RDTSCP and will #UD in VMX non-root
if ENABLE_RDTSCP is not enabled.

Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-2-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7352,9 +7352,11 @@ static __init void vmx_set_cpu_caps(void
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
-	/* CPUID 0x80000001 */
-	if (!cpu_has_vmx_rdtscp())
+	/* CPUID 0x80000001 and 0x7 (RDPID) */
+	if (!cpu_has_vmx_rdtscp()) {
 		kvm_cpu_cap_clear(X86_FEATURE_RDTSCP);
+		kvm_cpu_cap_clear(X86_FEATURE_RDPID);
+	}
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);


