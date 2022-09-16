Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286D65BB17A
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIPRGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiIPRGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:06:51 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A01EB656F;
        Fri, 16 Sep 2022 10:06:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y127so21819530pfy.5;
        Fri, 16 Sep 2022 10:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=oo7u2RMqtvn+f9vVLWk7c1hXsiGPEPQ41u+tdbZ00WY=;
        b=ULCZgzOwAj5gEn5gZ0ov+KXlyCAF97hCMJKwf+iQnVJNMEx7Z1pnH/LGftzOJ9YSYu
         MzdagE91DdRPH/GDSQmAUUUJb80L6CRCED2gg6Ph1RBZ76fuhrBBd8/AgolmAiqqPFN5
         r1Api3OAPOi8gpDdAp87d9f7H6SijcFNDkDA1nkUsauml6TKrRutctjWYAU7YNB/7WQT
         jWRWXo3WL47u2Bk9B8CEEZ0ngHT/0Q23PDK7KxTr6hLg5WB9VQeqWogxloJmpvjykaVW
         D5HPjcIMHzLN7GghhYp37cYty8gVg/NKb1v0+9OYNnrlc5tKxoud99sLv2IMP3eWqrWo
         JaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oo7u2RMqtvn+f9vVLWk7c1hXsiGPEPQ41u+tdbZ00WY=;
        b=KLTu5DJ3SF2ZrtxE271IQ/6BnPbtnef/fS4tDhWWSwKZAVl+5OoHcyqvRfVJc82FxY
         Xdfttd3H//bxATTc/mNyYWEvZNynflVbhfzR2nnRgWZG+MwS2Gf40kivwedthUk4sspS
         s7lQzuRbWS2LqCTYyRnPLXwapp/1ajJWteQ2IaKI4uIxUJyfVUrQg4BjGGsiz9DUWW82
         ai0JjjMAamLeXyJ3tTFUD2z82VAWThf0jlhWEL3sHhWIMUNGrgCdxj7Ftd7Q2nwQRZXp
         51bMTmcsiy2omRl7Ii8P6H5jWEJ4plbmzBBEP4A2/hmQAHyacyG9FdV4IvibP/dcHwM6
         URrA==
X-Gm-Message-State: ACrzQf3GCiRmBc11ULgxf2AQGaYb46YlNglF5whpn5FZPGa9VuLxy7ki
        q23rtm/LMn4LgqKowT2SfNM=
X-Google-Smtp-Source: AMsMyM7ypvJ6LyfAu+SvbIIyWL09Js8gh62kTKwJ6Y1fzhGTmHDN2ERwhTpd39GlGP0rt079XHFDhA==
X-Received: by 2002:a05:6a00:4287:b0:543:7bae:55f7 with SMTP id bx7-20020a056a00428700b005437bae55f7mr6451197pfb.58.1663348008910;
        Fri, 16 Sep 2022 10:06:48 -0700 (PDT)
Received: from localhost.localdomain ([117.176.186.9])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b00176d4b093e1sm15386677plg.16.2022.09.16.10.06.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Sep 2022 10:06:48 -0700 (PDT)
From:   wangyong <yongw.pur@gmail.com>
X-Google-Original-From: wangyong <wang.yong12@zte.com.cn>
To:     gregkh@linuxfoundation.org
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn,
        yongw.pur@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yong-Taek Lee <ytk.lee@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/3] page_alloc: consider highatomic reserve in watermark fast
Date:   Fri, 16 Sep 2022 10:05:48 -0700
Message-Id: <1663347949-20389-3-git-send-email-wang.yong12@zte.com.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
References: <YyREk5hHs2F0eWiE@kroah.com>
 <1663347949-20389-1-git-send-email-wang.yong12@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaewon Kim <jaewon31.kim@samsung.com>

zone_watermark_fast was introduced by commit 48ee5f3696f6 ("mm,
page_alloc: shortcut watermark checks for order-0 pages").  The commit
simply checks if free pages is bigger than watermark without additional
calculation such like reducing watermark.

It considered free cma pages but it did not consider highatomic reserved.
This may incur exhaustion of free pages except high order atomic free
pages.

Assume that reserved_highatomic pageblock is bigger than watermark min,
and there are only few free pages except high order atomic free.  Because
zone_watermark_fast passes the allocation without considering high order
atomic free, normal reclaimable allocation like GFP_HIGHUSER will consume
all the free pages.  Then finally order-0 atomic allocation may fail on
allocation.

This means watermark min is not protected against non-atomic allocation.
The order-0 atomic allocation with ALLOC_HARDER unwantedly can be failed.
Additionally the __GFP_MEMALLOC allocation with ALLOC_NO_WATERMARKS also
can be failed.

To avoid the problem, zone_watermark_fast should consider highatomic
reserve.  If the actual size of high atomic free is counted accurately
like cma free, we may use it.  On this patch just use
nr_reserved_highatomic.  Additionally introduce
__zone_watermark_unusable_free to factor out common parts between
zone_watermark_fast and __zone_watermark_ok.

This is an example of ALLOC_HARDER allocation failure using v4.19 based
kernel.

 Binder:9343_3: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
 Call trace:
 [<ffffff8008f40f8c>] dump_stack+0xb8/0xf0
 [<ffffff8008223320>] warn_alloc+0xd8/0x12c
 [<ffffff80082245e4>] __alloc_pages_nodemask+0x120c/0x1250
 [<ffffff800827f6e8>] new_slab+0x128/0x604
 [<ffffff800827b0cc>] ___slab_alloc+0x508/0x670
 [<ffffff800827ba00>] __kmalloc+0x2f8/0x310
 [<ffffff80084ac3e0>] context_struct_to_string+0x104/0x1cc
 [<ffffff80084ad8fc>] security_sid_to_context_core+0x74/0x144
 [<ffffff80084ad880>] security_sid_to_context+0x10/0x18
 [<ffffff800849bd80>] selinux_secid_to_secctx+0x20/0x28
 [<ffffff800849109c>] security_secid_to_secctx+0x3c/0x70
 [<ffffff8008bfe118>] binder_transaction+0xe68/0x454c
 Mem-Info:
 active_anon:102061 inactive_anon:81551 isolated_anon:0
  active_file:59102 inactive_file:68924 isolated_file:64
  unevictable:611 dirty:63 writeback:0 unstable:0
  slab_reclaimable:13324 slab_unreclaimable:44354
  mapped:83015 shmem:4858 pagetables:26316 bounce:0
  free:2727 free_pcp:1035 free_cma:178
 Node 0 active_anon:408244kB inactive_anon:326204kB active_file:236408kB inactive_file:275696kB unevictable:2444kB isolated(anon):0kB isolated(file):256kB mapped:332060kB dirty:252kB writeback:0kB shmem:19432kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
 Normal free:10908kB min:6192kB low:44388kB high:47060kB active_anon:409160kB inactive_anon:325924kB active_file:235820kB inactive_file:276628kB unevictable:2444kB writepending:252kB present:3076096kB managed:2673676kB mlocked:2444kB kernel_stack:62512kB pagetables:105264kB bounce:0kB free_pcp:4140kB local_pcp:40kB free_cma:712kB
 lowmem_reserve[]: 0 0
 Normal: 505*4kB (H) 357*8kB (H) 201*16kB (H) 65*32kB (H) 1*64kB (H) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10236kB
 138826 total pagecache pages
 5460 pages in swap cache
 Swap cache stats: add 8273090, delete 8267506, find 1004381/4060142

This is an example of ALLOC_NO_WATERMARKS allocation failure using v4.14
based kernel.

 kswapd0: page allocation failure: order:0, mode:0x140000a(GFP_NOIO|__GFP_HIGHMEM|__GFP_MOVABLE), nodemask=(null)
 kswapd0 cpuset=/ mems_allowed=0
 CPU: 4 PID: 1221 Comm: kswapd0 Not tainted 4.14.113-18770262-userdebug #1
 Call trace:
 [<0000000000000000>] dump_backtrace+0x0/0x248
 [<0000000000000000>] show_stack+0x18/0x20
 [<0000000000000000>] __dump_stack+0x20/0x28
 [<0000000000000000>] dump_stack+0x68/0x90
 [<0000000000000000>] warn_alloc+0x104/0x198
 [<0000000000000000>] __alloc_pages_nodemask+0xdc0/0xdf0
 [<0000000000000000>] zs_malloc+0x148/0x3d0
 [<0000000000000000>] zram_bvec_rw+0x410/0x798
 [<0000000000000000>] zram_rw_page+0x88/0xdc
 [<0000000000000000>] bdev_write_page+0x70/0xbc
 [<0000000000000000>] __swap_writepage+0x58/0x37c
 [<0000000000000000>] swap_writepage+0x40/0x4c
 [<0000000000000000>] shrink_page_list+0xc30/0xf48
 [<0000000000000000>] shrink_inactive_list+0x2b0/0x61c
 [<0000000000000000>] shrink_node_memcg+0x23c/0x618
 [<0000000000000000>] shrink_node+0x1c8/0x304
 [<0000000000000000>] kswapd+0x680/0x7c4
 [<0000000000000000>] kthread+0x110/0x120
 [<0000000000000000>] ret_from_fork+0x10/0x18
 Mem-Info:
 active_anon:111826 inactive_anon:65557 isolated_anon:0\x0a active_file:44260 inactive_file:83422 isolated_file:0\x0a unevictable:4158 dirty:117 writeback:0 unstable:0\x0a            slab_reclaimable:13943 slab_unreclaimable:43315\x0a mapped:102511 shmem:3299 pagetables:19566 bounce:0\x0a free:3510 free_pcp:553 free_cma:0
 Node 0 active_anon:447304kB inactive_anon:262228kB active_file:177040kB inactive_file:333688kB unevictable:16632kB isolated(anon):0kB isolated(file):0kB mapped:410044kB d irty:468kB writeback:0kB shmem:13196kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
 Normal free:14040kB min:7440kB low:94500kB high:98136kB reserved_highatomic:32768KB active_anon:447336kB inactive_anon:261668kB active_file:177572kB inactive_file:333768k           B unevictable:16632kB writepending:480kB present:4081664kB managed:3637088kB mlocked:16632kB kernel_stack:47072kB pagetables:78264kB bounce:0kB free_pcp:2280kB local_pcp:720kB free_cma:0kB        [ 4738.329607] lowmem_reserve[]: 0 0
 Normal: 860*4kB (H) 453*8kB (H) 180*16kB (H) 26*32kB (H) 34*64kB (H) 6*128kB (H) 2*256kB (H) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14232kB

This is trace log which shows GFP_HIGHUSER consumes free pages right
before ALLOC_NO_WATERMARKS.

  <...>-22275 [006] ....   889.213383: mm_page_alloc: page=00000000d2be5665 pfn=970744 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213385: mm_page_alloc: page=000000004b2335c2 pfn=970745 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213387: mm_page_alloc: page=00000000017272e1 pfn=970278 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213389: mm_page_alloc: page=00000000c4be79fb pfn=970279 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213391: mm_page_alloc: page=00000000f8a51d4f pfn=970260 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213393: mm_page_alloc: page=000000006ba8f5ac pfn=970261 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213395: mm_page_alloc: page=00000000819f1cd3 pfn=970196 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
  <...>-22275 [006] ....   889.213396: mm_page_alloc: page=00000000f6b72a64 pfn=970197 order=0 migratetype=0 nr_free=3650 gfp_flags=GFP_HIGHUSER|__GFP_ZERO
kswapd0-1207  [005] ...1   889.213398: mm_page_alloc: page= (null) pfn=0 order=0 migratetype=1 nr_free=3650 gfp_flags=GFP_NOWAIT|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_MOVABLE

[jaewon31.kim@samsung.com: remove redundant code for high-order]
  Link: http://lkml.kernel.org/r/20200623035242.27232-1-jaewon31.kim@samsung.com

Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Link: http://lkml.kernel.org/r/20200619235958.11283-1-jaewon31.kim@samsung.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_alloc.c | 65 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c35403..237463d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3130,6 +3130,29 @@ static inline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
+static inline long __zone_watermark_unusable_free(struct zone *z,
+				unsigned int order, unsigned int alloc_flags)
+{
+	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
+	long unusable_free = (1 << order) - 1;
+
+	/*
+	 * If the caller does not have rights to ALLOC_HARDER then subtract
+	 * the high-atomic reserves. This will over-estimate the size of the
+	 * atomic reserve but it avoids a search.
+	 */
+	if (likely(!alloc_harder))
+		unusable_free += z->nr_reserved_highatomic;
+
+#ifdef CONFIG_CMA
+	/* If allocation can't use CMA areas don't use free CMA pages */
+	if (!(alloc_flags & ALLOC_CMA))
+		unusable_free += zone_page_state(z, NR_FREE_CMA_PAGES);
+#endif
+
+	return unusable_free;
+}
+
 /*
  * Return true if free base pages are above 'mark'. For high-order checks it
  * will return true of the order-0 watermark is reached and there is at least
@@ -3145,19 +3168,12 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 	const bool alloc_harder = (alloc_flags & (ALLOC_HARDER|ALLOC_OOM));
 
 	/* free_pages may go negative - that's OK */
-	free_pages -= (1 << order) - 1;
+	free_pages -= __zone_watermark_unusable_free(z, order, alloc_flags);
 
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
 
-	/*
-	 * If the caller does not have rights to ALLOC_HARDER then subtract
-	 * the high-atomic reserves. This will over-estimate the size of the
-	 * atomic reserve but it avoids a search.
-	 */
-	if (likely(!alloc_harder)) {
-		free_pages -= z->nr_reserved_highatomic;
-	} else {
+	if (unlikely(alloc_harder)) {
 		/*
 		 * OOM victims can try even harder than normal ALLOC_HARDER
 		 * users on the grounds that it's definitely going to be in
@@ -3170,13 +3186,6 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			min -= min / 4;
 	}
 
-
-#ifdef CONFIG_CMA
-	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
-		free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
-
 	/*
 	 * Check watermarks for an order-0 allocation request. If these
 	 * are not met, then a high-order request also cannot go ahead
@@ -3225,24 +3234,22 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 		unsigned long mark, int classzone_idx, unsigned int alloc_flags)
 {
-	long free_pages = zone_page_state(z, NR_FREE_PAGES);
-	long cma_pages = 0;
+	long free_pages;
 
-#ifdef CONFIG_CMA
-	/* If allocation can't use CMA areas don't use free CMA pages */
-	if (!(alloc_flags & ALLOC_CMA))
-		cma_pages = zone_page_state(z, NR_FREE_CMA_PAGES);
-#endif
+	free_pages = zone_page_state(z, NR_FREE_PAGES);
 
 	/*
 	 * Fast check for order-0 only. If this fails then the reserves
-	 * need to be calculated. There is a corner case where the check
-	 * passes but only the high-order atomic reserve are free. If
-	 * the caller is !atomic then it'll uselessly search the free
-	 * list. That corner case is then slower but it is harmless.
+	 * need to be calculated.
 	 */
-	if (!order && (free_pages - cma_pages) > mark + z->lowmem_reserve[classzone_idx])
-		return true;
+	if (!order) {
+		long fast_free;
+
+		fast_free = free_pages;
+		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
+		if (fast_free > mark + z->lowmem_reserve[classzone_idx])
+			return true;
+	}
 
 	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
 					free_pages);
-- 
2.7.4

