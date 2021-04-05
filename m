Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8704353DFC
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhDEJDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237624AbhDEJDS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E8461002;
        Mon,  5 Apr 2021 09:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613392;
        bh=MvspNmx/BQ2U6lxFhhm7YQJAvRh6QOInlWJfeIGGQP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YU1CfGclx1Ljpk60jPwG6Kb2U3IlbvKpu8OmUUMxpgAl9IbB6vFmIhhKJkobovFPc
         5vcx2axzZ4H/uI0yL9D3cfL0KYLFblr+p0k7fXBCXvvNjIElc76wUPrpe8NpsfLXVS
         vopmSXiQrN4ZJgs69fVByakIE2K/Ux/Pcv4dfLQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/74] powerpc: Force inlining of cpu_has_feature() to avoid build failure
Date:   Mon,  5 Apr 2021 10:53:44 +0200
Message-Id: <20210405085025.380053276@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



