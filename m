Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A68B37C363
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhELPSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234388AbhELPQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17536143D;
        Wed, 12 May 2021 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831999;
        bh=kKRTqiCKxEZOJvZCTcd+m9uqYXJSOUwtTAfECzwj4KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thjnQlznfay/h4GlwDoeIBgMkbmUHpJFo25P1ona9wsbQVl4MWVPelohy8ktOTuyq
         DTLZNuoY8VLdyClE7hS7DEIU1q1+gqJi4jkwnhEHNYC+hJK/Lo0d9fS7sW93xX6JFs
         vvplgZYqRQslVBOL1MJEIEA0pkA6mYf34Lxj2Ias=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 099/530] KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit
Date:   Wed, 12 May 2021 16:43:29 +0200
Message-Id: <20210512144823.056214058@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 82277eeed65eed6c6ee5b8f97bd978763eab148f upstream.

Drop bits 63:32 of the base and/or index GPRs when calculating the
effective address of a VMX instruction memory operand.  Outside of 64-bit
mode, memory encodings are strictly limited to E*X and below.

Fixes: 064aea774768 ("KVM: nVMX: Decoding memory operands of VMX instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4613,9 +4613,9 @@ int get_vmx_mem_address(struct kvm_vcpu
 	else if (addr_size == 0)
 		off = (gva_t)sign_extend64(off, 15);
 	if (base_is_valid)
-		off += kvm_register_read(vcpu, base_reg);
+		off += kvm_register_readl(vcpu, base_reg);
 	if (index_is_valid)
-		off += kvm_register_read(vcpu, index_reg) << scaling;
+		off += kvm_register_readl(vcpu, index_reg) << scaling;
 	vmx_get_segment(vcpu, &s, seg_reg);
 
 	/*


