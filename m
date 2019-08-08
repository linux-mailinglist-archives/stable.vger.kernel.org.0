Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0486998
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405005AbfHHTIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404518AbfHHTIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 751CD214C6;
        Thu,  8 Aug 2019 19:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291333;
        bh=KnAaBsKXRZgBi7HdEeufVsbNXQUPoj9DvtjdrIUwq1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImB/MXSKJbnbXN/3Ijigs8Nrhk/T/4oWQn/Rj2M6gvqwpWlExk1nfyAcLtmpsOgZv
         2HBsfA0EKtis84hpebJlqKLcd2eID1Y3r0i+nqSiNp+zwvHKO8XXCv9OBFYuXZNfu7
         Egaf4ZcSxoyBsJWTBl/TivLZu03HZ6G8ImYVzPFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/45] libnvdimm/region: Register badblocks before namespaces
Date:   Thu,  8 Aug 2019 21:04:52 +0200
Message-Id: <20190808190454.139386899@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 700cd033a82d466ad8f9615f9985525e45f8960a upstream.

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
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/156341208365.292348.1547528796026249120.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/region.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index b9ca0033cc999..f9130cc157e83 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -42,17 +42,6 @@ static int nd_region_probe(struct device *dev)
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
 
@@ -68,6 +57,17 @@ static int nd_region_probe(struct device *dev)
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
-- 
2.20.1



