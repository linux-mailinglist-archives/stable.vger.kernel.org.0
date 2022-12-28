Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0206581E5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiL1QcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiL1Qbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEA31C103
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF8E61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B414AC433D2;
        Wed, 28 Dec 2022 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244877;
        bh=oxZmb81wvZ5UFzg+zwWOs/hDFnklGRqG/BdZqsiI2HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vrnrVZfdrVZ8SxAMe/FaLUfgguD2sXba2uFkv/XqHzYFIzkNftnGK+k0c1/8lhnDv
         bSEJncnTszKdR99cqF8Mlo7YQqbz2THWFxLjxRR26k3YeSYVUwjMb+ncB10TcL0W6/
         j8za1CUpXCYnZPOa0S3ATumEPCARKKmPwLaWrwbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0792/1073] iommu/mediatek: Check return value after calling platform_get_resource()
Date:   Wed, 28 Dec 2022 15:39:40 +0100
Message-Id: <20221228144349.522893826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 73b6924cdebc899de9b719e1319aa86c6bed4acf ]

platform_get_resource() may return NULL pointer, we need check its
return value to avoid null-ptr-deref in resource_size().

Fixes: 42d57fc58aeb ("iommu/mediatek: Initialise/Remove for multi bank dev")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20221029103550.3774365-1-yangyingliang@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 7e363b1f24df..0c1c0d8e4d06 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1170,6 +1170,8 @@ static int mtk_iommu_probe(struct platform_device *pdev)
 
 	banks_num = data->plat_data->banks_num;
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	if (resource_size(res) < banks_num * MTK_IOMMU_BANK_SZ) {
 		dev_err(dev, "banknr %d. res %pR is not enough.\n", banks_num, res);
 		return -EINVAL;
-- 
2.35.1



