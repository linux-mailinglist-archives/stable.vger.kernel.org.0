Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129AE3743E7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbhEEQxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236453AbhEEQts (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:49:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA7AB61971;
        Wed,  5 May 2021 16:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232645;
        bh=NwISA0bDAB8Zj1wl7St5NVLpEslQf6oo/F2m7/RVcZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeqPNzv7jO4HnFFw0xI9qMyoGwbCu3OK6fcnFfx5KIeQKF5j+FjyU2zRGrG+c2ee/
         q//xynRwg/E4vtHzZMemWFjWQmOLsQL+6Dn0/KOFz7Fe6IOAW4KygAt4oo92cpP7FT
         yZ6vr1mmbhPtUElvy/W6LsjHLhcGym2wjfKEh6chm7b8dIyGoWDeA+XrnNw1/0yaFZ
         /R1DyYLy8x6m8WPsUhfzBR4TUV1ptoi/WSYt8IdWnJuu/l5zCXjX2MAprk5HKz2FdM
         apb0dHYQYLr2g7cF5Zzgg3VyViMa86HHdEHLFza3rR5PSPmseg6phqxTdzBkVjgzPm
         ml2YTBtwaIZwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 25/85] powerpc/32: Statically initialise first emergency context
Date:   Wed,  5 May 2021 12:35:48 -0400
Message-Id: <20210505163648.3462507-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index fef0b34a77c9..f8e3d15ddf69 100644
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -338,11 +338,7 @@
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
index 057d6b8e9bb0..e7f2eb7837fc 100644
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

