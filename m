Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 972E399AC9
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390432AbfHVRIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390392AbfHVRIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:39 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA93233FC;
        Thu, 22 Aug 2019 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493718;
        bh=TN/yZ7FjGl5BN0jJpt8bZnFuEvxtK5gvDFA4qWawSi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEsnQIa0AAkpNFGTEJE3KmfPSm2xpadpaigdeukAyXv4qp/V2nzrG9VaiWtIrsqYE
         +PVEFQYItfD88k2FNnXEAgbeMUMoML/OtEnkR6UGpgSrDvKafc/vUdngSZa5bE07WT
         F6vhOc7a7PWQtXf1KHdKeU4i3h6YAO0/Zb8hSQI0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 045/135] mm/hmm: always return EBUSY for invalid ranges in hmm_range_{fault,snapshot}
Date:   Thu, 22 Aug 2019 13:06:41 -0400
Message-Id: <20190822170811.13303-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2bcbeaefde2f0384d6ad351c151b1a9fe7791a0a ]

We should not have two different error codes for the same
condition. EAGAIN must be reserved for the FAULT_FLAG_ALLOW_RETRY retry
case and signals to the caller that the mmap_sem has been unlocked.

Use EBUSY for the !valid case so that callers can get the locking right.

Link: https://lore.kernel.org/r/20190724065258.16603-2-hch@lst.de
Tested-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
[jgg: elaborated commit message]
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/vm/hmm.rst |  2 +-
 mm/hmm.c                 | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/Documentation/vm/hmm.rst b/Documentation/vm/hmm.rst
index 7cdf7282e0229..65b6c1109cc81 100644
--- a/Documentation/vm/hmm.rst
+++ b/Documentation/vm/hmm.rst
@@ -231,7 +231,7 @@ respect in order to keep things properly synchronized. The usage pattern is::
       ret = hmm_range_snapshot(&range);
       if (ret) {
           up_read(&mm->mmap_sem);
-          if (ret == -EAGAIN) {
+          if (ret == -EBUSY) {
             /*
              * No need to check hmm_range_wait_until_valid() return value
              * on retry we will get proper error with hmm_range_snapshot()
diff --git a/mm/hmm.c b/mm/hmm.c
index 4c405dfbd2b3d..27dd9a8816272 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -995,7 +995,7 @@ EXPORT_SYMBOL(hmm_range_unregister);
  * @range: range
  * Returns: -EINVAL if invalid argument, -ENOMEM out of memory, -EPERM invalid
  *          permission (for instance asking for write and range is read only),
- *          -EAGAIN if you need to retry, -EFAULT invalid (ie either no valid
+ *          -EBUSY if you need to retry, -EFAULT invalid (ie either no valid
  *          vma or it is illegal to access that range), number of valid pages
  *          in range->pfns[] (from range start address).
  *
@@ -1019,7 +1019,7 @@ long hmm_range_snapshot(struct hmm_range *range)
 	do {
 		/* If range is no longer valid force retry. */
 		if (!range->valid)
-			return -EAGAIN;
+			return -EBUSY;
 
 		vma = find_vma(hmm->mm, start);
 		if (vma == NULL || (vma->vm_flags & device_vma))
@@ -1117,10 +1117,8 @@ long hmm_range_fault(struct hmm_range *range, bool block)
 
 	do {
 		/* If range is no longer valid force retry. */
-		if (!range->valid) {
-			up_read(&hmm->mm->mmap_sem);
-			return -EAGAIN;
-		}
+		if (!range->valid)
+			return -EBUSY;
 
 		vma = find_vma(hmm->mm, start);
 		if (vma == NULL || (vma->vm_flags & device_vma))
-- 
2.20.1

