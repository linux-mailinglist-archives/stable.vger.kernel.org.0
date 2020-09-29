Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E41B27C38B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgI2LGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728835AbgI2LGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144B821941;
        Tue, 29 Sep 2020 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377599;
        bh=AZyhVGJgpbhYzg3+kumaGZxjkK74KsqzH1d2Iwyom+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0crUZymxUJgCZLdlqznYgRcmipbsfbhx0cGvtLDytUkpIYHOSnotcBb6CUSmX3Vu
         zvSte38/hCU4j1PPxgYYUgNugTR+UGbhJvTo3kE/qQUM7+h9kebJvLxIn+xSkQt37w
         H1jMo/wHvym4ZsPCh2mw9ayG+PXcAB3A26konyVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 67/85] mtd: rawnand: omap_elm: Fix runtime PM imbalance on error
Date:   Tue, 29 Sep 2020 13:00:34 +0200
Message-Id: <20200929105931.568801981@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
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
 drivers/mtd/nand/omap_elm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/omap_elm.c b/drivers/mtd/nand/omap_elm.c
index 235ec7992b4cf..e46b11847082a 100644
--- a/drivers/mtd/nand/omap_elm.c
+++ b/drivers/mtd/nand/omap_elm.c
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



