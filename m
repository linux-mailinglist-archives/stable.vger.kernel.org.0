Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D54359454A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348476AbiHOWiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351059AbiHOWhe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711AA123CAB;
        Mon, 15 Aug 2022 12:50:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53126B80EAB;
        Mon, 15 Aug 2022 19:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9496BC433C1;
        Mon, 15 Aug 2022 19:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593031;
        bh=WYd78N6+cGqCZNCDwJNGzu9MD4xA9L78/Pgyr6dMArg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfvZY7xXj1MOUpeC3PHay8Bo9iNLk6gTm44cMHji+TB/2X0+etxn4ZtPHA1hjkbPF
         1KC+DqTK2UIEdm57K10N793HlZlAIiXPOVTwSXMiu5g5xi2mj5aCRpZ6P1tmXlkivd
         yeYrUTiwSEcO4jiCiGZGnvPSsfkG2XyXV6iJ8xqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0882/1095] iommu/exynos: Handle failed IOMMU device registration properly
Date:   Mon, 15 Aug 2022 20:04:41 +0200
Message-Id: <20220815180505.830831911@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Protsenko <semen.protsenko@linaro.org>

[ Upstream commit fce398d2d02c0a9a2bedf7c7201b123e153e8963 ]

If iommu_device_register() fails in exynos_sysmmu_probe(), the previous
calls have to be cleaned up. In this case, the iommu_device_sysfs_add()
should be cleaned up, by calling its remove counterpart call.

Fixes: d2c302b6e8b1 ("iommu/exynos: Make use of iommu_device_register interface")
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20220714165550.8884-3-semen.protsenko@linaro.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/exynos-iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 71f2018e23fe..cd4b889d5537 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -630,7 +630,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = iommu_device_register(&data->iommu, &exynos_iommu_ops, dev);
 	if (ret)
-		return ret;
+		goto err_iommu_register;
 
 	platform_set_drvdata(pdev, data);
 
@@ -657,6 +657,10 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 
 	return 0;
+
+err_iommu_register:
+	iommu_device_sysfs_remove(&data->iommu);
+	return ret;
 }
 
 static int __maybe_unused exynos_sysmmu_suspend(struct device *dev)
-- 
2.35.1



