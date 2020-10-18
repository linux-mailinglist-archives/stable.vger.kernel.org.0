Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56291291E7E
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgJRTUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgJRTUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:20:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A087822314;
        Sun, 18 Oct 2020 19:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048846;
        bh=XiJLm7dJT4iYtMQfAyf59AS4prF8Kb681A/GW+JkWyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLF8edkOkNtI2uimvIW/iFgSk7r3AhedKp/So+cSueVWFOQvyHVEIf5XiuVb/sMJ8
         /nQepoGlwmUepwSxg1p+leQu4V2owioczDkhYld0cGuoY8os/WDKrDUQT8bqL4OMaI
         oFBSvEvbtLZB6HzeKnLuejeFSlc5aj4zSFVqxe+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 015/101] media: platform: s3c-camif: Fix runtime PM imbalance on error
Date:   Sun, 18 Oct 2020 15:19:00 -0400
Message-Id: <20201018192026.4053674-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit dafa3605fe60d5a61239d670919b2a36e712481e ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Also, call pm_runtime_disable() when pm_runtime_get_sync() returns
an error code.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Sylwester Nawrocki <snawrocki@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s3c-camif/camif-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index c6fbcd7036d6d..ee624804862e2 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -464,7 +464,7 @@ static int s3c_camif_probe(struct platform_device *pdev)
 
 	ret = camif_media_dev_init(camif);
 	if (ret < 0)
-		goto err_alloc;
+		goto err_pm;
 
 	ret = camif_register_sensor(camif);
 	if (ret < 0)
@@ -498,10 +498,9 @@ static int s3c_camif_probe(struct platform_device *pdev)
 	media_device_unregister(&camif->media_dev);
 	media_device_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
-err_alloc:
+err_pm:
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
-err_pm:
 	camif_clk_put(camif);
 err_clk:
 	s3c_camif_unregister_subdev(camif);
-- 
2.25.1

