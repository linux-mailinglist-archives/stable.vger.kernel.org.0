Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB03956FC85
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiGKJpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbiGKJn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:43:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC395564D0;
        Mon, 11 Jul 2022 02:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DC9612E8;
        Mon, 11 Jul 2022 09:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9470C34115;
        Mon, 11 Jul 2022 09:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531308;
        bh=cbIngTbkadnuBXg1TrRSSn/ja57fLg6KwjtLYx6GfUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pci1YgtbKNxkJ/8mZJxzXtfWKWUzNV4w+xnP6k52C1fRH8+5uVt9bOr0WSK/ttvxn
         zNhv4mLHwNiFO+Z6pEtHbhoksY4h4j2XypmPv8wY5JuKRZNgRwljzhEXq/oUgHOt5C
         0LGW+nb3yX9aN7mLF1LCm5Mj8Iuc8H9NrA5gFTlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/230] s390/boot: allocate amode31 section in decompressor
Date:   Mon, 11 Jul 2022 11:05:15 +0200
Message-Id: <20220711090605.752583647@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit e3ec8e0f5711d73f7e5d5c3cffdf4fad4f1487b9 ]

The memory for amode31 section is allocated from the decompressed
kernel. Instead, allocate that memory from the decompressor. This
is a prerequisite to allow initialization of the virtual memory
before the decompressed kernel takes over.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/compressed/decompressor.h |  1 +
 arch/s390/boot/startup.c                 |  8 ++++++++
 arch/s390/kernel/entry.h                 |  1 +
 arch/s390/kernel/setup.c                 | 22 +++++++++-------------
 arch/s390/kernel/vmlinux.lds.S           |  1 +
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/s390/boot/compressed/decompressor.h b/arch/s390/boot/compressed/decompressor.h
index a59f75c5b049..f75cc31a77dd 100644
--- a/arch/s390/boot/compressed/decompressor.h
+++ b/arch/s390/boot/compressed/decompressor.h
@@ -24,6 +24,7 @@ struct vmlinux_info {
 	unsigned long dynsym_start;
 	unsigned long rela_dyn_start;
 	unsigned long rela_dyn_end;
+	unsigned long amode31_size;
 };
 
 /* Symbols defined by linker scripts */
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index b13352dd1e1c..1aa11a8f57dd 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -15,6 +15,7 @@
 #include "uv.h"
 
 unsigned long __bootdata_preserved(__kaslr_offset);
+unsigned long __bootdata(__amode31_base);
 unsigned long __bootdata_preserved(VMALLOC_START);
 unsigned long __bootdata_preserved(VMALLOC_END);
 struct page *__bootdata_preserved(vmemmap);
@@ -233,6 +234,12 @@ static void offset_vmlinux_info(unsigned long offset)
 	vmlinux.dynsym_start += offset;
 }
 
+static unsigned long reserve_amode31(unsigned long safe_addr)
+{
+	__amode31_base = PAGE_ALIGN(safe_addr);
+	return safe_addr + vmlinux.amode31_size;
+}
+
 void startup_kernel(void)
 {
 	unsigned long random_lma;
@@ -247,6 +254,7 @@ void startup_kernel(void)
 	setup_lpp();
 	store_ipl_parmblock();
 	safe_addr = mem_safe_offset();
+	safe_addr = reserve_amode31(safe_addr);
 	safe_addr = read_ipl_report(safe_addr);
 	uv_query_info();
 	rescue_initrd(safe_addr);
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 7f2696e8d511..6083090be1f4 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -70,5 +70,6 @@ extern struct exception_table_entry _stop_amode31_ex_table[];
 #define __amode31_data __section(".amode31.data")
 #define __amode31_ref __section(".amode31.refs")
 extern long _start_amode31_refs[], _end_amode31_refs[];
+extern unsigned long __amode31_base;
 
 #endif /* _ENTRY_H */
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 8ede12c4ba6b..e38de9e8ee13 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -95,10 +95,10 @@ EXPORT_SYMBOL(console_irq);
  * relocated above 2 GB, because it has to use 31 bit addresses.
  * Such code and data is part of the .amode31 section.
  */
-unsigned long __amode31_ref __samode31 = __pa(&_samode31);
-unsigned long __amode31_ref __eamode31 = __pa(&_eamode31);
-unsigned long __amode31_ref __stext_amode31 = __pa(&_stext_amode31);
-unsigned long __amode31_ref __etext_amode31 = __pa(&_etext_amode31);
+unsigned long __amode31_ref __samode31 = (unsigned long)&_samode31;
+unsigned long __amode31_ref __eamode31 = (unsigned long)&_eamode31;
+unsigned long __amode31_ref __stext_amode31 = (unsigned long)&_stext_amode31;
+unsigned long __amode31_ref __etext_amode31 = (unsigned long)&_etext_amode31;
 struct exception_table_entry __amode31_ref *__start_amode31_ex_table = _start_amode31_ex_table;
 struct exception_table_entry __amode31_ref *__stop_amode31_ex_table = _stop_amode31_ex_table;
 
@@ -149,6 +149,7 @@ struct mem_detect_info __bootdata(mem_detect);
 struct initrd_data __bootdata(initrd_data);
 
 unsigned long __bootdata_preserved(__kaslr_offset);
+unsigned long __bootdata(__amode31_base);
 unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
 u64 __bootdata_preserved(stfle_fac_list[16]);
@@ -800,6 +801,7 @@ static void __init reserve_kernel(void)
 
 	memblock_reserve(0, STARTUP_NORMAL_OFFSET);
 	memblock_reserve((unsigned long)sclp_early_sccb, EXT_SCCB_READ_SCP);
+	memblock_reserve(__amode31_base, __eamode31 - __samode31);
 	memblock_reserve((unsigned long)_stext, PFN_PHYS(start_pfn)
 			 - (unsigned long)_stext);
 }
@@ -820,20 +822,14 @@ static void __init setup_memory(void)
 
 static void __init relocate_amode31_section(void)
 {
-	unsigned long amode31_addr, amode31_size;
-	long amode31_offset;
+	unsigned long amode31_size = __eamode31 - __samode31;
+	long amode31_offset = __amode31_base - __samode31;
 	long *ptr;
 
-	/* Allocate a new AMODE31 capable memory region */
-	amode31_size = __eamode31 - __samode31;
 	pr_info("Relocating AMODE31 section of size 0x%08lx\n", amode31_size);
-	amode31_addr = (unsigned long)memblock_alloc_low(amode31_size, PAGE_SIZE);
-	if (!amode31_addr)
-		panic("Failed to allocate memory for AMODE31 section\n");
-	amode31_offset = amode31_addr - __samode31;
 
 	/* Move original AMODE31 section to the new one */
-	memmove((void *)amode31_addr, (void *)__samode31, amode31_size);
+	memmove((void *)__amode31_base, (void *)__samode31, amode31_size);
 	/* Zero out the old AMODE31 section to catch invalid accesses within it */
 	memset((void *)__samode31, 0, amode31_size);
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 63bdb9e1bfc1..42c43521878f 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -212,6 +212,7 @@ SECTIONS
 		QUAD(__dynsym_start)				/* dynsym_start */
 		QUAD(__rela_dyn_start)				/* rela_dyn_start */
 		QUAD(__rela_dyn_end)				/* rela_dyn_end */
+		QUAD(_eamode31 - _samode31)			/* amode31_size */
 	} :NONE
 
 	/* Debugging sections.	*/
-- 
2.35.1



