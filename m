Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D772E6AE9AC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjCGR06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjCGR0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751EB9E657
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00EB5614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB845C4339B;
        Tue,  7 Mar 2023 17:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209673;
        bh=WtRAcWOMjcBClOVIvjiGtG8S1zNtSlXdm4kXmOuLBJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjQOZLO+OCUJGUaeqQ1AVzgZRENZmKw8eWERqaqiAshp4WPoFYLfL2fbznibrCbTH
         SejKQg9/utMsVoBN2lfQjXndqwOuP5QyeunSUfxDci4q1127GX1tC1FLMabdt4KPtB
         1Ts+aUpYwyIy8B7CwkbGXT1PXH7INq/wAjlssoB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0263/1001] s390/boot: fix mem_detect extended area allocation
Date:   Tue,  7 Mar 2023 17:50:35 +0100
Message-Id: <20230307170033.144930828@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 22476f47b6b7fb7d066c71f67ebc11892adb0849 ]

Allocation of mem_detect extended area was not considered neither
in commit 9641b8cc733f ("s390/ipl: read IPL report at early boot")
nor in commit b2d24b97b2a9 ("s390/kernel: add support for kernel address
space layout randomization (KASLR)"). As a result mem_detect extended
theoretically may overlap with ipl report or randomized kernel image
position. But as mem_detect code will allocate extended area only
upon exceeding 255 online regions (which should alternate with offline
memory regions) it is not seen in practice.

To make sure mem_detect extended area does not overlap with ipl report
or randomized kernel position extend usage of "safe_addr". Make initrd
handling and mem_detect extended area allocation code move it further
right and make KASLR takes in into consideration as well.

Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
Fixes: b2d24b97b2a9 ("s390/kernel: add support for kernel address space layout randomization (KASLR)")
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/boot.h       |  4 +--
 arch/s390/boot/kaslr.c      |  6 -----
 arch/s390/boot/mem_detect.c | 52 ++++++++++++-------------------------
 arch/s390/boot/startup.c    | 21 ++++++++-------
 4 files changed, 31 insertions(+), 52 deletions(-)

diff --git a/arch/s390/boot/boot.h b/arch/s390/boot/boot.h
index f6e82cf7851e2..939a1b7806df2 100644
--- a/arch/s390/boot/boot.h
+++ b/arch/s390/boot/boot.h
@@ -24,10 +24,10 @@ struct vmlinux_info {
 };
 
 void startup_kernel(void);
-unsigned long detect_memory(void);
+unsigned long detect_memory(unsigned long *safe_addr);
 bool is_ipl_block_dump(void);
 void store_ipl_parmblock(void);
-unsigned long read_ipl_report(unsigned long safe_offset);
+unsigned long read_ipl_report(unsigned long safe_addr);
 void setup_boot_command_line(void);
 void parse_boot_command_line(void);
 void verify_facilities(void);
diff --git a/arch/s390/boot/kaslr.c b/arch/s390/boot/kaslr.c
index e8d74d4f62aa5..58a8d8c8a1007 100644
--- a/arch/s390/boot/kaslr.c
+++ b/arch/s390/boot/kaslr.c
@@ -174,7 +174,6 @@ unsigned long get_random_base(unsigned long safe_addr)
 {
 	unsigned long memory_limit = get_mem_detect_end();
 	unsigned long base_pos, max_pos, kernel_size;
-	unsigned long kasan_needs;
 	int i;
 
 	memory_limit = min(memory_limit, ident_map_size);
@@ -186,12 +185,7 @@ unsigned long get_random_base(unsigned long safe_addr)
 	 */
 	memory_limit -= kasan_estimate_memory_needs(memory_limit);
 
-	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_data.start && initrd_data.size) {
-		if (safe_addr < initrd_data.start + initrd_data.size)
-			safe_addr = initrd_data.start + initrd_data.size;
-	}
 	safe_addr = ALIGN(safe_addr, THREAD_SIZE);
-
 	kernel_size = vmlinux.image_size + vmlinux.bss_size;
 	if (safe_addr + kernel_size > memory_limit)
 		return 0;
diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 41792a3a5e364..daa1593171835 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -16,29 +16,10 @@ struct mem_detect_info __bootdata(mem_detect);
 #define ENTRIES_EXTENDED_MAX						       \
 	(256 * (1020 / 2) * sizeof(struct mem_detect_block))
 
-/*
- * To avoid corrupting old kernel memory during dump, find lowest memory
- * chunk possible either right after the kernel end (decompressed kernel) or
- * after initrd (if it is present and there is no hole between the kernel end
- * and initrd)
- */
-static void *mem_detect_alloc_extended(void)
-{
-	unsigned long offset = ALIGN(mem_safe_offset(), sizeof(u64));
-
-	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && initrd_data.start && initrd_data.size &&
-	    initrd_data.start < offset + ENTRIES_EXTENDED_MAX)
-		offset = ALIGN(initrd_data.start + initrd_data.size, sizeof(u64));
-
-	return (void *)offset;
-}
-
 static struct mem_detect_block *__get_mem_detect_block_ptr(u32 n)
 {
 	if (n < MEM_INLINED_ENTRIES)
 		return &mem_detect.entries[n];
-	if (unlikely(!mem_detect.entries_extended))
-		mem_detect.entries_extended = mem_detect_alloc_extended();
 	return &mem_detect.entries_extended[n - MEM_INLINED_ENTRIES];
 }
 
@@ -147,7 +128,7 @@ static int tprot(unsigned long addr)
 	return rc;
 }
 
-static void search_mem_end(void)
+static unsigned long search_mem_end(void)
 {
 	unsigned long range = 1 << (MAX_PHYSMEM_BITS - 20); /* in 1MB blocks */
 	unsigned long offset = 0;
@@ -159,33 +140,34 @@ static void search_mem_end(void)
 		if (!tprot(pivot << 20))
 			offset = pivot;
 	}
-
-	add_mem_detect_block(0, (offset + 1) << 20);
+	return (offset + 1) << 20;
 }
 
-unsigned long detect_memory(void)
+unsigned long detect_memory(unsigned long *safe_addr)
 {
 	unsigned long max_physmem_end = 0;
 
 	sclp_early_get_memsize(&max_physmem_end);
+	mem_detect.entries_extended = (struct mem_detect_block *)ALIGN(*safe_addr, sizeof(u64));
 
 	if (!sclp_early_read_storage_info()) {
 		mem_detect.info_source = MEM_DETECT_SCLP_STOR_INFO;
-		return max_physmem_end;
-	}
-
-	if (!diag260()) {
+	} else if (!diag260()) {
 		mem_detect.info_source = MEM_DETECT_DIAG260;
-		return max_physmem_end ?: get_mem_detect_end();
-	}
-
-	if (max_physmem_end) {
+		max_physmem_end = max_physmem_end ?: get_mem_detect_end();
+	} else if (max_physmem_end) {
 		add_mem_detect_block(0, max_physmem_end);
 		mem_detect.info_source = MEM_DETECT_SCLP_READ_INFO;
-		return max_physmem_end;
+	} else {
+		max_physmem_end = search_mem_end();
+		add_mem_detect_block(0, max_physmem_end);
+		mem_detect.info_source = MEM_DETECT_BIN_SEARCH;
+	}
+
+	if (mem_detect.count > MEM_INLINED_ENTRIES) {
+		*safe_addr += (mem_detect.count - MEM_INLINED_ENTRIES) *
+			     sizeof(struct mem_detect_block);
 	}
 
-	search_mem_end();
-	mem_detect.info_source = MEM_DETECT_BIN_SEARCH;
-	return get_mem_detect_end();
+	return max_physmem_end;
 }
diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 47ca3264c0230..e0863d28759a5 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -57,16 +57,17 @@ unsigned long mem_safe_offset(void)
 }
 #endif
 
-static void rescue_initrd(unsigned long addr)
+static unsigned long rescue_initrd(unsigned long safe_addr)
 {
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INITRD))
-		return;
+		return safe_addr;
 	if (!initrd_data.start || !initrd_data.size)
-		return;
-	if (addr <= initrd_data.start)
-		return;
-	memmove((void *)addr, (void *)initrd_data.start, initrd_data.size);
-	initrd_data.start = addr;
+		return safe_addr;
+	if (initrd_data.start < safe_addr) {
+		memmove((void *)safe_addr, (void *)initrd_data.start, initrd_data.size);
+		initrd_data.start = safe_addr;
+	}
+	return initrd_data.start + initrd_data.size;
 }
 
 static void copy_bootdata(void)
@@ -250,6 +251,7 @@ static unsigned long reserve_amode31(unsigned long safe_addr)
 
 void startup_kernel(void)
 {
+	unsigned long max_physmem_end;
 	unsigned long random_lma;
 	unsigned long safe_addr;
 	void *img;
@@ -265,12 +267,13 @@ void startup_kernel(void)
 	safe_addr = reserve_amode31(safe_addr);
 	safe_addr = read_ipl_report(safe_addr);
 	uv_query_info();
-	rescue_initrd(safe_addr);
+	safe_addr = rescue_initrd(safe_addr);
 	sclp_early_read_info();
 	setup_boot_command_line();
 	parse_boot_command_line();
 	sanitize_prot_virt_host();
-	setup_ident_map_size(detect_memory());
+	max_physmem_end = detect_memory(&safe_addr);
+	setup_ident_map_size(max_physmem_end);
 	setup_vmalloc_size();
 	setup_kernel_memory_layout();
 
-- 
2.39.2



