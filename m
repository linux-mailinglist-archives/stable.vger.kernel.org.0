Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E209499A60
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445736AbiAXVnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46210 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454452AbiAXVcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:32:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E45C1B8105C;
        Mon, 24 Jan 2022 21:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B72C340E4;
        Mon, 24 Jan 2022 21:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059959;
        bh=KTa5uE2Mb93sD38nS7uJSUFuBanTPcMxB9FmfumWRN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykvS9Y8CfmY/MlQIb7n0BK7vq5gSZpNW6X+yNsBLYS6oNt9TyKB083+YOrg+KUFT6
         C2Ft0CPE0k6puq+mi14rZvrFQ+t6HAQOps2b9vubMjTUF3o+Nl9S3QBo9qctm52fx6
         BpyHN6AlGw+Ck0PUMy6u3G8BYg88nqNM66QwvInk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0791/1039] KVM: X86: Ensure that dirty PDPTRs are loaded
Date:   Mon, 24 Jan 2022 19:43:00 +0100
Message-Id: <20220124184151.881561471@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

[ Upstream commit 2c5653caecc4807b8abfe9c41880ac38417be7bf ]

For VMX with EPT, dirty PDPTRs need to be loaded before the next vmentry
via vmx_load_mmu_pgd()

But not all paths that call load_pdptrs() will cause vmx_load_mmu_pgd()
to be invoked.  Normally, kvm_mmu_reset_context() is used to cause
KVM_REQ_LOAD_MMU_PGD, but sometimes it is skipped:

* commit d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and
CR0.NW are changed") skips kvm_mmu_reset_context() after load_pdptrs()
when changing CR0.CD and CR0.NW.

* commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
PCID on MOV CR3 w/ flush") skips KVM_REQ_LOAD_MMU_PGD after
load_pdptrs() when rewriting the CR3 with the same value.

* commit a91a7c709600("KVM: X86: Don't reset mmu context when
toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
load_pdptrs() when changing CR4.PGE.

Fixes: d81135a57aa6 ("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
Fixes: 21823fbda552 ("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
Fixes: a91a7c709600 ("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20211108124407.12187-2-jiangshanlai@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b5c61bb24a17..bb87f43cdc78c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -830,6 +830,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 	vcpu->arch.pdptrs_from_userspace = false;
 
 	return 1;
-- 
2.34.1



