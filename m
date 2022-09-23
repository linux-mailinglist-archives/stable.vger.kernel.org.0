Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CB05E858B
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 00:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIWWGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 18:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiIWWF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 18:05:59 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20259F509C
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 15:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663970758; x=1695506758;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5RPs/JpeWjIw9SBDcGjffvbJdKw3Fxq8yxwf7Ewx05M=;
  b=PE4Z/S1yFSDSlb/+29SxPBj6UMBJ2Ou/JnyQ+qSJiAU4q4GRU3ln9ZBU
   SwYUl2MorIftTDQm9Eeg7yJ3pm6zsHtSO7OCXGXfBSvXWCZdoTn2fflf/
   CdXoj5IAW+nGzAEBaknBRpXgNeaTGOOnYHgxQvR24GLKGlOWEnvPJyrtL
   9sgKnRG264QxFW1N93fZPc+Wl+H9G1e0gbRWEjWQpLyuWK/UHNGoMMu95
   MO25XIqDukAvl/bd1JWo/lpBHc8axtI5Ow4z+WsKdW9gX651EiF9Dw6Il
   WRWbitvlrbEpo/AZVby+YLiIoGtpY4JTgrOe2tloTfQHJngng16vHIvEK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="287828447"
X-IronPort-AV: E=Sophos;i="5.93,340,1654585200"; 
   d="scan'208";a="287828447"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 15:05:57 -0700
X-IronPort-AV: E=Sophos;i="5.93,340,1654585200"; 
   d="scan'208";a="795663612"
Received: from tsellis-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.14.35])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 15:05:57 -0700
Subject: [PATCH] devdax: Fix soft-reservation memory description
From:   Dan Williams <dan.j.williams@intel.com>
To:     nvdimm@lists.linux.dev
Cc:     Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>,
        Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Omar Avelar <omar.avelar@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Gross <markgross@kernel.org>, linux-mm@kvack.org
Date:   Fri, 23 Sep 2022 15:05:56 -0700
Message-ID: <166397075670.389916.7435722208896316387.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "hmem" platform-devices that are created to represent the
platform-advertised "Soft Reserved" memory ranges end up inserting a
resource that causes the iomem_resource tree to look like this:

340000000-43fffffff : hmem.0
  340000000-43fffffff : Soft Reserved
    340000000-43fffffff : dax0.0

This is because insert_resource() reparents ranges when they completely
intersect an existing range.

This matters because code that uses region_intersects() to scan for a
given IORES_DESC will only check that top-level 'hmem.0' resource and
not the 'Soft Reserved' descendant.

So, to support EINJ (via einj_error_inject()) to inject errors into
memory hosted by a dax-device, be sure to describe the memory as
IORES_DESC_SOFT_RESERVED. This is a follow-on to:

commit b13a3e5fd40b ("ACPI: APEI: Fix _EINJ vs EFI_MEMORY_SP")

...that fixed EINJ support for "Soft Reserved" ranges in the first
instance.

Fixes: 262b45ae3ab4 ("x86/efi: EFI soft reservation to E820 enumeration")
Reported-by: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>
Tested-by: Ricardo Sandoval Torres <ricardo.sandoval.torres@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Omar Avelar <omar.avelar@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Mark Gross <markgross@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/hmem/device.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
index cb6401c9e9a4..acf31cc1dbcc 100644
--- a/drivers/dax/hmem/device.c
+++ b/drivers/dax/hmem/device.c
@@ -15,6 +15,7 @@ void hmem_register_device(int target_nid, struct resource *r)
 		.start = r->start,
 		.end = r->end,
 		.flags = IORESOURCE_MEM,
+		.desc = IORES_DESC_SOFT_RESERVED,
 	};
 	struct platform_device *pdev;
 	struct memregion_info info;

