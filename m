Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B86229C5AE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756196AbgJ0OLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754887AbgJ0OHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:07:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B299F218AC;
        Tue, 27 Oct 2020 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807653;
        bh=xV8v4HsfW/T/pSVmTp0YC8+BuJdwI81D8/nK9ImUFdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS+yx0ub55B/W+P5IeIbfOT5iI1A0Hn4cVEQq6BZcq4it7H3SVrXQKhBvupfAKGLL
         Ny+74Ae2S/Xy4QRLHADDI2NDTbOG9a5YRIO12mn917OGem1bYbkdoFGbqdIFlagQmi
         ZJRLS/Ss5qtkIS0T5zUOcGJpIInofIUHhjyFOK1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 101/139] media: platform: s3c-camif: Fix runtime PM imbalance on error
Date:   Tue, 27 Oct 2020 14:49:55 +0100
Message-Id: <20201027134906.929869714@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
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
index ec40019703132..560e1ff236508 100644
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



