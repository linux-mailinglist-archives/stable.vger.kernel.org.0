Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5454D4A53
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiCJOWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244556AbiCJOTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:19:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E6B13A1C5;
        Thu, 10 Mar 2022 06:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26789B82615;
        Thu, 10 Mar 2022 14:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BB0C340E8;
        Thu, 10 Mar 2022 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921763;
        bh=QvXUabqW2e72/S9y0yAqLS0m5Evxyk8ez5ZxAIHm2YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWWPs8o+KJyW2VxWrf4TWQr0dbfacY1ynEci/RAy3tPaHsWg5dqnTI0OMuwOLwB9Y
         NdLtV+qd5gG5FHAl+uHs52GvXZc7g6W0rQRJJi+1y8lhHFzkR926N17E3T0zuvrlWv
         /JVlGW4jJNyYqGa/qy66HARh+t7UDsk7kZkdg6o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.9 32/38] xen/blkfront: dont use gnttab_query_foreign_access() for mapped status
Date:   Thu, 10 Mar 2022 15:13:45 +0100
Message-Id: <20220310140809.073321234@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Commit abf1fd5919d6238ee3bc5eb4a9b6c3947caa6638 upstream.

It isn't enough to check whether a grant is still being in use by
calling gnttab_query_foreign_access(), as a mapping could be realized
by the other side just after having called that function.

In case the call was done in preparation of revoking a grant it is
better to do so via gnttab_end_foreign_access_ref() and check the
success of that operation instead.

For the ring allocation use alloc_pages_exact() in order to avoid
high order pages in case of a multi-page ring.

If a grant wasn't unmapped by the backend without persistent grants
being used, set the device state to "error".

This is CVE-2022-23036 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Roger Pau Monné <roger.pau@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   67 +++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1266,17 +1266,16 @@ static void blkif_free_ring(struct blkfr
 		list_for_each_entry_safe(persistent_gnt, n,
 					 &rinfo->grants, node) {
 			list_del(&persistent_gnt->node);
-			if (persistent_gnt->gref != GRANT_INVALID_REF) {
-				gnttab_end_foreign_access(persistent_gnt->gref,
-							  0, 0UL);
-				rinfo->persistent_gnts_c--;
-			}
+			if (persistent_gnt->gref == GRANT_INVALID_REF ||
+			    !gnttab_try_end_foreign_access(persistent_gnt->gref))
+				continue;
+
+			rinfo->persistent_gnts_c--;
 			if (info->feature_persistent)
 				__free_page(persistent_gnt->page);
 			kfree(persistent_gnt);
 		}
 	}
-	BUG_ON(rinfo->persistent_gnts_c != 0);
 
 	for (i = 0; i < BLK_RING_SIZE(info); i++) {
 		/*
@@ -1333,7 +1332,8 @@ free_shadow:
 			rinfo->ring_ref[i] = GRANT_INVALID_REF;
 		}
 	}
-	free_pages((unsigned long)rinfo->ring.sring, get_order(info->nr_ring_pages * XEN_PAGE_SIZE));
+	free_pages_exact(rinfo->ring.sring,
+			 info->nr_ring_pages * XEN_PAGE_SIZE);
 	rinfo->ring.sring = NULL;
 
 	if (rinfo->irq)
@@ -1417,9 +1417,15 @@ static int blkif_get_final_status(enum b
 	return BLKIF_RSP_OKAY;
 }
 
-static bool blkif_completion(unsigned long *id,
-			     struct blkfront_ring_info *rinfo,
-			     struct blkif_response *bret)
+/*
+ * Return values:
+ *  1 response processed.
+ *  0 missing further responses.
+ * -1 error while processing.
+ */
+static int blkif_completion(unsigned long *id,
+			    struct blkfront_ring_info *rinfo,
+			    struct blkif_response *bret)
 {
 	int i = 0;
 	struct scatterlist *sg;
@@ -1493,42 +1499,43 @@ static bool blkif_completion(unsigned lo
 	}
 	/* Add the persistent grant into the list of free grants */
 	for (i = 0; i < num_grant; i++) {
-		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
+		if (!gnttab_try_end_foreign_access(s->grants_used[i]->gref)) {
 			/*
 			 * If the grant is still mapped by the backend (the
 			 * backend has chosen to make this grant persistent)
 			 * we add it at the head of the list, so it will be
 			 * reused first.
 			 */
-			if (!info->feature_persistent)
-				pr_alert_ratelimited("backed has not unmapped grant: %u\n",
-						     s->grants_used[i]->gref);
+			if (!info->feature_persistent) {
+				pr_alert("backed has not unmapped grant: %u\n",
+					 s->grants_used[i]->gref);
+				return -1;
+			}
 			list_add(&s->grants_used[i]->node, &rinfo->grants);
 			rinfo->persistent_gnts_c++;
 		} else {
 			/*
-			 * If the grant is not mapped by the backend we end the
-			 * foreign access and add it to the tail of the list,
-			 * so it will not be picked again unless we run out of
-			 * persistent grants.
+			 * If the grant is not mapped by the backend we add it
+			 * to the tail of the list, so it will not be picked
+			 * again unless we run out of persistent grants.
 			 */
-			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
 			s->grants_used[i]->gref = GRANT_INVALID_REF;
 			list_add_tail(&s->grants_used[i]->node, &rinfo->grants);
 		}
 	}
 	if (s->req.operation == BLKIF_OP_INDIRECT) {
 		for (i = 0; i < INDIRECT_GREFS(num_grant); i++) {
-			if (gnttab_query_foreign_access(s->indirect_grants[i]->gref)) {
-				if (!info->feature_persistent)
-					pr_alert_ratelimited("backed has not unmapped grant: %u\n",
-							     s->indirect_grants[i]->gref);
+			if (!gnttab_try_end_foreign_access(s->indirect_grants[i]->gref)) {
+				if (!info->feature_persistent) {
+					pr_alert("backed has not unmapped grant: %u\n",
+						 s->indirect_grants[i]->gref);
+					return -1;
+				}
 				list_add(&s->indirect_grants[i]->node, &rinfo->grants);
 				rinfo->persistent_gnts_c++;
 			} else {
 				struct page *indirect_page;
 
-				gnttab_end_foreign_access(s->indirect_grants[i]->gref, 0, 0UL);
 				/*
 				 * Add the used indirect page back to the list of
 				 * available pages for indirect grefs.
@@ -1610,12 +1617,17 @@ static irqreturn_t blkif_interrupt(int i
 		}
 
 		if (bret.operation != BLKIF_OP_DISCARD) {
+			int ret;
+
 			/*
 			 * We may need to wait for an extra response if the
 			 * I/O request is split in 2
 			 */
-			if (!blkif_completion(&id, rinfo, &bret))
+			ret = blkif_completion(&id, rinfo, &bret);
+			if (!ret)
 				continue;
+			if (unlikely(ret < 0))
+				goto err;
 		}
 
 		if (add_id_to_freelist(rinfo, id)) {
@@ -1717,8 +1729,7 @@ static int setup_blkring(struct xenbus_d
 	for (i = 0; i < info->nr_ring_pages; i++)
 		rinfo->ring_ref[i] = GRANT_INVALID_REF;
 
-	sring = (struct blkif_sring *)__get_free_pages(GFP_NOIO | __GFP_HIGH,
-						       get_order(ring_size));
+	sring = alloc_pages_exact(ring_size, GFP_NOIO);
 	if (!sring) {
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
 		return -ENOMEM;
@@ -1728,7 +1739,7 @@ static int setup_blkring(struct xenbus_d
 
 	err = xenbus_grant_ring(dev, rinfo->ring.sring, info->nr_ring_pages, gref);
 	if (err < 0) {
-		free_pages((unsigned long)sring, get_order(ring_size));
+		free_pages_exact(sring, ring_size);
 		rinfo->ring.sring = NULL;
 		goto fail;
 	}


