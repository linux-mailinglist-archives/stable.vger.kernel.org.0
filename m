Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9583C37C5A5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhELPmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236312AbhELPhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4007661C58;
        Wed, 12 May 2021 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832746;
        bh=9rgStVf8uJ42fg/JS6I/fqJIH8Ygt3YKG46sUok9Azw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haBkmSzZlzb5xKPcZY/+9qNXdOcczxQocDPptS75VkD51lvqRAlYTFpujV1dO/BW8
         0FD1y0OjUxTRc/0pYHUzfevLgoLGAMWSlOp7q38VaXjgkpGjzEFfvOnhvo2w8uhwJt
         3MkLbb5o1iephYIl5U5clK7ov/YDwM9RCgvDYZkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Zhu <zhurui3@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 372/530] iommu/arm-smmu-v3: add bit field SFM into GERROR_ERR_MASK
Date:   Wed, 12 May 2021 16:48:02 +0200
Message-Id: <20210512144832.005199577@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index d4b7f40ccb02..57e5d223c467 100644
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



