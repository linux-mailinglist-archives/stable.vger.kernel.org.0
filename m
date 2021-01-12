Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F292F2B74
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 10:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392728AbhALJfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 04:35:44 -0500
Received: from mga04.intel.com ([192.55.52.120]:27807 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392715AbhALJfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 04:35:44 -0500
IronPort-SDR: hQVrSipWi1753H5bqOW6loq9qg2aye7L7HEyfkokPoUWxbj/bCbrK5Yr77kJdXl66qDJZpQ67S
 ciPDy7Nklamw==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="175431872"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="175431872"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 01:35:04 -0800
IronPort-SDR: HVZqNl53V65Tso0tlSZDAki2BhNRCeDvuLlb4LwKZ9nWDLF/vuZHYg39G/jHHA2AHqRaEJUf/a
 rqUR72lW1F8A==
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="381355078"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 01:35:04 -0800
Subject: [PATCH v2 5/5] libnvdimm/namespace: Fix visibility of namespace
 resource attribute
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-mm@kvack.org
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jan 2021 01:35:03 -0800
Message-ID: <161044410393.1482714.2866941280476392381.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <161044407603.1482714.16630477578392768273.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <161044407603.1482714.16630477578392768273.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Legacy pmem namespaces lost support for the "resource" attribute when
the code was cleaned up to put the permission visibility in the
declaration. Restore this by listing 'resource' in the default
attributes.

A new ndctl regression test for pfn_to_online_page() corner cases builds
on this fix.

Fixes: bfd2e9140656 ("libnvdimm: Simplify root read-only definition for the 'resource' attribute")
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 6da67f4d641a..2403b71b601e 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1635,11 +1635,11 @@ static umode_t namespace_visible(struct kobject *kobj,
 		return a->mode;
 	}
 
-	if (a == &dev_attr_nstype.attr || a == &dev_attr_size.attr
-			|| a == &dev_attr_holder.attr
-			|| a == &dev_attr_holder_class.attr
-			|| a == &dev_attr_force_raw.attr
-			|| a == &dev_attr_mode.attr)
+	/* base is_namespace_io() attributes */
+	if (a == &dev_attr_nstype.attr || a == &dev_attr_size.attr ||
+	    a == &dev_attr_holder.attr || a == &dev_attr_holder_class.attr ||
+	    a == &dev_attr_force_raw.attr || a == &dev_attr_mode.attr ||
+	    a == &dev_attr_resource.attr)
 		return a->mode;
 
 	return 0;

