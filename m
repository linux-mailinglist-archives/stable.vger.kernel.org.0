Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97604417401
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345250AbhIXNBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345419AbhIXM7k (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE2C361362;
        Fri, 24 Sep 2021 12:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488008;
        bh=gvIjB8OOrrv5Z+DarVr6BPu4UxusQVTO8fpLctnqWHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHM3ZIe0ii+HOe7jwk9DFaYuI2a8pykpuueJwGyhszVHwvTpcThuj8W+Xz+SnLHxL
         Zw2ksIJGZOtAMVXmZlfHGTbDz6Lw+lkMGxBtjmXBJJaJp7693asRrVoxVIBIKDITgS
         ekcGOFPDR8CoPkzfusCLBgoLBVl8wqf0mB3cQW8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.14 048/100] iommu/vt-d: Fix PASID leak in intel_svm_unbind_mm()
Date:   Fri, 24 Sep 2021 14:43:57 +0200
Message-Id: <20210924124343.053305848@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit a21518cb23a3c7d49bafcb59862fd389fd829d4b ]

The mm->pasid will be used in intel_svm_free_pasid() after load_pasid()
during unbinding mm. Clearing it in load_pasid() will cause PASID cannot
be freed in intel_svm_free_pasid().

Additionally mm->pasid was updated already before load_pasid() during pasid
allocation. No need to update it again in load_pasid() during binding mm.
Don't update mm->pasid to avoid the issues in both binding mm and unbinding
mm.

Fixes: 4048377414162 ("iommu/vt-d: Use iommu_sva_alloc(free)_pasid() helpers")
Reported-and-tested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20210826215918.4073446-1-fenghua.yu@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210828070622.2437559-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/svm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 4b9b3f35ba0e..ceeca633a5f9 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -516,9 +516,6 @@ static void load_pasid(struct mm_struct *mm, u32 pasid)
 {
 	mutex_lock(&mm->context.lock);
 
-	/* Synchronize with READ_ONCE in update_pasid(). */
-	smp_store_release(&mm->pasid, pasid);
-
 	/* Update PASID MSR on all CPUs running the mm's tasks. */
 	on_each_cpu_mask(mm_cpumask(mm), _load_pasid, NULL, true);
 
-- 
2.33.0



