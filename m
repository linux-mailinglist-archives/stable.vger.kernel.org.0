Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8EA2E13E2
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgLWCgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgLWCYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71A34225AB;
        Wed, 23 Dec 2020 02:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690261;
        bh=bDkRmOk5xWiufWsEudftt83U7NscQvi6wj1oRpyNZZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oi+pCOFXxNn4S7q8NckhQl5vnzXLCSWm3Zde9BVnpkV8qnnJyTUbMLeIn79Vc0Pia
         Z0z1Pt363YFurD9IVxAJfnELHsOf8JzJmJ1UKxczm4ujhzqK5mWcG3Lwa4rn0txuGg
         VPa5h9G5U9KmlE1N8ktq1aX7BE5fY9ocvNtTxY2pZXwMwNvhqZaQvHLiPK7Q5MbOIn
         MAomgOwWh0kukECaweobTQQt7ey3kNWHjVVpE3ZuiGulhRJJZpr0yibAujFLVGvAJs
         wy5bo8EWaI5guVrz9Km67LnlNVJnWLNoFNxFjVuKqWf5m6tW/XkWyrOY4fVc60Uqe3
         egeFPQicsJgiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/48] crypto: omap-aes - fix the reference count leak of omap device
Date:   Tue, 22 Dec 2020 21:23:31 -0500
Message-Id: <20201223022417.2794032-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 383e8a823014532ffd81c787ef9009f1c2bd3b79 ]

pm_runtime_get_sync() will increment  pm usage counter even
when it returns an error code. We should call put operation
in error handling paths of omap_aes_hw_init.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-aes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index fe32dd95ae4ff..717cde167873a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -251,6 +251,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 
 	err = pm_runtime_get_sync(dd->dev);
 	if (err < 0) {
+		pm_runtime_put_noidle(dd->dev);
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
 	}
-- 
2.27.0

