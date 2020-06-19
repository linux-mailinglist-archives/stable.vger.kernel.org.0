Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F75200F17
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392381AbgFSPPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392385AbgFSPPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:15:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A0A720776;
        Fri, 19 Jun 2020 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579714;
        bh=YbqtuQXTkWQFQNXjZrD5f/zRbkD1TxaNOZmWnwI/YpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUVwk3TuoCIJ2eZ54UrKPfmr//Dsfe0nT4sGu1cUdfOR1A2x3j2SF4SO850S9NeLM
         4H74qKZdY0SL7M8T/rrQnwdfg+8eP3N4cFgQseCyE13mOYYzqlO7WKG9n2sYgIfbRs
         ay4WA+FdGHHC/jIuwxq2rPnYayg6p7SYhrlvxC7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 221/261] powerpc/fadump: use static allocation for reserved memory ranges
Date:   Fri, 19 Jun 2020 16:33:52 +0200
Message-Id: <20200619141700.466879544@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hari Bathini <hbathini@linux.ibm.com>

commit 02c04e374e176ae3a3f64a682f80702f8d2fb65d upstream.

At times, memory ranges have to be looked up during early boot, when
kernel couldn't be initialized for dynamic memory allocation. In fact,
reserved-ranges look up is needed during FADump memory reservation.
Without accounting for reserved-ranges in reserving memory for FADump,
MPIPL boot fails with memory corruption issues. So, extend memory
ranges handling to support static allocation and populate reserved
memory ranges during early boot.

Fixes: dda9dbfeeb7a ("powerpc/fadump: consider reserved ranges while releasing memory")
Cc: stable@vger.kernel.org
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/158737294432.26700.4830263187856221314.stgit@hbathini.in.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/fadump-internal.h |    4 +
 arch/powerpc/kernel/fadump.c               |   77 ++++++++++++++++-------------
 2 files changed, 48 insertions(+), 33 deletions(-)

--- a/arch/powerpc/include/asm/fadump-internal.h
+++ b/arch/powerpc/include/asm/fadump-internal.h
@@ -64,12 +64,14 @@ struct fadump_memory_range {
 };
 
 /* fadump memory ranges info */
+#define RNG_NAME_SZ			16
 struct fadump_mrange_info {
-	char				name[16];
+	char				name[RNG_NAME_SZ];
 	struct fadump_memory_range	*mem_ranges;
 	u32				mem_ranges_sz;
 	u32				mem_range_cnt;
 	u32				max_mem_ranges;
+	bool				is_static;
 };
 
 /* Platform specific callback functions */
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -38,8 +38,17 @@ static void __init fadump_reserve_crash_
 
 #ifndef CONFIG_PRESERVE_FA_DUMP
 static DEFINE_MUTEX(fadump_mutex);
-struct fadump_mrange_info crash_mrange_info = { "crash", NULL, 0, 0, 0 };
-struct fadump_mrange_info reserved_mrange_info = { "reserved", NULL, 0, 0, 0 };
+struct fadump_mrange_info crash_mrange_info = { "crash", NULL, 0, 0, 0, false };
+
+#define RESERVED_RNGS_SZ	16384 /* 16K - 128 entries */
+#define RESERVED_RNGS_CNT	(RESERVED_RNGS_SZ / \
+				 sizeof(struct fadump_memory_range))
+static struct fadump_memory_range rngs[RESERVED_RNGS_CNT];
+struct fadump_mrange_info reserved_mrange_info = { "reserved", rngs,
+						   RESERVED_RNGS_SZ, 0,
+						   RESERVED_RNGS_CNT, true };
+
+static void __init early_init_dt_scan_reserved_ranges(unsigned long node);
 
 #ifdef CONFIG_CMA
 static struct cma *fadump_cma;
@@ -108,6 +117,11 @@ static int __init fadump_cma_init(void)
 int __init early_init_dt_scan_fw_dump(unsigned long node, const char *uname,
 				      int depth, void *data)
 {
+	if (depth == 0) {
+		early_init_dt_scan_reserved_ranges(node);
+		return 0;
+	}
+
 	if (depth != 1)
 		return 0;
 
@@ -726,10 +740,14 @@ void fadump_free_cpu_notes_buf(void)
 
 static void fadump_free_mem_ranges(struct fadump_mrange_info *mrange_info)
 {
+	if (mrange_info->is_static) {
+		mrange_info->mem_range_cnt = 0;
+		return;
+	}
+
 	kfree(mrange_info->mem_ranges);
-	mrange_info->mem_ranges = NULL;
-	mrange_info->mem_ranges_sz = 0;
-	mrange_info->max_mem_ranges = 0;
+	memset((void *)((u64)mrange_info + RNG_NAME_SZ), 0,
+	       (sizeof(struct fadump_mrange_info) - RNG_NAME_SZ));
 }
 
 /*
@@ -786,6 +804,12 @@ static inline int fadump_add_mem_range(s
 		if (mrange_info->mem_range_cnt == mrange_info->max_mem_ranges) {
 			int ret;
 
+			if (mrange_info->is_static) {
+				pr_err("Reached array size limit for %s memory ranges\n",
+				       mrange_info->name);
+				return -ENOSPC;
+			}
+
 			ret = fadump_alloc_mem_ranges(mrange_info);
 			if (ret)
 				return ret;
@@ -1202,20 +1226,19 @@ static void sort_and_merge_mem_ranges(st
  * Scan reserved-ranges to consider them while reserving/releasing
  * memory for FADump.
  */
-static inline int fadump_scan_reserved_mem_ranges(void)
+static void __init early_init_dt_scan_reserved_ranges(unsigned long node)
 {
-	struct device_node *root;
 	const __be32 *prop;
 	int len, ret = -1;
 	unsigned long i;
 
-	root = of_find_node_by_path("/");
-	if (!root)
-		return ret;
+	/* reserved-ranges already scanned */
+	if (reserved_mrange_info.mem_range_cnt != 0)
+		return;
 
-	prop = of_get_property(root, "reserved-ranges", &len);
+	prop = of_get_flat_dt_prop(node, "reserved-ranges", &len);
 	if (!prop)
-		return ret;
+		return;
 
 	/*
 	 * Each reserved range is an (address,size) pair, 2 cells each,
@@ -1237,7 +1260,8 @@ static inline int fadump_scan_reserved_m
 		}
 	}
 
-	return ret;
+	/* Compact reserved ranges */
+	sort_and_merge_mem_ranges(&reserved_mrange_info);
 }
 
 /*
@@ -1251,32 +1275,21 @@ static void fadump_release_memory(u64 be
 	u64 ra_start, ra_end, tstart;
 	int i, ret;
 
-	fadump_scan_reserved_mem_ranges();
-
 	ra_start = fw_dump.reserve_dump_area_start;
 	ra_end = ra_start + fw_dump.reserve_dump_area_size;
 
 	/*
-	 * Add reserved dump area to reserved ranges list
-	 * and exclude all these ranges while releasing memory.
+	 * If reserved ranges array limit is hit, overwrite the last reserved
+	 * memory range with reserved dump area to ensure it is excluded from
+	 * the memory being released (reused for next FADump registration).
 	 */
-	ret = fadump_add_mem_range(&reserved_mrange_info, ra_start, ra_end);
-	if (ret != 0) {
-		/*
-		 * Not enough memory to setup reserved ranges but the system is
-		 * running shortage of memory. So, release all the memory except
-		 * Reserved dump area (reused for next fadump registration).
-		 */
-		if (begin < ra_end && end > ra_start) {
-			if (begin < ra_start)
-				fadump_release_reserved_area(begin, ra_start);
-			if (end > ra_end)
-				fadump_release_reserved_area(ra_end, end);
-		} else
-			fadump_release_reserved_area(begin, end);
+	if (reserved_mrange_info.mem_range_cnt ==
+	    reserved_mrange_info.max_mem_ranges)
+		reserved_mrange_info.mem_range_cnt--;
 
+	ret = fadump_add_mem_range(&reserved_mrange_info, ra_start, ra_end);
+	if (ret != 0)
 		return;
-	}
 
 	/* Get the reserved ranges list in order first. */
 	sort_and_merge_mem_ranges(&reserved_mrange_info);


