Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5962A555F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbgKCVJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbgKCVJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 045FE205ED;
        Tue,  3 Nov 2020 21:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437751;
        bh=OL+qO1rHfIQb/juRRsCMJBnD/zn9AUei3CNLxgY3ciY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCSP/QLaLqFm0cvAEaUPjSGtsl8NV4WxOSw0awdHQPdXn/0918zf0nX2m8ta4ZVWr
         lZkYFIGxxiRjCaQkyTlx7rYz9Yn+zHfqYsJ2zZYR/hTivOSXmcVvh1Ai5wCO+1np+h
         L+WcmiPDv2XEsG1quvfvk4S3tXR5xckj1Ktkw6So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 018/125] powerpc: select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
Date:   Tue,  3 Nov 2020 21:36:35 +0100
Message-Id: <20201103203159.377192547@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 66acd46080bd9e5ad2be4b0eb1d498d5145d058e ]

powerpc uses IPIs in some situations to switch a kernel thread away
from a lazy tlb mm, which is subject to the TLB flushing race
described in the changelog introducing ARCH_WANT_IRQS_OFF_ACTIVATE_MM.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200914045219.3736466-3-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig                   | 1 +
 arch/powerpc/include/asm/mmu_context.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 679e1e3c16953..7cc91d7f893cf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -154,6 +154,7 @@ config PPC
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
 	select ARCH_WEAK_RELEASE_ACQUIRE
 	select BINFMT_ELF
 	select BUILDTIME_EXTABLE_SORT
diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index 6f67ff5a52672..5f9ad4f4b9c0f 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -101,7 +101,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
  */
 static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
 {
-	switch_mm(prev, next, current);
+	switch_mm_irqs_off(prev, next, current);
 }
 
 /* We don't currently use enter_lazy_tlb() for anything */
-- 
2.27.0



