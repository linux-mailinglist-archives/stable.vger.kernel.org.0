Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6073C5290
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbhGLHrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345585AbhGLHpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF296124C;
        Mon, 12 Jul 2021 07:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075701;
        bh=wZotuakH7TeQd7N/SZBUvTmK8QPSopfKoUtA8RCOTUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPhQDTHJ/EaHEqKYZmmA4HeT+os23MsDmItF5u6zuJqS5Dh+XmuJDUgApftq6/KyV
         4r7b8u74YndnBP5y/atmrjhGTska0wRFEeQGeZqFaNzkRak3kWUU+/XjwrtnavEnjz
         IhYKpY2HZjpACZAQSVKlm65R8Eq8Uajaeaw8gg9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 326/800] KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
Date:   Mon, 12 Jul 2021 08:05:49 +0200
Message-Id: <20210712061000.929333188@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0e75225dfa4c5d5d51291f54a3d2d5895bad38da ]

Use BIT_ULL() instead of an open-coded shift to check whether or not a
function is enabled in L1's VMFUNC bitmap.  This is a benign bug as KVM
supports only bit 0, and will fail VM-Enter if any other bits are set,
i.e. bits 63:32 are guaranteed to be zero.

Note, "function" is bounded by hardware as VMFUNC will #UD before taking
a VM-Exit if the function is greater than 63.

Before:
  if ((vmcs12->vm_function_control & (1 << function)) == 0)
   0x000000000001a916 <+118>:	mov    $0x1,%eax
   0x000000000001a91b <+123>:	shl    %cl,%eax
   0x000000000001a91d <+125>:	cltq
   0x000000000001a91f <+127>:	and    0x128(%rbx),%rax

After:
  if (!(vmcs12->vm_function_control & BIT_ULL(function & 63)))
   0x000000000001a955 <+117>:	mov    0x128(%rbx),%rdx
   0x000000000001a95c <+124>:	bt     %rax,%rdx

Fixes: 27c42a1bb867 ("KVM: nVMX: Enable VMFUNC for the L1 hypervisor")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210609234235.1244004-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1dd092d35cae..ba82b8563b07 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5540,7 +5540,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	}
 
 	vmcs12 = get_vmcs12(vcpu);
-	if ((vmcs12->vm_function_control & (1 << function)) == 0)
+	if (!(vmcs12->vm_function_control & BIT_ULL(function)))
 		goto fail;
 
 	switch (function) {
-- 
2.30.2



