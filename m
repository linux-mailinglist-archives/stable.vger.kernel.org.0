Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA24462461
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhK2WSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhK2WRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:17:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B5C041F56;
        Mon, 29 Nov 2021 10:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46A37CE13E6;
        Mon, 29 Nov 2021 18:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E057DC53FC7;
        Mon, 29 Nov 2021 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210237;
        bh=bK7z1Vs44b+i1Y33kOUKiQhtT4oVT/F7Mt7Ixfz5X4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAqd+slaRT3FCx5mNVY+jXMKtBo0nnl9aJND4AfVqAIZo3GPqX9JEU6N9SOghDr/s
         AANZSiTLNbvZZrSffT1hUULZf/JAAavq5ykwav2C8TBmb40ZxEt+AvOSwjr6nJFoyZ
         L9pxUo/5jm4PAjIO8eJBX5lAndRo7cv3E/+RdQoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 18/92] KVM: PPC: Book3S HV: Prevent POWER7/8 TLB flush flushing SLB
Date:   Mon, 29 Nov 2021 19:17:47 +0100
Message-Id: <20211129181708.028679759@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
@@ -821,6 +821,7 @@ static void flush_guest_tlb(struct kvm *
 				       "r" (0) : "memory");
 		}
 		asm volatile("ptesync": : :"memory");
+		// POWER9 congruence-class TLBIEL leaves ERAT. Flush it now.
 		asm volatile(PPC_RADIX_INVALIDATE_ERAT_GUEST : : :"memory");
 	} else {
 		for (set = 0; set < kvm->arch.tlb_sets; ++set) {
@@ -831,7 +832,9 @@ static void flush_guest_tlb(struct kvm *
 			rb += PPC_BIT(51);	/* increment set number */
 		}
 		asm volatile("ptesync": : :"memory");
-		asm volatile(PPC_ISA_3_0_INVALIDATE_ERAT : : :"memory");
+		// POWER9 congruence-class TLBIEL leaves ERAT. Flush it now.
+		if (cpu_has_feature(CPU_FTR_ARCH_300))
+			asm volatile(PPC_ISA_3_0_INVALIDATE_ERAT : : :"memory");
 	}
 }
 


