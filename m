Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ACE5938AC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245614AbiHOTMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343943AbiHOTLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:11:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC614F1A6;
        Mon, 15 Aug 2022 11:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B436161129;
        Mon, 15 Aug 2022 18:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A192AC433C1;
        Mon, 15 Aug 2022 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588616;
        bh=acG0Ir6mHP3cYPb/vZ/vXu97MaHwAxbCdXUpZ4Qddbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whiN8ivJh0UCVHBN7EmezDholctLQ/Laa1bdXxwqJf2upmeJ8maSNMWpsZdYhsxU5
         PTb8VE3FeZ2k/TVn4OaGIOt2Dsv3VbuWTFJW+3/IgslWBTV+IuNl+aVmBOunrTK3eW
         sGv4fDL5aLZwi36OMT412Lp85FEsPbClXYJ+pJxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/779] memremap: remove support for external pgmap refcounts
Date:   Mon, 15 Aug 2022 20:01:14 +0200
Message-Id: <20220815180355.666680477@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b80892ca022e9eb484771a66eb68e12364695a2a ]

No driver is left using the external pgmap refcount, so remove the
code to support it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20211028151017.50234-1-hch@lst.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c              |  2 +-
 include/linux/memremap.h          | 18 ++--------
 mm/memremap.c                     | 59 +++++++------------------------
 tools/testing/nvdimm/test/iomap.c | 43 +++++++---------------
 4 files changed, 28 insertions(+), 94 deletions(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 50cdde3e9a8b..316fd2f44df4 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -219,7 +219,7 @@ int pci_p2pdma_add_resource(struct pci_dev *pdev, int bar, size_t size,
 	error = gen_pool_add_owner(p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
 			range_len(&pgmap->range), dev_to_node(&pdev->dev),
-			pgmap->ref);
+			&pgmap->ref);
 	if (error)
 		goto pages_free;
 
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c0e9d35889e8..a8bc588fe7aa 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -72,16 +72,6 @@ struct dev_pagemap_ops {
 	 */
 	void (*page_free)(struct page *page);
 
-	/*
-	 * Transition the refcount in struct dev_pagemap to the dead state.
-	 */
-	void (*kill)(struct dev_pagemap *pgmap);
-
-	/*
-	 * Wait for refcount in struct dev_pagemap to be idle and reap it.
-	 */
-	void (*cleanup)(struct dev_pagemap *pgmap);
-
 	/*
 	 * Used for private (un-addressable) device memory only.  Must migrate
 	 * the page back to a CPU accessible page.
@@ -95,8 +85,7 @@ struct dev_pagemap_ops {
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
  * @ref: reference count that pins the devm_memremap_pages() mapping
- * @internal_ref: internal reference if @ref is not provided by the caller
- * @done: completion for @internal_ref
+ * @done: completion for @ref
  * @type: memory type: see MEMORY_* in memory_hotplug.h
  * @flags: PGMAP_* flags to specify defailed behavior
  * @ops: method table
@@ -109,8 +98,7 @@ struct dev_pagemap_ops {
  */
 struct dev_pagemap {
 	struct vmem_altmap altmap;
-	struct percpu_ref *ref;
-	struct percpu_ref internal_ref;
+	struct percpu_ref ref;
 	struct completion done;
 	enum memory_type type;
 	unsigned int flags;
@@ -191,7 +179,7 @@ static inline unsigned long memremap_compat_align(void)
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
 {
 	if (pgmap)
-		percpu_ref_put(pgmap->ref);
+		percpu_ref_put(&pgmap->ref);
 }
 
 #endif /* _LINUX_MEMREMAP_H_ */
diff --git a/mm/memremap.c b/mm/memremap.c
index e77487375c8e..a638a27d89f5 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -112,30 +112,6 @@ static unsigned long pfn_next(unsigned long pfn)
 #define for_each_device_pfn(pfn, map, i) \
 	for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
 
-static void dev_pagemap_kill(struct dev_pagemap *pgmap)
-{
-	if (pgmap->ops && pgmap->ops->kill)
-		pgmap->ops->kill(pgmap);
-	else
-		percpu_ref_kill(pgmap->ref);
-}
-
-static void dev_pagemap_cleanup(struct dev_pagemap *pgmap)
-{
-	if (pgmap->ops && pgmap->ops->cleanup) {
-		pgmap->ops->cleanup(pgmap);
-	} else {
-		wait_for_completion(&pgmap->done);
-		percpu_ref_exit(pgmap->ref);
-	}
-	/*
-	 * Undo the pgmap ref assignment for the internal case as the
-	 * caller may re-enable the same pgmap.
-	 */
-	if (pgmap->ref == &pgmap->internal_ref)
-		pgmap->ref = NULL;
-}
-
 static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 {
 	struct range *range = &pgmap->ranges[range_id];
@@ -167,11 +143,12 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 	unsigned long pfn;
 	int i;
 
-	dev_pagemap_kill(pgmap);
+	percpu_ref_kill(&pgmap->ref);
 	for (i = 0; i < pgmap->nr_range; i++)
 		for_each_device_pfn(pfn, pgmap, i)
 			put_page(pfn_to_page(pfn));
-	dev_pagemap_cleanup(pgmap);
+	wait_for_completion(&pgmap->done);
+	percpu_ref_exit(&pgmap->ref);
 
 	for (i = 0; i < pgmap->nr_range; i++)
 		pageunmap_range(pgmap, i);
@@ -188,8 +165,7 @@ static void devm_memremap_pages_release(void *data)
 
 static void dev_pagemap_percpu_release(struct percpu_ref *ref)
 {
-	struct dev_pagemap *pgmap =
-		container_of(ref, struct dev_pagemap, internal_ref);
+	struct dev_pagemap *pgmap = container_of(ref, struct dev_pagemap, ref);
 
 	complete(&pgmap->done);
 }
@@ -295,8 +271,8 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
-			- pfn_first(pgmap, range_id));
+	percpu_ref_get_many(&pgmap->ref,
+		pfn_end(pgmap, range_id) - pfn_first(pgmap, range_id));
 	return 0;
 
 err_add_memory:
@@ -362,22 +338,11 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 		break;
 	}
 
-	if (!pgmap->ref) {
-		if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
-			return ERR_PTR(-EINVAL);
-
-		init_completion(&pgmap->done);
-		error = percpu_ref_init(&pgmap->internal_ref,
-				dev_pagemap_percpu_release, 0, GFP_KERNEL);
-		if (error)
-			return ERR_PTR(error);
-		pgmap->ref = &pgmap->internal_ref;
-	} else {
-		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
-			WARN(1, "Missing reference count teardown definition\n");
-			return ERR_PTR(-EINVAL);
-		}
-	}
+	init_completion(&pgmap->done);
+	error = percpu_ref_init(&pgmap->ref, dev_pagemap_percpu_release, 0,
+				GFP_KERNEL);
+	if (error)
+		return ERR_PTR(error);
 
 	devmap_managed_enable_get(pgmap);
 
@@ -486,7 +451,7 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
-	if (pgmap && !percpu_ref_tryget_live(pgmap->ref))
+	if (pgmap && !percpu_ref_tryget_live(&pgmap->ref))
 		pgmap = NULL;
 	rcu_read_unlock();
 
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index ed563bdd88f3..b752ce47ead3 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -100,25 +100,17 @@ static void nfit_test_kill(void *_pgmap)
 {
 	struct dev_pagemap *pgmap = _pgmap;
 
-	WARN_ON(!pgmap || !pgmap->ref);
-
-	if (pgmap->ops && pgmap->ops->kill)
-		pgmap->ops->kill(pgmap);
-	else
-		percpu_ref_kill(pgmap->ref);
-
-	if (pgmap->ops && pgmap->ops->cleanup) {
-		pgmap->ops->cleanup(pgmap);
-	} else {
-		wait_for_completion(&pgmap->done);
-		percpu_ref_exit(pgmap->ref);
-	}
+	WARN_ON(!pgmap);
+
+	percpu_ref_kill(&pgmap->ref);
+
+	wait_for_completion(&pgmap->done);
+	percpu_ref_exit(&pgmap->ref);
 }
 
 static void dev_pagemap_percpu_release(struct percpu_ref *ref)
 {
-	struct dev_pagemap *pgmap =
-		container_of(ref, struct dev_pagemap, internal_ref);
+	struct dev_pagemap *pgmap = container_of(ref, struct dev_pagemap, ref);
 
 	complete(&pgmap->done);
 }
@@ -132,22 +124,11 @@ void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 	if (!nfit_res)
 		return devm_memremap_pages(dev, pgmap);
 
-	if (!pgmap->ref) {
-		if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
-			return ERR_PTR(-EINVAL);
-
-		init_completion(&pgmap->done);
-		error = percpu_ref_init(&pgmap->internal_ref,
-				dev_pagemap_percpu_release, 0, GFP_KERNEL);
-		if (error)
-			return ERR_PTR(error);
-		pgmap->ref = &pgmap->internal_ref;
-	} else {
-		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
-			WARN(1, "Missing reference count teardown definition\n");
-			return ERR_PTR(-EINVAL);
-		}
-	}
+	init_completion(&pgmap->done);
+	error = percpu_ref_init(&pgmap->ref, dev_pagemap_percpu_release, 0,
+				GFP_KERNEL);
+	if (error)
+		return ERR_PTR(error);
 
 	error = devm_add_action_or_reset(dev, nfit_test_kill, pgmap);
 	if (error)
-- 
2.35.1



