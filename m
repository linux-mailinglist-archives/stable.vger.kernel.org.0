Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8DA10BA13
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729560AbfK0U7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:51342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbfK0U7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBB1720678;
        Wed, 27 Nov 2019 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888384;
        bh=u8SiLUbdAmzmgn2psFb7E6iGOkA0Wgtr0WjV9/CVkxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POoLvSqFB7ahD1aAE2/UIogYpM216ry/rKcwzTjJn3PXJ19rFz1n8O6ZzFOiEiJn8
         bvdQkdB+dBjS+XCe/DuiTIEZooXr8JI2wRjsJn5JRKCln9sGHCnEwOjS8EnpwqAYvP
         bbEXdlUyziHK87dym9dZLeW6uXGtkXFe+/SsO0Ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/306] powerpc/64s/radix: Fix radix__flush_tlb_collapsed_pmd double flushing pmd
Date:   Wed, 27 Nov 2019 21:29:24 +0100
Message-Id: <20191127203123.525654180@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit dd76ff5af35350fd6d5bb5b069e73b6017f66893 ]

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/tlb-radix.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/mm/tlb-radix.c b/arch/powerpc/mm/tlb-radix.c
index 796ff5de26d09..1749f15fc0705 100644
--- a/arch/powerpc/mm/tlb-radix.c
+++ b/arch/powerpc/mm/tlb-radix.c
@@ -1072,7 +1072,6 @@ void radix__flush_tlb_collapsed_pmd(struct mm_struct *mm, unsigned long addr)
 			goto local;
 		}
 		_tlbie_va_range(addr, end, pid, PAGE_SIZE, mmu_virtual_psize, true);
-		goto local;
 	} else {
 local:
 		_tlbiel_va_range(addr, end, pid, PAGE_SIZE, mmu_virtual_psize, true);
-- 
2.20.1



