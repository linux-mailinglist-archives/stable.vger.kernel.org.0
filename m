Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA2490D93
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbiAQREA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:04:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241625AbiAQRCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:02:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB255B8114D;
        Mon, 17 Jan 2022 17:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097A6C36AF2;
        Mon, 17 Jan 2022 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438941;
        bh=MRETdH0R/JG+t6ZDfa9LEIzPGElTchgZ8fjTDMT/5lk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+2cN96UvCsWx73qSFjZV0JJWz0Dq4YxM7kscbhC9TLRQJM0kvny8P0HskJzDiPLd
         azPLQhjCYPGBsSu/0OmgsfcCSYqbVpRuHTmXYalvr36My5OhHg1X+5D3DIBRSdkAZ9
         5zBRmieQbRzPFEGqzGstRlhuailnHyA3Bwj3RZCyNE+NpAt3Rt/NQm+4HqrancQPtG
         W8qEJWXR+BH2yZfb38UC7lwMgPqgVMnsVbAU/2R/FaIo8sMBDhJ99Dyz7AHcpXSPx+
         uCpmFuwtQRtebFbSU9vZthlTJNb15o2X4lIhCU2TgRhbZ7DFkZFjt0ujmYBmGpSggb
         3cEazC3BubyqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 24/44] powerpc/40x: Map 32Mbytes of memory at startup
Date:   Mon, 17 Jan 2022 12:01:07 -0500
Message-Id: <20220117170127.1471115-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 06e7cbc29e97b4713b4ea6def04ae8501a7d1a59 ]

As reported by Carlo, 16Mbytes is not enough with modern kernels
that tend to be a bit big, so map another 16M page at boot.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/89b5f974a7fa5011206682cd092e2c905530ff46.1632755552.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_40x.S | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_40x.S b/arch/powerpc/kernel/head_40x.S
index 7d72ee5ab387c..e783860bea838 100644
--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -27,6 +27,7 @@
 
 #include <linux/init.h>
 #include <linux/pgtable.h>
+#include <linux/sizes.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -650,7 +651,7 @@ start_here:
 	b	.		/* prevent prefetch past rfi */
 
 /* Set up the initial MMU state so we can do the first level of
- * kernel initialization.  This maps the first 16 MBytes of memory 1:1
+ * kernel initialization.  This maps the first 32 MBytes of memory 1:1
  * virtual to physical and more importantly sets the cache mode.
  */
 initial_mmu:
@@ -687,6 +688,12 @@ initial_mmu:
 	tlbwe	r4,r0,TLB_DATA		/* Load the data portion of the entry */
 	tlbwe	r3,r0,TLB_TAG		/* Load the tag portion of the entry */
 
+	li	r0,62			/* TLB slot 62 */
+	addis	r4,r4,SZ_16M@h
+	addis	r3,r3,SZ_16M@h
+	tlbwe	r4,r0,TLB_DATA		/* Load the data portion of the entry */
+	tlbwe	r3,r0,TLB_TAG		/* Load the tag portion of the entry */
+
 	isync
 
 	/* Establish the exception vector base
-- 
2.34.1

