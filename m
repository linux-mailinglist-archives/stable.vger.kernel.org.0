Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2A4638D9
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244762AbhK3PGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242943AbhK3O5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:57:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502EEC0698CA;
        Tue, 30 Nov 2021 06:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AF97B81A4D;
        Tue, 30 Nov 2021 14:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38ADC53FCD;
        Tue, 30 Nov 2021 14:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283869;
        bh=oGxz23YAkk3Yiv9CNxq7yYjjVJDbaNfQm/HJFeV+cNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRpE1Ix2nS9iNJqiM6CMc67K9zBi81X7eayJ2qPcEHDdBG9oqiAPBnA3QnG8sZTaR
         xFdrzl+/CdRHqf4f3aY3a76QegZBIRIIsU3li0FVS3NbET28vFOAKcFxgztiGi9cc7
         QNv0IiAR92XC62HQ9hd58y68KkQzEqd9Wrdb0o2S8fu8l+VHb+wUki4sa7Bk+9Qlkw
         RRt7ibYCmi+fdFLXX2l5ZS2VQiPc67ducnRKCKs2N5C6hElLQS1Mf6aMxSJJ0hlT/3
         Ip/25Izwe6h3LycFxWAxcBZFSbXe2blHd2tQrnlVowQGLvU63j4eFHiKsoXn1kz7sY
         nNxGMRMUiTDCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        dave.anglin@bell.net, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/43] parisc: Convert PTE lookup to use extru_safe() macro
Date:   Tue, 30 Nov 2021 09:49:56 -0500
Message-Id: <20211130145022.945517-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 3fbdc121bd051d9f1b3b2e232ad734c44b47d32c ]

Convert the PTE lookup functions to use the safer extru_safe macro.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/entry.S | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 3da39140babcf..420097af7cc1b 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -394,17 +394,9 @@
 	 */
 	.macro		L2_ptep	pmd,pte,index,va,fault
 #if CONFIG_PGTABLE_LEVELS == 3
-	extru		\va,31-ASM_PMD_SHIFT,ASM_BITS_PER_PMD,\index
+	extru_safe	\va,31-ASM_PMD_SHIFT,ASM_BITS_PER_PMD,\index
 #else
-# if defined(CONFIG_64BIT)
-	extrd,u		\va,63-ASM_PGDIR_SHIFT,ASM_BITS_PER_PGD,\index
-  #else
-  # if PAGE_SIZE > 4096
-	extru		\va,31-ASM_PGDIR_SHIFT,32-ASM_PGDIR_SHIFT,\index
-  # else
-	extru		\va,31-ASM_PGDIR_SHIFT,ASM_BITS_PER_PGD,\index
-  # endif
-# endif
+	extru_safe	\va,31-ASM_PGDIR_SHIFT,ASM_BITS_PER_PGD,\index
 #endif
 	dep             %r0,31,PAGE_SHIFT,\pmd  /* clear offset */
 	copy		%r0,\pte
@@ -412,7 +404,7 @@
 	bb,>=,n		\pmd,_PxD_PRESENT_BIT,\fault
 	dep		%r0,31,PxD_FLAG_SHIFT,\pmd /* clear flags */
 	SHLREG		\pmd,PxD_VALUE_SHIFT,\pmd
-	extru		\va,31-PAGE_SHIFT,ASM_BITS_PER_PTE,\index
+	extru_safe	\va,31-PAGE_SHIFT,ASM_BITS_PER_PTE,\index
 	dep		%r0,31,PAGE_SHIFT,\pmd  /* clear offset */
 	shladd		\index,BITS_PER_PTE_ENTRY,\pmd,\pmd /* pmd is now pte */
 	.endm
-- 
2.33.0

