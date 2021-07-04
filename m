Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A553BB013
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhGDXHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhGDXH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E82F613F7;
        Sun,  4 Jul 2021 23:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439891;
        bh=g7YZHIXlmpzIxBwyRILjn1eXvxCLTK1iVgAuIElkdJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pj9xx7nSYUWmuAatkVjyZOVgO/ZQvoJ6AHHtHeqwu2sAQK20dMY8JozpegDR5ishy
         /qkjJ/CROPy0NPlJzYV4qWOF5KajA9SzMz0O6Ue1Q/5CA07D2+5bvZKeWPkad8ntCi
         95y/fOa66quRpOUsjsb+aDE+O93vNkIpdFTr5kzQY9Ac/fCcwkUylGAdFNq6ADwltz
         h9ftgRbRQr0enRTRFhSE38nUM9UV8stIa03Q8wc1Fq9pXvvqpAlEvjFtwrVuy5mBlp
         E4VzRIoNWnlsDtah5nE3v5kZijWtVe7c+JsYeaUFgkAMlvJr9rWa3fH8rm9ajo3/Em
         qlNCPL3N/9zTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 21/85] hwrng: exynos - Fix runtime PM imbalance on error
Date:   Sun,  4 Jul 2021 19:03:16 -0400
Message-Id: <20210704230420.1488358-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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

