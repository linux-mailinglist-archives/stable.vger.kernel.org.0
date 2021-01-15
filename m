Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9A2F7972
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbhAOMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732844AbhAOMgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4BF523136;
        Fri, 15 Jan 2021 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714156;
        bh=+z3tkAt1O8PXv7548J5zbfZy4EYIjOYAoO9nih98JEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSLO9JL6GjLMDeVSCC8K1ISvAKuZj/qcwmuvPq4u5w+ulmDw9ql9mFrp1fE6TKi8f
         tBjXuNGvEcUJ6agIYU8MlCXst2MRDU5YQn9rM2l20TyOwpgYB2+ttA5078I8RvyhCC
         7De8ieCFfEVhECQUvaLupXP5OTq7ciQu0Q2nnppM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/103] powerpc/32s: Fix RTAS machine check with VMAP stack
Date:   Fri, 15 Jan 2021 13:26:54 +0100
Message-Id: <20210115122006.122859786@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 98bf2d3f4970179c702ef64db658e0553bc6ef3a ]

When we have VMAP stack, exception prolog 1 sets r1, not r11.

When it is not an RTAS machine check, don't trash r1 because it is
needed by prolog 1.

Fixes: da7bb43ab9da ("powerpc/32: Fix vmap stack - Properly set r1 before activating MMU")
Fixes: d2e006036082 ("powerpc/32: Use SPRN_SPRG_SCRATCH2 in exception prologs")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Squash in fixup for RTAS machine check from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bc77d61d1c18940e456a2dee464f1e2eda65a3f0.1608621048.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_book3s_32.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index a0dda2a1f2df0..d66da35f2e8d3 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -262,10 +262,19 @@ __secondary_hold_acknowledge:
 MachineCheck:
 	EXCEPTION_PROLOG_0
 #ifdef CONFIG_PPC_CHRP
+#ifdef CONFIG_VMAP_STACK
+	mr	r11, r1
+	mfspr	r1, SPRN_SPRG_THREAD
+	lwz	r1, RTAS_SP(r1)
+	cmpwi	cr1, r1, 0
+	bne	cr1, 7f
+	mr	r1, r11
+#else
 	mfspr	r11, SPRN_SPRG_THREAD
 	lwz	r11, RTAS_SP(r11)
 	cmpwi	cr1, r11, 0
 	bne	cr1, 7f
+#endif
 #endif /* CONFIG_PPC_CHRP */
 	EXCEPTION_PROLOG_1 for_rtas=1
 7:	EXCEPTION_PROLOG_2
-- 
2.27.0



