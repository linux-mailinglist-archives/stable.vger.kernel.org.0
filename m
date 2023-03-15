Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C906BB0D3
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjCOMVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjCOMVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:21:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878B344A6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1328FCE19B9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4D6C433D2;
        Wed, 15 Mar 2023 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882835;
        bh=+vDmKt/JVPrDBFrPdIIvQBGMLnUYJiKUX+hIKdYqUho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OU7KP1VDpMeR3UkCDtX9GWzcDtVktTE0uxy3lqbGHH3izU4O7FYdrlZ5nPKWhDXTs
         LdLRKS03giRVC+3vS8NaspGjTRyHQSgm6CdEWU8en/Fz0RX8aOZlBXmE9OWCcEgD9a
         3DxTAgamnJc7ML3YDZugUt+N6pFgb4v/ue2x7W3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.10 020/104] iommu/vt-d: Fix lockdep splat in intel_pasid_get_entry()
Date:   Wed, 15 Mar 2023 13:11:51 +0100
Message-Id: <20230315115732.924259380@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 803766cbf85fb8edbf896729bbefc2d38dcf1e0a ]

The pasid_lock is used to synchronize different threads from modifying a
same pasid directory entry at the same time. It causes below lockdep splat.

[   83.296538] ========================================================
[   83.296538] WARNING: possible irq lock inversion dependency detected
[   83.296539] 5.12.0-rc3+ #25 Tainted: G        W
[   83.296539] --------------------------------------------------------
[   83.296540] bash/780 just changed the state of lock:
[   83.296540] ffffffff82b29c98 (device_domain_lock){..-.}-{2:2}, at:
           iommu_flush_dev_iotlb.part.0+0x32/0x110
[   83.296547] but this lock took another, SOFTIRQ-unsafe lock in the past:
[   83.296547]  (pasid_lock){+.+.}-{2:2}
[   83.296548]

           and interrupts could create inverse lock ordering between them.

[   83.296549] other info that might help us debug this:
[   83.296549] Chain exists of:
                 device_domain_lock --> &iommu->lock --> pasid_lock
[   83.296551]  Possible interrupt unsafe locking scenario:

[   83.296551]        CPU0                    CPU1
[   83.296552]        ----                    ----
[   83.296552]   lock(pasid_lock);
[   83.296553]                                local_irq_disable();
[   83.296553]                                lock(device_domain_lock);
[   83.296554]                                lock(&iommu->lock);
[   83.296554]   <Interrupt>
[   83.296554]     lock(device_domain_lock);
[   83.296555]
                *** DEADLOCK ***

Fix it by replacing the pasid_lock with an atomic exchange operation.

Reported-and-tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210320020916.640115-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 194b3348bdbb ("iommu/vt-d: Fix PASID directory pointer coherency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 86fd49ae7f612..f821153390e53 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -24,7 +24,6 @@
 /*
  * Intel IOMMU system wide PASID name space:
  */
-static DEFINE_SPINLOCK(pasid_lock);
 u32 intel_pasid_max_id = PASID_MAX;
 
 int vcmd_alloc_pasid(struct intel_iommu *iommu, u32 *pasid)
@@ -259,19 +258,25 @@ struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 	dir_index = pasid >> PASID_PDE_SHIFT;
 	index = pasid & PASID_PTE_MASK;
 
-	spin_lock(&pasid_lock);
+retry:
 	entries = get_pasid_table_from_pde(&dir[dir_index]);
 	if (!entries) {
 		entries = alloc_pgtable_page(info->iommu->node);
-		if (!entries) {
-			spin_unlock(&pasid_lock);
+		if (!entries)
 			return NULL;
-		}
 
-		WRITE_ONCE(dir[dir_index].val,
-			   (u64)virt_to_phys(entries) | PASID_PTE_PRESENT);
+		/*
+		 * The pasid directory table entry won't be freed after
+		 * allocation. No worry about the race with free and
+		 * clear. However, this entry might be populated by others
+		 * while we are preparing it. Use theirs with a retry.
+		 */
+		if (cmpxchg64(&dir[dir_index].val, 0ULL,
+			      (u64)virt_to_phys(entries) | PASID_PTE_PRESENT)) {
+			free_pgtable_page(entries);
+			goto retry;
+		}
 	}
-	spin_unlock(&pasid_lock);
 
 	return &entries[index];
 }
-- 
2.39.2



