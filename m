Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0E3621593
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiKHONP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbiKHONM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB60F56548
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D8C6B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31C4C433C1;
        Tue,  8 Nov 2022 14:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916789;
        bh=YLInMk2egbkxgurOopNLJ/iKMVJkqvZY+xbvNRaEKm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQ2jeyYtf0AprkgN9RwhuklOUGZhey+SI+K2+12QOd8f3k0F1bYxmJDQnouUiiATr
         M9uSnjAIk/WIM6MmTQSGTtDqVNG4g1lnVx1ClJWN8VoEA8aYGXCLtuD2LF9HJ+/1uN
         aQUYojQNqQ0hqXb5R0dZxSKHD2kv1aBeYhf3zzyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.0 134/197] cxl/region: Fix decoder allocation crash
Date:   Tue,  8 Nov 2022 14:39:32 +0100
Message-Id: <20221108133401.039240599@linuxfoundation.org>
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

From: Vishal Verma <vishal.l.verma@intel.com>

commit 71ee71d7adcba648077997a29a91158d20c40b09 upstream.

When an intermediate port's decoders have been exhausted by existing
regions, and creating a new region with the port in question in it's
hierarchical path is attempted, cxl_port_attach_region() fails to find a
port decoder (as would be expected), and drops into the failure / cleanup
path.

However, during cleanup of the region reference, a sanity check attempts
to dereference the decoder, which in the above case didn't exist. This
causes a NULL pointer dereference BUG.

To fix this, refactor the decoder allocation and de-allocation into
helper routines, and in this 'free' routine, check that the decoder,
@cxld, is valid before attempting any operations on it.

Cc: <stable@vger.kernel.org>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Fixes: 384e624bb211 ("cxl/region: Attach endpoint decoders")
Link: https://lore.kernel.org/r/20221101074100.1732003-1-vishal.l.verma@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |   67 ++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 26 deletions(-)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -686,18 +686,27 @@ static struct cxl_region_ref *alloc_regi
 	return cxl_rr;
 }
 
-static void free_region_ref(struct cxl_region_ref *cxl_rr)
+static void cxl_rr_free_decoder(struct cxl_region_ref *cxl_rr)
 {
-	struct cxl_port *port = cxl_rr->port;
 	struct cxl_region *cxlr = cxl_rr->region;
 	struct cxl_decoder *cxld = cxl_rr->decoder;
 
+	if (!cxld)
+		return;
+
 	dev_WARN_ONCE(&cxlr->dev, cxld->region != cxlr, "region mismatch\n");
 	if (cxld->region == cxlr) {
 		cxld->region = NULL;
 		put_device(&cxlr->dev);
 	}
+}
 
+static void free_region_ref(struct cxl_region_ref *cxl_rr)
+{
+	struct cxl_port *port = cxl_rr->port;
+	struct cxl_region *cxlr = cxl_rr->region;
+
+	cxl_rr_free_decoder(cxl_rr);
 	xa_erase(&port->regions, (unsigned long)cxlr);
 	xa_destroy(&cxl_rr->endpoints);
 	kfree(cxl_rr);
@@ -728,6 +737,33 @@ static int cxl_rr_ep_add(struct cxl_regi
 	return 0;
 }
 
+static int cxl_rr_alloc_decoder(struct cxl_port *port, struct cxl_region *cxlr,
+				struct cxl_endpoint_decoder *cxled,
+				struct cxl_region_ref *cxl_rr)
+{
+	struct cxl_decoder *cxld;
+
+	if (port == cxled_to_port(cxled))
+		cxld = &cxled->cxld;
+	else
+		cxld = cxl_region_find_decoder(port, cxlr);
+	if (!cxld) {
+		dev_dbg(&cxlr->dev, "%s: no decoder available\n",
+			dev_name(&port->dev));
+		return -EBUSY;
+	}
+
+	if (cxld->region) {
+		dev_dbg(&cxlr->dev, "%s: %s already attached to %s\n",
+			dev_name(&port->dev), dev_name(&cxld->dev),
+			dev_name(&cxld->region->dev));
+		return -EBUSY;
+	}
+
+	cxl_rr->decoder = cxld;
+	return 0;
+}
+
 /**
  * cxl_port_attach_region() - track a region's interest in a port by endpoint
  * @port: port to add a new region reference 'struct cxl_region_ref'
@@ -794,12 +830,6 @@ static int cxl_port_attach_region(struct
 			cxl_rr->nr_targets++;
 			nr_targets_inc = true;
 		}
-
-		/*
-		 * The decoder for @cxlr was allocated when the region was first
-		 * attached to @port.
-		 */
-		cxld = cxl_rr->decoder;
 	} else {
 		cxl_rr = alloc_region_ref(port, cxlr);
 		if (IS_ERR(cxl_rr)) {
@@ -810,26 +840,11 @@ static int cxl_port_attach_region(struct
 		}
 		nr_targets_inc = true;
 
-		if (port == cxled_to_port(cxled))
-			cxld = &cxled->cxld;
-		else
-			cxld = cxl_region_find_decoder(port, cxlr);
-		if (!cxld) {
-			dev_dbg(&cxlr->dev, "%s: no decoder available\n",
-				dev_name(&port->dev));
-			goto out_erase;
-		}
-
-		if (cxld->region) {
-			dev_dbg(&cxlr->dev, "%s: %s already attached to %s\n",
-				dev_name(&port->dev), dev_name(&cxld->dev),
-				dev_name(&cxld->region->dev));
-			rc = -EBUSY;
+		rc = cxl_rr_alloc_decoder(port, cxlr, cxled, cxl_rr);
+		if (rc)
 			goto out_erase;
-		}
-
-		cxl_rr->decoder = cxld;
 	}
+	cxld = cxl_rr->decoder;
 
 	rc = cxl_rr_ep_add(cxl_rr, cxled);
 	if (rc) {


