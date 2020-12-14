Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DC62DA067
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502562AbgLNT07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502215AbgLNRgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:36:55 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 010/105] powerpc/64s: Fix hash ISA v3.0 TLBIEL instruction generation
Date:   Mon, 14 Dec 2020 18:27:44 +0100
Message-Id: <20201214172555.776521509@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 5844cc25fd121074de7895181a2fa1ce100a0fdd ]

A typo has the R field of the instruction assigned by lucky dip a la
register allocator.

Fixes: d4748276ae14c ("powerpc/64s: Improve local TLB flush for boot and MCE on POWER9")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201126102530.691335-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/hash_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/hash_native.c b/arch/powerpc/mm/book3s64/hash_native.c
index cf20e5229ce1f..562094863e915 100644
--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -68,7 +68,7 @@ static __always_inline void tlbiel_hash_set_isa300(unsigned int set, unsigned in
 	rs = ((unsigned long)pid << PPC_BITLSHIFT(31));
 
 	asm volatile(PPC_TLBIEL(%0, %1, %2, %3, %4)
-		     : : "r"(rb), "r"(rs), "i"(ric), "i"(prs), "r"(r)
+		     : : "r"(rb), "r"(rs), "i"(ric), "i"(prs), "i"(r)
 		     : "memory");
 }
 
-- 
2.27.0



