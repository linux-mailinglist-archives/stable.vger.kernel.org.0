Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C52138A27
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfFGMZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 08:25:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:8771 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728526AbfFGMZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 08:25:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 05:25:33 -0700
X-ExtLoop1: 1
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2019 05:25:33 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id x57CPRgH062796;
        Fri, 7 Jun 2019 05:25:27 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id x57CPPbd158510;
        Fri, 7 Jun 2019 08:25:25 -0400
Subject: [PATCH for-rc 1/3] IB/hfi1: Validate fault injection opcode user
 input
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kaike Wan <kaike.wan@intel.com>
Date:   Fri, 07 Jun 2019 08:25:25 -0400
Message-ID: <20190607122525.158478.61319.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

The opcode range for fault injection from user should be validated
before it is applied to the fault->opcodes[] bitmap to avoid
out-of-bound error. In addition, this patch also simplifies the code
by using the BIT macro.

Fixes: a74d5307caba ("IB/hfi1: Rework fault injection machinery")
Cc: <stable@vger.kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/fault.c |    5 +++++
 drivers/infiniband/hw/hfi1/fault.h |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index 3fd3315..13ba291 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -153,6 +153,7 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 		char *dash;
 		unsigned long range_start, range_end, i;
 		bool remove = false;
+		unsigned long bound = BIT(BITS_PER_BYTE);
 
 		end = strchr(ptr, ',');
 		if (end)
@@ -178,6 +179,10 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
 				    BITS_PER_BYTE);
 			break;
 		}
+		/* Check the inputs */
+		if (range_start >= bound || range_end >= bound)
+			break;
+
 		for (i = range_start; i <= range_end; i++) {
 			if (remove)
 				clear_bit(i, fault->opcodes);
diff --git a/drivers/infiniband/hw/hfi1/fault.h b/drivers/infiniband/hw/hfi1/fault.h
index a833827..c61035c 100644
--- a/drivers/infiniband/hw/hfi1/fault.h
+++ b/drivers/infiniband/hw/hfi1/fault.h
@@ -60,13 +60,13 @@
 struct fault {
 	struct fault_attr attr;
 	struct dentry *dir;
-	u64 n_rxfaults[(1U << BITS_PER_BYTE)];
-	u64 n_txfaults[(1U << BITS_PER_BYTE)];
+	u64 n_rxfaults[BIT(BITS_PER_BYTE)];
+	u64 n_txfaults[BIT(BITS_PER_BYTE)];
 	u64 fault_skip;
 	u64 skip;
 	u64 fault_skip_usec;
 	unsigned long skip_usec;
-	unsigned long opcodes[(1U << BITS_PER_BYTE) / BITS_PER_LONG];
+	unsigned long opcodes[BIT(BITS_PER_BYTE) / BITS_PER_LONG];
 	bool enable;
 	bool suppress_err;
 	bool opcode;

