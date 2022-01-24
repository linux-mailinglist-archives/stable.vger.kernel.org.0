Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F96E498D3A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348359AbiAXT3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:29:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351509AbiAXT1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:27:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 127E1B81238;
        Mon, 24 Jan 2022 19:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CECC340E5;
        Mon, 24 Jan 2022 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052434;
        bh=jo1QdWXfxk/xuGISj2AdjzU5SrJsUUu9kwioQXF1HGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOT/0oz635qDGSYXk/pQmnkqzBfASksYTYQ2drrwNRx9OCtd7h7GoeP8piNN/JKka
         rM6lRfNl2xfatSYprnO4syCQq5dMpflakGHVGlCkVPGCo3OsHh1t0w5Wt+RzaonMJw
         20Bl2qM+kLl7Z9mMfvZlGkQsTdaBPR3WoJVtCO3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/320] media: imx-pxp: Initialize the spinlock prior to using it
Date:   Mon, 24 Jan 2022 19:40:40 +0100
Message-Id: <20220124183955.640446385@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit ed2f97ad4b21072f849cf4ae6645d1f2b1d3f550 ]

After devm_request_threaded_irq() is called there is a chance that an
interrupt may occur before the spinlock is initialized, which will trigger
a kernel oops.

To prevent that, move the initialization of the spinlock prior to
requesting the interrupts.

Fixes: 51abcf7fdb70 ("media: imx-pxp: add i.MX Pixel Pipeline driver")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-pxp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index 38d9423223025..3c36cefddec7c 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -1664,6 +1664,8 @@ static int pxp_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	spin_lock_init(&dev->irqlock);
+
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
 			IRQF_ONESHOT, dev_name(&pdev->dev), dev);
 	if (ret < 0) {
@@ -1681,8 +1683,6 @@ static int pxp_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	spin_lock_init(&dev->irqlock);
-
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		goto err_clk;
-- 
2.34.1



