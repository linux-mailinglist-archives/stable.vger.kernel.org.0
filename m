Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EE93C4D56
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbhGLHMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244180AbhGLHK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F6CA613B9;
        Mon, 12 Jul 2021 07:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073612;
        bh=YCb/SEytGyNVfPLdMRL6NO9tGa6sjoFDQBhuC4TjDkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WV1hDLrHm0OuA5bxtLNssBc9FzHvy3S4N1ZNBKB6DT3PRNOB5YriTpjn96YmQu9Ee
         zBtavcXcQtszVXcQBX0KmbPM5Y7aOoAYb2Pu/dC9ROHOOJI1F4uq+k4+qGIR5+R99S
         Rj4J+Qu0Njp5vXm7W+dZmH5iMkz/PKHyG715CmZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 298/700] KVM: nVMX: Ensure 64-bit shift when checking VMFUNC bitmap
Date:   Mon, 12 Jul 2021 08:06:21 +0200
Message-Id: <20210712061008.056432309@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index eca3db08d183..d3774d79916d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5524,7 +5524,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	}
 
 	vmcs12 = get_vmcs12(vcpu);
-	if ((vmcs12->vm_function_control & (1 << function)) == 0)
+	if (!(vmcs12->vm_function_control & BIT_ULL(function)))
 		goto fail;
 
 	switch (function) {
-- 
2.30.2



