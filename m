Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334C04D8391
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiCNMRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240860AbiCNMQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525633465C;
        Mon, 14 Mar 2022 05:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA92612FF;
        Mon, 14 Mar 2022 12:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA276C340E9;
        Mon, 14 Mar 2022 12:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259912;
        bh=goGPS0/NtJl6pel8mha0NruBMTGuqFC9n5/ssjqFxmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHi+nw55rfHugQitgvNMCDmBsg+MNsDemYr/R+es4Jloa+mcdvdWUK5E9TX/aqeg/
         aHGjQOlve2BP+HDUcY0iZ7FTOXCZRRqe/uGD9fJWPt9gPGG3QWCgUq0gIE9Cihs5V4
         bTYbUOXcl9Z9+mosmQROLsOpllQ+sTVYNKz8PB1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 5.15 085/110] arm64: Ensure execute-only permissions are not allowed without EPAN
Date:   Mon, 14 Mar 2022 12:54:27 +0100
Message-Id: <20220314112745.403315496@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 6e2edd6371a497a6350bb735534c9bda2a31f43d upstream.

Commit 18107f8a2df6 ("arm64: Support execute-only permissions with
Enhanced PAN") re-introduced execute-only permissions when EPAN is
available. When EPAN is not available, arch_filter_pgprot() is supposed
to change a PAGE_EXECONLY permission into PAGE_READONLY_EXEC. However,
if BTI or MTE are present, such check does not detect the execute-only
pgprot in the presence of PTE_GP (BTI) or MT_NORMAL_TAGGED (MTE),
allowing the user to request PROT_EXEC with PROT_BTI or PROT_MTE.

Remove the arch_filter_pgprot() function, change the default VM_EXEC
permissions to PAGE_READONLY_EXEC and update the protection_map[] array
at core_initcall() if EPAN is detected.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 18107f8a2df6 ("arm64: Support execute-only permissions with Enhanced PAN")
Cc: <stable@vger.kernel.org> # 5.13.x
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig                    |    3 ---
 arch/arm64/include/asm/pgtable-prot.h |    4 ++--
 arch/arm64/include/asm/pgtable.h      |   12 ------------
 arch/arm64/mm/mmap.c                  |   17 +++++++++++++++++
 4 files changed, 19 insertions(+), 17 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1053,9 +1053,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config ARCH_HAS_FILTER_PGPROT
-	def_bool y
-
 # Supported by clang >= 7.0
 config CC_HAVE_SHADOW_CALL_STACK
 	def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -92,7 +92,7 @@ extern bool arm64_use_ng_mappings;
 #define __P001  PAGE_READONLY
 #define __P010  PAGE_READONLY
 #define __P011  PAGE_READONLY
-#define __P100  PAGE_EXECONLY
+#define __P100  PAGE_READONLY_EXEC	/* PAGE_EXECONLY if Enhanced PAN */
 #define __P101  PAGE_READONLY_EXEC
 #define __P110  PAGE_READONLY_EXEC
 #define __P111  PAGE_READONLY_EXEC
@@ -101,7 +101,7 @@ extern bool arm64_use_ng_mappings;
 #define __S001  PAGE_READONLY
 #define __S010  PAGE_SHARED
 #define __S011  PAGE_SHARED
-#define __S100  PAGE_EXECONLY
+#define __S100  PAGE_READONLY_EXEC	/* PAGE_EXECONLY if Enhanced PAN */
 #define __S101  PAGE_READONLY_EXEC
 #define __S110  PAGE_SHARED_EXEC
 #define __S111  PAGE_SHARED_EXEC
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1017,18 +1017,6 @@ static inline bool arch_wants_old_prefau
 }
 #define arch_wants_old_prefaulted_pte	arch_wants_old_prefaulted_pte
 
-static inline pgprot_t arch_filter_pgprot(pgprot_t prot)
-{
-	if (cpus_have_const_cap(ARM64_HAS_EPAN))
-		return prot;
-
-	if (pgprot_val(prot) != pgprot_val(PAGE_EXECONLY))
-		return prot;
-
-	return PAGE_READONLY_EXEC;
-}
-
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ASM_PGTABLE_H */
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -7,8 +7,10 @@
 
 #include <linux/io.h>
 #include <linux/memblock.h>
+#include <linux/mm.h>
 #include <linux/types.h>
 
+#include <asm/cpufeature.h>
 #include <asm/page.h>
 
 /*
@@ -38,3 +40,18 @@ int valid_mmap_phys_addr_range(unsigned
 {
 	return !(((pfn << PAGE_SHIFT) + size) & ~PHYS_MASK);
 }
+
+static int __init adjust_protection_map(void)
+{
+	/*
+	 * With Enhanced PAN we can honour the execute-only permissions as
+	 * there is no PAN override with such mappings.
+	 */
+	if (cpus_have_const_cap(ARM64_HAS_EPAN)) {
+		protection_map[VM_EXEC] = PAGE_EXECONLY;
+		protection_map[VM_EXEC | VM_SHARED] = PAGE_EXECONLY;
+	}
+
+	return 0;
+}
+arch_initcall(adjust_protection_map);


