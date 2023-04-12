Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652E96DEEB0
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjDLIoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjDLIoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78287D94
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BFEE630B4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CB9C433EF;
        Wed, 12 Apr 2023 08:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288987;
        bh=qRnW51CAr4tybE3yzK5UfT/m6IaLRpp8rBezNZ9P2Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX02KK+hji2McX4curzRNfzlE1eVLPjQYYVsy+5vCjOGDiyYGMXN2k8E/ZTvjzwSt
         RlzuiuCKY/ZbaCskkxF6be1SSxUmxEep6joaNZyh0EzGJjMfcjdE1DxBX3ViyHcqQZ
         ReCgbhUCJRjr63+nhCdRfVhFj1EOQu1freqlQcL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Muchun Song <songmuchun@bytedance.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Jann Horn <jannh@google.com>, Marco Elver <elver@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        SeongJae Park <sjpark@amazon.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 094/164] mm: kfence: fix PG_slab and memcg_data clearing
Date:   Wed, 12 Apr 2023 10:33:36 +0200
Message-Id: <20230412082840.675462099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

From: Muchun Song <songmuchun@bytedance.com>

commit 3ee2d7471fa4963a2ced0a84f0653ce88b43c5b2 upstream.

It does not reset PG_slab and memcg_data when KFENCE fails to initialize
kfence pool at runtime.  It is reporting a "Bad page state" message when
kfence pool is freed to buddy.  The checking of whether it is a compound
head page seems unnecessary since we already guarantee this when
allocating kfence pool.   Remove the check to simplify the code.

Link: https://lkml.kernel.org/r/20230320030059.20189-1-songmuchun@bytedance.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -562,10 +562,6 @@ static unsigned long kfence_init_pool(vo
 		if (!i || (i % 2))
 			continue;
 
-		/* Verify we do not have a compound head page. */
-		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
-			return addr;
-
 		__folio_set_slab(slab_folio(slab));
 #ifdef CONFIG_MEMCG
 		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
@@ -598,12 +594,26 @@ static unsigned long kfence_init_pool(vo
 
 		/* Protect the right redzone. */
 		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
-			return addr;
+			goto reset_slab;
 
 		addr += 2 * PAGE_SIZE;
 	}
 
 	return 0;
+
+reset_slab:
+	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct slab *slab = page_slab(&pages[i]);
+
+		if (!i || (i % 2))
+			continue;
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = 0;
+#endif
+		__folio_clear_slab(slab_folio(slab));
+	}
+
+	return addr;
 }
 
 static bool __init kfence_init_pool_early(void)
@@ -633,16 +643,6 @@ static bool __init kfence_init_pool_earl
 	 * fails for the first page, and therefore expect addr==__kfence_pool in
 	 * most failure cases.
 	 */
-	for (char *p = (char *)addr; p < __kfence_pool + KFENCE_POOL_SIZE; p += PAGE_SIZE) {
-		struct slab *slab = virt_to_slab(p);
-
-		if (!slab)
-			continue;
-#ifdef CONFIG_MEMCG
-		slab->memcg_data = 0;
-#endif
-		__folio_clear_slab(slab_folio(slab));
-	}
 	memblock_free_late(__pa(addr), KFENCE_POOL_SIZE - (addr - (unsigned long)__kfence_pool));
 	__kfence_pool = NULL;
 	return false;


