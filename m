Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4B14C42
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfEFOiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbfEFOiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B1EE214C6;
        Mon,  6 May 2019 14:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153487;
        bh=BaH+cTG8MNxmf2G1evFZX/hJl0oSG6msQP0eoWe5B9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9kZIG5APcdx2bczeVxadHxAvm5D9hbXvw/CKTZTjKfuYpBkrrMjON16RG53cDvrq
         UK3moMNGA+zVinrWeOSzMQPF0HWaHR/m3PKrAWGlFbLFbV/SwITY5zR4jkxNcdipT6
         G1pvvi4dYtu+sWaRlBywYGBb1bbvU5EGp/ARowds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 100/122] KVM: VMX: Save RSI to an unused output in the vCPU-run asm blob
Date:   Mon,  6 May 2019 16:32:38 +0200
Message-Id: <20190506143103.757242468@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit f3689e3f17f064fd4cd5f0cb01ae2395c94f39d9 upstream.

RSI is clobbered by the vCPU-run asm blob, but it's not marked as such,
probably because GCC doesn't let you mark inputs as clobbered.  "Save"
RSI to a dummy output so that GCC recognizes it as being clobbered.

Fixes: 773e8a0425c9 ("x86/kvm: use Enlightened VMCS when running on Hyper-V")
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6465,7 +6465,7 @@ static void __vmx_vcpu_run(struct kvm_vc
 		"xor %%edi, %%edi \n\t"
 		"xor %%ebp, %%ebp \n\t"
 		"pop  %%" _ASM_BP "; pop  %%" _ASM_DX " \n\t"
-	      : ASM_CALL_CONSTRAINT
+	      : ASM_CALL_CONSTRAINT, "=S"((int){0})
 	      : "c"(vmx), "d"((unsigned long)HOST_RSP), "S"(evmcs_rsp),
 		[launched]"i"(offsetof(struct vcpu_vmx, __launched)),
 		[fail]"i"(offsetof(struct vcpu_vmx, fail)),


