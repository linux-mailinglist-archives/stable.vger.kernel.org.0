Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E9456A780
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 18:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiGGQIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 12:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235710AbiGGQIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 12:08:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C8F13F24;
        Thu,  7 Jul 2022 09:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58386623D0;
        Thu,  7 Jul 2022 16:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364D0C341C0;
        Thu,  7 Jul 2022 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657210110;
        bh=Uk6AL+D7oDCD/G19N4B8xkYeut7GFycO1avngUZV6YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWkgLeONJaM3c560BZidYMZm8dYGbaBeLKyBGecR2dQEcgjYSZ7eH2SuBUY7HdVkt
         Bie5M+n2zzwBu4B7tp0nOElycm1D0E6Y9Z/0LKMgwH1cwgyB+JOiXB2iBk4Vktuvmg
         ABXs/W6MSx4sM7RoJnB3IdxScSbagBsdJL8G0bms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.287
Date:   Thu,  7 Jul 2022 18:08:14 +0200
Message-Id: <165721009410161@kroah.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <165721009435145@kroah.com>
References: <165721009435145@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4040699fbfdd..1ae54266908b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 286
+SUBLEVEL = 287
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
index 8a8a388549e7..e04b5044f597 100644
--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -61,11 +61,12 @@ static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
 
 unsigned long __pfn_to_mfn(unsigned long pfn)
 {
-	struct rb_node *n = phys_to_mach.rb_node;
+	struct rb_node *n;
 	struct xen_p2m_entry *entry;
 	unsigned long irqflags;
 
 	read_lock_irqsave(&p2m_lock, irqflags);
+	n = phys_to_mach.rb_node;
 	while (n) {
 		entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
 		if (entry->pfn <= pfn &&
@@ -151,10 +152,11 @@ bool __set_phys_to_machine_multi(unsigned long pfn,
 	int rc;
 	unsigned long irqflags;
 	struct xen_p2m_entry *p2m_entry;
-	struct rb_node *n = phys_to_mach.rb_node;
+	struct rb_node *n;
 
 	if (mfn == INVALID_P2M_ENTRY) {
 		write_lock_irqsave(&p2m_lock, irqflags);
+		n = phys_to_mach.rb_node;
 		while (n) {
 			p2m_entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
 			if (p2m_entry->pfn <= pfn &&
diff --git a/arch/s390/crypto/arch_random.c b/arch/s390/crypto/arch_random.c
index 36aefc07d10c..1f2d40993c4d 100644
--- a/arch/s390/crypto/arch_random.c
+++ b/arch/s390/crypto/arch_random.c
@@ -1,13 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * s390 arch random implementation.
  *
- * Copyright IBM Corp. 2017
- * Author(s): Harald Freudenberger <freude@de.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License (version 2 only)
- * as published by the Free Software Foundation.
- *
+ * Copyright IBM Corp. 2017, 2020
+ * Author(s): Harald Freudenberger
  */
 
 #include <linux/kernel.h>
@@ -20,13 +16,3 @@ DEFINE_STATIC_KEY_FALSE(s390_arch_random_available);
 
 atomic64_t s390_arch_random_counter = ATOMIC64_INIT(0);
 EXPORT_SYMBOL(s390_arch_random_counter);
-
-static int __init s390_arch_random_init(void)
-{
-	/* check if subfunction CPACF_PRNO_TRNG is available */
-	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
-		static_branch_enable(&s390_arch_random_available);
-
-	return 0;
-}
-arch_initcall(s390_arch_random_init);
diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
index ddf97715ee53..2c6e1c6ecbe7 100644
--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017
+ * Copyright IBM Corp. 2017, 2020
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -20,38 +20,34 @@
 DECLARE_STATIC_KEY_FALSE(s390_arch_random_available);
 extern atomic64_t s390_arch_random_counter;
 
-static void s390_arch_random_generate(u8 *buf, unsigned int nbytes)
+static inline bool __must_check arch_get_random_long(unsigned long *v)
 {
-	cpacf_trng(NULL, 0, buf, nbytes);
-	atomic64_add(nbytes, &s390_arch_random_counter);
+	return false;
 }
 
-static inline bool arch_get_random_long(unsigned long *v)
+static inline bool __must_check arch_get_random_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
-		s390_arch_random_generate((u8 *)v, sizeof(*v));
-		return true;
-	}
 	return false;
 }
 
-static inline bool arch_get_random_int(unsigned int *v)
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
 	if (static_branch_likely(&s390_arch_random_available)) {
-		s390_arch_random_generate((u8 *)v, sizeof(*v));
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
 	}
 	return false;
 }
 
-static inline bool arch_get_random_seed_long(unsigned long *v)
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	return arch_get_random_long(v);
-}
-
-static inline bool arch_get_random_seed_int(unsigned int *v)
-{
-	return arch_get_random_int(v);
+	if (static_branch_likely(&s390_arch_random_available)) {
+		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
+		atomic64_add(sizeof(*v), &s390_arch_random_counter);
+		return true;
+	}
+	return false;
 }
 
 #endif /* CONFIG_ARCH_RANDOM */
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e9ef093eb676..b3343f093f67 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -853,6 +853,11 @@ static void __init setup_randomness(void)
 	if (stsi(vmms, 3, 2, 2) == 0 && vmms->count)
 		add_device_randomness(&vmms->vm, sizeof(vmms->vm[0]) * vmms->count);
 	memblock_free((unsigned long) vmms, PAGE_SIZE);
+
+#ifdef CONFIG_ARCH_RANDOM
+	if (cpacf_query_func(CPACF_PRNO, CPACF_PRNO_TRNG))
+		static_branch_enable(&s390_arch_random_available);
+#endif
 }
 
 /*
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a97a306c3850..cd58f582c50c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -148,6 +148,10 @@ static unsigned int xen_blkif_max_ring_order;
 module_param_named(max_ring_page_order, xen_blkif_max_ring_order, int, S_IRUGO);
 MODULE_PARM_DESC(max_ring_page_order, "Maximum order of pages to be used for the shared ring");
 
+static bool __read_mostly xen_blkif_trusted = true;
+module_param_named(trusted, xen_blkif_trusted, bool, 0644);
+MODULE_PARM_DESC(trusted, "Is the backend trusted");
+
 #define BLK_RING_SIZE(info)	\
 	__CONST_RING_SIZE(blkif, XEN_PAGE_SIZE * (info)->nr_ring_pages)
 
@@ -208,6 +212,7 @@ struct blkfront_info
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
 	unsigned int feature_persistent:1;
+	unsigned int bounce:1;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	/* Number of 4KB segments handled */
@@ -301,8 +306,8 @@ static int fill_grant_buffer(struct blkfront_ring_info *rinfo, int num)
 		if (!gnt_list_entry)
 			goto out_of_memory;
 
-		if (info->feature_persistent) {
-			granted_page = alloc_page(GFP_NOIO);
+		if (info->bounce) {
+			granted_page = alloc_page(GFP_NOIO | __GFP_ZERO);
 			if (!granted_page) {
 				kfree(gnt_list_entry);
 				goto out_of_memory;
@@ -321,7 +326,7 @@ static int fill_grant_buffer(struct blkfront_ring_info *rinfo, int num)
 	list_for_each_entry_safe(gnt_list_entry, n,
 	                         &rinfo->grants, node) {
 		list_del(&gnt_list_entry->node);
-		if (info->feature_persistent)
+		if (info->bounce)
 			__free_page(gnt_list_entry->page);
 		kfree(gnt_list_entry);
 		i--;
@@ -367,7 +372,7 @@ static struct grant *get_grant(grant_ref_t *gref_head,
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (info->feature_persistent)
+	if (info->bounce)
 		grant_foreign_access(gnt_list_entry, info);
 	else {
 		/* Grant access to the GFN passed by the caller */
@@ -391,7 +396,7 @@ static struct grant *get_indirect_grant(grant_ref_t *gref_head,
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (!info->feature_persistent) {
+	if (!info->bounce) {
 		struct page *indirect_page;
 
 		/* Fetch a pre-allocated page to use for indirect grefs */
@@ -706,7 +711,7 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 		.grant_idx = 0,
 		.segments = NULL,
 		.rinfo = rinfo,
-		.need_copy = rq_data_dir(req) && info->feature_persistent,
+		.need_copy = rq_data_dir(req) && info->bounce,
 	};
 
 	/*
@@ -1027,11 +1032,12 @@ static void xlvbd_flush(struct blkfront_info *info)
 {
 	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
 			      info->feature_fua ? true : false);
-	pr_info("blkfront: %s: %s %s %s %s %s\n",
+	pr_info("blkfront: %s: %s %s %s %s %s %s %s\n",
 		info->gd->disk_name, flush_info(info),
 		"persistent grants:", info->feature_persistent ?
 		"enabled;" : "disabled;", "indirect descriptors:",
-		info->max_indirect_segments ? "enabled;" : "disabled;");
+		info->max_indirect_segments ? "enabled;" : "disabled;",
+		"bounce buffer:", info->bounce ? "enabled" : "disabled;");
 }
 
 static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
@@ -1266,7 +1272,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 	if (!list_empty(&rinfo->indirect_pages)) {
 		struct page *indirect_page, *n;
 
-		BUG_ON(info->feature_persistent);
+		BUG_ON(info->bounce);
 		list_for_each_entry_safe(indirect_page, n, &rinfo->indirect_pages, lru) {
 			list_del(&indirect_page->lru);
 			__free_page(indirect_page);
@@ -1283,7 +1289,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 				continue;
 
 			rinfo->persistent_gnts_c--;
-			if (info->feature_persistent)
+			if (info->bounce)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1303,7 +1309,7 @@ static void blkif_free_ring(struct blkfront_ring_info *rinfo)
 		for (j = 0; j < segs; j++) {
 			persistent_gnt = rinfo->shadow[i].grants_used[j];
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
-			if (info->feature_persistent)
+			if (info->bounce)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1493,7 +1499,7 @@ static int blkif_completion(unsigned long *id,
 	data.s = s;
 	num_sg = s->num_sg;
 
-	if (bret->operation == BLKIF_OP_READ && info->feature_persistent) {
+	if (bret->operation == BLKIF_OP_READ && info->bounce) {
 		for_each_sg(s->sg, sg, num_sg, i) {
 			BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
@@ -1552,7 +1558,7 @@ static int blkif_completion(unsigned long *id,
 				 * Add the used indirect page back to the list of
 				 * available pages for indirect grefs.
 				 */
-				if (!info->feature_persistent) {
+				if (!info->bounce) {
 					indirect_page = s->indirect_grants[i]->page;
 					list_add(&indirect_page->lru, &rinfo->indirect_pages);
 				}
@@ -1744,7 +1750,7 @@ static int setup_blkring(struct xenbus_device *dev,
 	for (i = 0; i < info->nr_ring_pages; i++)
 		rinfo->ring_ref[i] = GRANT_INVALID_REF;
 
-	sring = alloc_pages_exact(ring_size, GFP_NOIO);
+	sring = alloc_pages_exact(ring_size, GFP_NOIO | __GFP_ZERO);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -1841,6 +1847,10 @@ static int talk_to_blkback(struct xenbus_device *dev,
 	if (!info)
 		return -ENODEV;
 
+	/* Check if backend is trusted. */
+	info->bounce = !xen_blkif_trusted ||
+		       !xenbus_read_unsigned(dev->nodename, "trusted", 1);
+
 	max_page_order = xenbus_read_unsigned(info->xbdev->otherend,
 					      "max-ring-page-order", 0);
 	ring_page_order = min(xen_blkif_max_ring_order, max_page_order);
@@ -2256,17 +2266,18 @@ static int blkfront_setup_indirect(struct blkfront_ring_info *rinfo)
 	if (err)
 		goto out_of_memory;
 
-	if (!info->feature_persistent && info->max_indirect_segments) {
+	if (!info->bounce && info->max_indirect_segments) {
 		/*
-		 * We are using indirect descriptors but not persistent
-		 * grants, we need to allocate a set of pages that can be
+		 * We are using indirect descriptors but don't have a bounce
+		 * buffer, we need to allocate a set of pages that can be
 		 * used for mapping indirect grefs
 		 */
 		int num = INDIRECT_GREFS(grants) * BLK_RING_SIZE(info);
 
 		BUG_ON(!list_empty(&rinfo->indirect_pages));
 		for (i = 0; i < num; i++) {
-			struct page *indirect_page = alloc_page(GFP_NOIO);
+			struct page *indirect_page = alloc_page(GFP_NOIO |
+			                                        __GFP_ZERO);
 			if (!indirect_page)
 				goto out_of_memory;
 			list_add(&indirect_page->lru, &rinfo->indirect_pages);
@@ -2351,6 +2362,8 @@ static void blkfront_gather_backend_features(struct blkfront_info *info)
 	info->feature_persistent =
 		!!xenbus_read_unsigned(info->xbdev->otherend,
 				       "feature-persistent", 0);
+	if (info->feature_persistent)
+		info->bounce = true;
 
 	indirect_segments = xenbus_read_unsigned(info->xbdev->otherend,
 					"feature-max-indirect-segments", 0);
diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 1f643782ce04..c9cfc958e853 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -563,7 +563,7 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 
 	res = platform_device_add(data->pdev);
 	if (res)
-		goto ipmi_err;
+		goto dev_add_err;
 
 	platform_set_drvdata(data->pdev, data);
 
@@ -611,7 +611,9 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 	ipmi_destroy_user(data->ipmi.user);
 ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
-	platform_device_unregister(data->pdev);
+	platform_device_del(data->pdev);
+dev_add_err:
+	platform_device_put(data->pdev);
 dev_err:
 	ida_simple_remove(&aem_ida, data->id);
 id_err:
@@ -703,7 +705,7 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 
 	res = platform_device_add(data->pdev);
 	if (res)
-		goto ipmi_err;
+		goto dev_add_err;
 
 	platform_set_drvdata(data->pdev, data);
 
@@ -751,7 +753,9 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 	ipmi_destroy_user(data->ipmi.user);
 ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
-	platform_device_unregister(data->pdev);
+	platform_device_del(data->pdev);
+dev_add_err:
+	platform_device_put(data->pdev);
 dev_err:
 	ida_simple_remove(&aem_ida, data->id);
 id_err:
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 254083b524bd..b40f6f41005b 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -361,6 +361,7 @@ struct qedr_qp {
 	u32 sq_psn;
 	u32 qkey;
 	u32 dest_qp_num;
+	u8 timeout;
 
 	/* Relevant to qps created from kernel space only (ULPs) */
 	u8 prev_wqe_size;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 990e652cb4ca..53252eacf036 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1921,6 +1921,8 @@ int qedr_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					1 << max_t(int, attr->timeout - 8, 0);
 		else
 			qp_params.ack_timeout = 0;
+
+		qp->timeout = attr->timeout;
 	}
 
 	if (attr_mask & IB_QP_RETRY_CNT) {
@@ -2080,7 +2082,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	rdma_ah_set_dgid_raw(&qp_attr->ah_attr, &params.dgid.bytes[0]);
 	rdma_ah_set_port_num(&qp_attr->ah_attr, 1);
 	rdma_ah_set_sl(&qp_attr->ah_attr, 0);
-	qp_attr->timeout = params.timeout;
+	qp_attr->timeout = qp->timeout;
 	qp_attr->rnr_retry = params.rnr_retry;
 	qp_attr->retry_cnt = params.retry_cnt;
 	qp_attr->min_rnr_timer = params.min_rnr_nak_timer;
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2c5912e75514..85deeb90904b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -998,12 +998,13 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
 static int validate_raid_redundancy(struct raid_set *rs)
 {
 	unsigned int i, rebuild_cnt = 0;
-	unsigned int rebuilds_per_group = 0, copies;
+	unsigned int rebuilds_per_group = 0, copies, raid_disks;
 	unsigned int group_size, last_group_start;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
-		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
-		    !rs->dev[i].rdev.sb_page)
+	for (i = 0; i < rs->raid_disks; i++)
+		if (!test_bit(FirstUse, &rs->dev[i].rdev.flags) &&
+		    ((!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
+		      !rs->dev[i].rdev.sb_page)))
 			rebuild_cnt++;
 
 	switch (rs->raid_type->level) {
@@ -1038,8 +1039,9 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		 *	    A	 A    B	   B	C
 		 *	    C	 D    D	   E	E
 		 */
+		raid_disks = min(rs->raid_disks, rs->md.raid_disks);
 		if (__is_raid10_near(rs->md.new_layout)) {
-			for (i = 0; i < rs->md.raid_disks; i++) {
+			for (i = 0; i < raid_disks; i++) {
 				if (!(i % copies))
 					rebuilds_per_group = 0;
 				if ((!rs->dev[i].rdev.sb_page ||
@@ -1062,10 +1064,10 @@ static int validate_raid_redundancy(struct raid_set *rs)
 		 * results in the need to treat the last (potentially larger)
 		 * set differently.
 		 */
-		group_size = (rs->md.raid_disks / copies);
-		last_group_start = (rs->md.raid_disks / group_size) - 1;
+		group_size = (raid_disks / copies);
+		last_group_start = (raid_disks / group_size) - 1;
 		last_group_start *= group_size;
-		for (i = 0; i < rs->md.raid_disks; i++) {
+		for (i = 0; i < raid_disks; i++) {
 			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
 			if ((!rs->dev[i].rdev.sb_page ||
@@ -1569,7 +1571,7 @@ static sector_t __rdev_sectors(struct raid_set *rs)
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->raid_disks; i++) {
 		struct md_rdev *rdev = &rs->dev[i].rdev;
 
 		if (!test_bit(Journal, &rdev->flags) &&
@@ -3611,13 +3613,13 @@ static int raid_iterate_devices(struct dm_target *ti,
 	unsigned int i;
 	int r = 0;
 
-	for (i = 0; !r && i < rs->md.raid_disks; i++)
-		if (rs->dev[i].data_dev)
-			r = fn(ti,
-				 rs->dev[i].data_dev,
-				 0, /* No offset on data devs */
-				 rs->md.dev_sectors,
-				 data);
+	for (i = 0; !r && i < rs->raid_disks; i++) {
+		if (rs->dev[i].data_dev) {
+			r = fn(ti, rs->dev[i].data_dev,
+			       0, /* No offset on data devs */
+			       rs->md.dev_sectors, data);
+		}
+	}
 
 	return r;
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ed55b02f9f89..1e52443f3aca 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7689,6 +7689,7 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	 */
 	if (rdev->saved_raid_disk >= 0 &&
 	    rdev->saved_raid_disk >= first &&
+	    rdev->saved_raid_disk <= last &&
 	    conf->disks[rdev->saved_raid_disk].rdev == NULL)
 		first = rdev->saved_raid_disk;
 
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index e3f814e83d9c..b3eaef31b767 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2199,7 +2199,8 @@ void bond_3ad_unbind_slave(struct slave *slave)
 				temp_aggregator->num_of_ports--;
 				if (__agg_active_ports(temp_aggregator) == 0) {
 					select_new_active_agg = temp_aggregator->is_active;
-					ad_clear_agg(temp_aggregator);
+					if (temp_aggregator->num_of_ports == 0)
+						ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
 						netdev_info(bond->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 0b79ddec15b7..4926c3e06e4e 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1296,12 +1296,12 @@ int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
 		return res;
 
 	if (rlb_enabled) {
-		bond->alb_info.rlb_enabled = 1;
 		res = rlb_initialize(bond);
 		if (res) {
 			tlb_deinitialize(bond);
 			return res;
 		}
+		bond->alb_info.rlb_enabled = 1;
 	} else {
 		bond->alb_info.rlb_enabled = 0;
 	}
diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index c3d104feee13..f9738b7bc505 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -727,13 +727,21 @@ static int cfv_probe(struct virtio_device *vdev)
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
 
+	/* serialize netdev register + virtio_device_ready() with ndo_open() */
+	rtnl_lock();
+
 	/* register Netdev */
-	err = register_netdev(netdev);
+	err = register_netdevice(netdev);
 	if (err) {
+		rtnl_unlock();
 		dev_err(&vdev->dev, "Unable to register netdev (%d)\n", err);
 		goto err;
 	}
 
+	virtio_device_ready(vdev);
+
+	rtnl_unlock();
+
 	debugfs_init(cfv);
 
 	return 0;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 03153c30a821..8a48df80b59a 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1377,6 +1377,42 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	 * are bundled into this buffer and where we can find an array of
 	 * per-packet metadata (which contains elements encoded into u16).
 	 */
+
+	/* SKB contents for current firmware:
+	 *   <packet 1> <padding>
+	 *   ...
+	 *   <packet N> <padding>
+	 *   <per-packet metadata entry 1> <dummy header>
+	 *   ...
+	 *   <per-packet metadata entry N> <dummy header>
+	 *   <padding2> <rx_hdr>
+	 *
+	 * where:
+	 *   <packet N> contains pkt_len bytes:
+	 *		2 bytes of IP alignment pseudo header
+	 *		packet received
+	 *   <per-packet metadata entry N> contains 4 bytes:
+	 *		pkt_len and fields AX_RXHDR_*
+	 *   <padding>	0-7 bytes to terminate at
+	 *		8 bytes boundary (64-bit).
+	 *   <padding2> 4 bytes to make rx_hdr terminate at
+	 *		8 bytes boundary (64-bit)
+	 *   <dummy-header> contains 4 bytes:
+	 *		pkt_len=0 and AX_RXHDR_DROP_ERR
+	 *   <rx-hdr>	contains 4 bytes:
+	 *		pkt_cnt and hdr_off (offset of
+	 *		  <per-packet metadata entry 1>)
+	 *
+	 * pkt_cnt is number of entrys in the per-packet metadata.
+	 * In current firmware there is 2 entrys per packet.
+	 * The first points to the packet and the
+	 *  second is a dummy header.
+	 * This was done probably to align fields in 64-bit and
+	 *  maintain compatibility with old firmware.
+	 * This code assumes that <dummy header> and <padding2> are
+	 *  optional.
+	 */
+
 	if (skb->len < 4)
 		return 0;
 	skb_trim(skb, skb->len - 4);
@@ -1391,51 +1427,66 @@ static int ax88179_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	/* Make sure that the bounds of the metadata array are inside the SKB
 	 * (and in front of the counter at the end).
 	 */
-	if (pkt_cnt * 2 + hdr_off > skb->len)
+	if (pkt_cnt * 4 + hdr_off > skb->len)
 		return 0;
 	pkt_hdr = (u32 *)(skb->data + hdr_off);
 
 	/* Packets must not overlap the metadata array */
 	skb_trim(skb, hdr_off);
 
-	for (; ; pkt_cnt--, pkt_hdr++) {
+	for (; pkt_cnt > 0; pkt_cnt--, pkt_hdr++) {
+		u16 pkt_len_plus_padd;
 		u16 pkt_len;
 
 		le32_to_cpus(pkt_hdr);
 		pkt_len = (*pkt_hdr >> 16) & 0x1fff;
+		pkt_len_plus_padd = (pkt_len + 7) & 0xfff8;
 
-		if (pkt_len > skb->len)
+		/* Skip dummy header used for alignment
+		 */
+		if (pkt_len == 0)
+			continue;
+
+		if (pkt_len_plus_padd > skb->len)
 			return 0;
 
 		/* Check CRC or runt packet */
-		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) == 0) &&
-		    pkt_len >= 2 + ETH_HLEN) {
-			bool last = (pkt_cnt == 0);
-
-			if (last) {
-				ax_skb = skb;
-			} else {
-				ax_skb = skb_clone(skb, GFP_ATOMIC);
-				if (!ax_skb)
-					return 0;
-			}
-			ax_skb->len = pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(ax_skb, 2);
-			skb_set_tail_pointer(ax_skb, ax_skb->len);
-			ax_skb->truesize = pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(ax_skb, pkt_hdr);
+		if ((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) ||
+		    pkt_len < 2 + ETH_HLEN) {
+			dev->net->stats.rx_errors++;
+			skb_pull(skb, pkt_len_plus_padd);
+			continue;
+		}
 
-			if (last)
-				return 1;
+		/* last packet */
+		if (pkt_len_plus_padd == skb->len) {
+			skb_trim(skb, pkt_len);
 
-			usbnet_skb_return(dev, ax_skb);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+
+			skb->truesize = SKB_TRUESIZE(pkt_len_plus_padd);
+			ax88179_rx_checksum(skb, pkt_hdr);
+			return 1;
 		}
 
-		/* Trim this packet away from the SKB */
-		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+		ax_skb = skb_clone(skb, GFP_ATOMIC);
+		if (!ax_skb)
 			return 0;
+		skb_trim(ax_skb, pkt_len);
+
+		/* Skip IP alignment pseudo header */
+		skb_pull(ax_skb, 2);
+
+		skb->truesize = pkt_len_plus_padd +
+				SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		ax88179_rx_checksum(ax_skb, pkt_hdr);
+		usbnet_skb_return(dev, ax_skb);
+
+		skb_pull(skb, pkt_len_plus_padd);
 	}
+
+	return 0;
 }
 
 static struct sk_buff *
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index e8d57954596d..0c3129c9ac08 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1307,6 +1307,8 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index c83b6f05ff7f..43f14f64be00 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -2002,7 +2002,7 @@ static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 		   cmd, reqtype, value, index, size);
 
 	if (size) {
-		buf = kmalloc(size, GFP_KERNEL);
+		buf = kmalloc(size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	}
@@ -2034,7 +2034,7 @@ static int __usbnet_write_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
 		   cmd, reqtype, value, index, size);
 
 	if (data) {
-		buf = kmemdup(data, size, GFP_KERNEL);
+		buf = kmemdup(data, size, GFP_NOIO);
 		if (!buf)
 			goto out;
 	} else {
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 430d7c223585..e2eba7e103ff 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -63,6 +63,10 @@ module_param_named(max_queues, xennet_max_queues, uint, 0644);
 MODULE_PARM_DESC(max_queues,
 		 "Maximum number of queues per virtual interface");
 
+static bool __read_mostly xennet_trusted = true;
+module_param_named(trusted, xennet_trusted, bool, 0644);
+MODULE_PARM_DESC(trusted, "Is the backend trusted");
+
 #define XENNET_TIMEOUT  (5 * HZ)
 
 static const struct ethtool_ops xennet_ethtool_ops;
@@ -163,6 +167,9 @@ struct netfront_info {
 	/* Is device behaving sane? */
 	bool broken;
 
+	/* Should skbs be bounced into a zeroed buffer? */
+	bool bounce;
+
 	atomic_t rx_gso_checksum_fixup;
 };
 
@@ -261,7 +268,7 @@ static struct sk_buff *xennet_alloc_one_rx_buffer(struct netfront_queue *queue)
 	if (unlikely(!skb))
 		return NULL;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+	page = alloc_page(GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO);
 	if (!page) {
 		kfree_skb(skb);
 		return NULL;
@@ -592,6 +599,34 @@ static void xennet_mark_tx_pending(struct netfront_queue *queue)
 		queue->tx_link[i] = TX_PENDING;
 }
 
+struct sk_buff *bounce_skb(const struct sk_buff *skb)
+{
+	unsigned int headerlen = skb_headroom(skb);
+	/* Align size to allocate full pages and avoid contiguous data leaks */
+	unsigned int size = ALIGN(skb_end_offset(skb) + skb->data_len,
+				  XEN_PAGE_SIZE);
+	struct sk_buff *n = alloc_skb(size, GFP_ATOMIC | __GFP_ZERO);
+
+	if (!n)
+		return NULL;
+
+	if (!IS_ALIGNED((uintptr_t)n->head, XEN_PAGE_SIZE)) {
+		WARN_ONCE(1, "misaligned skb allocated\n");
+		kfree_skb(n);
+		return NULL;
+	}
+
+	/* Set the data pointer */
+	skb_reserve(n, headerlen);
+	/* Set the tail pointer and length */
+	skb_put(n, skb->len);
+
+	BUG_ON(skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len));
+
+	skb_copy_header(n, skb);
+	return n;
+}
+
 #define MAX_XEN_SKB_FRAGS (65536 / XEN_PAGE_SIZE + 1)
 
 static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -644,9 +679,13 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* The first req should be at least ETH_HLEN size or the packet will be
 	 * dropped by netback.
+	 *
+	 * If the backend is not trusted bounce all data to zeroed pages to
+	 * avoid exposing contiguous data on the granted page not belonging to
+	 * the skb.
 	 */
-	if (unlikely(PAGE_SIZE - offset < ETH_HLEN)) {
-		nskb = skb_copy(skb, GFP_ATOMIC);
+	if (np->bounce || unlikely(PAGE_SIZE - offset < ETH_HLEN)) {
+		nskb = bounce_skb(skb);
 		if (!nskb)
 			goto drop;
 		dev_consume_skb_any(skb);
@@ -1946,6 +1985,10 @@ static int talk_to_netback(struct xenbus_device *dev,
 
 	info->netdev->irq = 0;
 
+	/* Check if backend is trusted. */
+	info->bounce = !xennet_trusted ||
+		       !xenbus_read_unsigned(dev->nodename, "trusted", 1);
+
 	/* Check if backend supports multiple queues */
 	max_queues = xenbus_read_unsigned(info->xbdev->otherend,
 					  "multi-queue-max-queues", 1);
@@ -2099,6 +2142,9 @@ static int xennet_connect(struct net_device *dev)
 	err = talk_to_netback(np->xbdev, np);
 	if (err)
 		return err;
+	if (np->bounce)
+		dev_info(&np->xbdev->dev,
+			 "bouncing transmitted data to zeroed pages\n");
 
 	/* talk_to_netback() sets the correct number of queues */
 	num_queues = dev->real_num_tx_queues;
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index ffec103702f1..3dbe209221e4 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -186,9 +186,9 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 		pdata->irq_polarity = IRQF_TRIGGER_RISING;
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 8e0ddb434770..1f4120e3314b 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -129,9 +129,9 @@ static int nfcmrvl_spi_parse_dt(struct device_node *node,
 	}
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index d9492cffd00e..871ad23d05c0 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -178,6 +178,9 @@ static int nxp_nci_i2c_nci_read(struct nxp_nci_i2c_phy *phy,
 
 	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
 
+	if (!header.plen)
+		return 0;
+
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
 	if (r != header.plen) {
 		nfc_err(&client->dev,
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 83e18b367944..79188812f90c 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -192,8 +192,8 @@ static int nvdimm_clear_badblocks_region(struct device *dev, void *data)
 	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
 
 	/* make sure we are in the region */
-	if (ctx->phys < nd_region->ndr_start
-			|| (ctx->phys + ctx->cleared) > ndr_end)
+	if (ctx->phys < nd_region->ndr_start ||
+	    (ctx->phys + ctx->cleared - 1) > ndr_end)
 		return 0;
 
 	sector = (ctx->phys - nd_region->ndr_start) / 512;
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 7b4ac5505f53..2827015604fb 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -59,6 +59,7 @@ MODULE_PARM_DESC(limit, "Maximum number of grants that may be mapped by "
 
 static atomic_t pages_mapped = ATOMIC_INIT(0);
 
+/* True in PV mode, false otherwise */
 static int use_ptemod;
 #define populate_freeable_maps use_ptemod
 
@@ -94,11 +95,16 @@ struct grant_map {
 	struct gnttab_unmap_grant_ref *unmap_ops;
 	struct gnttab_map_grant_ref   *kmap_ops;
 	struct gnttab_unmap_grant_ref *kunmap_ops;
+	bool *being_removed;
 	struct page **pages;
 	unsigned long pages_vm_start;
+	/* Number of live grants */
+	atomic_t live_grants;
+	/* Needed to avoid allocation in unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
-static int unmap_grant_pages(struct grant_map *map, int offset, int pages);
+static void unmap_grant_pages(struct grant_map *map, int offset, int pages);
 
 /* ------------------------------------------------------------------ */
 
@@ -129,6 +135,7 @@ static void gntdev_free_map(struct grant_map *map)
 	kfree(map->unmap_ops);
 	kfree(map->kmap_ops);
 	kfree(map->kunmap_ops);
+	kfree(map->being_removed);
 	kfree(map);
 }
 
@@ -147,12 +154,15 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	add->kmap_ops  = kcalloc(count, sizeof(add->kmap_ops[0]), GFP_KERNEL);
 	add->kunmap_ops = kcalloc(count, sizeof(add->kunmap_ops[0]), GFP_KERNEL);
 	add->pages     = kcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
 	    NULL == add->kmap_ops  ||
 	    NULL == add->kunmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 
 	if (gnttab_alloc_pages(count, add->pages))
@@ -217,6 +227,35 @@ static void gntdev_put_map(struct gntdev_priv *priv, struct grant_map *map)
 		return;
 
 	atomic_sub(map->count, &pages_mapped);
+	if (map->pages && !use_ptemod) {
+		/*
+		 * Increment the reference count.  This ensures that the
+		 * subsequent call to unmap_grant_pages() will not wind up
+		 * re-entering itself.  It *can* wind up calling
+		 * gntdev_put_map() recursively, but such calls will be with a
+		 * reference count greater than 1, so they will return before
+		 * this code is reached.  The recursion depth is thus limited to
+		 * 1.  Do NOT use refcount_inc() here, as it will detect that
+		 * the reference count is zero and WARN().
+		 */
+		refcount_set(&map->users, 1);
+
+		/*
+		 * Unmap the grants.  This may or may not be asynchronous, so it
+		 * is possible that the reference count is 1 on return, but it
+		 * could also be greater than 1.
+		 */
+		unmap_grant_pages(map, 0, map->count);
+
+		/* Check if the memory now needs to be freed */
+		if (!refcount_dec_and_test(&map->users))
+			return;
+
+		/*
+		 * All pages have been returned to the hypervisor, so free the
+		 * map.
+		 */
+	}
 
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
@@ -274,6 +313,7 @@ static int set_grant_ptes_as_special(pte_t *pte, pgtable_t token,
 
 static int map_grant_pages(struct grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -322,85 +362,107 @@ static int map_grant_pages(struct grant_map *map)
 			map->pages, map->count);
 
 	for (i = 0; i < map->count; i++) {
-		if (map->map_ops[i].status == GNTST_okay)
+		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-		else if (!err)
+			if (!use_ptemod)
+				alloced++;
+		} else if (!err)
 			err = -EINVAL;
 
 		if (map->flags & GNTMAP_device_map)
 			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
 
 		if (use_ptemod) {
-			if (map->kmap_ops[i].status == GNTST_okay)
+			if (map->kmap_ops[i].status == GNTST_okay) {
+				if (map->map_ops[i].status == GNTST_okay)
+					alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
-			else if (!err)
+			} else if (!err)
 				err = -EINVAL;
 		}
 	}
+	atomic_add(alloced, &map->live_grants);
 	return err;
 }
 
-static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
+static void __unmap_grant_pages_done(int result,
+		struct gntab_unmap_queue_data *data)
 {
-	int i, err = 0;
-	struct gntab_unmap_queue_data unmap_data;
+	unsigned int i;
+	struct grant_map *map = data->data;
+	unsigned int offset = data->unmap_ops - map->unmap_ops;
+
+	for (i = 0; i < data->count; i++) {
+		WARN_ON(map->unmap_ops[offset+i].status);
+		pr_debug("unmap handle=%d st=%d\n",
+			map->unmap_ops[offset+i].handle,
+			map->unmap_ops[offset+i].status);
+		map->unmap_ops[offset+i].handle = -1;
+	}
+	/*
+	 * Decrease the live-grant counter.  This must happen after the loop to
+	 * prevent premature reuse of the grants by gnttab_mmap().
+	 */
+	atomic_sub(data->count, &map->live_grants);
 
+	/* Release reference taken by unmap_grant_pages */
+	gntdev_put_map(NULL, map);
+}
+
+static void __unmap_grant_pages(struct grant_map *map, int offset, int pages)
+{
 	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
 		int pgno = (map->notify.addr >> PAGE_SHIFT);
+
 		if (pgno >= offset && pgno < offset + pages) {
 			/* No need for kmap, pages are in lowmem */
 			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
+
 			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
 			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
 		}
 	}
 
-	unmap_data.unmap_ops = map->unmap_ops + offset;
-	unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
-	unmap_data.pages = map->pages + offset;
-	unmap_data.count = pages;
+	map->unmap_data.unmap_ops = map->unmap_ops + offset;
+	map->unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
+	map->unmap_data.pages = map->pages + offset;
+	map->unmap_data.count = pages;
+	map->unmap_data.done = __unmap_grant_pages_done;
+	map->unmap_data.data = map;
+	refcount_inc(&map->users); /* to keep map alive during async call below */
 
-	err = gnttab_unmap_refs_sync(&unmap_data);
-	if (err)
-		return err;
-
-	for (i = 0; i < pages; i++) {
-		if (map->unmap_ops[offset+i].status)
-			err = -EINVAL;
-		pr_debug("unmap handle=%d st=%d\n",
-			map->unmap_ops[offset+i].handle,
-			map->unmap_ops[offset+i].status);
-		map->unmap_ops[offset+i].handle = -1;
-	}
-	return err;
+	gnttab_unmap_refs_async(&map->unmap_data);
 }
 
-static int unmap_grant_pages(struct grant_map *map, int offset, int pages)
+static void unmap_grant_pages(struct grant_map *map, int offset, int pages)
 {
-	int range, err = 0;
+	int range;
+
+	if (atomic_read(&map->live_grants) == 0)
+		return; /* Nothing to do */
 
 	pr_debug("unmap %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
 
 	/* It is possible the requested range will have a "hole" where we
 	 * already unmapped some of the grants. Only unmap valid ranges.
 	 */
-	while (pages && !err) {
-		while (pages && map->unmap_ops[offset].handle == -1) {
+	while (pages) {
+		while (pages && map->being_removed[offset]) {
 			offset++;
 			pages--;
 		}
 		range = 0;
 		while (range < pages) {
-			if (map->unmap_ops[offset+range].handle == -1)
+			if (map->being_removed[offset + range])
 				break;
+			map->being_removed[offset + range] = true;
 			range++;
 		}
-		err = __unmap_grant_pages(map, offset, range);
+		if (range)
+			__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -456,7 +518,6 @@ static void unmap_if_in_range(struct grant_map *map,
 			      unsigned long start, unsigned long end)
 {
 	unsigned long mstart, mend;
-	int err;
 
 	if (!map->vma)
 		return;
@@ -470,10 +531,9 @@ static void unmap_if_in_range(struct grant_map *map,
 			map->index, map->count,
 			map->vma->vm_start, map->vma->vm_end,
 			start, end, mstart, mend);
-	err = unmap_grant_pages(map,
+	unmap_grant_pages(map,
 				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
 				(mend - mstart) >> PAGE_SHIFT);
-	WARN_ON(err);
 }
 
 static void mn_invl_range_start(struct mmu_notifier *mn,
@@ -498,7 +558,6 @@ static void mn_release(struct mmu_notifier *mn,
 {
 	struct gntdev_priv *priv = container_of(mn, struct gntdev_priv, mn);
 	struct grant_map *map;
-	int err;
 
 	mutex_lock(&priv->lock);
 	list_for_each_entry(map, &priv->maps, next) {
@@ -507,8 +566,7 @@ static void mn_release(struct mmu_notifier *mn,
 		pr_debug("map %d+%d (%lx %lx)\n",
 				map->index, map->count,
 				map->vma->vm_start, map->vma->vm_end);
-		err = unmap_grant_pages(map, /* offset */ 0, map->count);
-		WARN_ON(err);
+		unmap_grant_pages(map, /* offset */ 0, map->count);
 	}
 	list_for_each_entry(map, &priv->freeable_maps, next) {
 		if (!map->vma)
@@ -516,8 +574,7 @@ static void mn_release(struct mmu_notifier *mn,
 		pr_debug("map %d+%d (%lx %lx)\n",
 				map->index, map->count,
 				map->vma->vm_start, map->vma->vm_end);
-		err = unmap_grant_pages(map, /* offset */ 0, map->count);
-		WARN_ON(err);
+		unmap_grant_pages(map, /* offset */ 0, map->count);
 	}
 	mutex_unlock(&priv->lock);
 }
@@ -1006,6 +1063,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	}
 
+	if (atomic_read(&map->live_grants)) {
+		err = -EAGAIN;
+		goto unlock_out;
+	}
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 33b6d3ba49a7..2da9e3904c43 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1025,6 +1025,7 @@ static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
 struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src);
 int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask);
 struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t priority);
+void skb_copy_header(struct sk_buff *new, const struct sk_buff *old);
 struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t priority);
 struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 				   gfp_t gfp_mask, bool fclone);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fbb1ab032d2e..629997753f69 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1314,7 +1314,7 @@ static void skb_headers_offset_update(struct sk_buff *skb, int off)
 	skb->inner_mac_header += off;
 }
 
-static void copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
+void skb_copy_header(struct sk_buff *new, const struct sk_buff *old)
 {
 	__copy_skb_header(new, old);
 
@@ -1322,6 +1322,7 @@ static void copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	skb_shinfo(new)->gso_segs = skb_shinfo(old)->gso_segs;
 	skb_shinfo(new)->gso_type = skb_shinfo(old)->gso_type;
 }
+EXPORT_SYMBOL(skb_copy_header);
 
 static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 {
@@ -1365,7 +1366,7 @@ struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 	if (skb_copy_bits(skb, -headerlen, n->head, headerlen + skb->len))
 		BUG();
 
-	copy_skb_header(n, skb);
+	skb_copy_header(n, skb);
 	return n;
 }
 EXPORT_SYMBOL(skb_copy);
@@ -1429,7 +1430,7 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 		skb_clone_fraglist(n);
 	}
 
-	copy_skb_header(n, skb);
+	skb_copy_header(n, skb);
 out:
 	return n;
 }
@@ -1609,7 +1610,7 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
 			  skb->len + head_copy_len))
 		BUG();
 
-	copy_skb_header(n, skb);
+	skb_copy_header(n, skb);
 
 	skb_headers_offset_update(n, newheadroom - oldheadroom);
 
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index ad5f8d521402..73ef23dae184 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -414,7 +414,6 @@ int __net_init seg6_hmac_net_init(struct net *net)
 
 	return 0;
 }
-EXPORT_SYMBOL(seg6_hmac_net_init);
 
 void seg6_hmac_exit(void)
 {
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 43fd9cfa7b11..6525a95a668d 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -308,9 +308,7 @@ static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
-	ca = t->prl_count < cmax ? t->prl_count : cmax;
+	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
 		/* We don't try hard to allocate much memory for
@@ -325,7 +323,7 @@ static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -337,7 +335,7 @@ static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -346,7 +344,7 @@ static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index a8daa80143ef..a684234bd229 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -127,6 +127,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 	/* Another cpu may race to insert the element with the same key */
 	if (prev) {
 		nft_set_elem_destroy(set, he, true);
+		atomic_dec(&set->nelems);
 		he = prev;
 	}
 
@@ -136,6 +137,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 
 err2:
 	nft_set_elem_destroy(set, he, true);
+	atomic_dec(&set->nelems);
 err1:
 	return false;
 }
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index 3b89d66f15bb..f3a4d3b6947a 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -34,90 +34,90 @@ static void rose_idletimer_expiry(struct timer_list *);
 
 void rose_start_heartbeat(struct sock *sk)
 {
-	del_timer(&sk->sk_timer);
+	sk_stop_timer(sk, &sk->sk_timer);
 
 	sk->sk_timer.data     = (unsigned long)sk;
 	sk->sk_timer.function = &rose_heartbeat_expiry;
 	sk->sk_timer.expires  = jiffies + 5 * HZ;
 
-	add_timer(&sk->sk_timer);
+	sk_reset_timer(sk, &sk->sk_timer, sk->sk_timer.expires);
 }
 
 void rose_start_t1timer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t1;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_t2timer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t2;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_t3timer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t3;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_hbtimer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->timer);
+	sk_stop_timer(sk, &rose->timer);
 
 	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->hb;
 
-	add_timer(&rose->timer);
+	sk_reset_timer(sk, &rose->timer, rose->timer.expires);
 }
 
 void rose_start_idletimer(struct sock *sk)
 {
 	struct rose_sock *rose = rose_sk(sk);
 
-	del_timer(&rose->idletimer);
+	sk_stop_timer(sk, &rose->timer);
 
 	if (rose->idle > 0) {
 		rose->idletimer.function = (TIMER_FUNC_TYPE)rose_idletimer_expiry;
 		rose->idletimer.expires  = jiffies + rose->idle;
 
-		add_timer(&rose->idletimer);
+		sk_reset_timer(sk, &rose->idletimer, rose->idletimer.expires);
 	}
 }
 
 void rose_stop_heartbeat(struct sock *sk)
 {
-	del_timer(&sk->sk_timer);
+	sk_stop_timer(sk, &sk->sk_timer);
 }
 
 void rose_stop_timer(struct sock *sk)
 {
-	del_timer(&rose_sk(sk)->timer);
+	sk_stop_timer(sk, &rose_sk(sk)->timer);
 }
 
 void rose_stop_idletimer(struct sock *sk)
 {
-	del_timer(&rose_sk(sk)->idletimer);
+	sk_stop_timer(sk, &rose_sk(sk)->idletimer);
 }
 
 static void rose_heartbeat_expiry(unsigned long param)
@@ -134,6 +134,7 @@ static void rose_heartbeat_expiry(unsigned long param)
 		    (sk->sk_state == TCP_LISTEN && sock_flag(sk, SOCK_DEAD))) {
 			bh_unlock_sock(sk);
 			rose_destroy_socket(sk);
+			sock_put(sk);
 			return;
 		}
 		break;
@@ -156,6 +157,7 @@ static void rose_heartbeat_expiry(unsigned long param)
 
 	rose_start_heartbeat(sk);
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void rose_timer_expiry(struct timer_list *t)
@@ -185,6 +187,7 @@ static void rose_timer_expiry(struct timer_list *t)
 		break;
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
 
 static void rose_idletimer_expiry(struct timer_list *t)
@@ -209,4 +212,5 @@ static void rose_idletimer_expiry(struct timer_list *t)
 		sock_set_flag(sk, SOCK_DEAD);
 	}
 	bh_unlock_sock(sk);
+	sock_put(sk);
 }
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 51ccde7c1311..e3287f019bdd 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -544,7 +544,7 @@ static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	if (space_left - nbytes >= PAGE_SIZE)
+	if (space_left - frag1bytes >= PAGE_SIZE)
 		xdr->end = (void *)p + PAGE_SIZE;
 	else
 		xdr->end = (void *)p + space_left - frag1bytes;
