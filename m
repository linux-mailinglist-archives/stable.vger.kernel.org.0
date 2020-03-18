Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6312F18A48D
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgCRUym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727950AbgCRUym (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199C8208E0;
        Wed, 18 Mar 2020 20:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564881;
        bh=fCNfBvEj8FxR11jKzYU+guYTmGDCT7dasMbitXaR4R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJGy7/R7qHbCazNYWG2tii+/UlomRi6MvG7Wnkn8EYRF6JJbojlVZFIa20mcogQo5
         oL9T0v0MhZyyi91kRln5yuoE8l+DoyVuWhG9kgwlt2TDEiURTOw2xUeO+TOxiYG393
         zpkUEG3jadliCv/8cV16s03qWuI4lBzb2cGUaBFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 51/73] iommu/vt-d: Silence RCU-list debugging warnings
Date:   Wed, 18 Mar 2020 16:53:15 -0400
Message-Id: <20200318205337.16279-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit f5152416528c2295f35dd9c9bd4fb27c4032413d ]

Similar to the commit 02d715b4a818 ("iommu/vt-d: Fix RCU list debugging
warnings"), there are several other places that call
list_for_each_entry_rcu() outside of an RCU read side critical section
but with dmar_global_lock held. Silence those false positives as well.

 drivers/iommu/intel-iommu.c:4288 RCU-list traversed in non-reader section!!
 1 lock held by swapper/0/1:
  #0: ffffffff935892c8 (dmar_global_lock){+.+.}, at: intel_iommu_init+0x1ad/0xb97

 drivers/iommu/dmar.c:366 RCU-list traversed in non-reader section!!
 1 lock held by swapper/0/1:
  #0: ffffffff935892c8 (dmar_global_lock){+.+.}, at: intel_iommu_init+0x125/0xb97

 drivers/iommu/intel-iommu.c:5057 RCU-list traversed in non-reader section!!
 1 lock held by swapper/0/1:
  #0: ffffffffa71892c8 (dmar_global_lock){++++}, at: intel_iommu_init+0x61a/0xb13

Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dmar.c | 3 ++-
 include/linux/dmar.h | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 7196cabafb252..6ec5da4d028f9 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -363,7 +363,8 @@ dmar_find_dmaru(struct acpi_dmar_hardware_unit *drhd)
 {
 	struct dmar_drhd_unit *dmaru;
 
-	list_for_each_entry_rcu(dmaru, &dmar_drhd_units, list)
+	list_for_each_entry_rcu(dmaru, &dmar_drhd_units, list,
+				dmar_rcu_check())
 		if (dmaru->segment == drhd->segment &&
 		    dmaru->reg_base_addr == drhd->address)
 			return dmaru;
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index a7cf3599d9a1c..e0d52e9358c9c 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -73,11 +73,13 @@ extern struct list_head dmar_drhd_units;
 	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)
 
 #define for_each_active_drhd_unit(drhd)					\
-	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)		\
+	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list,		\
+				dmar_rcu_check())			\
 		if (drhd->ignored) {} else
 
 #define for_each_active_iommu(i, drhd)					\
-	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)		\
+	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list,		\
+				dmar_rcu_check())			\
 		if (i=drhd->iommu, drhd->ignored) {} else
 
 #define for_each_iommu(i, drhd)						\
-- 
2.20.1

