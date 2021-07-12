Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6DE3C50F6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344206AbhGLHfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243100AbhGLHdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11089613DC;
        Mon, 12 Jul 2021 07:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075031;
        bh=DSZyYzhJotfCKGAIacXj6L5zB78kS4zPwJGJEBxsjF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpBJXO/sUt6BQ31/iTqRRwwr9Ciyq0MvZ9+yCjdCf928QtLejbMbN1aX5Mt09d4dK
         kD4NuIZPsl2npkdsSER15yBBHf3dxONK0R8G4ptKMz5RSHurmyQKCnCRMB7fU5ClGP
         ORZn2fqrXDIeYaZxxwjHQAlc/c/Vr5L0VDe4OqIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 078/800] KVM: x86/mmu: Use MMUs role to detect CR4.SMEP value in nested NPT walk
Date:   Mon, 12 Jul 2021 08:01:41 +0200
Message-Id: <20210712060924.109814849@linuxfoundation.org>
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


