Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19833C4C33
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbhGLHCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241450AbhGLHBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF5CE61380;
        Mon, 12 Jul 2021 06:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073134;
        bh=f1Sjv0zlq9PsPdKWVEVw8yrJjikq6t9Q1LmNaHFmjHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOfX1PTs457lulVnreeIkLcvzbdmcnRE/ZVVL1ol+wCh3Vaxb68OJr6iRMKpuiEhm
         kGdMqlTUQotByb68Qk6cBSM2JjAM0d/6Lm5pLLCsbyiTIENYtQIgUq7GfmuTVHfE6J
         P02yWVo6EyxwEeDWs6RCu6OR6Qpm2ISeQSDMnbHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 139/700] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Mon, 12 Jul 2021 08:03:42 +0200
Message-Id: <20210712060945.197383700@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -165,7 +165,7 @@ err_register:
 	clk_disable_unprepare(trng->clk);
 
 err_clock:
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 
 err_pm_get:
 	pm_runtime_disable(&pdev->dev);
-- 
2.30.2



