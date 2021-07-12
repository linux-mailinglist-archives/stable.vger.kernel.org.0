Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303E23C50F2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343968AbhGLHfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244644AbhGLHdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:33:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF55A60FF1;
        Mon, 12 Jul 2021 07:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075025;
        bh=Fyc4kmRbFFjK/m9dPgf4SN5B8TxWzKkPORGJvz+HkxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DI9O+x9J1uL2vxOLZ447cuefoSIIre8K2D6nPtJMhMke/AH211wrbbez2SuJumaua
         1drhQViw7l1o2aIUNyDVfx+ESKff/I2Zy4OIpTP2wEu1S9Zr4lUSCzbKqsXnd+6hNe
         yR63InoO1rjZPPGuuoBCTCIHWydccXfQ/wAYhoow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 076/800] KVM: x86/mmu: Remove broken WARN that fires on 32-bit KVM w/ nested EPT
Date:   Mon, 12 Jul 2021 08:01:39 +0200
Message-Id: <20210712060923.824263014@linuxfoundation.org>
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

commit f0d4379087d8a83f478b371ff7786e8df0cc2314 upstream.

Remove a misguided WARN that attempts to detect the scenario where using
a special A/D tracking flag will set reserved bits on a non-MMIO spte.
The WARN triggers false positives when using EPT with 32-bit KVM because
of the !64-bit clause, which is just flat out wrong.  The whole A/D
tracking goo is specific to EPT, and one of the big selling points of EPT
is that EPT is decoupled from the host's native paging mode.

Drop the WARN instead of trying to salvage the check.  Keeping a check
specific to A/D tracking bits would essentially regurgitate the same code
that led to KVM needed the tracking bits in the first place.

A better approach would be to add a generic WARN on reserved bits being
set, which would naturally cover the A/D tracking bits, work for all
flavors of paging, and be self-documenting to some extent.

Fixes: 8a406c89532c ("KVM: x86/mmu: Rename and document A/D scheme for TDP SPTEs")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/spte.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -103,13 +103,6 @@ int make_spte(struct kvm_vcpu *vcpu, uns
 		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
 
 	/*
-	 * Bits 62:52 of PAE SPTEs are reserved.  WARN if said bits are set
-	 * if PAE paging may be employed (shadow paging or any 32-bit KVM).
-	 */
-	WARN_ON_ONCE((!tdp_enabled || !IS_ENABLED(CONFIG_X86_64)) &&
-		     (spte & SPTE_TDP_AD_MASK));
-
-	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
 	 * supports exec-only page table entries.  In that case,
 	 * ACC_USER_MASK and shadow_user_mask are used to represent


