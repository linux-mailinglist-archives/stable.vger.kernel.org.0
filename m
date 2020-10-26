Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4180B29A046
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394082AbgJ0A3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:29:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409802AbgJZXwj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 431E52224E;
        Mon, 26 Oct 2020 23:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756358;
        bh=zlOUWURAScUqYy57y+ng5nCNK7N8pGx9FtvyCDjyXDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDKF7AgdfeOYEl343DTdyCecrSnpEEQv4cl/P7/O1yXkllxlu6UWys0NSILWRsdwZ
         Ksa3OP+LZ9W4VrewR0pQVbEI2Gd1GlQEak0uvtSkK3UO/oI2n8roKXNTO6D1UOUiFV
         po7JMdZlUiHyefzQia++dZy6xqOhEhgO2oAswXy8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 028/132] x86/kaslr: Initialize mem_limit to the real maximum address
Date:   Mon, 26 Oct 2020 19:50:20 -0400
Message-Id: <20201026235205.1023962-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 451286940d95778e83fa7f97006316d995b4c4a8 ]

On 64-bit, the kernel must be placed below MAXMEM (64TiB with 4-level
paging or 4PiB with 5-level paging). This is currently not enforced by
KASLR, which thus implicitly relies on physical memory being limited to
less than 64TiB.

On 32-bit, the limit is KERNEL_IMAGE_SIZE (512MiB). This is enforced by
special checks in __process_mem_region().

Initialize mem_limit to the maximum (depending on architecture), instead
of ULLONG_MAX, and make sure the command-line arguments can only
decrease it. This makes the enforcement explicit on 64-bit, and
eliminates the 32-bit specific checks to keep the kernel below 512M.

Check upfront to make sure the minimum address is below the limit before
doing any work.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20200727230801.3468620-5-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/kaslr.c | 41 +++++++++++++++++---------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index d7408af557386..b59592273c329 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -94,8 +94,11 @@ static unsigned long get_boot_seed(void)
 static bool memmap_too_large;
 
 
-/* Store memory limit specified by "mem=nn[KMG]" or "memmap=nn[KMG]" */
-static unsigned long long mem_limit = ULLONG_MAX;
+/*
+ * Store memory limit: MAXMEM on 64-bit and KERNEL_IMAGE_SIZE on 32-bit.
+ * It may be reduced by "mem=nn[KMG]" or "memmap=nn[KMG]" command line options.
+ */
+static unsigned long long mem_limit;
 
 /* Number of immovable memory regions */
 static int num_immovable_mem;
@@ -221,7 +224,7 @@ static void mem_avoid_memmap(enum parse_mode mode, char *str)
 
 		if (start == 0) {
 			/* Store the specified memory limit if size > 0 */
-			if (size > 0)
+			if (size > 0 && size < mem_limit)
 				mem_limit = size;
 
 			continue;
@@ -309,7 +312,8 @@ static void handle_mem_options(void)
 			if (mem_size == 0)
 				goto out;
 
-			mem_limit = mem_size;
+			if (mem_size < mem_limit)
+				mem_limit = mem_size;
 		} else if (!strcmp(param, "efi_fake_mem")) {
 			mem_avoid_memmap(PARSE_EFI, val);
 		}
@@ -321,7 +325,9 @@ static void handle_mem_options(void)
 }
 
 /*
- * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
+ * In theory, KASLR can put the kernel anywhere in the range of [16M, MAXMEM)
+ * on 64-bit, and [16M, KERNEL_IMAGE_SIZE) on 32-bit.
+ *
  * The mem_avoid array is used to store the ranges that need to be avoided
  * when KASLR searches for an appropriate random address. We must avoid any
  * regions that are unsafe to overlap with during decompression, and other
@@ -621,10 +627,6 @@ static void __process_mem_region(struct mem_vector *entry,
 	unsigned long start_orig, end;
 	struct mem_vector cur_entry;
 
-	/* On 32-bit, ignore entries entirely above our maximum. */
-	if (IS_ENABLED(CONFIG_X86_32) && entry->start >= KERNEL_IMAGE_SIZE)
-		return;
-
 	/* Ignore entries entirely below our minimum. */
 	if (entry->start + entry->size < minimum)
 		return;
@@ -657,11 +659,6 @@ static void __process_mem_region(struct mem_vector *entry,
 		/* Reduce size by any delta from the original address. */
 		region.size -= region.start - start_orig;
 
-		/* On 32-bit, reduce region size to fit within max size. */
-		if (IS_ENABLED(CONFIG_X86_32) &&
-		    region.start + region.size > KERNEL_IMAGE_SIZE)
-			region.size = KERNEL_IMAGE_SIZE - region.start;
-
 		/* Return if region can't contain decompressed kernel */
 		if (region.size < image_size)
 			return;
@@ -846,15 +843,16 @@ static void process_e820_entries(unsigned long minimum,
 static unsigned long find_random_phys_addr(unsigned long minimum,
 					   unsigned long image_size)
 {
+	/* Bail out early if it's impossible to succeed. */
+	if (minimum + image_size > mem_limit)
+		return 0;
+
 	/* Check if we had too many memmaps. */
 	if (memmap_too_large) {
 		debug_putstr("Aborted memory entries scan (more than 4 memmap= args)!\n");
 		return 0;
 	}
 
-	/* Make sure minimum is aligned. */
-	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
-
 	if (process_efi_entries(minimum, image_size))
 		return slots_fetch_random();
 
@@ -867,8 +865,6 @@ static unsigned long find_random_virt_addr(unsigned long minimum,
 {
 	unsigned long slots, random_addr;
 
-	/* Make sure minimum is aligned. */
-	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
 	/* Align image_size for easy slot calculations. */
 	image_size = ALIGN(image_size, CONFIG_PHYSICAL_ALIGN);
 
@@ -915,6 +911,11 @@ void choose_random_location(unsigned long input,
 	/* Prepare to add new identity pagetables on demand. */
 	initialize_identity_maps();
 
+	if (IS_ENABLED(CONFIG_X86_32))
+		mem_limit = KERNEL_IMAGE_SIZE;
+	else
+		mem_limit = MAXMEM;
+
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init(input, input_size, *output);
 
@@ -924,6 +925,8 @@ void choose_random_location(unsigned long input,
 	 * location:
 	 */
 	min_addr = min(*output, 512UL << 20);
+	/* Make sure minimum is aligned. */
+	min_addr = ALIGN(min_addr, CONFIG_PHYSICAL_ALIGN);
 
 	/* Walk available memory entries to find a random address. */
 	random_addr = find_random_phys_addr(min_addr, output_size);
-- 
2.25.1

