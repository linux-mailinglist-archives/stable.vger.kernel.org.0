Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B032E39D3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389975AbgL1N2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389971AbgL1N2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB2622072C;
        Mon, 28 Dec 2020 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162083;
        bh=6gvyU8TwEM1eKa2+wq12PoNjxm2NYeyytB8mB1Eat+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4DdRuk+NVQ+4JWdrmmbctzU0+czKqg1vOWBrnZ+YiiAmX4jROXJrsucQXuFtuS7/
         EyVx/XSd76V9tcOZ7RA3Ykc/K8rHnC8NRxVApWkVrFmveV5HzLYuU9mUPjy6YagMuN
         xA6DB06pZ+DKu5cX/ZkHA4lSwYekkgqsaxfSK0Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 154/346] crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
Date:   Mon, 28 Dec 2020 13:47:53 +0100
Message-Id: <20201228124927.229346776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit ff8107200367f4abe0e5bce66a245e8d0f2d229e ]

The pm_runtime_enable will increase power disable depth.
Thus a pairing decrement is needed on the error handling
path to keep it balanced according to context.

Fixes: f7b2b5dd6a62a ("crypto: omap-aes - add error check for pm_runtime_get_sync")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-aes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9019f6b67986b..a5d6e1a0192bc 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1163,7 +1163,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	if (err < 0) {
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
-		goto err_res;
+		goto err_pm_disable;
 	}
 
 	omap_aes_dma_stop(dd);
@@ -1276,6 +1276,7 @@ err_engine:
 	omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
+err_pm_disable:
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
-- 
2.27.0



