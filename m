Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2DF2E14AA
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbgLWCl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgLWCXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8383922D73;
        Wed, 23 Dec 2020 02:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690177;
        bh=UXKOGuw0XHr/W4/vCaNtZZD+Iilf1QiSCxs8krdK5io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4Yy0w2yPEdg9HgcIydJfWKvA02k2TmLlIisPahRKx3h+9JeWuLD507w/YuGdaGtN
         Tw7cBtHbHyv+YfGHykZEPTTFgny6aDQxMJ3fiu+Dc9moxd1Xlz87rqF9ELzgbU5BMT
         oW6JAdtV845Vp/dL1c65M83nV+rcxrlcXDwOfngP5YSmufKIu2cqNqZgAZnLtpxOdb
         uR3+vumLnup5wljRKQ5N9DG4jCscqnCcA37TMMz74j+ydvIb/BYF1k6YRdN+S8Ln1x
         BD8TWjqkHJFQYWteu4FIwFXi5k+s23fw4HzBaae7zUe/fvD/c+H20TPI49jL74O3wH
         i56EAzt1CXZFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/66] crypto: omap-aes - fix the reference count leak of omap device
Date:   Tue, 22 Dec 2020 21:21:49 -0500
Message-Id: <20201223022253.2793452-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index c376a3ee7c2c3..57d4269d17f65 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -106,6 +106,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 
 	err = pm_runtime_get_sync(dd->dev);
 	if (err < 0) {
+		pm_runtime_put_noidle(dd->dev);
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
 	}
-- 
2.27.0

