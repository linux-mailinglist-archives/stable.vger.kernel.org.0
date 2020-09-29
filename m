Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5AE27CB16
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgI2MYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:24:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729775AbgI2LfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:35:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798BA23C81;
        Tue, 29 Sep 2020 11:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378918;
        bh=XVGbZGXzyGzRewPWKVp/MbziheKaRme8wTSbBriuDLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9HOQzZHl4N9iqa5QUryZES+9pqKRm5uTLnQLEJ2St3mF2ChVpkdnk+2JDIAeEBe2
         uXcpG9RREOErnM6tCT9SJ3lCRHSM2SzYjvgqyOB6XirkRqjq6zTS6knVnOaUde7/m7
         18E63SDwFKwlqiq8/M9MouV7mz/x1FMsC5gYb+BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/245] mtd: rawnand: omap_elm: Fix runtime PM imbalance on error
Date:   Tue, 29 Sep 2020 13:00:38 +0200
Message-Id: <20200929105956.075784651@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 37f7212148cf1d796135cdf8d0c7fee13067674b ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200522104008.28340-1-dinghao.liu@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/omap_elm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/raw/omap_elm.c b/drivers/mtd/nand/raw/omap_elm.c
index a3f32f939cc17..6736777a41567 100644
--- a/drivers/mtd/nand/raw/omap_elm.c
+++ b/drivers/mtd/nand/raw/omap_elm.c
@@ -421,6 +421,7 @@ static int elm_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	if (pm_runtime_get_sync(&pdev->dev) < 0) {
 		ret = -EINVAL;
+		pm_runtime_put_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		dev_err(&pdev->dev, "can't enable clock\n");
 		return ret;
-- 
2.25.1



