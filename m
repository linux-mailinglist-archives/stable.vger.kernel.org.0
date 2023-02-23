Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046686A0A27
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbjBWNNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbjBWNNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A356570B2
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 967E8CE206D
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83790C433EF;
        Thu, 23 Feb 2023 13:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157903;
        bh=/iEHLs0KpQuGAnTWn65nnYL9Uq7x7kyb4KgUxDjd1CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1sA4M8OsZAu+j0nlRG0Vgf8V75H/E96qX3TY8c+mcpPn3w6G2V0w9lZXJaapfHRXV
         90UUeMDO8LA2wm2eZ5FOb7cSOAsmqGAnLJeYmN7+FC0Tl6ByBedk+xbWx5aDaZMKJA
         Nws2rxFPPhMk1ChfuMZcavDX9FnbU6FAsiwtvr5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/36] powerpc/vmlinux.lds: Add an explicit symbol for the SRWX boundary
Date:   Thu, 23 Feb 2023 14:06:54 +0100
Message-Id: <20230223130429.924214142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit b150a4d12b919baf956b807aa305cf78df03d0fe ]

Currently __init_begin is used as the boundary for strict RWX between
executable/read-only text and data, and non-executable (after boot) code
and data.

But that's a little subtle, so add an explicit symbol to document that
the SRWX boundary lies there, and add a comment making it clear that
__init_begin must also begin there.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220916131422.318752-2-mpe@ellerman.id.au
Stable-dep-of: 111bcb373853 ("powerpc/64s/radix: Fix RWX mapping with relocated kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/sections.h      | 1 +
 arch/powerpc/kernel/vmlinux.lds.S        | 9 +++++++--
 arch/powerpc/mm/book3s32/mmu.c           | 2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c | 4 ++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
index 79cb7a25a5fb6..e92d39c0cd1d9 100644
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -9,6 +9,7 @@
 #include <asm-generic/sections.h>
 
 extern char __head_end[];
+extern char __srwx_boundary[];
 
 #ifdef __powerpc64__
 
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index bcbe41c6998ca..a664d0c4344a9 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -208,11 +208,16 @@ SECTIONS
 	}
 #endif
 
+	/*
+	 * Various code relies on __init_begin being at the strict RWX boundary.
+	 */
+	. = ALIGN(STRICT_ALIGN_SIZE);
+	__srwx_boundary = .;
+	__init_begin = .;
+
 /*
  * Init sections discarded at runtime
  */
-	. = ALIGN(STRICT_ALIGN_SIZE);
-	__init_begin = .;
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
 		INIT_TEXT
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index bfca0afe91126..692c336e4f55b 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -159,7 +159,7 @@ static unsigned long __init __mmu_mapin_ram(unsigned long base, unsigned long to
 unsigned long __init mmu_mapin_ram(unsigned long base, unsigned long top)
 {
 	unsigned long done;
-	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
+	unsigned long border = (unsigned long)__srwx_boundary - PAGE_OFFSET;
 	unsigned long size;
 
 	size = roundup_pow_of_two((unsigned long)_einittext - PAGE_OFFSET);
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index a339cb5de5dd1..52e27fd995da7 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -260,8 +260,8 @@ print_mapping(unsigned long start, unsigned long end, unsigned long size, bool e
 static unsigned long next_boundary(unsigned long addr, unsigned long end)
 {
 #ifdef CONFIG_STRICT_KERNEL_RWX
-	if (addr < __pa_symbol(__init_begin))
-		return __pa_symbol(__init_begin);
+	if (addr < __pa_symbol(__srwx_boundary))
+		return __pa_symbol(__srwx_boundary);
 #endif
 	return end;
 }
-- 
2.39.0



