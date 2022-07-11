Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9024566D28
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiGEMVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbiGEMTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3ED1D0C4;
        Tue,  5 Jul 2022 05:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80C9E61A3D;
        Tue,  5 Jul 2022 12:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5D5C341C7;
        Tue,  5 Jul 2022 12:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023274;
        bh=vc3t8t9uDqwIKwmimRTdh5iyPmCEoC2otLW8ME+c/YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERPUD2eFkUMZvb8y9temkFlwMEY90L0butphPX/GOPC57cT6MH3qoBcIYIgxS3mlv
         oXAmPGhAnX7+fPEWXM2CE5FOT7ZgyFDe6ZVijQJa+E0DteJEfqFdRSVzG6votINKTn
         VbEDIXnTYZDdS6gAPJwpNOqfvZWJiySgo6tuIj+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 81/98] xen/blkfront: force data bouncing when backend is untrusted
Date:   Tue,  5 Jul 2022 13:58:39 +0200
Message-Id: <20220705115619.872499026@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Roger Pau Monne <roger.pau@citrix.com>

commit 2400617da7eebf9167d71a46122828bc479d64c9 upstream.

Split the current bounce buffering logic used with persistent grants
into it's own option, and allow enabling it independently of
persistent grants.  This allows to reuse the same code paths to
perform the bounce buffering required to avoid leaking contiguous data
in shared pages not part of the request fragments.

Reporting whether the backend is to be trusted can be done using a
module parameter, or from the xenstore frontend path as set by the
toolstack when adding the device.

This is CVE-2022-33742, part of XSA-403.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   49 +++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 15 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -152,6 +152,10 @@ static unsigned int xen_blkif_max_ring_o
 module_param_named(max_ring_page_order, xen_blkif_max_ring_order, int, 0444);
 MODULE_PARM_DESC(max_ring_page_order, "Maximum order of pages to be used for the shared ring");
 
+static bool __read_mostly xen_blkif_trusted = true;
+module_param_named(trusted, xen_blkif_trusted, bool, 0644);
+MODULE_PARM_DESC(trusted, "Is the backend trusted");
+
 #define BLK_RING_SIZE(info)	\
 	__CONST_RING_SIZE(blkif, XEN_PAGE_SIZE * (info)->nr_ring_pages)
 
@@ -209,6 +213,7 @@ struct blkfront_info
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
 	unsigned int feature_persistent:1;
+	unsigned int bounce:1;
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	/* Number of 4KB segments handled */
@@ -311,7 +316,7 @@ static int fill_grant_buffer(struct blkf
 		if (!gnt_list_entry)
 			goto out_of_memory;
 
-		if (info->feature_persistent) {
+		if (info->bounce) {
 			granted_page = alloc_page(GFP_NOIO | __GFP_ZERO);
 			if (!granted_page) {
 				kfree(gnt_list_entry);
@@ -331,7 +336,7 @@ out_of_memory:
 	list_for_each_entry_safe(gnt_list_entry, n,
 	                         &rinfo->grants, node) {
 		list_del(&gnt_list_entry->node);
-		if (info->feature_persistent)
+		if (info->bounce)
 			__free_page(gnt_list_entry->page);
 		kfree(gnt_list_entry);
 		i--;
@@ -377,7 +382,7 @@ static struct grant *get_grant(grant_ref
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (info->feature_persistent)
+	if (info->bounce)
 		grant_foreign_access(gnt_list_entry, info);
 	else {
 		/* Grant access to the GFN passed by the caller */
@@ -401,7 +406,7 @@ static struct grant *get_indirect_grant(
 	/* Assign a gref to this page */
 	gnt_list_entry->gref = gnttab_claim_grant_reference(gref_head);
 	BUG_ON(gnt_list_entry->gref == -ENOSPC);
-	if (!info->feature_persistent) {
+	if (!info->bounce) {
 		struct page *indirect_page;
 
 		/* Fetch a pre-allocated page to use for indirect grefs */
@@ -703,7 +708,7 @@ static int blkif_queue_rw_req(struct req
 		.grant_idx = 0,
 		.segments = NULL,
 		.rinfo = rinfo,
-		.need_copy = rq_data_dir(req) && info->feature_persistent,
+		.need_copy = rq_data_dir(req) && info->bounce,
 	};
 
 	/*
@@ -981,11 +986,12 @@ static void xlvbd_flush(struct blkfront_
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
@@ -1212,7 +1218,7 @@ static void blkif_free_ring(struct blkfr
 	if (!list_empty(&rinfo->indirect_pages)) {
 		struct page *indirect_page, *n;
 
-		BUG_ON(info->feature_persistent);
+		BUG_ON(info->bounce);
 		list_for_each_entry_safe(indirect_page, n, &rinfo->indirect_pages, lru) {
 			list_del(&indirect_page->lru);
 			__free_page(indirect_page);
@@ -1229,7 +1235,7 @@ static void blkif_free_ring(struct blkfr
 							  0, 0UL);
 				rinfo->persistent_gnts_c--;
 			}
-			if (info->feature_persistent)
+			if (info->bounce)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1250,7 +1256,7 @@ static void blkif_free_ring(struct blkfr
 		for (j = 0; j < segs; j++) {
 			persistent_gnt = rinfo->shadow[i].grants_used[j];
 			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
-			if (info->feature_persistent)
+			if (info->bounce)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
@@ -1440,7 +1446,7 @@ static int blkif_completion(unsigned lon
 	data.s = s;
 	num_sg = s->num_sg;
 
-	if (bret->operation == BLKIF_OP_READ && info->feature_persistent) {
+	if (bret->operation == BLKIF_OP_READ && info->bounce) {
 		for_each_sg(s->sg, sg, num_sg, i) {
 			BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 
@@ -1499,7 +1505,7 @@ static int blkif_completion(unsigned lon
 				 * Add the used indirect page back to the list of
 				 * available pages for indirect grefs.
 				 */
-				if (!info->feature_persistent) {
+				if (!info->bounce) {
 					indirect_page = s->indirect_grants[i]->page;
 					list_add(&indirect_page->lru, &rinfo->indirect_pages);
 				}
@@ -1790,6 +1796,10 @@ static int talk_to_blkback(struct xenbus
 	if (!info)
 		return -ENODEV;
 
+	/* Check if backend is trusted. */
+	info->bounce = !xen_blkif_trusted ||
+		       !xenbus_read_unsigned(dev->nodename, "trusted", 1);
+
 	max_page_order = xenbus_read_unsigned(info->xbdev->otherend,
 					      "max-ring-page-order", 0);
 	ring_page_order = min(xen_blkif_max_ring_order, max_page_order);
@@ -2199,10 +2209,10 @@ static int blkfront_setup_indirect(struc
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
@@ -2303,6 +2313,8 @@ static void blkfront_gather_backend_feat
 		info->feature_persistent =
 			!!xenbus_read_unsigned(info->xbdev->otherend,
 					       "feature-persistent", 0);
+	if (info->feature_persistent)
+		info->bounce = true;
 
 	indirect_segments = xenbus_read_unsigned(info->xbdev->otherend,
 					"feature-max-indirect-segments", 0);
@@ -2566,6 +2578,13 @@ static void blkfront_delay_work(struct w
 	struct blkfront_info *info;
 	bool need_schedule_work = false;
 
+	/*
+	 * Note that when using bounce buffers but not persistent grants
+	 * there's no need to run blkfront_delay_work because grants are
+	 * revoked in blkif_completion or else an error is reported and the
+	 * connection is closed.
+	 */
+
 	mutex_lock(&blkfront_mutex);
 
 	list_for_each_entry(info, &info_list, info_list) {


