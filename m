Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9CC37404E
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbhEEQdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234353AbhEEQdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F192461410;
        Wed,  5 May 2021 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232327;
        bh=u+7H3tecFBn74PvO0+rdTTNUktlPn9S2gEwqwcxkwdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8gUZTaPBymDKOeFu+voOiKZDCrd4mP7iY65ErHZq5l8TabGNHCfXvB9cCrN/AYSs
         c0uYa9xJHRfzhnOt3VV4w2dp9Nd6JBrUAUQR19b7F8v+dAC2icYFiCukwUamOsQicY
         D93YtFMVSuxybYapILGtqMgbh+Byk4WTjdS8pvtKSaTPlpB6YG1y+HcLIKCjoct3AS
         GO/5Ye2hx3Ab9EkJiOz2hsg1Y0+fPveGARePv8DU//H/duCgijFQ7cGs0v5MwICg30
         nMyZob3ek9eBNDsjcHJsadtV7HjlNg5z3C2bH/jJTKv+yIjKZ6OOsaZ8Otv5CYu5tA
         mgsDbl31SL3kA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.12 031/116] powerpc/32: Statically initialise first emergency context
Date:   Wed,  5 May 2021 12:29:59 -0400
Message-Id: <20210505163125.3460440-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -261,11 +261,7 @@
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

