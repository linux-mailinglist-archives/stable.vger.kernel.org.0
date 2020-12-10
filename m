Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329722D5DF0
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390880AbgLJOfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390886AbgLJOfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:35:11 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 27/54] powerpc/64s/powernv: Fix memory corruption when saving SLB entries on MCE
Date:   Thu, 10 Dec 2020 15:27:04 +0100
Message-Id: <20201210142603.365405138@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit a1ee28117077c3bf24e5ab6324c835eaab629c45 upstream.

This can be hit by an HPT guest running on an HPT host and bring down
the host, so it's quite important to fix.

Fixes: 7290f3b3d3e6 ("powerpc/64s/powernv: machine check dump SLB contents")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201128070728.825934-2-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/setup.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -186,11 +186,16 @@ static void __init pnv_init(void)
 		add_preferred_console("hvc", 0, NULL);
 
 	if (!radix_enabled()) {
+		size_t size = sizeof(struct slb_entry) * mmu_slb_size;
 		int i;
 
 		/* Allocate per cpu area to save old slb contents during MCE */
-		for_each_possible_cpu(i)
-			paca_ptrs[i]->mce_faulty_slbs = memblock_alloc_node(mmu_slb_size, __alignof__(*paca_ptrs[i]->mce_faulty_slbs), cpu_to_node(i));
+		for_each_possible_cpu(i) {
+			paca_ptrs[i]->mce_faulty_slbs =
+					memblock_alloc_node(size,
+						__alignof__(struct slb_entry),
+						cpu_to_node(i));
+		}
 	}
 }
 


