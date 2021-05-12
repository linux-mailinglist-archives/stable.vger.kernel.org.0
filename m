Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E832837C9A2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbhELQUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235733AbhELQOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:14:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB0826134F;
        Wed, 12 May 2021 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834122;
        bh=4qNypdK8nMY4Zsqcd7e8B+90UExoKbmN3+HzmkxVTKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr96cgzIu8jlxsWk3h9rluBXKnNfmMExgWaIDia8tnlM5KLZNfVkEsgcHxe5qC1S6
         TblsiSvOOX9m/ALIWjmSA+jIRz99kDp79x7RdRqI3s5NMQvmsybXpGtCdgj4+VsdGO
         z5dEccSlsAlnsU9flR1A8JdgZsl3J1mW4dsVk4Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Zhu <zhurui3@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 417/601] iommu/arm-smmu-v3: add bit field SFM into GERROR_ERR_MASK
Date:   Wed, 12 May 2021 16:48:14 +0200
Message-Id: <20210512144841.565308269@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 655c447c97d7fe462e6cd9e15809037be028bc70 ]

In arm_smmu_gerror_handler(), the value of the SMMU_GERROR register is
filtered by GERROR_ERR_MASK. However, the GERROR_ERR_MASK does not contain
the SFM bit. As a result, the subsequent error processing is not performed
when only the SFM error occurs.

Fixes: 48ec83bcbcf5 ("iommu/arm-smmu: Add initial driver support for ARM SMMUv3 devices")
Reported-by: Rui Zhu <zhurui3@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210324081603.1074-1-thunder.leizhen@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 96c2e9565e00..190f723a5bcd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -115,7 +115,7 @@
 #define GERROR_PRIQ_ABT_ERR		(1 << 3)
 #define GERROR_EVTQ_ABT_ERR		(1 << 2)
 #define GERROR_CMDQ_ERR			(1 << 0)
-#define GERROR_ERR_MASK			0xfd
+#define GERROR_ERR_MASK			0x1fd
 
 #define ARM_SMMU_GERRORN		0x64
 
-- 
2.30.2



