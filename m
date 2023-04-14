Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DE36E2A43
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 20:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDNSx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 14:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDNSx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 14:53:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B40900B;
        Fri, 14 Apr 2023 11:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681498435; x=1713034435;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jkZRto+6A4BtIkT/zvg0a1aOJMB5oaVVUHzEWvb8qps=;
  b=NgUUyT3KvkV7wugBnaM3htwUhl0bOMlt0iN7ZwnhWewWLTDD7PzMv/AU
   eHnINttkEpZ1LqwPdJQF5oXj7rqcI836qJbcqYWkk1EYSLWq+TmO6+McO
   4BA1YmpYzX79DyA0dTZyPE0R2jOw3XcjqxnpK4OqTx3M8qP0M2pVTt4+3
   mpPFqqX75lBtLdm05pGJVn4DzsEMd7M1WaQST05LyY64Tc5KfZu8dx4lp
   rtgNQ5OP0dZ3G+fJ4FbYDKb1Q7mqnECwmVEmpdjSDYG1y1EhM4QKpdtEh
   m3JI3vqial5f9VejlXTUewYyr6ALWPVYKpAY6au3NVBnpwbQVbJt1aDkr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="347270250"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="347270250"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 11:53:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="683437683"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="683437683"
Received: from rkulesho-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.41.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 11:53:55 -0700
Subject: [PATCH 1/5] cxl/hdm: Fail upon detecting 0-sized decoders
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Fri, 14 Apr 2023 11:53:55 -0700
Message-ID: <168149843516.792294.11872242648319572632.stgit@dwillia2-xfh.jf.intel.com>
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

Decoders committed with 0-size lead to later crashes on shutdown as
__cxl_dpa_release() assumes a 'struct resource' has been established in
the in 'cxlds->dpa_res'. Just fail the driver load in this instance
since there are deeper problems with the enumeration or the setup when
this happens.

Fixes: 9c57cde0dcbd ("cxl/hdm: Enumerate allocated DPA")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/hdm.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 02cc2c38b44b..35b338b716fe 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -269,8 +269,11 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 
 	lockdep_assert_held_write(&cxl_dpa_rwsem);
 
-	if (!len)
-		goto success;
+	if (!len) {
+		dev_warn(dev, "decoder%d.%d: empty reservation attempted\n",
+			 port->id, cxled->cxld.id);
+		return -EINVAL;
+	}
 
 	if (cxled->dpa_res) {
 		dev_dbg(dev, "decoder%d.%d: existing allocation %pr assigned\n",
@@ -323,7 +326,6 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 		cxled->mode = CXL_DECODER_MIXED;
 	}
 
-success:
 	port->hdm_end++;
 	get_device(&cxled->cxld.dev);
 	return 0;
@@ -833,6 +835,13 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 				 port->id, cxld->id);
 			return -ENXIO;
 		}
+
+		if (size == 0) {
+			dev_warn(&port->dev,
+				 "decoder%d.%d: Committed with zero size\n",
+				 port->id, cxld->id);
+			return -ENXIO;
+		}
 		port->commit_end = cxld->id;
 	} else {
 		/* unless / until type-2 drivers arrive, assume type-3 */

