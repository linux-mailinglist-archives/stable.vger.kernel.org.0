Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536DE59E130
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355258AbiHWKnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355787AbiHWKku (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBD895A4;
        Tue, 23 Aug 2022 02:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 087A2B81C53;
        Tue, 23 Aug 2022 09:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425ACC433C1;
        Tue, 23 Aug 2022 09:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245696;
        bh=W0RFa5n/bsdIeIsaCkYXbeLFaQlkU+73fKGi3Lcxwps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTpOxNaVVBAq4ZSYTfiIhK9dA59776DvMRoyKi/zA3aWGz7hocoATTNtLksIwylYQ
         /9RFiT/HKJdOezpdptNQG74TRpJZn6hBhKft2kTH+q2ubOQtCRh38/1ZZV28yPqaoS
         MQBEcBstqcNhR46bCwjnGGJnRS4EthX9LzAKmlA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/287] iommu/exynos: Handle failed IOMMU device registration properly
Date:   Tue, 23 Aug 2022 10:25:29 +0200
Message-Id: <20220823080106.094151657@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 4bf6049dd2c7..8626c924f724 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -640,7 +640,7 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = iommu_device_register(&data->iommu);
 	if (ret)
-		return ret;
+		goto err_iommu_register;
 
 	platform_set_drvdata(pdev, data);
 
@@ -667,6 +667,10 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
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



