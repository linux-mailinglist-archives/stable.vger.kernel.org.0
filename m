Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AACE15E90B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390387AbgBNREX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404149AbgBNQPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB7C5246E0;
        Fri, 14 Feb 2020 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696932;
        bh=Cn24knfDqUAqJvb4N8NFHPFVd8dzAnate7ktenvU3Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBmauCHPHq8XwgfWNRW0mjBp7YfSjnPim7NpTBSVuAmrQxjn27jv4u893d60atOub
         8FI/hrxdqlyrecWSiAdX6xnIAP7OxJ8r7bV9Os+P++E4lunpTaBSXA0tslMyVql6CA
         NRaDW8YFrIjdt3TH+42bpsdWfabcqygx3EJpsQuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.19 177/252] iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE
Date:   Fri, 14 Feb 2020 11:10:32 -0500
Message-Id: <20200214161147.15842-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit d71e01716b3606a6648df7e5646ae12c75babde4 ]

If, for some bizarre reason, the compiler decided to split up the write
of STE DWORD 0, we could end up making a partial structure valid.

Although this probably won't happen, follow the example of the
context-descriptor code and use WRITE_ONCE() to ensure atomicity of the
write.

Reported-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index eff1f3aa5ef43..6b7664052b5be 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1185,7 +1185,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 	}
 
 	arm_smmu_sync_ste_for_sid(smmu, sid);
-	dst[0] = cpu_to_le64(val);
+	/* See comment in arm_smmu_write_ctx_desc() */
+	WRITE_ONCE(dst[0], cpu_to_le64(val));
 	arm_smmu_sync_ste_for_sid(smmu, sid);
 
 	/* It's likely that we'll want to use the new STE soon */
-- 
2.20.1

