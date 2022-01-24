Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B15499111
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356431AbiAXUJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59946 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353551AbiAXUDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3B06131D;
        Mon, 24 Jan 2022 20:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28C1C340E5;
        Mon, 24 Jan 2022 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054607;
        bh=LeyIUgvkFtpWE6KUzBcR44hgBmbAuYis0U7utztFNFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGQQDY/HwEHrisLD+MRjFojNdAvqI2VNuD0uR73/qjU4UzxCv/pkYQxsuudeHM7+g
         LgnNG/OfJty2WPuxkI7psdJmCH9gVjBjkbEDzW4lpbWDWWd9dzsYgyhDWHih1RkLSf
         G91rT9bndQbhB8zH9JaF5XNUMLzf48uG56DZE2IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 427/563] powerpc/40x: Map 32Mbytes of memory at startup
Date:   Mon, 24 Jan 2022 19:43:12 +0100
Message-Id: <20220124184039.220968113@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a1ae00689e0f4..aeb9bc9958749 100644
--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -27,6 +27,7 @@
 
 #include <linux/init.h>
 #include <linux/pgtable.h>
+#include <linux/sizes.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -626,7 +627,7 @@ start_here:
 	b	.		/* prevent prefetch past rfi */
 
 /* Set up the initial MMU state so we can do the first level of
- * kernel initialization.  This maps the first 16 MBytes of memory 1:1
+ * kernel initialization.  This maps the first 32 MBytes of memory 1:1
  * virtual to physical and more importantly sets the cache mode.
  */
 initial_mmu:
@@ -663,6 +664,12 @@ initial_mmu:
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



