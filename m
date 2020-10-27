Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2539129C3A6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822059AbgJ0Rqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759055AbgJ0O11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:27:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F91B206DC;
        Tue, 27 Oct 2020 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808847;
        bh=ubTthlQXPGpbLr5597toqvhjvnhASr4vmo2xJWKCu+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST0fpqzduXqZSp4OgY518BtN5QqZ18Yk7Xxl5RgruaX4qFyq+7mUYMEz/fmLkoigt
         TYNgALLf+gI4Z3AfGkTmvJh4Iq+9u0cnQN44gpLDW4K6u4ULUWfgzQRZS5xz08ak3t
         hHVmmGZ/drP3v83mbH4YPJhj+AINlKIBzcuU3nP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/264] media: platform: s3c-camif: Fix runtime PM imbalance on error
Date:   Tue, 27 Oct 2020 14:54:34 +0100
Message-Id: <20201027135440.826681230@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 79bc0ef6bb413..8d8ed72bd0aaf 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -476,7 +476,7 @@ static int s3c_camif_probe(struct platform_device *pdev)
 
 	ret = camif_media_dev_init(camif);
 	if (ret < 0)
-		goto err_alloc;
+		goto err_pm;
 
 	ret = camif_register_sensor(camif);
 	if (ret < 0)
@@ -510,10 +510,9 @@ static int s3c_camif_probe(struct platform_device *pdev)
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



