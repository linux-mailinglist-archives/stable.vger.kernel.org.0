Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F559621596
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiKHONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbiKHONW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7D7B05
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09BBB81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48531C433C1;
        Tue,  8 Nov 2022 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916798;
        bh=P7WP8C+SzAoY6ejwIMYjm8VKL2wa+36twlLdcHTtw9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQcbwCZEBjgt79VCIAp5RBUGK02XH5KQtI17YJkCxFJsnDVdc6ofjLAeJlbzQRtuE
         iHLUYJkG1uVQ7IvCuEsYvveEd3fpA/LziZRO30VaIY3c4pVjhUeMyHpbsIj+2J11dc
         +GlEYG5NdXq1DQhWaXDuVo6thxdF4a9eq8EyY4PM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bobo WL <lmw.bobo@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 137/197] cxl/region: Fix distance calculation with passthrough ports
Date:   Tue,  8 Nov 2022 14:39:35 +0100
Message-Id: <20221108133401.167552938@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit e4f6dfa9ef756a3934a4caf618b1e86e9e8e21d0 upstream.

When programming port decode targets, the algorithm wants to ensure that
two devices are compatible to be programmed as peers beneath a given
port. A compatible peer is a target that shares the same dport, and
where that target's interleave position also routes it to the same
dport. Compatibility is determined by the device's interleave position
being >= to distance. For example, if a given dport can only map every
Nth position then positions less than N away from the last target
programmed are incompatible.

The @distance for the host-bridge's cxl_port in a simple dual-ported
host-bridge configuration with 2 direct-attached devices is 1, i.e. An
x2 region divided by 2 dports to reach 2 region targets.

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
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166752185440.947915.6617495912508299445.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/port.c   |   11 +++++++++--
 drivers/cxl/core/region.c |    9 ++++++++-
 drivers/cxl/cxl.h         |    2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -811,6 +811,7 @@ static struct cxl_dport *find_dport(stru
 static int add_dport(struct cxl_port *port, struct cxl_dport *new)
 {
 	struct cxl_dport *dup;
+	int rc;
 
 	device_lock_assert(&port->dev);
 	dup = find_dport(port, new->port_id);
@@ -821,8 +822,14 @@ static int add_dport(struct cxl_port *po
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
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -989,7 +989,14 @@ static int cxl_port_setup_targets(struct
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


