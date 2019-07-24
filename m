Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0FC73E88
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389790AbfGXTix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388130AbfGXTiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F8F8214AF;
        Wed, 24 Jul 2019 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997131;
        bh=1ISgymW0dhzU5kusBtoD+doCSuaV84R8I3wlBCcZM9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bz5GxgP3W+varUlBf4X4yQAh+jkS+N2itZRhqFk6Z5Rk7b4W7H/cBTeuqkEchNCOF
         VeVvpSvDXnqSGamPrI1yzCQs4u6mWaK0qdI26Q4BLq6vWGIEfkYtfLG1JixumTWvc4
         wA/MNbBsKkxkcNdJFR38Yc4KklwKJ/YGOwsme2dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Tao Xu <tao3.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 5.2 330/413] KVM: VMX: check CPUID before allowing read/write of IA32_XSS
Date:   Wed, 24 Jul 2019 21:20:21 +0200
Message-Id: <20190724191759.454363598@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

commit 4d763b168e9c5c366b05812c7bba7662e5ea3669 upstream.

Raise #GP when guest read/write IA32_XSS, but the CPUID bits
say that it shouldn't exist.

Fixes: 203000993de5 (kvm: vmx: add MSR logic for XSAVES)
Reported-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Reported-by: Tao Xu <tao3.xu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1718,7 +1718,10 @@ static int vmx_get_msr(struct kvm_vcpu *
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!vmx_xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -1933,7 +1936,10 @@ static int vmx_set_msr(struct kvm_vcpu *
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!vmx_xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
 		/*
 		 * The only supported bit as of Skylake is bit 8, but


