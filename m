Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0D11D0D
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfEBP2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbfEBP2O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:28:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD4522085A;
        Thu,  2 May 2019 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810893;
        bh=1VVvQ42yPx4UFn5CcpwxO3KJv48pAmeUFKCkKRMgnGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcFITOh2ZUslxwf8xSWcNtQgxcV92ZNfyG/TT9teVNZUxiOonXrE4Ij4+fTfW6xaa
         +LMeTfegN7luMu5nKwaEULXDVZsAvx+wmZdx5qlktu9qOjsTZ3AybyFPB1iF7k7Y/W
         qWIxRLMqsc2bNdyl6o2k+9cyDWHpEAv+LgSKDwUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Gary R Hook <gary.hook@amd.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 69/72] iommu/amd: Reserve exclusion range in iova-domain
Date:   Thu,  2 May 2019 17:21:31 +0200
Message-Id: <20190502143338.751301775@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8aafaaf2212192012f5bae305bb31cdf7681d777 ]

If a device has an exclusion range specified in the IVRS
table, this region needs to be reserved in the iova-domain
of that device. This hasn't happened until now and can cause
data corruption on data transfered with these devices.

Treat exclusion ranges as reserved regions in the iommu-core
to fix the problem.

Fixes: be2a022c0dd0 ('x86, AMD IOMMU: add functions to parse IOMMU memory mapping requirements for devices')
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c       | 9 ++++++---
 drivers/iommu/amd_iommu_init.c  | 7 ++++---
 drivers/iommu/amd_iommu_types.h | 2 ++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 0b3877681e4a..8d9920ff4134 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3119,21 +3119,24 @@ static void amd_iommu_get_resv_regions(struct device *dev,
 		return;
 
 	list_for_each_entry(entry, &amd_iommu_unity_map, list) {
+		int type, prot = 0;
 		size_t length;
-		int prot = 0;
 
 		if (devid < entry->devid_start || devid > entry->devid_end)
 			continue;
 
+		type   = IOMMU_RESV_DIRECT;
 		length = entry->address_end - entry->address_start;
 		if (entry->prot & IOMMU_PROT_IR)
 			prot |= IOMMU_READ;
 		if (entry->prot & IOMMU_PROT_IW)
 			prot |= IOMMU_WRITE;
+		if (entry->prot & IOMMU_UNITY_MAP_FLAG_EXCL_RANGE)
+			/* Exclusion range */
+			type = IOMMU_RESV_RESERVED;
 
 		region = iommu_alloc_resv_region(entry->address_start,
-						 length, prot,
-						 IOMMU_RESV_DIRECT);
+						 length, prot, type);
 		if (!region) {
 			pr_err("Out of memory allocating dm-regions for %s\n",
 				dev_name(dev));
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index e062ab9687c7..be3801d43d48 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2001,6 +2001,9 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	if (e == NULL)
 		return -ENOMEM;
 
+	if (m->flags & IVMD_FLAG_EXCL_RANGE)
+		init_exclusion_range(m);
+
 	switch (m->type) {
 	default:
 		kfree(e);
@@ -2047,9 +2050,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 
 	while (p < end) {
 		m = (struct ivmd_header *)p;
-		if (m->flags & IVMD_FLAG_EXCL_RANGE)
-			init_exclusion_range(m);
-		else if (m->flags & IVMD_FLAG_UNITY_MAP)
+		if (m->flags & (IVMD_FLAG_UNITY_MAP | IVMD_FLAG_EXCL_RANGE))
 			init_unity_map_range(m);
 
 		p += m->length;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e2b342e65a7b..69f3d4c95b53 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -373,6 +373,8 @@
 #define IOMMU_PROT_IR 0x01
 #define IOMMU_PROT_IW 0x02
 
+#define IOMMU_UNITY_MAP_FLAG_EXCL_RANGE	(1 << 2)
+
 /* IOMMU capabilities */
 #define IOMMU_CAP_IOTLB   24
 #define IOMMU_CAP_NPCACHE 26
-- 
2.19.1



