Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D942F4553
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 08:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAMHgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 02:36:32 -0500
Received: from mga04.intel.com ([192.55.52.120]:44299 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbhAMHgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 02:36:31 -0500
IronPort-SDR: ASxNLmIT8ClOGYg3/e3O3l9LUdH8eeVVTZY+b5TtDZXlaXcs4L0WYODH19x0cbgOhH4kIqBnSG
 FgS/EIeHH1qg==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="175583402"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="175583402"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:35:50 -0800
IronPort-SDR: d8GujxA6lUoNjhNaAJz9tCcEE8MtX/S74Fsm93UPPhEDTmgKMmxzwKKQoyDeaITQtrNsVU9w4Y
 vwsXOaj6HKog==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="404741126"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 23:35:50 -0800
Subject: [PATCH v3 6/6] libnvdimm/namespace: Fix visibility of namespace
 resource attribute
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-mm@kvack.org
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, stable@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Tue, 12 Jan 2021 23:35:50 -0800
Message-ID: <161052334995.1805594.12054873528154362921.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <161052331545.1805594.2356512831689786960.stgit@dwillia2-desk3.amr.corp.intel.com>
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

