Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1927F4A8F19
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiBCUmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242140AbiBCUjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:39:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF79C061765;
        Thu,  3 Feb 2022 12:36:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED298B835A4;
        Thu,  3 Feb 2022 20:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999D2C36AE3;
        Thu,  3 Feb 2022 20:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920568;
        bh=nBbcmC2clBtFUE4+r3jUl7e4KKEhA/7ys6t+U2NjNkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2oG9puqbN7GqimjoSjJmz0N7/wjTehrMqxEDL/h2i/EQ6ackG0sEUDZgpMXWzSCL
         u3kZZoXAMTVW0jtWTZRod5IIMxbahokU4K2iamCtseooyXQHGEzRQRtPjCO8XNpbLC
         ebjr5gYZHOW5jN5bVsy0reflmNEJxWAqQrNMvu6Rn0iVR6fxLWQGQ+1/h60wUaIi+E
         LXrWXbcyF3V3taoKG04BuQ2lGZeWd8eHSUUfl7o7Ur6Xpb556U24c4b5I3W2jlUr5Y
         DX0W11o1qBqbHXbvNGCsok97J+a1dhbaWV0kk9y0sq/hV/ioknabBUaf7eE3TFdqOR
         hhN3FCFWzhoVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        len.brown@intel.com, pavel@ucw.cz, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/15] PM: hibernate: Remove register_nosave_region_late()
Date:   Thu,  3 Feb 2022 15:35:43 -0500
Message-Id: <20220203203545.3879-13-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
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
index cd97d2c8840cc..44dd49cb2ea05 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -428,15 +428,7 @@ struct platform_hibernation_ops {
 
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
@@ -453,7 +445,6 @@ extern struct pbe *restore_pblist;
 int pfn_is_nosave(unsigned long pfn);
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d65f2d5ab6942..46455aa7951ec 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -945,8 +945,7 @@ static void memory_bm_recycle(struct memory_bitmap *bm)
  * Register a range of page frames the contents of which should not be saved
  * during hibernation (to be used in the early initialization code).
  */
-void __init __register_nosave_region(unsigned long start_pfn,
-				     unsigned long end_pfn, int use_kmalloc)
+void __init register_nosave_region(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct nosave_region *region;
 
@@ -962,18 +961,12 @@ void __init __register_nosave_region(unsigned long start_pfn,
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

