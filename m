Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0525451183
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243874AbhKOTJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243923AbhKOTGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D158633E8;
        Mon, 15 Nov 2021 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000213;
        bh=M02QWAk0CWVlGELd5C/PWcooZHTw12m97DuvWuIJaZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ou6mrTnTPKGrkAmu2eRS9Z96hp5sdqbTOkrnS2CXVC+0jVG7MXjiufP8gpcIhD6zO
         wc1e3t4dDgILr/uTjpR97Guz3Scye/2WXlyd0A29i1e+4i3+Loq+Y5CQRdgN2Y9X8n
         IrLIhKODIqVpsruKDEvBEPg2IbVlWCm/gjxb6g8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Yong Wu <yong.wu@mediatek.com>, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 579/849] iommu/mediatek: Fix out-of-range warning with clang
Date:   Mon, 15 Nov 2021 18:01:02 +0100
Message-Id: <20211115165439.843060295@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f13efafc1a2cf30d4a74c00f40210d6de36db2d0 ]

clang-14 notices that a comparison is never true when
CONFIG_PHYS_ADDR_T_64BIT is disabled:

drivers/iommu/mtk_iommu.c:553:34: error: result of comparison of constant 5368709120 with expression of type 'phys_addr_t' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (dom->data->enable_4GB && pa >= MTK_IOMMU_4GB_MODE_REMAP_BASE)
                                     ~~ ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add an explicit check for the type of the variable to skip the check
and the warning in that case.

Fixes: b4dad40e4f35 ("iommu/mediatek: Adjust the PA for the 4GB Mode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Link: https://lore.kernel.org/r/20210927121857.941160-1-arnd@kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 6f7c69688ce2a..366a9c05642fa 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -561,7 +561,9 @@ static phys_addr_t mtk_iommu_iova_to_phys(struct iommu_domain *domain,
 	phys_addr_t pa;
 
 	pa = dom->iop->iova_to_phys(dom->iop, iova);
-	if (dom->data->enable_4GB && pa >= MTK_IOMMU_4GB_MODE_REMAP_BASE)
+	if (IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT) &&
+	    dom->data->enable_4GB &&
+	    pa >= MTK_IOMMU_4GB_MODE_REMAP_BASE)
 		pa &= ~BIT_ULL(32);
 
 	return pa;
-- 
2.33.0



