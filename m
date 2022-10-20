Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA9C606C37
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJTXy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 19:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJTXy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 19:54:58 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32550688A1;
        Thu, 20 Oct 2022 16:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666310098; x=1697846098;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jMRKQdTw1ohaKpE/lNW6EvKLDyv+u1hBguYWhqbep6M=;
  b=K9btm6GV2HeZgy9hiqt9sQZFJKq21Uz4bP73kz5PBQAEjdjh5ZucSnx3
   KvynH5xluPkhvx8zpXhsx5cwI5YDxG5X0q/RZLSuiu+iHDaP3Mf2w+Das
   kYIOsa5kI0PKwyl+r8Rp+qXVPiSceqHWdfmqGRihytN0xnc1IwilyXlsa
   sT1NW71WaflrviWjx0RJBU6GQ+Arw1IoCkKwIWkA0IJTrNYXpQfJIPU7H
   9+3rUTKGYqRoOTl4dzaBfMSbdFDsc5/TEx9VYxQqX5KrNdPHk5TbIF1Bt
   ncfoCi7ZOT6ASCOfrSmuCDHsG6uR6ZYQ/5TmKRAQDm1K0XoN8K0a+nxDv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="393167139"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="393167139"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 16:54:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="772689011"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="772689011"
Received: from amwalker-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.42.205])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 16:54:56 -0700
Subject: [PATCH] ACPI: NUMA: Add CXL CFMWS 'nodes' to the possible nodes set
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Alison Schofield <alison.schofield@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-acpi@vger.kernel.org
Date:   Thu, 20 Oct 2022 16:54:55 -0700
Message-ID: <166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ACPI CEDT.CFMWS indicates a range of possible address where new CXL
regions can appear. Each range is associated with a QTG id (QoS
Throttling Group id). For each range + QTG pair that is not covered by a proximity
domain in the SRAT, Linux creates a new NUMA node. However, the commit
that added the new ranges missed updating the node_possible mask which
causes memory_group_register() to fail. Add the new nodes to the
nodes_possible mask.

Cc: <stable@vger.kernel.org>
Fixes: fd49f99c1809 ("ACPI: NUMA: Add a node and memblk for each CFMWS not in SRAT")
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Rafael, I can take this through the CXL tree with some other pending
fixes.

 drivers/acpi/numa/srat.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 3b818ab186be..1f4fc5f8a819 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -327,6 +327,7 @@ static int __init acpi_parse_cfmws(union acpi_subtable_headers *header,
 		pr_warn("ACPI NUMA: Failed to add memblk for CFMWS node %d [mem %#llx-%#llx]\n",
 			node, start, end);
 	}
+	node_set(node, numa_nodes_parsed);
 
 	/* Set the next available fake_pxm value */
 	(*fake_pxm)++;

