Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BCB4B4781
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245410AbiBNJr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343846AbiBNJqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D932D69CCA;
        Mon, 14 Feb 2022 01:40:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9061FB80DC7;
        Mon, 14 Feb 2022 09:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7B6C340E9;
        Mon, 14 Feb 2022 09:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831598;
        bh=ojmiylI0YjC8wN3pyGRx1nGh82RjVji27PqBngnvtws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gyn1zm8fFw8lMX5yQG6thwUX1e9H24jyz+GNkttteyJm/2q1uY5ID2GBBqq7oTXJt
         07NHw0QQxzsKvl5ikXcv89pcPh0+O1dFH1KZY3Dur/Gfh1YYyo7dWaHZlZoiYmKhIN
         3NjqbcTHk3/bNXmVOU7aKpC74O9sih7wxme5yjdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/116] PM: hibernate: Remove register_nosave_region_late()
Date:   Mon, 14 Feb 2022 10:25:31 +0100
Message-Id: <20220214092459.800350010@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 46b1804c1ddf7..1da013f50059a 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -944,8 +944,7 @@ static void memory_bm_recycle(struct memory_bitmap *bm)
  * Register a range of page frames the contents of which should not be saved
  * during hibernation (to be used in the early initialization code).
  */
-void __init __register_nosave_region(unsigned long start_pfn,
-				     unsigned long end_pfn, int use_kmalloc)
+void __init register_nosave_region(unsigned long start_pfn, unsigned long end_pfn)
 {
 	struct nosave_region *region;
 
@@ -961,18 +960,12 @@ void __init __register_nosave_region(unsigned long start_pfn,
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



