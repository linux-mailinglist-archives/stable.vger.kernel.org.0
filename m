Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7C8D22FC
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbfJJIig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387635AbfJJIid (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:38:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 852B7218AC;
        Thu, 10 Oct 2019 08:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696713;
        bh=y5aWi6JFqE7hG9IoPsDAQ3ZREBJm3293HIapSjdFlLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhfVtziDjHdyM48C5si2Q/pO6tt+OZQyv+j9AWRcYhttwDxETb+kgPRCw8EI80NlR
         zXtQ3s0bCJpyKIHAS6t6XoPWnQvQMESLopUQzU+QaiX+Zig6Y60CFlYuWTLCnhvf7s
         CeQyevV0Js3Tq3Hj8E99sekHX27191qy4t6fYz6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Neuschafer <j.neuschaefer@gmx.net>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.3 025/148] powerpc/32s: Fix boot failure with DEBUG_PAGEALLOC without KASAN.
Date:   Thu, 10 Oct 2019 10:34:46 +0200
Message-Id: <20191010083612.646600033@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 9d6d712fbf7766f21c838940eebcd7b4d476c5e6 upstream.

When KASAN is selected, the definitive hash table has to be
set up later, but there is already an early temporary one.

When KASAN is not selected, there is no early hash table,
so the setup of the definitive hash table cannot be delayed.

Fixes: 72f208c6a8f7 ("powerpc/32s: move hash code patching out of MMU_init_hw()")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Jonathan Neuschafer <j.neuschaefer@gmx.net>
Tested-by: Jonathan Neuschafer <j.neuschaefer@gmx.net>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b7860c5e1e784d6b96ba67edf47dd6cbc2e78ab6.1565776892.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_32.S  |    2 ++
 arch/powerpc/mm/book3s32/mmu.c |    9 +++++++++
 2 files changed, 11 insertions(+)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -897,9 +897,11 @@ start_here:
 	bl	machine_init
 	bl	__save_cpu_setup
 	bl	MMU_init
+#ifdef CONFIG_KASAN
 BEGIN_MMU_FTR_SECTION
 	bl	MMU_init_hw_patch
 END_MMU_FTR_SECTION_IFSET(MMU_FTR_HPTE_TABLE)
+#endif
 
 /*
  * Go back to running unmapped so we can load up new values
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -358,6 +358,15 @@ void __init MMU_init_hw(void)
 	hash_mb2 = hash_mb = 32 - LG_HPTEG_SIZE - lg_n_hpteg;
 	if (lg_n_hpteg > 16)
 		hash_mb2 = 16 - LG_HPTEG_SIZE;
+
+	/*
+	 * When KASAN is selected, there is already an early temporary hash
+	 * table and the switch to the final hash table is done later.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN))
+		return;
+
+	MMU_init_hw_patch();
 }
 
 void __init MMU_init_hw_patch(void)


