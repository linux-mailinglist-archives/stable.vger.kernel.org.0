Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DFD1D3CBA
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgENTJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgENSwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA6F32074A;
        Thu, 14 May 2020 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482362;
        bh=XvvQGQi6rNHp7yIor6r2pjt4T0oppQ/D8dKBL0zMt+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6mICxrbQF4fiMOqRgcKfKf9FCeaSUwWBWqaHmNst4gE4V2LZXIIa6gJyNKwsbFBq
         T+TyxNtC7smtm27TevAYNw1gWo+7BnXFna+X3fleQ5IHAg0Pfiv0u4SeG7KZTEH+lF
         p2g5rO+hLOVDEKu+XPOVJZzbMP7reSG9h5PdDUHE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Qian Cai <cai@lca.pw>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.6 42/62] iommu/amd: Call domain_flush_complete() in update_domain()
Date:   Thu, 14 May 2020 14:51:27 -0400
Message-Id: <20200514185147.19716-42-sashal@kernel.org>
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
index 68da484a69dd0..d2499c86d395c 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2321,6 +2321,7 @@ static void update_domain(struct protection_domain *domain)
 
 	domain_flush_devices(domain);
 	domain_flush_tlb_pde(domain);
+	domain_flush_complete(domain);
 }
 
 int __init amd_iommu_init_api(void)
-- 
2.20.1

