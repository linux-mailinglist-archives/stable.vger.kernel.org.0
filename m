Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B071AEE4A
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgDROMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgDROKK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:10:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7191721D79;
        Sat, 18 Apr 2020 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587219010;
        bh=T9ctf/OjrEvQnAxPrSzCi8ZBdl86yOCobW5C1jccqD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vuE62ywE0d66pB0vaZs0/koy49AORbaJbTJjglOrejalnC80LOm4hLXmGmUGl7vgu
         BtcLi6BDN1lU388WWfzoOMQbtyOaN3lcTgLLR+FVIKUVrzA6JFivslhFscv0Ma9HeB
         cnhGxgMrA/p9H/EL2MTc1siSq52maglMgeby4UPo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.5 47/75] iommu/vt-d: Silence RCU-list debugging warning in dmar_find_atsr()
Date:   Sat, 18 Apr 2020 10:08:42 -0400
Message-Id: <20200418140910.8280-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit c6f4ebdeba4cff590594df931ff1ee610c426431 ]

dmar_find_atsr() calls list_for_each_entry_rcu() outside of an RCU read
side critical section but with dmar_global_lock held. Silence this
false positive.

 drivers/iommu/intel-iommu.c:4504 RCU-list traversed in non-reader section!!
 1 lock held by swapper/0/1:
 #0: ffffffff9755bee8 (dmar_global_lock){+.+.}, at: intel_iommu_init+0x1a6/0xe19

 Call Trace:
  dump_stack+0xa4/0xfe
  lockdep_rcu_suspicious+0xeb/0xf5
  dmar_find_atsr+0x1ab/0x1c0
  dmar_parse_one_atsr+0x64/0x220
  dmar_walk_remapping_entries+0x130/0x380
  dmar_table_init+0x166/0x243
  intel_iommu_init+0x1ab/0xe19
  pci_iommu_init+0x1a/0x44
  do_one_initcall+0xae/0x4d0
  kernel_init_freeable+0x412/0x4c5
  kernel_init+0x19/0x193

Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 87cd68a4e5eab..8e5d6732b48d2 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4359,7 +4359,8 @@ static struct dmar_atsr_unit *dmar_find_atsr(struct acpi_dmar_atsr *atsr)
 	struct dmar_atsr_unit *atsru;
 	struct acpi_dmar_atsr *tmp;
 
-	list_for_each_entry_rcu(atsru, &dmar_atsr_units, list) {
+	list_for_each_entry_rcu(atsru, &dmar_atsr_units, list,
+				dmar_rcu_check()) {
 		tmp = (struct acpi_dmar_atsr *)atsru->hdr;
 		if (atsr->segment != tmp->segment)
 			continue;
-- 
2.20.1

