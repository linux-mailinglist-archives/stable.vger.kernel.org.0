Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213672B700D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 21:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgKQU3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 15:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgKQU3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 15:29:20 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDEEC0613CF;
        Tue, 17 Nov 2020 12:29:20 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id m9so7195352pgb.4;
        Tue, 17 Nov 2020 12:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A04NdGw3EYYnjizlVIom+Qa0tfDsLEhS7W1vhUNsh64=;
        b=AL2QC4FX7HIPPHrmuPaqw0qaE2rf455IERCc268AcGBiGhcj5vbVatxOe0cNKE0Zez
         dAAuX4PxD0jincL8S/xz3B4FYaZmtcXe3Iob/yqX9+6NCI9SPSTqO+0DXNDG4tZR1wHp
         gpjIZZJVlnLrQUZFP6C7P0G/ntFZ/8fGKUfsoInvlVn0LA/S7xxxq3ZSibx9DVr+hv5H
         A19z0XBIYmUYa5OW6nmGK//EJol9U6PA9gFTVK3orvCFIxBG3YxtVBQXjQI5rJ+eCePx
         9dSb6oldALYZC6KOzNHItD2Bt9l2dLGe05HUTUnIjlwFfOxXeyGLQQNdg+d11ji2uQrY
         vSDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=A04NdGw3EYYnjizlVIom+Qa0tfDsLEhS7W1vhUNsh64=;
        b=roy+Hmbs8IdoiOjwJfnevUJwenROOjR78xQ9Ck6m5d1xeGaX+Sxm0VuUIhyQVb2YJ2
         hcsKCv7Xz0WczI/zyedJp1qOxtv+Pig+Un9Xv2Mm6kR1tYO7sjdlvH2zyJhJRBsxhTSN
         Gswm3uEt0gFLOGJ2Z6BrtweVWRTY3lGN9c0XgNpqOlwOQueWT2+xTEZeX0cLJ8qWHRWN
         y5wtWx8/By847qbkFthSXyxUHBFnjag9drnAx+AzyNwWg2iZnH0IRZcchfilXoefV52t
         YEG6N2/8Q1+pxOcnPDCcwlA1W4dC5NoV+tpZdRdh3Nwz5gZyoyn49hLzJbUuwOhGbiBL
         VThw==
X-Gm-Message-State: AOAM533Rajd3AVbbxyaaQixlGvLgbtG0yFheEUArsv9hslkzqzyq57yF
        3ViByTjBiTShzJBhGL4lcsg=
X-Google-Smtp-Source: ABdhPJzPaLg+9m926PfSHe5hFt/HzmTYiFVRagNeDtcWTPYTqAe/L+otCw+OaCGvKsNUX8/59thZPA==
X-Received: by 2002:a63:486:: with SMTP id 128mr4693071pge.200.1605644959967;
        Tue, 17 Nov 2020 12:29:19 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id m73sm7389164pfd.106.2020.11.17.12.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 12:29:18 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Tue, 17 Nov 2020 12:29:16 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>,
        sergey.senozhatsky.work@gmail.com, tony@atomide.com,
        linux-arm-kernel@lists.infradead.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201117202916.GA3856507@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
 <20201113162529.GA2378542@google.com>
 <20201116175323.GB3805951@google.com>
 <20201117135632.GA27763@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117135632.GA27763@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 17, 2020 at 01:56:32PM +0000, Christoph Hellwig wrote:
> Btw, I remember that the whole vmalloc magic in zsmalloc was only giving
> a small benefit for a few niche use cases.  Given that it generally has
> very strange interaction with the vmalloc core, including using various
> APIs not used by any driver I'm going to ask once again why we can't
> just drop the CONFIG_ZSMALLOC_PGTABLE_MAPPING case entirely?

Yub, I remeber the discussion. 
https://lore.kernel.org/linux-mm/20200416203736.GB50092@google.com/

I wanted to remove it but 30% gain made me think again before
deciding to drop it.
Since it continue to make problems and Linux is approaching to
deprecate the 32bit machines, I think it would be better to drop it
rather than inventing weird workaround.

Ccing Tony since omap2plus have used it by default for just in case.

From fc1b17a120991fd86b9e1153ab22d0b0bdadd8d0 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 17 Nov 2020 11:58:51 -0800
Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING

Even though this option showed some amount improvement(e.g., 30%)
in some arm32 platforms, it has been headache to maintain since it
have abused APIs[1](e.g., unmap_kernel_range in atomic context).

Since we are approaching to deprecate 32bit machines and already made
the config option available for only builtin build since v5.8, lastly
it has been not default option in zsmalloc, it's time to drop the
option for better maintainance.

[1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org

Cc: Tony Lindgren <tony@atomide.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/arm/configs/omap2plus_defconfig |  1 -
 include/linux/zsmalloc.h             |  1 -
 mm/Kconfig                           | 13 -------
 mm/zsmalloc.c                        | 54 ----------------------------
 4 files changed, 69 deletions(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 77716f500813..70ee84a314c8 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -81,7 +81,6 @@ CONFIG_PARTITION_ADVANCED=y
 CONFIG_BINFMT_MISC=y
 CONFIG_CMA=y
 CONFIG_ZSMALLOC=m
-CONFIG_ZSMALLOC_PGTABLE_MAPPING=y
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 0fdbf653b173..4807ca4d52e0 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -20,7 +20,6 @@
  * zsmalloc mapping modes
  *
  * NOTE: These only make a difference when a mapped object spans pages.
- * They also have no effect when ZSMALLOC_PGTABLE_MAPPING is selected.
  */
 enum zs_mapmode {
 	ZS_MM_RW, /* normal read-write mapping */
diff --git a/mm/Kconfig b/mm/Kconfig
index 29904dc16bfc..7af1a55b708e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -707,19 +707,6 @@ config ZSMALLOC
 	  returned by an alloc().  This handle must be mapped in order to
 	  access the allocated space.
 
-config ZSMALLOC_PGTABLE_MAPPING
-	bool "Use page table mapping to access object in zsmalloc"
-	depends on ZSMALLOC=y
-	help
-	  By default, zsmalloc uses a copy-based object mapping method to
-	  access allocations that span two pages. However, if a particular
-	  architecture (ex, ARM) performs VM mapping faster than copying,
-	  then you should select this. This causes zsmalloc to use page table
-	  mapping rather than copying for object mapping.
-
-	  You can check speed with zsmalloc benchmark:
-	  https://github.com/spartacus06/zsmapbench
-
 config ZSMALLOC_STAT
 	bool "Export zsmalloc statistics"
 	depends on ZSMALLOC
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b03bee2e1b5f..7289f502ffac 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -293,11 +293,7 @@ struct zspage {
 };
 
 struct mapping_area {
-#ifdef CONFIG_ZSMALLOC_PGTABLE_MAPPING
-	struct vm_struct *vm; /* vm area for mapping object that span pages */
-#else
 	char *vm_buf; /* copy buffer for objects that span pages */
-#endif
 	char *vm_addr; /* address of kmap_atomic()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
@@ -1110,54 +1106,6 @@ static struct zspage *find_get_zspage(struct size_class *class)
 	return zspage;
 }
 
-#ifdef CONFIG_ZSMALLOC_PGTABLE_MAPPING
-static inline int __zs_cpu_up(struct mapping_area *area)
-{
-	/*
-	 * Make sure we don't leak memory if a cpu UP notification
-	 * and zs_init() race and both call zs_cpu_up() on the same cpu
-	 */
-	if (area->vm)
-		return 0;
-	area->vm = get_vm_area(PAGE_SIZE * 2, 0);
-	if (!area->vm)
-		return -ENOMEM;
-
-	/*
-	 * Populate ptes in advance to avoid pte allocation with GFP_KERNEL
-	 * in non-preemtible context of zs_map_object.
-	 */
-	return apply_to_page_range(&init_mm, (unsigned long)area->vm->addr,
-			PAGE_SIZE * 2, NULL, NULL);
-}
-
-static inline void __zs_cpu_down(struct mapping_area *area)
-{
-	if (area->vm)
-		free_vm_area(area->vm);
-	area->vm = NULL;
-}
-
-static inline void *__zs_map_object(struct mapping_area *area,
-				struct page *pages[2], int off, int size)
-{
-	unsigned long addr = (unsigned long)area->vm->addr;
-
-	BUG_ON(map_kernel_range(addr, PAGE_SIZE * 2, PAGE_KERNEL, pages) < 0);
-	area->vm_addr = area->vm->addr;
-	return area->vm_addr + off;
-}
-
-static inline void __zs_unmap_object(struct mapping_area *area,
-				struct page *pages[2], int off, int size)
-{
-	unsigned long addr = (unsigned long)area->vm_addr;
-
-	unmap_kernel_range(addr, PAGE_SIZE * 2);
-}
-
-#else /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static inline int __zs_cpu_up(struct mapping_area *area)
 {
 	/*
@@ -1238,8 +1186,6 @@ static void __zs_unmap_object(struct mapping_area *area,
 	pagefault_enable();
 }
 
-#endif /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-
 static int zs_cpu_prepare(unsigned int cpu)
 {
 	struct mapping_area *area;
-- 
2.29.2.299.gdc1121823c-goog

