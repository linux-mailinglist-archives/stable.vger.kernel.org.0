Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF88C1DDB5A
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgEUXyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:54:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:45842 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729651AbgEUXyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 19:54:18 -0400
IronPort-SDR: WbEB6N4Bx61bAxSvkUqzJksde/5h3QvCdYZYHeMBRKn2Qh8r/n0CH1RRk/GmXKCKkY50FyNUVj
 s472CknjrgoQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:17 -0700
IronPort-SDR: ROjuZNDlLRNLug3TjhV2WIuX4ZIbIOLnyqxC8TroxBj6wGfc44W8xfNQSOx34qvRVAwHVmpQ88
 InVFqdAw0a/w==
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="300494343"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 16:54:16 -0700
Subject: [5.4-stable PATCH 4/7] libnvdimm/pfn_dev: Don't clear device memmap
 area during generic namespace probe
From:   Dan Williams <dan.j.williams@intel.com>
To:     stable@vger.kernel.org
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        vishal.l.verma@intel.com, hch@lst.de, linux-nvdimm@lists.01.org
Date:   Thu, 21 May 2020 16:38:05 -0700
Message-ID: <159010428513.1062454.12082464664066026554.stgit@dwillia2-desk3.amr.corp.intel.com>
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

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Commit c1f45d86a522d568aef541dbbc066ccac262b4c3 upstream.

nvdimm core use nd_pfn_validate when looking for devdax or fsdax namespace. In this
case device resources are allocated against nd_namespace_io dev. In-order to
allow remap of range in nd_pfn_clear_memmap_error(), move the device memmap
area clearing while initializing pfn namespace. With this device
resource are allocated against nd_pfn and we can use nd_pfn->dev for remapping.

This also avoids calling nd_pfn_clear_mmap_errors twice. Once while probing the
namespace and second while initializing a pfn namespace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Link: https://lore.kernel.org/r/20191101032728.113001-1-aneesh.kumar@linux.ibm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8c5b13567f55..6e5b042f453e 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -591,7 +591,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 		return -EOPNOTSUPP;
 	}
 
-	return nd_pfn_clear_memmap_errors(nd_pfn);
+	return 0;
 }
 EXPORT_SYMBOL(nd_pfn_validate);
 
@@ -729,6 +729,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		sig = PFN_SIG;
 
 	rc = nd_pfn_validate(nd_pfn, sig);
+	if (rc == 0)
+		return nd_pfn_clear_memmap_errors(nd_pfn);
 	if (rc != -ENODEV)
 		return rc;
 
@@ -796,6 +798,10 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
 
+	rc = nd_pfn_clear_memmap_errors(nd_pfn);
+	if (rc)
+		return rc;
+
 	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb), 0);
 }
 

