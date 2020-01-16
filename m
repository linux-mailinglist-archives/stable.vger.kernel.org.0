Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4926213E2CB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387510AbgAPQ5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387540AbgAPQ5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC72022525;
        Thu, 16 Jan 2020 16:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193865;
        bh=Kfq7vR1aY0nNg82frCd7ANsw/ZvrzG9h0pRt5rTHc9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IICYjNyzZD1dRsRCNhd1DMpfglOOX0DJexhAufyaeDik+jBpb5bOdZBTilsi0o9vE
         L3q8KY3zYGkOpdrMjWDRxdUvyN7DRHCRd+GJfMVh2TqcDQfN98z7QMDvKjYhkUf0fs
         umZkqccuUkzYJ4csxZOfOZtWB844KHaepd5QAimc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 111/671] drm/shmob: Fix return value check in shmob_drm_probe
Date:   Thu, 16 Jan 2020 11:45:42 -0500
Message-Id: <20200116165502.8838-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 06c3bbd3c12737a50c2e981821b5585e1786e73d ]

In case of error, the function devm_ioremap_resource() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should
be replaced with IS_ERR().

Fixes: 8f1597c8f1a5 ("drm: shmobile: Perform initialization/cleanup at probe/remove time")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/shmobile/shmob_drm_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/shmobile/shmob_drm_drv.c b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
index 592572554eb0..58d8a98c749b 100644
--- a/drivers/gpu/drm/shmobile/shmob_drm_drv.c
+++ b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
@@ -233,8 +233,8 @@ static int shmob_drm_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sdev->mmio = devm_ioremap_resource(&pdev->dev, res);
-	if (sdev->mmio == NULL)
-		return -ENOMEM;
+	if (IS_ERR(sdev->mmio))
+		return PTR_ERR(sdev->mmio);
 
 	ret = shmob_drm_setup_clocks(sdev, pdata->clk_source);
 	if (ret < 0)
-- 
2.20.1

