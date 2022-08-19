Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A7F59A242
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353135AbiHSQd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353546AbiHSQb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:31:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABCF11E926;
        Fri, 19 Aug 2022 09:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01CB16181A;
        Fri, 19 Aug 2022 16:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E125BC433C1;
        Fri, 19 Aug 2022 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925143;
        bh=taOFjwG/oEmxhFwNnlXZcPoYM8Ds3Fx/LnUKUtBM40Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+uQCbU9XaYCTFR7Soi4wmJQgxag2BqroKIyRjVvr75UVj9Wom7NEuZIfwOMurh3g
         LFJ4M7E68hlbeSaQgOCfWWFzkxBGvty1lxDxqUo1A//jCmtGqv7uwr5j1cS2e4/HEi
         vSj9/NE0ht2csDUnvD6U34v2zWGZSrjUWxjKJHgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 397/545] iommu/exynos: Handle failed IOMMU device registration properly
Date:   Fri, 19 Aug 2022 17:42:47 +0200
Message-Id: <20220819153847.182654870@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index de324b4eedfe..0cdb5493a464 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -635,7 +635,7 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 
 	ret = iommu_device_register(&data->iommu);
 	if (ret)
-		return ret;
+		goto err_iommu_register;
 
 	platform_set_drvdata(pdev, data);
 
@@ -662,6 +662,10 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
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



