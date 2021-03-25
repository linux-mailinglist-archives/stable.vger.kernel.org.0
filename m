Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589C1348F72
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCYL1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231177AbhCYL0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 929C561A34;
        Thu, 25 Mar 2021 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671587;
        bh=MvspNmx/BQ2U6lxFhhm7YQJAvRh6QOInlWJfeIGGQP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op4lhtXpH4+JZBNTK6Als9+FV0JJg4OSHgfEzt/spZe8T1zl3n23cM0pJ8npKNBWd
         c6c7PacjxRiOPZSSC5GLKU1IuuNdvLn5yBcSjSiVqgQtyE7ip43795hj0KGi97nPcL
         jJrJgcM+JxPNJer8cg7uWhgeDwsjdTrFgvLgsnvm47S3+75jL9T4nmbx4CvvDOq2fj
         7nZbPegpFNCZxqrlMQyRSdlspeH/60CYGUOF5guDs5EYhDWNnARcPWn9ZbIRW+ioGy
         RlHbPPmv1PuReU2MeIm8tad6rLjG44+b/Eo1LimMeXYk3VKj9kxYbBWzP/2gmThLdR
         7WLsGhTGVb1rw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 21/39] powerpc: Force inlining of cpu_has_feature() to avoid build failure
Date:   Thu, 25 Mar 2021 07:25:40 -0400
Message-Id: <20210325112558.1927423-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit eed5fae00593ab9d261a0c1ffc1bdb786a87a55a ]

The code relies on constant folding of cpu_has_feature() based
on possible and always true values as defined per
CPU_FTRS_ALWAYS and CPU_FTRS_POSSIBLE.

Build failure is encountered with for instance
book3e_all_defconfig on kisskb in the AMDGPU driver which uses
cpu_has_feature(CPU_FTR_VSX_COMP) to decide whether calling
kernel_enable_vsx() or not.

The failure is due to cpu_has_feature() not being inlined with
that configuration with gcc 4.9.

In the same way as commit acdad8fb4a15 ("powerpc: Force inlining of
mmu_has_feature to fix build failure"), for inlining of
cpu_has_feature().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b231dfa040ce4cc37f702f5c3a595fdeabfe0462.1615378209.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cpu_has_feature.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/cpu_has_feature.h b/arch/powerpc/include/asm/cpu_has_feature.h
index 7897d16e0990..727d4b321937 100644
--- a/arch/powerpc/include/asm/cpu_has_feature.h
+++ b/arch/powerpc/include/asm/cpu_has_feature.h
@@ -7,7 +7,7 @@
 #include <linux/bug.h>
 #include <asm/cputable.h>
 
-static inline bool early_cpu_has_feature(unsigned long feature)
+static __always_inline bool early_cpu_has_feature(unsigned long feature)
 {
 	return !!((CPU_FTRS_ALWAYS & feature) ||
 		  (CPU_FTRS_POSSIBLE & cur_cpu_spec->cpu_features & feature));
@@ -46,7 +46,7 @@ static __always_inline bool cpu_has_feature(unsigned long feature)
 	return static_branch_likely(&cpu_feature_keys[i]);
 }
 #else
-static inline bool cpu_has_feature(unsigned long feature)
+static __always_inline bool cpu_has_feature(unsigned long feature)
 {
 	return early_cpu_has_feature(feature);
 }
-- 
2.30.1

