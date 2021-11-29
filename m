Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B4646270C
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhK2XA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbhK2XAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A54C03AA3E;
        Mon, 29 Nov 2021 10:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DC2EB815BE;
        Mon, 29 Nov 2021 18:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAB0C53FAD;
        Mon, 29 Nov 2021 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210018;
        bh=rfakzb2/ZLX9xsJU+vnKWIjBnsh7rb7hRdajVcrg/Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvTdpWZSSCscWNZvE2A9b9QXBMLOj72og38VOUqnAPcnu6R9zgUBF3/3JV7t9MMGP
         GYkOmuWF36WTnpAuyI98pdHY5fXP3IAhUra4L7DIT3hqfreiDQ1mTHTBVTTdV9gXyN
         i1AltlrraR1RpRYcbQNqhmV/FbQ3UZbmqlZvVNIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4.19 15/69] xtensa: use CONFIG_USE_OF instead of CONFIG_OF
Date:   Mon, 29 Nov 2021 19:17:57 +0100
Message-Id: <20211129181704.163228936@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit d67ed2510d28a1eb33171010d35cf52178cfcbdd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/vectors.h |    2 +-
 arch/xtensa/kernel/setup.c        |   12 ++++++------
 arch/xtensa/mm/mmu.c              |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/xtensa/include/asm/vectors.h
+++ b/arch/xtensa/include/asm/vectors.h
@@ -31,7 +31,7 @@
 #endif
 #define XCHAL_KIO_SIZE			0x10000000
 
-#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_OF)
+#if (!XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY) && defined(CONFIG_USE_OF)
 #define XCHAL_KIO_PADDR			xtensa_get_kio_paddr()
 #ifndef __ASSEMBLY__
 extern unsigned long xtensa_kio_paddr;
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -65,7 +65,7 @@ int initrd_is_mapped = 0;
 extern int initrd_below_start_ok;
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 void *dtb_start = __dtb_start;
 #endif
 
@@ -127,7 +127,7 @@ __tagtable(BP_TAG_INITRD, parse_tag_init
 
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 static int __init parse_tag_fdt(const bp_tag_t *tag)
 {
@@ -137,7 +137,7 @@ static int __init parse_tag_fdt(const bp
 
 __tagtable(BP_TAG_FDT, parse_tag_fdt);
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
 
 static int __init parse_tag_cmdline(const bp_tag_t* tag)
 {
@@ -185,7 +185,7 @@ static int __init parse_bootparam(const
 }
 #endif
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 
 #if !XCHAL_HAVE_PTP_MMU || XCHAL_HAVE_SPANNING_WAY
 unsigned long xtensa_kio_paddr = XCHAL_KIO_DEFAULT_PADDR;
@@ -234,7 +234,7 @@ void __init early_init_devtree(void *par
 		strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 }
 
-#endif /* CONFIG_OF */
+#endif /* CONFIG_USE_OF */
 
 /*
  * Initialize architecture. (Early stage)
@@ -255,7 +255,7 @@ void __init init_arch(bp_tag_t *bp_start
 	if (bp_start)
 		parse_bootparam(bp_start);
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_USE_OF
 	early_init_devtree(dtb_start);
 #endif
 
--- a/arch/xtensa/mm/mmu.c
+++ b/arch/xtensa/mm/mmu.c
@@ -98,7 +98,7 @@ void init_mmu(void)
 
 void init_kio(void)
 {
-#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY && defined(CONFIG_OF)
+#if XCHAL_HAVE_PTP_MMU && XCHAL_HAVE_SPANNING_WAY && defined(CONFIG_USE_OF)
 	/*
 	 * Update the IO area mapping in case xtensa_kio_paddr has changed
 	 */


