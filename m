Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D2B15E273
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405664AbgBNQXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:23:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405657AbgBNQXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7703A24776;
        Fri, 14 Feb 2020 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697410;
        bh=zg6Uq7ArT0C+WyG4FP67wrVc7ANAPFZHEsRcL6m0R6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7O2o9pt8U4bwIJB2bBN42fv7kVC+tBRtcngVnxRe920X0lPEKQf5tUWj4XYxbkbR
         72rDkaMgf9R9+9oXydNhrFZ77t0COvOdbRWy3BV4argW+4ZuM2NyBoJSMyunHTDm3D
         50quqgDZcsKAhLeedWqOH2uPrOVY6ampY5O8A41A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 4.9 102/141] iommu/arm-smmu-v3: Use WRITE_ONCE() when changing validity of an STE
Date:   Fri, 14 Feb 2020 11:20:42 -0500
Message-Id: <20200214162122.19794-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
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
index 7bd98585d78d2..48d3820087881 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1103,7 +1103,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_device *smmu, u32 sid,
 	}
 
 	arm_smmu_sync_ste_for_sid(smmu, sid);
-	dst[0] = cpu_to_le64(val);
+	/* See comment in arm_smmu_write_ctx_desc() */
+	WRITE_ONCE(dst[0], cpu_to_le64(val));
 	arm_smmu_sync_ste_for_sid(smmu, sid);
 
 	/* It's likely that we'll want to use the new STE soon */
-- 
2.20.1

