Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E542458C8A3
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 14:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbiHHMxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 08:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242986AbiHHMxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 08:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A20DF05;
        Mon,  8 Aug 2022 05:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57D68611B1;
        Mon,  8 Aug 2022 12:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0DBC433C1;
        Mon,  8 Aug 2022 12:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659963208;
        bh=BmIftkQ0BzMbYotXaR2i1XOZ3mRUNcoQMmDFYPC3egk=;
        h=From:To:Cc:Subject:Date:From;
        b=it47u2D7EoHexGB/oK8cSgI70d1TB6ZsbijH1HlcDoPkhIJDbi0ft6HozazrLV81w
         PAwjUsSiUuMqF/Fu2EPsUdMsFK4GmXI5j4sCJLUI4trb62OR1aBXgBX5LUlNDgEkB1
         FDBbBETMuJBrldDoLXN+4tunfy3AM0TNyhf+Dw2pTpWjhrcW0fqVa6eMyNeu0yB7mr
         uTLM9VwEIX0weCL1hUyqJpdREBd7+AvuvN4sxoisIJm6mJ/f7TlYDDWa9fOXuQllLB
         WRx9XgVp2uPb/S1ho98dr1kGk+zna+Ign4CWeMco0eQ4jYOPLvztVdU90pTOM6Yloc
         dRzNXRM+Hjoug==
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Collingbourne <pcc@google.com>, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH][for-stable] arm64: set UXN on swapper page tables
Date:   Mon,  8 Aug 2022 13:53:21 +0100
Message-Id: <20220808125321.32598-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

[ This issue was fixed upstream by accident in c3cee924bd85 ("arm64:
  head: cover entire kernel image in initial ID map") as part of a
  large refactoring of the arm64 boot flow. This simple fix is therefore
  preferred for -stable backporting ]

On a system that implements FEAT_EPAN, read/write access to the idmap
is denied because UXN is not set on the swapper PTEs. As a result,
idmap_kpti_install_ng_mappings panics the kernel when accessing
__idmap_kpti_flag. Fix it by setting UXN on these PTEs.

Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
Cc: <stable@vger.kernel.org> # 5.15
Link: https://linux-review.googlesource.com/id/Ic452fa4b4f74753e54f71e61027e7222a0fae1b1
Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20220719234909.1398992-1-pcc@google.com
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kernel-pgtable.h | 4 ++--
 arch/arm64/kernel/head.S                | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 96dc0f7da258..a971d462f531 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -103,8 +103,8 @@
 /*
  * Initial memory map attributes.
  */
-#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED)
-#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S)
+#define SWAPPER_PTE_FLAGS	(PTE_TYPE_PAGE | PTE_AF | PTE_SHARED | PTE_UXN)
+#define SWAPPER_PMD_FLAGS	(PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S | PMD_SECT_UXN)
 
 #if ARM64_KERNEL_USES_PMD_MAPS
 #define SWAPPER_MM_MMUFLAGS	(PMD_ATTRINDX(MT_NORMAL) | SWAPPER_PMD_FLAGS)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6a98f1a38c29..8a93a0a7489b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -285,7 +285,7 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 	subs	x1, x1, #64
 	b.ne	1b
 
-	mov	x7, SWAPPER_MM_MMUFLAGS
+	mov_q	x7, SWAPPER_MM_MMUFLAGS
 
 	/*
 	 * Create the identity mapping.
-- 
2.37.1.559.g78731f0fdb-goog

