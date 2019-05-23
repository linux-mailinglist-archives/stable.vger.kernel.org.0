Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519C4288C9
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391256AbfEWT2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391810AbfEWT2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC63206BA;
        Thu, 23 May 2019 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639723;
        bh=HouLTLqIqjRCwjXfcBrJZTlxNRJEi9ykC66tBSDO8QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUKkSCsgq/v5chWw/k1acTKEP+v4lPx64jgsbi2Zpqvr+DLwL5TcmkNpWyIKztz21
         24maJhlA4sQ+rzNPTgj7/hH3o+tySpAX2vfC6etvZE6w4OAgjbMVxQXT4ZVYBPatCV
         5bfvhVI5WCreARiMbrmGtumaP6TCpXzc+9nCJyMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.1 071/122] iommu/tegra-smmu: Fix invalid ASID bits on Tegra30/114
Date:   Thu, 23 May 2019 21:06:33 +0200
Message-Id: <20190523181714.112401613@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 43a0541e312f7136e081e6bf58f6c8a2e9672688 upstream.

Both Tegra30 and Tegra114 have 4 ASID's and the corresponding bitfield of
the TLB_FLUSH register differs from later Tegra generations that have 128
ASID's.

In a result the PTE's are now flushed correctly from TLB and this fixes
problems with graphics (randomly failing tests) on Tegra30.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/tegra-smmu.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -102,7 +102,6 @@ static inline u32 smmu_readl(struct tegr
 #define  SMMU_TLB_FLUSH_VA_MATCH_ALL     (0 << 0)
 #define  SMMU_TLB_FLUSH_VA_MATCH_SECTION (2 << 0)
 #define  SMMU_TLB_FLUSH_VA_MATCH_GROUP   (3 << 0)
-#define  SMMU_TLB_FLUSH_ASID(x)          (((x) & 0x7f) << 24)
 #define  SMMU_TLB_FLUSH_VA_SECTION(addr) ((((addr) & 0xffc00000) >> 12) | \
 					  SMMU_TLB_FLUSH_VA_MATCH_SECTION)
 #define  SMMU_TLB_FLUSH_VA_GROUP(addr)   ((((addr) & 0xffffc000) >> 12) | \
@@ -205,8 +204,12 @@ static inline void smmu_flush_tlb_asid(s
 {
 	u32 value;
 
-	value = SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_ASID(asid) |
-		SMMU_TLB_FLUSH_VA_MATCH_ALL;
+	if (smmu->soc->num_asids == 4)
+		value = (asid & 0x3) << 29;
+	else
+		value = (asid & 0x7f) << 24;
+
+	value |= SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_VA_MATCH_ALL;
 	smmu_writel(smmu, value, SMMU_TLB_FLUSH);
 }
 
@@ -216,8 +219,12 @@ static inline void smmu_flush_tlb_sectio
 {
 	u32 value;
 
-	value = SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_ASID(asid) |
-		SMMU_TLB_FLUSH_VA_SECTION(iova);
+	if (smmu->soc->num_asids == 4)
+		value = (asid & 0x3) << 29;
+	else
+		value = (asid & 0x7f) << 24;
+
+	value |= SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_VA_SECTION(iova);
 	smmu_writel(smmu, value, SMMU_TLB_FLUSH);
 }
 
@@ -227,8 +234,12 @@ static inline void smmu_flush_tlb_group(
 {
 	u32 value;
 
-	value = SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_ASID(asid) |
-		SMMU_TLB_FLUSH_VA_GROUP(iova);
+	if (smmu->soc->num_asids == 4)
+		value = (asid & 0x3) << 29;
+	else
+		value = (asid & 0x7f) << 24;
+
+	value |= SMMU_TLB_FLUSH_ASID_MATCH | SMMU_TLB_FLUSH_VA_GROUP(iova);
 	smmu_writel(smmu, value, SMMU_TLB_FLUSH);
 }
 


