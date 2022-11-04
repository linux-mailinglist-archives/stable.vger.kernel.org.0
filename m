Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FDB618D32
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiKDAa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 20:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiKDAa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 20:30:27 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9331F9C7;
        Thu,  3 Nov 2022 17:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667521826; x=1699057826;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KW5/cxXK+ahDlmPQLZoHLFgyQdcS5VgmsJ/Vdh9TikI=;
  b=nkKNzHYRRnNvfROxWwDUczXqmybuXuQQIZT7Y9A38+1AFMsVpKdCaKzG
   wjNMpVnQlNmi9hgfy6uXvtyTUhN0PGay730ecAkdVtvP2Rkdo+tI7LOJx
   uCphFWV22c6PSxJlXeaeBKgrKcfPbsbdaKvEwkUIuL5QgIxHSY40wCDeQ
   WeDkms0TINDFS5FEs4dVKgwqKF2kmveH9VtaYP+e6ZW7JSEtu1+tGCBq7
   9ZdsSUtEvOJVKjK1OGHokzd6XbcFuQNCHf5BrdqeexlDWMzQ/UdhMslSZ
   sX6xlF2wHLoydCQFNqzb04k5civ7z7W3NUKnhBVchrEMwLZUbi/Xq4Ssx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="297304849"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="297304849"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:25 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="740421851"
X-IronPort-AV: E=Sophos;i="5.96,135,1665471600"; 
   d="scan'208";a="740421851"
Received: from arunvasu-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.53.48])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 17:30:25 -0700
Subject: [PATCH 1/7] cxl/region: Fix region HPA ordering validation
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org, vishal.l.verma@intel.com,
        vishal.l.verma@intel.com, alison.schofield@intel.com,
        ira.weiny@intel.com, dave.jiang@intel.com
Date:   Thu, 03 Nov 2022 17:30:24 -0700
Message-ID: <166752182461.947915.497032805239915067.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some regions may not have any address space allocated. Skip them when
validating HPA order otherwise a crash like the following may result:

 devm_cxl_add_region: cxl_acpi cxl_acpi.0: decoder3.4: created region9
 BUG: kernel NULL pointer dereference, address: 0000000000000000
 [..]
 RIP: 0010:store_targetN+0x655/0x1740 [cxl_core]
 [..]
 Call Trace:
  <TASK>
  kernfs_fop_write_iter+0x144/0x200
  vfs_write+0x24a/0x4d0
  ksys_write+0x69/0xf0
  do_syscall_64+0x3a/0x90

store_targetN+0x655/0x1740:
alloc_region_ref at drivers/cxl/core/region.c:676
(inlined by) cxl_port_attach_region at drivers/cxl/core/region.c:850
(inlined by) cxl_region_attach at drivers/cxl/core/region.c:1290
(inlined by) attach_target at drivers/cxl/core/region.c:1410
(inlined by) store_targetN at drivers/cxl/core/region.c:1453

Cc: <stable@vger.kernel.org>
Fixes: 384e624bb211 ("cxl/region: Attach endpoint decoders")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/region.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index bb6f4fc84a3f..d26ca7a6beae 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -658,6 +658,9 @@ static struct cxl_region_ref *alloc_region_ref(struct cxl_port *port,
 	xa_for_each(&port->regions, index, iter) {
 		struct cxl_region_params *ip = &iter->region->params;
 
+		if (!ip->res)
+			continue;
+
 		if (ip->res->start > p->res->start) {
 			dev_dbg(&cxlr->dev,
 				"%s: HPA order violation %s:%pr vs %pr\n",

