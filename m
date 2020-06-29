Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D033C20E79D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgF2V6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgF2Sf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A53224691;
        Mon, 29 Jun 2020 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443988;
        bh=PxQi7KYMGjCiF39BGevEi1RnPJUzvD/9wwRNIYsBLBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKvT45COOMHibV4HpiKtr29/MIp3/2uGzpg357cLjcmULTJZIta7S/qiDSSijelM0
         92aivXUIVWGzozLwzmCnQcS0P+gtgI58xib4UZgCYVJKhvIRlQx86DqudWYM0cGvde
         Tq8wM0OlHgoTYdc36WGaykTb7BLzRCot2rVmkngo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 092/265] IB/hfi1: Fix module use count flaw due to leftover module put calls
Date:   Mon, 29 Jun 2020 11:15:25 -0400
Message-Id: <20200629151818.2493727-93-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro@intel.com>

commit 822fbd37410639acdae368ea55477ddd3498651d upstream.

When the try_module_get calls were removed from opening and closing of the
i2c debugfs file, the corresponding module_put calls were missed.  This
results in an inaccurate module use count that requires a power cycle to
fix.

Fixes: 09fbca8e6240 ("IB/hfi1: No need to use try_module_get for debugfs")
Link: https://lore.kernel.org/r/20200623203230.106975.76240.stgit@awfm-01.aw.intel.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 4633a0ce1a8c0..2ced236e1553c 100644
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
-- 
2.25.1

