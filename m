Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F42A618D33
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 01:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKDAag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 20:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiKDAae (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 20:30:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C8F2228A;
        Thu,  3 Nov 2022 17:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667521834; x=1699057834;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sel2wz9gd8ULsJh7vAKit3UgUoQcAtnXVs9XXx3t5AY=;
  b=EYZDqo00byalrJa0qZTzRIDaayUjBvgXdOxOkzCTDC3CdNf+mAR4bCTZ
   lbq8alXHqIzRV3ttTOaqlV79Q/eXNQsSV489Y86bLNfxiZ+VuUisJtP4P
   EDt488muoNHnKe7roWy7T2YeKmaq0znzboOEgfP4vO+iYW/IlKPxIqDkR
   v7l+N385HWDxe0uFbKXfFJEc54fZJgNUaQsjz45hvbQMBYkIc79zNSMRv
   bx5SQ34rUDEId7aWw6+blivc0adv1DsuUEJVYI7QIjcY5aODTQnjA7Z1P
   w02cRZ0glmGU7Y3lJ0aR58S7L0OvxOigUEw+b2r3zJamQpiXEnD56ybNc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="311577098"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="311577098"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:32 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="740421872"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="740421872"
Received: from arunvasu-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.53.48])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:31 -0700
Subject: [PATCH 2/7] cxl/region: Fix cxl_region leak,
 cleanup targets at region delete
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, vishal.l.verma@intel.com,
        vishal.l.verma@intel.com, alison.schofield@intel.com,
        ira.weiny@intel.com, dave.jiang@intel.com
Date:   Thu, 03 Nov 2022 17:30:30 -0700
Message-ID: <166752183055.947915.17681995648556534844.stgit@dwillia2-xfh.jf.intel.com>
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

When a region is deleted any targets that have been previously assigned
to that region hold references to it. Trigger those references to
drop by detaching all targets at unregister_region() time.

Otherwise that region object will leak as userspace has lost the ability
to detach targets once region sysfs is torn down.

Cc: <stable@vger.kernel.org>
Fixes: b9686e8c8e39 ("cxl/region: Enable the assignment of endpoint decoders to regions")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/region.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index d26ca7a6beae..c52465e09f26 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1557,8 +1557,19 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 static void unregister_region(void *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	int i;
 
 	device_del(dev);
+
+	/*
+	 * Now that region sysfs is shutdown, the parameter block is now
+	 * read-only, so no need to hold the region rwsem to access the
+	 * region parameters.
+	 */
+	for (i = 0; i < p->interleave_ways; i++)
+		detach_target(cxlr, i);
+
 	cxl_region_iomem_release(cxlr);
 	put_device(dev);
 }

