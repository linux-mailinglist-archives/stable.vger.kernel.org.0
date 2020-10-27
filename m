Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F429BCB5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811011AbgJ0Qgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766397AbgJ0Prv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D85204EF;
        Tue, 27 Oct 2020 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813670;
        bh=t68tp8bSwHQXP2i7QZUSWg0VOmCsE5Ba5w1WVPnpz4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdunPZjPN0XLwZ3hE7Wp8Mvqeh6OUEWSAvzRH0PuevJ+HmTfinJYPCTKEn/aNK+IC
         U9guwrGeX7U99y+UUeEb23uqgjNG/9u4jvNBqMkW4sUPr3OITGvmYsAbD60QRZglkm
         qndyO8sJbo1ZpZD1J77q4rE+fPMYVf5te/A8Wfk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 630/757] powerpc/64s: Remove TM from Power10 features
Date:   Tue, 27 Oct 2020 14:54:40 +0100
Message-Id: <20201027135520.095060879@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit ec613a57fa1d57381f890c3166175fe68cf43f12 ]

ISA v3.1 removes transactional memory and hence it should not be present
in cpu_features or cpu_user_features2. Remove CPU_FTR_TM_COMP from
CPU_FTRS_POWER10. Remove PPC_FEATURE2_HTM_COMP and
PPC_FEATURE2_HTM_NOSC_COMP from COMMON_USER2_POWER10.

Fixes: a3ea40d5c736 ("powerpc: Add POWER10 architected mode")
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200827035529.900-1-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cputable.h |  2 +-
 arch/powerpc/kernel/cputable.c      | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 32a15dc49e8ca..ade681c1d4095 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -483,7 +483,7 @@ static inline void cpu_feature_keys_init(void) { }
 	    CPU_FTR_STCX_CHECKS_ADDRESS | CPU_FTR_POPCNTB | CPU_FTR_POPCNTD | \
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_ARCH_207S | \
-	    CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | CPU_FTR_ARCH_31 | \
+	    CPU_FTR_ARCH_300 | CPU_FTR_ARCH_31 | \
 	    CPU_FTR_DAWR | CPU_FTR_DAWR1)
 #define CPU_FTRS_CELL	(CPU_FTR_LWSYNC | \
 	    CPU_FTR_PPCAS_ARCH_V2 | CPU_FTR_CTRL | \
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 2aa89c6b28967..0d704f1e07739 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -120,9 +120,16 @@ extern void __restore_cpu_e6500(void);
 				 PPC_FEATURE2_DARN | \
 				 PPC_FEATURE2_SCV)
 #define COMMON_USER_POWER10	COMMON_USER_POWER9
-#define COMMON_USER2_POWER10	(COMMON_USER2_POWER9 | \
-				 PPC_FEATURE2_ARCH_3_1 | \
-				 PPC_FEATURE2_MMA)
+#define COMMON_USER2_POWER10	(PPC_FEATURE2_ARCH_3_1 | \
+				 PPC_FEATURE2_MMA | \
+				 PPC_FEATURE2_ARCH_3_00 | \
+				 PPC_FEATURE2_HAS_IEEE128 | \
+				 PPC_FEATURE2_DARN | \
+				 PPC_FEATURE2_SCV | \
+				 PPC_FEATURE2_ARCH_2_07 | \
+				 PPC_FEATURE2_DSCR | \
+				 PPC_FEATURE2_ISEL | PPC_FEATURE2_TAR | \
+				 PPC_FEATURE2_VEC_CRYPTO)
 
 #ifdef CONFIG_PPC_BOOK3E_64
 #define COMMON_USER_BOOKE	(COMMON_USER_PPC64 | PPC_FEATURE_BOOKE)
-- 
2.25.1



