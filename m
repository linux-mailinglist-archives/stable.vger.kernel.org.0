Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC676C424
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 03:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfGRBWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 21:22:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:24106 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732571AbfGRBWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 21:22:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 18:22:21 -0700
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="168124002"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 18:22:21 -0700
Subject: [PATCH v2 3/7] libnvdimm/region: Register badblocks before
 namespaces
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 17 Jul 2019 18:08:03 -0700
Message-ID: <156341208365.292348.1547528796026249120.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156341206785.292348.1660822720191643298.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Namespace activation expects to be able to reference region badblocks.
The following warning sometimes triggers when asynchronous namespace
activation races in front of the completion of namespace probing. Move
all possible namespace probing after region badblocks initialization.

Otherwise, lockdep sometimes catches the uninitialized state of the
badblocks seqlock with stack trace signatures like:

    INFO: trying to register non-static key.
    pmem2: detected capacity change from 0 to 136365211648
    the code is fine but needs lockdep annotation.
    turning off the locking correctness validator.
    CPU: 9 PID: 358 Comm: kworker/u80:5 Tainted: G           OE     5.2.0-rc4+ #3382
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
    Workqueue: events_unbound async_run_entry_fn
    Call Trace:
     dump_stack+0x85/0xc0
    pmem1.12: detected capacity change from 0 to 8589934592
     register_lock_class+0x56a/0x570
     ? check_object+0x140/0x270
     __lock_acquire+0x80/0x1710
     ? __mutex_lock+0x39d/0x910
     lock_acquire+0x9e/0x180
     ? nd_pfn_validate+0x28f/0x440 [libnvdimm]
     badblocks_check+0x93/0x1f0
     ? nd_pfn_validate+0x28f/0x440 [libnvdimm]
     nd_pfn_validate+0x28f/0x440 [libnvdimm]
     ? lockdep_hardirqs_on+0xf0/0x180
     nd_dax_probe+0x9a/0x120 [libnvdimm]
     nd_pmem_probe+0x6d/0x180 [nd_pmem]
     nvdimm_bus_probe+0x90/0x2c0 [libnvdimm]

Fixes: 48af2f7e52f4 ("libnvdimm, pfn: during init, clear errors...")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index ef46cc3a71ae..488c47ac4c4a 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -34,17 +34,6 @@ static int nd_region_probe(struct device *dev)
 	if (rc)
 		return rc;
 
-	rc = nd_region_register_namespaces(nd_region, &err);
-	if (rc < 0)
-		return rc;
-
-	ndrd = dev_get_drvdata(dev);
-	ndrd->ns_active = rc;
-	ndrd->ns_count = rc + err;
-
-	if (rc && err && rc == err)
-		return -ENODEV;
-
 	if (is_nd_pmem(&nd_region->dev)) {
 		struct resource ndr_res;
 
@@ -60,6 +49,17 @@ static int nd_region_probe(struct device *dev)
 		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &ndr_res);
 	}
 
+	rc = nd_region_register_namespaces(nd_region, &err);
+	if (rc < 0)
+		return rc;
+
+	ndrd = dev_get_drvdata(dev);
+	ndrd->ns_active = rc;
+	ndrd->ns_count = rc + err;
+
+	if (rc && err && rc == err)
+		return -ENODEV;
+
 	nd_region->btt_seed = nd_btt_create(nd_region);
 	nd_region->pfn_seed = nd_pfn_create(nd_region);
 	nd_region->dax_seed = nd_dax_create(nd_region);

