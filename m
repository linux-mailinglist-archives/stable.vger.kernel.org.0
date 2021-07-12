Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410F13C4BDF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbhGLHAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240083AbhGLG6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 308FC6124B;
        Mon, 12 Jul 2021 06:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072947;
        bh=DSZyYzhJotfCKGAIacXj6L5zB78kS4zPwJGJEBxsjF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVBJnNjee4KGKbX+pYmRqTeE2eWw7lPzbfu86p4Ityre9jYrb/mWN/AGzgfAq82vf
         TSSKEJYZKtDv1DinYjSGPZZ0Xu0Iy2VeJCG+q+C3VR0a3OufuaFeC/lyOee9Lw6vml
         P4BXtq7fHmqtLPRWcC2x4i+jSn/lAZ1XnRdYTl8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 073/700] KVM: x86/mmu: Use MMUs role to detect CR4.SMEP value in nested NPT walk
Date:   Mon, 12 Jul 2021 08:02:36 +0200
Message-Id: <20210712060935.020357020@linuxfoundation.org>
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

commit ef318b9edf66a082f23d00d79b70c17b4c055a26 upstream.

Use the MMU's role to get its effective SMEP value when injecting a fault
into the guest.  When walking L1's (nested) NPT while L2 is active, vCPU
state will reflect L2, whereas NPT uses the host's (L1 in this case) CR0,
CR4, EFER, etc...  If L1 and L2 have different settings for SMEP and
L1 does not have EFER.NX=1, this can result in an incorrect PFEC.FETCH
when injecting #NPF.

Fixes: e57d4a356ad3 ("KVM: Add instruction fetch checking when walking guest page table")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/paging_tmpl.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -471,8 +471,7 @@ retry_walk:
 
 error:
 	errcode |= write_fault | user_fault;
-	if (fetch_fault && (mmu->nx ||
-			    kvm_read_cr4_bits(vcpu, X86_CR4_SMEP)))
+	if (fetch_fault && (mmu->nx || mmu->mmu_role.ext.cr4_smep))
 		errcode |= PFERR_FETCH_MASK;
 
 	walker->fault.vector = PF_VECTOR;


