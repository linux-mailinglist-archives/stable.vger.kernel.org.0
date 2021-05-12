Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0776B37C12A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhELO5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:57:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232249AbhELOz4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B9E86142E;
        Wed, 12 May 2021 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831288;
        bh=ujjArPhB3AH2Rri0wcvOgGRStrZZAyifv4N5DMeJnzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zS5+qCE/FG1cx6YKpS2n134+ser7oRYrfubK3+eJk9/sm+MSty7tK/qy6O2JGisAd
         T91Ip1EJMhpBEUEq51n4yO6wMcJLBKV136AbZ7x/655B3Va1PeS5kO+VfAFBoLlKVK
         Nr9YK5C2qUsndxy5/EB3YiZscmGBfabjbSxP2UYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 060/244] KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in !64-bit
Date:   Wed, 12 May 2021 16:47:11 +0200
Message-Id: <20210512144744.966159933@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit ee050a577523dfd5fac95e6cc182ebe0293ead59 upstream.

Drop bits 63:32 of the VMCS field encoding when checking for a nested
VM-Exit on VMREAD/VMWRITE in !64-bit mode.  VMREAD and VMWRITE always
use 32-bit operands outside of 64-bit mode.

The actual emulation of VMREAD/VMWRITE does the right thing, this bug is
purely limited to incorrectly causing a nested VM-Exit if a GPR happens
to have bits 63:32 set outside of 64-bit mode.

Fixes: a7cde481b6e8 ("KVM: nVMX: Do not forward VMREAD/VMWRITE VMExits to L1 if required so by vmcs12 vmread/vmwrite bitmaps")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5308,7 +5308,7 @@ static bool nested_vmx_exit_handled_vmcs
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)


