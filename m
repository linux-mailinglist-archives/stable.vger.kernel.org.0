Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF611DDB58
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgEUXyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:54:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:42215 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729651AbgEUXyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:54:12 -0400
IronPort-SDR: 7b8ssZEwRR2BLX9Sxivb/3zw4L+Xh6PZUCka2Y/fJ9YC/XGt2Su22qhFjiCgMBejqrhE1cCgVP
 1aKeaNlAp4vw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:11 -0700
IronPort-SDR: jC4NIxANmRw8At+c3PgCbb7hwea+BXWGo4yZ3uqm2DPl+lDjqCIpgJ+azYgPUWWP8rGeus0cJ5
 TsUeO52fiPTg==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="254130247"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:11 -0700
Subject: [5.4-stable PATCH 3/7] libnvdimm/pfn: Prevent raw mode fallback if
 pfn-infoblock valid
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        vishal.l.verma@intel.com, hch@lst.de, linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:37:59 -0700
Message-ID: <159010427971.1062454.10990062889525749549.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit b2ba7e91fa81bec9b64c47ab852145559cad2b68 upstream.

The EOPNOTSUPP return code from the pmem driver indicates that the
namespace has a configuration that may be valid, but the current kernel
does not support it. Expand this to all of the nd_pfn_validate() error
conditions after the infoblock has been verified as self consistent.

This prevents exposing the namespace to I/O when the infoblock needs to
be corrected, or the system needs to be put into a different
configuration (like changing the page size on PowerPC).

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index aa144c8a4ee6..8c5b13567f55 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -560,14 +560,14 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 			dev_dbg(&nd_pfn->dev, "align: %lx:%lx mode: %d:%d\n",
 					nd_pfn->align, align, nd_pfn->mode,
 					mode);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 	}
 
 	if (align > nvdimm_namespace_capacity(ndns)) {
 		dev_err(&nd_pfn->dev, "alignment: %lx exceeds capacity %llx\n",
 				align, nvdimm_namespace_capacity(ndns));
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	/*
@@ -580,7 +580,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (offset >= resource_size(&nsio->res)) {
 		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
 				dev_name(&ndns->dev));
-		return -EBUSY;
+		return -EOPNOTSUPP;
 	}
 
 	if ((align && !IS_ALIGNED(nsio->res.start + offset + start_pad, align))
@@ -588,7 +588,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		dev_err(&nd_pfn->dev,
 				"bad offset: %#llx dax disabled align: %#lx\n",
 				offset, align);
-		return -ENXIO;
+		return -EOPNOTSUPP;
 	}
 
 	return nd_pfn_clear_memmap_errors(nd_pfn);

