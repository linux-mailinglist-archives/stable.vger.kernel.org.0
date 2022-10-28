Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF45561108A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiJ1MGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiJ1MGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:06:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AD3B8C2C
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 000FB62807
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B38C433C1;
        Fri, 28 Oct 2022 12:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958794;
        bh=e6Kwfj8b9VtoSQA1NKD3Sf47xiVDNYYBJjNUh04cwEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWXOMC0LyUSW8CBmQdohmVUUHNCS2lmlkxj86TDmffd/gvGX+dXAx53kXenes1amx
         oakWDHwoCIUX/XcHGRyr/69dIH8Fjz3rmeKBd6QXRVSC8TMDDJZSqjHgWulE+mtITs
         3HyJqx6XxHece3e87UcfjNPT4IDGC+1AboV55RVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juergen Gross <jgross@suse.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/73] xen: assume XENFEAT_gnttab_map_avail_bits being set for pv guests
Date:   Fri, 28 Oct 2022 14:03:51 +0200
Message-Id: <20221028120234.723819100@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 30dcc56bba911db561c35d4131baf983a41023f8 ]

XENFEAT_gnttab_map_avail_bits is always set in Xen 4.0 and newer.
Remove coding assuming it might be zero.

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210730071804.4302-4-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: 5c13a4a0291b ("xen/gntdev: Accommodate VMA splitting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 36 ++----------------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 54fee4087bf1..5dd9d1ac755e 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -289,20 +289,13 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 {
 	struct gntdev_grant_map *map = data;
 	unsigned int pgnr = (addr - map->vma->vm_start) >> PAGE_SHIFT;
-	int flags = map->flags | GNTMAP_application_map | GNTMAP_contains_pte;
+	int flags = map->flags | GNTMAP_application_map | GNTMAP_contains_pte |
+		    (1 << _GNTMAP_guest_avail0);
 	u64 pte_maddr;
 
 	BUG_ON(pgnr >= map->count);
 	pte_maddr = arbitrary_virt_to_machine(pte).maddr;
 
-	/*
-	 * Set the PTE as special to force get_user_pages_fast() fall
-	 * back to the slow path.  If this is not supported as part of
-	 * the grant map, it will be done afterwards.
-	 */
-	if (xen_feature(XENFEAT_gnttab_map_avail_bits))
-		flags |= (1 << _GNTMAP_guest_avail0);
-
 	gnttab_set_map_op(&map->map_ops[pgnr], pte_maddr, flags,
 			  map->grants[pgnr].ref,
 			  map->grants[pgnr].domid);
@@ -311,14 +304,6 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 	return 0;
 }
 
-#ifdef CONFIG_X86
-static int set_grant_ptes_as_special(pte_t *pte, unsigned long addr, void *data)
-{
-	set_pte_at(current->mm, addr, pte, pte_mkspecial(*pte));
-	return 0;
-}
-#endif
-
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
 	size_t alloced = 0;
@@ -1102,23 +1087,6 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		err = vm_map_pages_zero(vma, map->pages, map->count);
 		if (err)
 			goto out_put_map;
-	} else {
-#ifdef CONFIG_X86
-		/*
-		 * If the PTEs were not made special by the grant map
-		 * hypercall, do so here.
-		 *
-		 * This is racy since the mapping is already visible
-		 * to userspace but userspace should be well-behaved
-		 * enough to not touch it until the mmap() call
-		 * returns.
-		 */
-		if (!xen_feature(XENFEAT_gnttab_map_avail_bits)) {
-			apply_to_page_range(vma->vm_mm, vma->vm_start,
-					    vma->vm_end - vma->vm_start,
-					    set_grant_ptes_as_special, NULL);
-		}
-#endif
 	}
 
 	return 0;
-- 
2.35.1



