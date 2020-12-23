Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336D52E166A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgLWCTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbgLWCTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D5A822A99;
        Wed, 23 Dec 2020 02:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689900;
        bh=JhX3Fhq593qbaf1eCnr81V44C24UQsGbMZo5mTwfTDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcYFZN8fML3gAE9SzRyQUg6Jw1QV1imqVbQqxFSv7yOz+GQAkqVVwEF+ZUYV7StNP
         lFQfDqOadwljmpgDMRKiyM5yNdsR/OChujH1CshmDdT+kppWGaQx1k4zaDNswfSTKI
         0cmw23Exq/JiudNVl0THBN22+ZMtSEK0W/i25zYrB/nDGwcWMa5enZ1aCM3cWjNhRM
         Gb5ANB2V98MIaVQQkxX9aQvWGpYmJ0J1W+sqON8C2GO5Tqw7pyorfJGCGQUaQw7oDC
         9pVUMhBYUoQcsZB6w6q5j4u60ha6DQBL0hDI/5YhTIBqqMajVlu/ADgVcanGuAVeTc
         sU0u24oj1spLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 005/130] crypto: omap-aes - fix the reference count leak of omap device
Date:   Tue, 22 Dec 2020 21:16:08 -0500
Message-Id: <20201223021813.2791612-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 2f53fbb741001..2f81f347b8fe0 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -105,6 +105,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
 
 	err = pm_runtime_get_sync(dd->dev);
 	if (err < 0) {
+		pm_runtime_put_noidle(dd->dev);
 		dev_err(dd->dev, "failed to get sync: %d\n", err);
 		return err;
 	}
-- 
2.27.0

