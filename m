Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05491D3BE2
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgENSx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgENSx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC892076A;
        Thu, 14 May 2020 18:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482436;
        bh=7D/zctjk5AKqwiEPDsf1Ku+Xppketp/iz8b48qj3Saw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWeLlxGQ1M9kNhjP6IhQBdmd2aBGSnSpEziEtdUvR+EnqRYrbzfBrqOydTTe60ij3
         4J3qMMVAEWe0wGXMVsLav7rU/Gg21vJ3iRn3VuO+tyrF1nGccmKShr0uH3suiST3li
         2RR01S+fKhe0UvwMsAW8fTWveaEw07guWRgvrV3E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Qian Cai <cai@lca.pw>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 36/49] iommu/amd: Call domain_flush_complete() in update_domain()
Date:   Thu, 14 May 2020 14:52:57 -0400
Message-Id: <20200514185311.20294-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit f44a4d7e4f1cdef73c90b1dc749c4d8a7372a8eb ]

The update_domain() function is expected to also inform the hardware
about domain changes. This needs a COMPLETION_WAIT command to be sent
to all IOMMUs which use the domain.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Tested-by: Qian Cai <cai@lca.pw>
Link: https://lore.kernel.org/r/20200504125413.16798-4-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index bc77714983421..32de8e7bb8b45 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2386,6 +2386,7 @@ static void update_domain(struct protection_domain *domain)
 
 	domain_flush_devices(domain);
 	domain_flush_tlb_pde(domain);
+	domain_flush_complete(domain);
 }
 
 static int dir2prot(enum dma_data_direction direction)
-- 
2.20.1

