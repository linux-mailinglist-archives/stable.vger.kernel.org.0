Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC2D6E2A45
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjDNSyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 14:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDNSyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 14:54:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679948A62;
        Fri, 14 Apr 2023 11:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681498441; x=1713034441;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tUqGHrY80SJ2eUDfu+8kOstL9TQ9mFA3t45VKnZoLr8=;
  b=QjJJov44flkTuyVKG43bS4DgctaPElJY3jUaJFclkWM5Sm/em/M2iNX3
   9W7h+9rUyp1MuHNxCL8kqk+uHrajMPdMRNZdOXhswdGCUhVZk/BdlB7Fg
   Thgpe8aAPGTUsHiH+zrhjg2MT2L+Dv8v45A/5I1y4ewdN6iaHTeB9/Im0
   UyYF35NFbydUN+66IsJ6CHKLT0gFNCzB9X2uSIfOIR45rGyakBhbasqLL
   ejMKO98u6lzRg3k+pyh7elN398NbcKWMN/Hc8EKjViHck+lLBZDqKw8ck
   DxSv9oq1J/DrhuAqhLIJEU7nkbTuFGl+5279FISnWt4O4QhUc47OWrLMC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="347270265"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="347270265"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 11:54:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="683437693"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="683437693"
Received: from rkulesho-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.41.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 11:54:00 -0700
Subject: [PATCH 2/5] cxl/hdm: Use 4-byte reads to retrieve HDM decoder
 base+limit
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Fri, 14 Apr 2023 11:54:00 -0700
Message-ID: <168149844056.792294.8224490474529733736.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The CXL specification mandates that 4-byte registers must be accessed
with 4-byte access cycles. CXL 3.0 8.2.3 "Component Register Layout and
Definition" states that the behavior is undefined if (2) 32-bit
registers are accessed as an 8-byte quantity. It turns out that at least
one hardware implementation is sensitive to this in practice. The @size
variable results in zero with:

    size = readq(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));

...and the correct size with:

    lo = readl(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
    hi = readl(hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(which));
    size = (hi << 32) + lo;

Fixes: d17d0540a0db ("cxl/core/hdm: Add CXL standard decoder enumeration to the core")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/hdm.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 35b338b716fe..6fdf7981ddc7 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2022 Intel Corporation. All rights reserved. */
-#include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/delay.h>
@@ -785,8 +784,8 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			    int *target_map, void __iomem *hdm, int which,
 			    u64 *dpa_base, struct cxl_endpoint_dvsec_info *info)
 {
+	u64 size, base, skip, dpa_size, lo, hi;
 	struct cxl_endpoint_decoder *cxled;
-	u64 size, base, skip, dpa_size;
 	bool committed;
 	u32 remainder;
 	int i, rc;
@@ -801,8 +800,12 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 							which, info);
 
 	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(which));
-	base = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(which));
-	size = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
+	lo = readl(hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(which));
+	hi = readl(hdm + CXL_HDM_DECODER0_BASE_HIGH_OFFSET(which));
+	base = (hi << 32) + lo;
+	lo = readl(hdm + CXL_HDM_DECODER0_SIZE_LOW_OFFSET(which));
+	hi = readl(hdm + CXL_HDM_DECODER0_SIZE_HIGH_OFFSET(which));
+	size = (hi << 32) + lo;
 	committed = !!(ctrl & CXL_HDM_DECODER0_CTRL_COMMITTED);
 	cxld->commit = cxl_decoder_commit;
 	cxld->reset = cxl_decoder_reset;
@@ -865,8 +868,9 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		return rc;
 
 	if (!info) {
-		target_list.value =
-			ioread64_hi_lo(hdm + CXL_HDM_DECODER0_TL_LOW(which));
+		lo = readl(hdm + CXL_HDM_DECODER0_TL_LOW(which));
+		hi = readl(hdm + CXL_HDM_DECODER0_TL_HIGH(which));
+		target_list.value = (hi << 32) + lo;
 		for (i = 0; i < cxld->interleave_ways; i++)
 			target_map[i] = target_list.target_id[i];
 
@@ -883,7 +887,9 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			port->id, cxld->id, size, cxld->interleave_ways);
 		return -ENXIO;
 	}
-	skip = ioread64_hi_lo(hdm + CXL_HDM_DECODER0_SKIP_LOW(which));
+	lo = readl(hdm + CXL_HDM_DECODER0_SKIP_LOW(which));
+	hi = readl(hdm + CXL_HDM_DECODER0_SKIP_HIGH(which));
+	skip = (hi << 32) + lo;
 	cxled = to_cxl_endpoint_decoder(&cxld->dev);
 	rc = devm_cxl_dpa_reserve(cxled, *dpa_base + skip, dpa_size, skip);
 	if (rc) {

