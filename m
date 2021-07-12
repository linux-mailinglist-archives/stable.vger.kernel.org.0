Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400E03C4830
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhGLGgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236695AbhGLGf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4056611F1;
        Mon, 12 Jul 2021 06:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071550;
        bh=f1Sjv0zlq9PsPdKWVEVw8yrJjikq6t9Q1LmNaHFmjHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrhgNEn5xwI8sG74xiuaavNJFx5eRgfc8yZAqEfagS9kasMOBjTpNFUaCgUDHa8gB
         AVbw3w7YV4MrXhNLbpN0MNkDl16NaTQiM5LTT9RmaW03I/k5AzvMFO6VA1cUrOhKva
         6QqiE/k+71gTKJMQ7tCBg32TJe/vELWYsyczr7BI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/593] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Mon, 12 Jul 2021 08:04:39 +0200
Message-Id: <20210712060856.263898501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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



