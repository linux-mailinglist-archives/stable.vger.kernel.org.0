Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8672063BB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391333AbgFWUcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:32:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:57159 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391021AbgFWUcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:32 -0400
IronPort-SDR: qX697drTlWyBBbiZtqVB4NpUSNHVjxWhPLK8LqJg7uK8smNVmSTrrb34sB6llT0oP8A3z/CrjP
 7Il7ucdywqbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="124468766"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="124468766"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 13:32:33 -0700
IronPort-SDR: ljY6GiuFpDxeeCzpwc9j9NScdF4ORc3YeHXVSc9f4HIOviz4IMtGr9Hw8C3up/P4QRTVQCZGJa
 ZPve6wvfhiRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="275474206"
Received: from sedona.ch.intel.com ([10.2.136.157])
  by orsmga003.jf.intel.com with ESMTP; 23 Jun 2020 13:32:32 -0700
Received: from awfm-01.aw.intel.com (awfm-01.aw.intel.com [10.228.212.213])
        by sedona.ch.intel.com (8.14.3/8.14.3/Standard MailSET/Hub) with ESMTP id 05NKWVH0056460;
        Tue, 23 Jun 2020 13:32:32 -0700
Received: from awfm-01.aw.intel.com (localhost [127.0.0.1])
        by awfm-01.aw.intel.com (8.14.7/8.14.7) with ESMTP id 05NKWUT5107432;
        Tue, 23 Jun 2020 16:32:30 -0400
Subject: [PATCH for-rc 2/2] IB/hfi1: Fix module use count flaw due to
 leftover module put calls
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
To:     jgg@ziepe.ca, dledford@redhat.com
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
Date:   Tue, 23 Jun 2020 16:32:30 -0400
Message-ID: <20200623203230.106975.76240.stgit@awfm-01.aw.intel.com>
In-Reply-To: <20200623202519.106975.94246.stgit@awfm-01.aw.intel.com>
References: <20200623202519.106975.94246.stgit@awfm-01.aw.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the try_module_get calls were removed from opening and closing of
the i2c debugfs file, the corresponding module_put calls were missed.
This results in an inaccurate module use count that requires a power
cycle to fix.

Fixes: 09fbca8e6240 ("IB/hfi1: No need to use try_module_get for debugfs")
Cc: <stable@vger.kernel.org>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/debugfs.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 4633a0c..2ced236 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -985,15 +985,10 @@ static ssize_t qsfp2_debugfs_read(struct file *file, char __user *buf,
 static int __i2c_debugfs_open(struct inode *in, struct file *fp, u32 target)
 {
 	struct hfi1_pportdata *ppd;
-	int ret;
 
 	ppd = private2ppd(fp);
 
-	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
-	if (ret) /* failed - release the module */
-		module_put(THIS_MODULE);
-
-	return ret;
+	return acquire_chip_resource(ppd->dd, i2c_target(target), 0);
 }
 
 static int i2c1_debugfs_open(struct inode *in, struct file *fp)
@@ -1013,7 +1008,6 @@ static int __i2c_debugfs_release(struct inode *in, struct file *fp, u32 target)
 	ppd = private2ppd(fp);
 
 	release_chip_resource(ppd->dd, i2c_target(target));
-	module_put(THIS_MODULE);
 
 	return 0;
 }
@@ -1031,18 +1025,10 @@ static int i2c2_debugfs_release(struct inode *in, struct file *fp)
 static int __qsfp_debugfs_open(struct inode *in, struct file *fp, u32 target)
 {
 	struct hfi1_pportdata *ppd;
-	int ret;
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
 
 	ppd = private2ppd(fp);
 
-	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
-	if (ret) /* failed - release the module */
-		module_put(THIS_MODULE);
-
-	return ret;
+	return acquire_chip_resource(ppd->dd, i2c_target(target), 0);
 }
 
 static int qsfp1_debugfs_open(struct inode *in, struct file *fp)
@@ -1062,7 +1048,6 @@ static int __qsfp_debugfs_release(struct inode *in, struct file *fp, u32 target)
 	ppd = private2ppd(fp);
 
 	release_chip_resource(ppd->dd, i2c_target(target));
-	module_put(THIS_MODULE);
 
 	return 0;
 }

