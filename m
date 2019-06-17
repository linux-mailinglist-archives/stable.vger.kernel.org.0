Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71B94818C
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 14:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfFQMJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 08:09:45 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:53599 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFQMJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 08:09:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8DE89557;
        Mon, 17 Jun 2019 08:09:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Jun 2019 08:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5R7A3G
        hFB+HfYNX7NzyEVpMPXFS4XuYhm/NiWtAhbRo=; b=dTIhEOJXVoblwvA1jSrHTj
        8Y5GcPuwxwn9tFJooufUhFOkNoLj6GgR8CX0KUdRBD4aZEJew8ghbzkKFyIO7ERK
        +BWeGNV2X+jB9W/+asE7a4GDKDD4xCj5De70ro0qtJz9k0uAlU2e1jEfO5TaCrUk
        g4lWffrZ9qhgTUZArknqSlhl0nes6EoqW1K2jmNaqV2NmP1xZX6ku7TpgnPPt0iC
        3Wjk0F7gmdYjmOlS8I0zoOZrzNWxrfm8DrEyezcv71tkUyEbuGCy4klKCxGJLJ3S
        0D47pwLGeFhF3ULw96SR9XI+RpsP/ejoz2r8e5VDyutwcTU1ClwLHvuFcU8VeZuA
        ==
X-ME-Sender: <xms:BIMHXdsF6Wfd0o65dLm5P0Q2qJW2zvtsV7icMQecLS6l5eJDRvHoiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeijedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:BIMHXbb4ED8T4g-EYs8hkuuKTpMClpUgnLRF29OaD3UBN4TNtgbBjg>
    <xmx:BIMHXcRGyh3PltjFJkQPW56VZ-7xNUi5iHio7-f_wJ1zOVYSVV7ycQ>
    <xmx:BIMHXXU_if699k773PiUYUIXnowfWy8Ig2zitgshM58W9gysd-EzWA>
    <xmx:BYMHXaIi35TJmyjLq8lV44hMBAoNGd_Do_6Qn8oPQ4TR3aQq2Q_-ug>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA3EB380085;
        Mon, 17 Jun 2019 08:09:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64s: __find_linux_pte() synchronization vs" failed to apply to 5.1-stable tree
To:     npiggin@gmail.com, aneesh.kumar@linux.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Jun 2019 14:09:37 +0200
Message-ID: <15607733777254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a00196a272161338d4b1d66ec69e3d57c6b280e0 Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Fri, 7 Jun 2019 13:56:36 +1000
Subject: [PATCH] powerpc/64s: __find_linux_pte() synchronization vs
 pmdp_invalidate()

The change to pmdp_invalidate() to mark the pmd with _PAGE_INVALID
broke the synchronisation against lock free lookups,
__find_linux_pte()'s pmd_none() check no longer returns true for such
cases.

Fix this by adding a check for this condition as well.

Fixes: da7ad366b497 ("powerpc/mm/book3s: Update pmd_present to look at _PAGE_PRESENT bit")
Cc: stable@vger.kernel.org # v4.20+
Suggested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index db4a6253df92..533fc6fa6726 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -372,13 +372,25 @@ pte_t *__find_linux_pte(pgd_t *pgdir, unsigned long ea,
 	pdshift = PMD_SHIFT;
 	pmdp = pmd_offset(&pud, ea);
 	pmd  = READ_ONCE(*pmdp);
+
 	/*
-	 * A hugepage collapse is captured by pmd_none, because
-	 * it mark the pmd none and do a hpte invalidate.
+	 * A hugepage collapse is captured by this condition, see
+	 * pmdp_collapse_flush.
 	 */
 	if (pmd_none(pmd))
 		return NULL;
 
+#ifdef CONFIG_PPC_BOOK3S_64
+	/*
+	 * A hugepage split is captured by this condition, see
+	 * pmdp_invalidate.
+	 *
+	 * Huge page modification can be caught here too.
+	 */
+	if (pmd_is_serializing(pmd))
+		return NULL;
+#endif
+
 	if (pmd_trans_huge(pmd) || pmd_devmap(pmd)) {
 		if (is_thp)
 			*is_thp = true;

