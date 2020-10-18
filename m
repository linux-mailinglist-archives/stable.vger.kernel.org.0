Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA4291CA3
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgJRTYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729506AbgJRTYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:24:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EC12223AB;
        Sun, 18 Oct 2020 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049071;
        bh=VT0Bmb4Wg8Imwpbfcbw7Zxqc2bJh0Cmv2/xczKlzgA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYBV8JzaAt2ZvumhnUk2OJwwFKtwe8FFgWwYuWGr1b1w2HBXGuaF20FxE/rcARCB0
         6NzmL8xO/C1AU1WTzl9AcSfLLhWBvO903DCLtu1uDQq2rNU46EMohQmrKVfCHjcbtZ
         SFeKgpJBBbO5HigPzR/Ys2GguVml24ptA8rii01I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/56] media: vsp1: Fix runtime PM imbalance on error
Date:   Sun, 18 Oct 2020 15:23:31 -0400
Message-Id: <20201018192417.4055228-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 98fae901c8883640202802174a4bd70a1b9118bd ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index b6619c9c18bb4..4e6530ee809af 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -562,7 +562,12 @@ int vsp1_device_get(struct vsp1_device *vsp1)
 	int ret;
 
 	ret = pm_runtime_get_sync(vsp1->dev);
-	return ret < 0 ? ret : 0;
+	if (ret < 0) {
+		pm_runtime_put_noidle(vsp1->dev);
+		return ret;
+	}
+
+	return 0;
 }
 
 /*
@@ -845,12 +850,12 @@ static int vsp1_probe(struct platform_device *pdev)
 	/* Configure device parameters based on the version register. */
 	pm_runtime_enable(&pdev->dev);
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = vsp1_device_get(vsp1);
 	if (ret < 0)
 		goto done;
 
 	vsp1->version = vsp1_read(vsp1, VI6_IP_VERSION);
-	pm_runtime_put_sync(&pdev->dev);
+	vsp1_device_put(vsp1);
 
 	for (i = 0; i < ARRAY_SIZE(vsp1_device_infos); ++i) {
 		if ((vsp1->version & VI6_IP_VERSION_MODEL_MASK) ==
-- 
2.25.1

