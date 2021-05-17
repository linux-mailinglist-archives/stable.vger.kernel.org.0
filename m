Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEA5382E84
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbhEQOIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237987AbhEQOHC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8819561353;
        Mon, 17 May 2021 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260346;
        bh=IPfpyrXS7tHH5SJRrW7b2YGSvcyyhg5Wvzg96PJhElQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R29L9mKsAm0LeyvwnUcuPdsUnlqdl0KqB4TA8JBs9W/VVPS+iLN5F8diWK1fyiy+X
         elGEktGYXf5spKSjcR1Dc+m+BBdUExidFnGBnvH4Qo/LFx2wrEk8vBYyuB0oexuJZA
         LgIm/jyT23jEJUl2zK6YMfU2437WT0kNmKS1spUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 040/363] powerpc/32: Statically initialise first emergency context
Date:   Mon, 17 May 2021 15:58:26 +0200
Message-Id: <20210517140303.958582084@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit a4719f5bb6d7dc220bffdc1b9f5ce5eaa5543581 ]

The check of the emergency context initialisation in
vmap_stack_overflow is buggy for the SMP case, as it
compares r1 with 0 while in the SMP case r1 is offseted
by the CPU id.

Instead of fixing it, just perform static initialisation
of the first emergency context.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4a67ba422be75713286dca0c86ee0d3df2eb6dfa.1615552867.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_32.h  | 6 +-----
 arch/powerpc/kernel/setup_32.c | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head_32.h
index 5d4706c14572..cf8ca08295bf 100644
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -261,11 +261,7 @@ label:
 	lis	r1, emergency_ctx@ha
 #endif
 	lwz	r1, emergency_ctx@l(r1)
-	cmpwi	cr1, r1, 0
-	bne	cr1, 1f
-	lis	r1, init_thread_union@ha
-	addi	r1, r1, init_thread_union@l
-1:	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
+	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
 	EXCEPTION_PROLOG_2
 	SAVE_NVGPRS(r11)
 	addi	r3, r1, STACK_FRAME_OVERHEAD
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 8ba49a6bf515..d7c1f92152af 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -164,7 +164,7 @@ void __init irqstack_early_init(void)
 }
 
 #ifdef CONFIG_VMAP_STACK
-void *emergency_ctx[NR_CPUS] __ro_after_init;
+void *emergency_ctx[NR_CPUS] __ro_after_init = {[0] = &init_stack};
 
 void __init emergency_stack_init(void)
 {
-- 
2.30.2



