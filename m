Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A23C3BB203
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhGDXNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232149AbhGDXML (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8495E61956;
        Sun,  4 Jul 2021 23:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440112;
        bh=g7YZHIXlmpzIxBwyRILjn1eXvxCLTK1iVgAuIElkdJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljgqX0BKgPx3qhovMTmGQu5/9ayff8e+ZfUut4oA4u6P3ZxzaXkjejd5/YPXAxkKc
         4giQrtk+c7plBr/QPiEOR00mYPMxgU4b2xDPtee29eyfJJbI/7IGYqEP0LNErInbPF
         BkJPtSofa5DMQ5mzFey9XzE1qCkxUJrr7dRUQjiGtBo80RyPlZADFzJDuhUy6gMurc
         Sqjnl2EQMTxMLCDI5RKKWBnmj43xlnV7zn7GEiVdlPEUIhrBVB/pGrhqJ944hM7Kyg
         vIRZpJc9uOiiNQyjDCXFWHB9Lf1+UdA3W092hjpxMDp7ISc8Vf9JohwMDu3wMQeseY
         p1/V30TjcDTLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 20/70] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Sun,  4 Jul 2021 19:07:13 -0400
Message-Id: <20210704230804.1490078-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 0cdbabf8bb7a6147f5adf37dbc251e92a1bbc2c7 ]

pm_runtime_resume_and_get() wraps around pm_runtime_get_sync() and
decrements the runtime PM usage counter in case the latter function
fails and keeps the counter balanced.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/exynos-trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
index 8e1fe3f8dd2d..c8db62bc5ff7 100644
--- a/drivers/char/hw_random/exynos-trng.c
+++ b/drivers/char/hw_random/exynos-trng.c
@@ -132,7 +132,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 		return PTR_ERR(trng->mem);
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Could not get runtime PM.\n");
 		goto err_pm_get;
@@ -165,7 +165,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
 	clk_disable_unprepare(trng->clk);
 
 err_clock:
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 
 err_pm_get:
 	pm_runtime_disable(&pdev->dev);
-- 
2.30.2

