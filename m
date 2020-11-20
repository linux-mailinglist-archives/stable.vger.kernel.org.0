Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF412BB2F8
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 19:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgKTS2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 13:28:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:57252 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbgKTS2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 13:28:15 -0500
IronPort-SDR: F+k0hQ3dsst/wqsO7JAQCCr9rQPZlsZS5qlpfj8oj4CfgQ6tMIlr6S35lSfPEOUlVvE4lW9DpN
 7uXVn6C4dAGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="189624492"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="189624492"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 10:28:15 -0800
IronPort-SDR: Q3O3PelUozvsAwIsLFJYjoqAZ32eFUGMGUXFsA35UKca4UytL7TZE2ZjiqIY+zm6Ca0zAHCpU7
 zSy6CR7/Whsg==
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="369251032"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 10:28:14 -0800
Subject: [PATCH] libnvdimm/namespace: Fix reaping of invalidated
 block-window-namespace labels
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org
Date:   Fri, 20 Nov 2020 10:28:14 -0800
Message-ID: <160589689452.3253830.10997437402431159372.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent change to ndctl to attempt to reconfigure namespaces in place
uncovered a label accounting problem in block-window-type namespaces.
The ndctl "create.sh" test is able to trigger this signature:

 WARNING: CPU: 34 PID: 9167 at drivers/nvdimm/label.c:1100 __blk_label_update+0x9a3/0xbc0 [libnvdimm]
 [..]
 RIP: 0010:__blk_label_update+0x9a3/0xbc0 [libnvdimm]
 [..]
 Call Trace:
  uuid_store+0x21b/0x2f0 [libnvdimm]
  kernfs_fop_write+0xcf/0x1c0
  vfs_write+0xcc/0x380
  ksys_write+0x68/0xe0

When allocated capacity for a namespace is renamed (new UUID) the labels
with the old UUID need to be deleted. The ndctl behavior to always
destroy namespaces on reconfiguration hid this problem.

The immediate impact of this bug is limited since block-window-type
namespaces only seem to exist in the specification and not in any
shipping products. However, the label handling code is being reused for
other technologies like CXL region labels, so there is a benefit to
making sure both vertical labels sets (block-window) and horizontal
label sets (pmem) have a functional reference implementation in
libnvdimm.

Fixes: c4703ce11c23 ("libnvdimm/namespace: Fix label tracking error")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 47a4828b8b31..6f2be7a34598 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -980,6 +980,15 @@ static int __blk_label_update(struct nd_region *nd_region,
 		}
 	}
 
+	/* release slots associated with any invalidated UUIDs */
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list)
+		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags)) {
+			reap_victim(nd_mapping, label_ent);
+			list_move(&label_ent->list, &list);
+		}
+	mutex_unlock(&nd_mapping->lock);
+
 	/*
 	 * Find the resource associated with the first label in the set
 	 * per the v1.2 namespace specification.

