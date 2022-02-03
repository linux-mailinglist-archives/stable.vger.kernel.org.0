Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B3C4A8DBC
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354515AbiBCUcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354510AbiBCUbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF1BC06176D;
        Thu,  3 Feb 2022 12:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E20C61AB9;
        Thu,  3 Feb 2022 20:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7000BC340F0;
        Thu,  3 Feb 2022 20:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920282;
        bh=L2abX2J6L4mBx7bs32Xn/5k1qnjftTG1FoPZV+6UUe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdT2AcNvjGHdAYQwN2k4HU0rSlkeQSjOFCLD1p8os0p8UnAK1NX0PANaLe4jiKgMM
         pYErwI9LSC7wqVoYPSHvcjZJ8i1ga43rVC1FCynQPNBToFcFTkr4dJpk72Yb62nN0V
         ecXb4y6uVo2W7qdtjksZC1w0OftT1NctiOh+V6gPqy8Zl+qatbF1L6H8TYJIQDMci3
         qTOpNJfcLICH8PehJu+rCYODDczdeVNfebx8EhEyoGYgCT3iyvnkYt3nxBF6EOBJVn
         VS1mO4ahNS4jO4ahombeXRihEcPlIbSrs/2GhXlb2Ev0A3p1sOvcOEmhWs6mfifADL
         7AcK/f7/Q15bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 37/52] PM: hibernate: Remove register_nosave_region_late()
Date:   Thu,  3 Feb 2022 15:29:31 -0500
Message-Id: <20220203202947.2304-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 33569ef3c754a82010f266b7b938a66a3ccf90a4 ]

It is an unused wrapper forcing kmalloc allocation for registering
nosave regions. Also, rename __register_nosave_region() to
register_nosave_region() now that there is no need for disambiguation.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/suspend.h | 11 +----------
 kernel/power/snapshot.c | 21 +++++++--------------
 2 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 8af13ba60c7e4..c1310c571d805 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -430,15 +430,7 @@ struct platform_hibernation_ops {
 
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
-extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
-static inline void __init register_nosave_region(unsigned long b, unsigned long e)
-{
-	__register_nosave_region(b, e, 0);
-}
-static inline void __init register_nosave_region_late(unsigned long b, unsigned long e)
-{
-	__register_nosave_region(b, e, 1);
-}
+extern void register_nosave_region(unsigned long b, unsigned long e);
 extern int swsusp_page_is_forbidden(struct page *);
 extern void swsusp_set_page_free(struct page *);
 extern void swsusp_unset_page_free(struct page *);
@@ -457,7 +449,6 @@ int pfn_is_nosave(unsigned long pfn);
 int hibernate_quiet_exec(int (*func)(void *data), void *data);
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index f7a9860782135..330d499376924 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -978,8 +978,7 @@ static void memory_bm_recycle(struct memory_bitmap *bm)
  * Register a range of page frames the contents of which should not be saved
  * during hibernation (to be used in the early initialization code).
  */
-void __init __register_nosave_region(unsigned long start_pfn,
-				     unsigned long end_pfn, int use_kmalloc)
+void __init register_nosave_region(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct nosave_region *region;
 
@@ -995,18 +994,12 @@ void __init __register_nosave_region(unsigned long start_pfn,
 			goto Report;
 		}
 	}
-	if (use_kmalloc) {
-		/* During init, this shouldn't fail */
-		region = kmalloc(sizeof(struct nosave_region), GFP_KERNEL);
-		BUG_ON(!region);
-	} else {
-		/* This allocation cannot fail */
-		region = memblock_alloc(sizeof(struct nosave_region),
-					SMP_CACHE_BYTES);
-		if (!region)
-			panic("%s: Failed to allocate %zu bytes\n", __func__,
-			      sizeof(struct nosave_region));
-	}
+	/* This allocation cannot fail */
+	region = memblock_alloc(sizeof(struct nosave_region),
+				SMP_CACHE_BYTES);
+	if (!region)
+		panic("%s: Failed to allocate %zu bytes\n", __func__,
+		      sizeof(struct nosave_region));
 	region->start_pfn = start_pfn;
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);
-- 
2.34.1

