Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD93D1FB946
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbgFPQCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732471AbgFPPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:51:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8F621501;
        Tue, 16 Jun 2020 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322668;
        bh=0C/mNTEOjZ2lmpONHhiVdH/VB/xNefd/mk9iWbnGayU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXzIQmsk68pBl0oSkXuyTz+Sfx13GZo4WPOJWE6qD+XO6lVrSpuC3sb++3z07Y2OS
         TnFtYY0H3xJNZKFRzoKMKlqQ397t7H23PQTMqHaaXhIiNy9PgfM9C3qFCxe0iGC6md
         qQ+iuSAcGJy1eDMzMbj8HCekNxiTHfDIku5TX6tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.6 057/161] KVM: x86/mmu: Set mmio_value to 0 if reserved #PF cant be generated
Date:   Tue, 16 Jun 2020 17:34:07 +0200
Message-Id: <20200616153109.092314231@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 6129ed877d409037b79866327102c9dc59a302fe upstream.

Set the mmio_value to '0' instead of simply clearing the present bit to
squash a benign warning in kvm_mmu_set_mmio_spte_mask() that complains
about the mmio_value overlapping the lower GFN mask on systems with 52
bits of PA space.

Opportunistically clean up the code and comments.

Cc: stable@vger.kernel.org
Fixes: d43e2675e96fc ("KVM: x86: only do L1TF workaround on affected processors")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200527084909.23492-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/mmu.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6132,25 +6132,16 @@ static void kvm_set_mmio_spte_mask(void)
 	u64 mask;
 
 	/*
-	 * Set the reserved bits and the present bit of an paging-structure
-	 * entry to generate page fault with PFER.RSV = 1.
+	 * Set a reserved PA bit in MMIO SPTEs to generate page faults with
+	 * PFEC.RSVD=1 on MMIO accesses.  64-bit PTEs (PAE, x86-64, and EPT
+	 * paging) support a maximum of 52 bits of PA, i.e. if the CPU supports
+	 * 52-bit physical addresses then there are no reserved PA bits in the
+	 * PTEs and so the reserved PA approach must be disabled.
 	 */
-
-	/*
-	 * Mask the uppermost physical address bit, which would be reserved as
-	 * long as the supported physical address width is less than 52.
-	 */
-	mask = 1ull << 51;
-
-	/* Set the present bit. */
-	mask |= 1ull;
-
-	/*
-	 * If reserved bit is not supported, clear the present bit to disable
-	 * mmio page fault.
-	 */
-	if (shadow_phys_bits == 52)
-		mask &= ~1ull;
+	if (shadow_phys_bits < 52)
+		mask = BIT_ULL(51) | PT_PRESENT_MASK;
+	else
+		mask = 0;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
 }


