Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FEB618D36
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKDAa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 20:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiKDAa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 20:30:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C103111C29;
        Thu,  3 Nov 2022 17:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667521856; x=1699057856;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CVIg1ieRaMXaBaGZSbJHKNIDEl4g/LxVeDiKTiaxnGo=;
  b=mYUfhJLCCK8QVtRkDdn6w2aWwM5c4e6k/RKe+SER7vT2RwjxDj/OEuCR
   jsIvfkt8GT91hGjxV91Z/Ypo4cOxgoHq7FrA0s42yRhwsQy8qHtegATW/
   w3fK/3T+NbKmqnlmuvu8o5j/ZUhJjtr3Pya36jYSgi211/iad31Ywk8EH
   yQWe+8V4MvYBxxy1aYaTwEEm4NyH00dTOs4my5rfS7z6OPji7ZaoX8nbV
   BIn/dZyn985u5n06/5gzn+UA4ZIo7opO0dtSkZeGDbqcGgaVxJwx0Be1N
   5Uk6O1Dd95dPIlxKh+tnkXxdYPR0eOb+lScp/AI/8U42bXKzm9a1Du7nm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="311577250"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="311577250"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="964151843"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="964151843"
Received: from arunvasu-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.53.48])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:54 -0700
Subject: [PATCH 6/7] cxl/region: Fix 'distance' calculation with passthrough
 ports
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, Bobo WL <lmw.bobo@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        vishal.l.verma@intel.com, vishal.l.verma@intel.com,
        alison.schofield@intel.com, ira.weiny@intel.com,
        dave.jiang@intel.com
Date:   Thu, 03 Nov 2022 17:30:54 -0700
Message-ID: <166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When programming port decode targets, the algorithm wants to ensure that
two devices are compatible to be programmed as peers beneath a given
port. A compatible peer is a target that shares the same dport, and
where that target's interleave position also routes it to the same
dport. Compatibility is determined by the device's interleave position
being >= to distance. For example, if a given dport can only map every
Nth position then positions less than N away from the last target
programmed are incompatible.

The @distance for the host-bridge-cxl_port a simple dual-ported
host-bridge configuration with 2 direct-attached devices is 1. An x2
region divded by 2 dports to reach 2 region targets.

An x4 region under an x2 host-bridge would need 2 intervening switches
where the @distance at the host bridge level is 2 (x4 region divided by
2 switches to reach 4 devices).

However, the distance between peers underneath a single ported
host-bridge is always zero because there is no limit to the number of
devices that can be mapped. In other words, there are no decoders to
program in a passthrough, all descendants are mapped and distance only
starts matters for the intervening descendant ports of the passthrough
port.

Add tracking for the number of dports mapped to a port, and use that to
detect the passthrough case for calculating @distance.

Cc: <stable@vger.kernel.org>
Reported-by: Bobo WL <lmw.bobo@gmail.com>
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: http://lore.kernel.org/r/20221010172057.00001559@huawei.com
Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/port.c   |   11 +++++++++--
 drivers/cxl/core/region.c |    9 ++++++++-
 drivers/cxl/cxl.h         |    2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index bffde862de0b..e7556864ea80 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -811,6 +811,7 @@ static struct cxl_dport *find_dport(struct cxl_port *port, int id)
 static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 {
 	struct cxl_dport *dup;
+	int rc;
 
 	device_lock_assert(&port->dev);
 	dup = find_dport(port, new->port_id);
@@ -821,8 +822,14 @@ static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 			dev_name(dup->dport));
 		return -EBUSY;
 	}
-	return xa_insert(&port->dports, (unsigned long)new->dport, new,
-			 GFP_KERNEL);
+
+	rc = xa_insert(&port->dports, (unsigned long)new->dport, new,
+		       GFP_KERNEL);
+	if (rc)
+		return rc;
+
+	port->nr_dports++;
+	return 0;
 }
 
 /*
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c52465e09f26..c0253de74945 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -990,7 +990,14 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 	if (cxl_rr->nr_targets_set) {
 		int i, distance;
 
-		distance = p->nr_targets / cxl_rr->nr_targets;
+		/*
+		 * Passthrough ports impose no distance requirements between
+		 * peers
+		 */
+		if (port->nr_dports == 1)
+			distance = 0;
+		else
+			distance = p->nr_targets / cxl_rr->nr_targets;
 		for (i = 0; i < cxl_rr->nr_targets_set; i++)
 			if (ep->dport == cxlsd->target[i]) {
 				rc = check_last_peer(cxled, ep, cxl_rr,
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1164ad49f3d3..ac75554b5d76 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -457,6 +457,7 @@ struct cxl_pmem_region {
  * @regions: cxl_region_ref instances, regions mapped by this port
  * @parent_dport: dport that points to this port in the parent
  * @decoder_ida: allocator for decoder ids
+ * @nr_dports: number of entries in @dports
  * @hdm_end: track last allocated HDM decoder instance for allocation ordering
  * @commit_end: cursor to track highest committed decoder for commit ordering
  * @component_reg_phys: component register capability base address (optional)
@@ -475,6 +476,7 @@ struct cxl_port {
 	struct xarray regions;
 	struct cxl_dport *parent_dport;
 	struct ida decoder_ida;
+	int nr_dports;
 	int hdm_end;
 	int commit_end;
 	resource_size_t component_reg_phys;

