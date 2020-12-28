Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996372E41B1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440245AbgL1PKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:10:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438462AbgL1OHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1602920715;
        Mon, 28 Dec 2020 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164412;
        bh=j5V2gvgXdfzE2voLcVnf7hxbYBvEsyTexWFxe1T/87Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWhX0VFeX2HliF0d3qg1QhE5TBVmzxb0T+tkO5ZM+7h3vHKXNUWbyjYw2XJ1BVoB3
         4O//6k0s/mvBEQDuYSBuj0IwdzuvgyLfCZuSFgq78JuCDnCe8R0gZEOOz21/ovqu1D
         oiIJXyNeeuEzZkU7G0sUNq4XBmpLQcrLn+bjKJvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/717] crypto: omap-aes - Fix PM disable depth imbalance in omap_aes_probe
Date:   Mon, 28 Dec 2020 13:42:49 +0100
Message-Id: <20201228125029.152352456@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index 4fd14d90cc409..1b1e0ab0a831a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1137,7 +1137,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 	if (err < 0) {
 		dev_err(dev, "%s: failed to get_sync(%d)\n",
 			__func__, err);
-		goto err_res;
+		goto err_pm_disable;
 	}
 
 	omap_aes_dma_stop(dd);
@@ -1246,6 +1246,7 @@ err_engine:
 	omap_aes_dma_cleanup(dd);
 err_irq:
 	tasklet_kill(&dd->done_task);
+err_pm_disable:
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
-- 
2.27.0



