Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8518B463769
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242749AbhK3Ox3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242746AbhK3Owh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ADFC0613F6;
        Tue, 30 Nov 2021 06:48:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7BCB81A22;
        Tue, 30 Nov 2021 14:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E21C53FC1;
        Tue, 30 Nov 2021 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283710;
        bh=Or+rphS/DIxiLVxUPs0uu1VUl3TELVGbxF0kTlRLYx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm/41jMADOQEAt+c2jInlh9YXejHhk+jy0aT/S9CeAMyX6jcNJbVbc0io4z+e2gjU
         oBJjEJNzitOcm0UDkz2GQqQegJfQbdBhJcQC8bhdycOgWzXn00qZkC9pLuMNjKdHro
         8ZWx+EiBwgTwGom5WMZIx32r8odIZuTfHE8zwn+LIZcln8WuyDNXTzoxRlNzfAMJyo
         dNuTMoSJOp8tgUaaEWnd9Ijoga784WljM2KEwC4ZXnOo24FhxRQXW0b56JBvTPFfwx
         BOiBXkOM41EFGr4jWo50JIp+Jf2mDPAG2TcgpFR4Rf1MT0WHxnL9PddVOGcNh8nvbB
         MnUqWsxpOxSZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        dave.anglin@bell.net, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/68] parisc: Convert PTE lookup to use extru_safe() macro
Date:   Tue, 30 Nov 2021 09:46:25 -0500
Message-Id: <20211130144707.944580-29-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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
index 437c8d31f3907..625c19884905b 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -393,17 +393,9 @@
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
 #if CONFIG_PGTABLE_LEVELS < 3
@@ -413,7 +405,7 @@
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

