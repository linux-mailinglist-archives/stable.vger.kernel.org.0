Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DB437C8E0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbhELQNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239272AbhELQHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3469661441;
        Wed, 12 May 2021 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833827;
        bh=VbGPAH96aUzPZb+ukJUD1RrN0bSkX4wnkXbe8BQtxXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThYyT8NFJB1pRZUC+5syGYi6PqVA4bJlzB7msXAYhLP9FBw/kTPZxq2AUDe4Rl6om
         lC3SRzQ2msRkhAvJuhXQBTzxcqz0sbjFZb49oKMWIbMnNAloclDbwLas0PRStzicwK
         +hSDU2xaRwO5n829W8Yn4uujYtqK3POyFwjlK0Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Durrant <pdurrant@amazon.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 305/601] xen-blkback: fix compatibility bug with single page rings
Date:   Wed, 12 May 2021 16:46:22 +0200
Message-Id: <20210512144837.857344041@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

[ Upstream commit d75e7f63b7c95c527cde42efb5d410d7f961498f ]

Prior to commit 4a8c31a1c6f5 ("xen/blkback: rework connect_ring() to avoid
inconsistent xenstore 'ring-page-order' set by malicious blkfront"), the
behaviour of xen-blkback when connecting to a frontend was:

- read 'ring-page-order'
- if not present then expect a single page ring specified by 'ring-ref'
- else expect a ring specified by 'ring-refX' where X is between 0 and
  1 << ring-page-order

This was correct behaviour, but was broken by the afforementioned commit to
become:

- read 'ring-page-order'
- if not present then expect a single page ring (i.e. ring-page-order = 0)
- expect a ring specified by 'ring-refX' where X is between 0 and
  1 << ring-page-order
- if that didn't work then see if there's a single page ring specified by
  'ring-ref'

This incorrect behaviour works most of the time but fails when a frontend
that sets 'ring-page-order' is unloaded and replaced by one that does not
because, instead of reading 'ring-ref', xen-blkback will read the stale
'ring-ref0' left around by the previous frontend will try to map the wrong
grant reference.

This patch restores the original behaviour.

Fixes: 4a8c31a1c6f5 ("xen/blkback: rework connect_ring() to avoid inconsistent xenstore 'ring-page-order' set by malicious blkfront")
Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: "Roger Pau Monné" <roger.pau@citrix.com>
Link: https://lore.kernel.org/r/20210202175659.18452-1-paul@xen.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkback/common.h |  1 +
 drivers/block/xen-blkback/xenbus.c | 38 +++++++++++++-----------------
 2 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index b0c71d3a81a0..bda5c815e441 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -313,6 +313,7 @@ struct xen_blkif {
 
 	struct work_struct	free_work;
 	unsigned int 		nr_ring_pages;
+	bool			multi_ref;
 	/* All rings for this device. */
 	struct xen_blkif_ring	*rings;
 	unsigned int		nr_rings;
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 9860d4842f36..6c5e9373e91c 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -998,14 +998,17 @@ static int read_per_ring_refs(struct xen_blkif_ring *ring, const char *dir)
 	for (i = 0; i < nr_grefs; i++) {
 		char ring_ref_name[RINGREF_NAME_LEN];
 
-		snprintf(ring_ref_name, RINGREF_NAME_LEN, "ring-ref%u", i);
+		if (blkif->multi_ref)
+			snprintf(ring_ref_name, RINGREF_NAME_LEN, "ring-ref%u", i);
+		else {
+			WARN_ON(i != 0);
+			snprintf(ring_ref_name, RINGREF_NAME_LEN, "ring-ref");
+		}
+
 		err = xenbus_scanf(XBT_NIL, dir, ring_ref_name,
 				   "%u", &ring_ref[i]);
 
 		if (err != 1) {
-			if (nr_grefs == 1)
-				break;
-
 			err = -EINVAL;
 			xenbus_dev_fatal(dev, err, "reading %s/%s",
 					 dir, ring_ref_name);
@@ -1013,18 +1016,6 @@ static int read_per_ring_refs(struct xen_blkif_ring *ring, const char *dir)
 		}
 	}
 
-	if (err != 1) {
-		WARN_ON(nr_grefs != 1);
-
-		err = xenbus_scanf(XBT_NIL, dir, "ring-ref", "%u",
-				   &ring_ref[0]);
-		if (err != 1) {
-			err = -EINVAL;
-			xenbus_dev_fatal(dev, err, "reading %s/ring-ref", dir);
-			return err;
-		}
-	}
-
 	err = -ENOMEM;
 	for (i = 0; i < nr_grefs * XEN_BLKIF_REQS_PER_PAGE; i++) {
 		req = kzalloc(sizeof(*req), GFP_KERNEL);
@@ -1129,10 +1120,15 @@ static int connect_ring(struct backend_info *be)
 		 blkif->nr_rings, blkif->blk_protocol, protocol,
 		 blkif->vbd.feature_gnt_persistent ? "persistent grants" : "");
 
-	ring_page_order = xenbus_read_unsigned(dev->otherend,
-					       "ring-page-order", 0);
-
-	if (ring_page_order > xen_blkif_max_ring_order) {
+	err = xenbus_scanf(XBT_NIL, dev->otherend, "ring-page-order", "%u",
+			   &ring_page_order);
+	if (err != 1) {
+		blkif->nr_ring_pages = 1;
+		blkif->multi_ref = false;
+	} else if (ring_page_order <= xen_blkif_max_ring_order) {
+		blkif->nr_ring_pages = 1 << ring_page_order;
+		blkif->multi_ref = true;
+	} else {
 		err = -EINVAL;
 		xenbus_dev_fatal(dev, err,
 				 "requested ring page order %d exceed max:%d",
@@ -1141,8 +1137,6 @@ static int connect_ring(struct backend_info *be)
 		return err;
 	}
 
-	blkif->nr_ring_pages = 1 << ring_page_order;
-
 	if (blkif->nr_rings == 1)
 		return read_per_ring_refs(&blkif->rings[0], dev->otherend);
 	else {
-- 
2.30.2



