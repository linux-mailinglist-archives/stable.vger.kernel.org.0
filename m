Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB662E670B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgL1NMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732042AbgL1NMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:12:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0607E207F7;
        Mon, 28 Dec 2020 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161103;
        bh=HC7o2PCeOIe++++B9TezS3nAeeucYTwVILTZ2ULRmks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlBo35UMIsL1pIs2m6pamnrCy/31ZeFwz+/1PbnRzcRYC8VgSHgm9VCMWK+T63OVK
         +bMcX4xIaU3t+tAgxlh6jrq02stN9cb4mJhTtcK4XLfB97WsNiKqpt7RaVgtWalMO/
         uV0tyECKGuzH3l87A93LAH6YXccu2IU/BkvOe+OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/242] crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
Date:   Mon, 28 Dec 2020 13:48:26 +0100
Message-Id: <20201228124909.663950777@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
index c376a3ee7c2c3..41c411ee0da5d 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1071,7 +1071,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	if (err < 0) {
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
-		goto err_res;
+		goto err_pm_disable;
 	}
 
 	omap_aes_dma_stop(dd);
@@ -1180,6 +1180,7 @@ err_engine:
 	omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
+err_pm_disable:
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
-- 
2.27.0



