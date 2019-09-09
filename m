Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3ECAE0A9
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406265AbfIIWQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406256AbfIIWQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:16:52 -0400
Received: from sasha-vm.mshome.net (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CA3721D79;
        Mon,  9 Sep 2019 22:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067411;
        bh=Vq+Q+TyIywCf300bwo+nTFXCX0Vt2F+9ts4QLniHC3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnTbIGDTpKbH/BpLvaHsHm4ahk+JJGAx/sGsXkWzQiXUALagRimLi41PSl2Rv9d1P
         3HjhbVUQZV4WXhLMn+wtG1wNZZWJnm5s3zyeAmBqoI1k4oE32robzNG/M+In7P5f24
         bef7dlsc047fmthZQdZiphYOrF9dFH671OPImuyg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stuart Hayes <stuart.w.hayes@gmail.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 7/8] iommu/amd: Flush old domains in kdump kernel
Date:   Mon,  9 Sep 2019 11:41:22 -0400
Message-Id: <20190909154124.31146-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909154124.31146-1-sashal@kernel.org>
References: <20190909154124.31146-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit 36b7200f67dfe75b416b5281ed4ace9927b513bc ]

When devices are attached to the amd_iommu in a kdump kernel, the old device
table entries (DTEs), which were copied from the crashed kernel, will be
overwritten with a new domain number.  When the new DTE is written, the IOMMU
is told to flush the DTE from its internal cache--but it is not told to flush
the translation cache entries for the old domain number.

Without this patch, AMD systems using the tg3 network driver fail when kdump
tries to save the vmcore to a network system, showing network timeouts and
(sometimes) IOMMU errors in the kernel log.

This patch will flush IOMMU translation cache entries for the old domain when
a DTE gets overwritten with a new domain number.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Fixes: 3ac3e5ee5ed5 ('iommu/amd: Copy old trans table from old kernel')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 8d9920ff41344..8b79e2b32d378 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1153,6 +1153,17 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 	iommu_completion_wait(iommu);
 }
 
+static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
+{
+	struct iommu_cmd cmd;
+
+	build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+			      dom_id, 1);
+	iommu_queue_command(iommu, &cmd);
+
+	iommu_completion_wait(iommu);
+}
+
 static void amd_iommu_flush_all(struct amd_iommu *iommu)
 {
 	struct iommu_cmd cmd;
@@ -1838,6 +1849,7 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain,
 {
 	u64 pte_root = 0;
 	u64 flags = 0;
+	u32 old_domid;
 
 	if (domain->mode != PAGE_MODE_NONE)
 		pte_root = iommu_virt_to_phys(domain->pt_root);
@@ -1887,8 +1899,20 @@ static void set_dte_entry(u16 devid, struct protection_domain *domain,
 	flags &= ~DEV_DOMID_MASK;
 	flags |= domain->id;
 
+	old_domid = amd_iommu_dev_table[devid].data[1] & DEV_DOMID_MASK;
 	amd_iommu_dev_table[devid].data[1]  = flags;
 	amd_iommu_dev_table[devid].data[0]  = pte_root;
+
+	/*
+	 * A kdump kernel might be replacing a domain ID that was copied from
+	 * the previous kernel--if so, it needs to flush the translation cache
+	 * entries for the old domain ID that is being overwritten
+	 */
+	if (old_domid) {
+		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+
+		amd_iommu_flush_tlb_domid(iommu, old_domid);
+	}
 }
 
 static void clear_dte_entry(u16 devid)
-- 
2.20.1

