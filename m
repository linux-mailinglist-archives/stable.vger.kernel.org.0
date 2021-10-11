Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5039428EA8
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhJKNvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237274AbhJKNuf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C8160F35;
        Mon, 11 Oct 2021 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960103;
        bh=ClNd6uSN0EqgLvT6FzR81C+1IlmjiccNfJiEPhk1ZX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lG/DUnOS/KqhFkMV84/zuAjgt76/sDmDvfcLbbhc6XT2/BzcAGIjb9Z8GVeiCMB0J
         1t4Wx6T22GDntgyYcN0Fi80k1OLFv2XOrURhoLpGaTkBQYjdZ7ZGlwqlgBtdK68gYP
         gKZ+Fr9a4bER683jGVImazp2c9KKf5ybYu2Iy+5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/52] xtensa: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Mon, 11 Oct 2021 15:45:51 +0200
Message-Id: <20211011134504.487816486@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d67ed2510d28a1eb33171010d35cf52178cfcbdd ]

CONFIG_OF can be set by a randconfig or by a user -- without setting the
early flattree option (OF_EARLY_FLATTREE).  This causes build errors.
However, if randconfig or a user sets USE_OF in the Xtensa config,
the right kconfig symbols are set to fix the build.

Fixes these build errors:

../arch/xtensa/kernel/setup.c:67:19: error: ‘__dtb_start’ undeclared here (not in a function); did you mean ‘dtb_start’?
   67 | void *dtb_start = __dtb_start;
      |                   ^~~~~~~~~~~
../arch/xtensa/kernel/setup.c: In function 'xtensa_dt_io_area':
../arch/xtensa/kernel/setup.c:201:14: error: implicit declaration of function 'of_flat_dt_is_compatible'; did you mean 'of_machine_is_compatible'? [-Werror=implicit-function-declaration]
  201 |         if (!of_flat_dt_is_compatible(node, "simple-bus"))
../arch/xtensa/kernel/setup.c:204:18: error: implicit declaration of function 'of_get_flat_dt_prop' [-Werror=implicit-function-declaration]
  204 |         ranges = of_get_flat_dt_prop(node, "ranges", &len);
../arch/xtensa/kernel/setup.c:204:16: error: assignment to 'const __be32 *' {aka 'const unsigned int *'} from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
  204 |         ranges = of_get_flat_dt_prop(node, "ranges", &len);
      |                ^
../arch/xtensa/kernel/setup.c: In function 'early_init_devtree':
../arch/xtensa/kernel/setup.c:228:9: error: implicit declaration of function 'early_init_dt_scan'; did you mean 'early_init_devtree'? [-Werror=implicit-function-declaration]
  228 |         early_init_dt_scan(params);
../arch/xtensa/kernel/setup.c:229:9: error: implicit declaration of function 'of_scan_flat_dt' [-Werror=implicit-function-declaration]
  229 |         of_scan_flat_dt(xtensa_dt_io_area, NULL);

xtensa-elf-ld: arch/xtensa/mm/mmu.o:(.text+0x0): undefined reference to `xtensa_kio_paddr'

Fixes: da844a81779e ("xtensa: add device trees support")
Fixes: 6cb971114f63 ("xtensa: remap io area defined in device tree")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/include/asm/kmem_layout.h |  2 +-
 arch/xtensa/kernel/setup.c            | 12 ++++++------
 arch/xtensa/mm/mmu.c                  |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/xtensa/include/asm/kmem_layout.h b/arch/xtensa/include/asm/kmem_layout.h
index 7cbf68ca7106..6fc05cba61a2 100644
--- a/arch/xtensa/include/asm/kmem_layout.h
+++ b/arch/xtensa/include/asm/kmem_layout.h
@@ -78,7 +78,7 @@
 #endif
 #define XCHAL_KIO_SIZE			0x10000000
 
-#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_OF)
+#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_USE_OF)
 #define XCHAL_KIO_PADDR			xtensa_get_kio_paddr()
 #ifndef __ASSEMBLY__
 extern unsigned long xtensa_kio_paddr;
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index d08172138369..5a25bc2b8052 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -64,7 +64,7 @@ extern unsigned long initrd_end;
 extern int initrd_below_start_ok;
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 void *dtb_start = __dtb_start;
 #endif
 
@@ -126,7 +126,7 @@ __tagtable(BP_TAG_INITRD, parse_tag_initrd);
 
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static int __init parse_tag_fdt(const bp_tag_t *tag)
 {
@@ -136,7 +136,7 @@ static int __init parse_tag_fdt(const bp_tag_t *tag)
 
 __tagtable(BP_TAG_FDT, parse_tag_fdt);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
 
 static int __init parse_tag_cmdline(const bp_tag_t* tag)
 {
@@ -184,7 +184,7 @@ static int __init parse_bootparam(const bp_tag_t *tag)
 }
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 #if !XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY
 unsigned long xtensa_kio_paddr = XCHAL_KIO_DEFAULT_PADDR;
@@ -233,7 +233,7 @@ void __init early_init_devtree(void *params)
 		strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 }
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
 
 /*
  * Initialize architecture. (Early stage)
@@ -254,7 +254,7 @@ void __init init_arch(bp_tag_t *bp_start)
 	if (bp_start)
 		parse_bootparam(bp_start);
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 	early_init_devtree(dtb_start);
 #endif
 
diff --git a/arch/xtensa/mm/mmu.c b/arch/xtensa/mm/mmu.c
index 03678c4afc39..bc858a7f98ba 100644
--- a/arch/xtensa/mm/mmu.c
+++ b/arch/xtensa/mm/mmu.c
@@ -101,7 +101,7 @@ void init_mmu(void)
 
 void init_kio(void)
 {
-#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY && defined(CONFIG_OF)
+#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY && defined(CONFIG_USE_OF)
 	/*
 	 * Update the IO area mapping in case xtensa_kio_paddr has changed
 	 */
-- 
2.33.0



