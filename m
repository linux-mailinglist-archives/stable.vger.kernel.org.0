Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F9D37CB4F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbhELQfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241642AbhELQ1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E786061413;
        Wed, 12 May 2021 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834880;
        bh=vPjtZLEKxQftbx8HDhG0Z4G2acBw6/vAJF9RUJIQWN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6SEIKGWBm8Z56mpZwUamRGgKBhf0rzLwEs5UnazWpPLDHkJznEXINLUhPmcGCHWQ
         2ONNo50fC3uIJujkBc6sBmNB8NwYVTVnXIxb1nWmqsPGkAYhM6dAXDc9Lu+Ln4Au7O
         9h6zIp1mJlUQE5J7rRWARDDDrV2W+ULTWvWmyDuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 121/677] KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit
Date:   Wed, 12 May 2021 16:42:47 +0200
Message-Id: <20210512144841.231320892@linuxfoundation.org>
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
@@ -4601,9 +4601,9 @@ int get_vmx_mem_address(struct kvm_vcpu
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


