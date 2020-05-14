Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4E1D3CBE
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgENTJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgENSwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD24820727;
        Thu, 14 May 2020 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482361;
        bh=QAu8hvM/s35hX8BMMzofK6q080Ve1pE3s86xMzwp0jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmeI8JtcRuAchSvueGRbQgqGXbWM8S7nPKCckylr5C3/XFwM0bj6iHd2qyvuJpzr1
         AbIUTTdHw3iDgCdM1h0HoJNsDRtAEnNGPIcJ+Y8sywHK7b3n2OIPJ8F7cdbBrSauTh
         UwfB++g4ukKqw0RaSAQi6CeKT7XWgqdHgycvCMwc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Qian Cai <cai@lca.pw>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 41/62] iommu/amd: Do not loop forever when trying to increase address space
Date:   Thu, 14 May 2020 14:51:26 -0400
Message-Id: <20200514185147.19716-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 5b8a9a047b6cad361405c7900c1e1cdd378c4589 ]

When increase_address_space() fails to allocate memory, alloc_pte()
will call it again until it succeeds. Do not loop forever while trying
to increase the address space and just return an error instead.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/r/20200504125413.16798-3-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 28229a38af4d2..68da484a69dd0 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1489,8 +1489,19 @@ static u64 *alloc_pte(struct protection_domain *domain,
 	amd_iommu_domain_get_pgtable(domain, &pgtable);
 
 	while (address > PM_LEVEL_SIZE(pgtable.mode)) {
-		*updated = increase_address_space(domain, address, gfp) || *updated;
+		bool upd = increase_address_space(domain, address, gfp);
+
+		/* Read new values to check if update was successful */
 		amd_iommu_domain_get_pgtable(domain, &pgtable);
+
+		/*
+		 * Return an error if there is no memory to update the
+		 * page-table.
+		 */
+		if (!upd && (address > PM_LEVEL_SIZE(pgtable.mode)))
+			return NULL;
+
+		*updated = *updated || upd;
 	}
 
 
-- 
2.20.1

