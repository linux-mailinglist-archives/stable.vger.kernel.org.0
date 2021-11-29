Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADE6462651
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhK2Wuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235508AbhK2WuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:50:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1B6C12B6AA;
        Mon, 29 Nov 2021 10:35:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16316B81636;
        Mon, 29 Nov 2021 18:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F6EC53FC7;
        Mon, 29 Nov 2021 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210938;
        bh=p4wtifTZ6CrWN6WlKL31Ez84vTDH7EOZYyssm2h0Srk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgsoTFPfX2VGlYR5VQbIexMry3nXvTd4opcxF0djHvvySpfvtfiEzy6eaRojmAPYQ
         P26Cp6I4ndFGx7LX6eSbguU3X8VwbmP3QQHbC3W+swE6/ifTCcuQ9YFi5aad0q5gD9
         PR7DHegVZTvic1A6UlYtY5it1UikfYjEDvGknMKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 047/179] KVM: PPC: Book3S HV: Prevent POWER7/8 TLB flush flushing SLB
Date:   Mon, 29 Nov 2021 19:17:21 +0100
Message-Id: <20211129181720.526064661@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit cf0b0e3712f7af90006f8317ff27278094c2c128 upstream.

The POWER9 ERAT flush instruction is a SLBIA with IH=7, which is a
reserved value on POWER7/8. On POWER8 this invalidates the SLB entries
above index 0, similarly to SLBIA IH=0.

If the SLB entries are invalidated, and then the guest is bypassed, the
host SLB does not get re-loaded, so the bolted entries above 0 will be
lost. This can result in kernel stack access causing a SLB fault.

Kernel stack access causing a SLB fault was responsible for the infamous
mega bug (search "Fix SLB reload bug"). Although since commit
48e7b7695745 ("powerpc/64s/hash: Convert SLB miss handlers to C") that
starts using the kernel stack in the SLB miss handler, it might only
result in an infinite loop of SLB faults. In any case it's a bug.

Fix this by only executing the instruction on >= POWER9 where IH=7 is
defined not to invalidate the SLB. POWER7/8 don't require this ERAT
flush.

Fixes: 500871125920 ("KVM: PPC: Book3S HV: Invalidate ERAT when flushing guest TLB entries")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211119031627.577853-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_builtin.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -695,6 +695,7 @@ static void flush_guest_tlb(struct kvm *
 				       "r" (0) : "memory");
 		}
 		asm volatile("ptesync": : :"memory");
+		// POWER9 congruence-class TLBIEL leaves ERAT. Flush it now.
 		asm volatile(PPC_RADIX_INVALIDATE_ERAT_GUEST : : :"memory");
 	} else {
 		for (set = 0; set < kvm->arch.tlb_sets; ++set) {
@@ -705,7 +706,9 @@ static void flush_guest_tlb(struct kvm *
 			rb += PPC_BIT(51);	/* increment set number */
 		}
 		asm volatile("ptesync": : :"memory");
-		asm volatile(PPC_ISA_3_0_INVALIDATE_ERAT : : :"memory");
+		// POWER9 congruence-class TLBIEL leaves ERAT. Flush it now.
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
+			asm volatile(PPC_ISA_3_0_INVALIDATE_ERAT : : :"memory");
 	}
 }
 


