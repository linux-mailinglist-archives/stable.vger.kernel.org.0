Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FE82B62CC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbgKQNbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbgKQNbR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 884C921534;
        Tue, 17 Nov 2020 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619876;
        bh=u1Ak2nNxo7nUzno8ukmvYi7sd/6Cx1+uQUo9XAzpz1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFKvS2vVElUmyVlinf/kMDH6sEsKVypOnA1sOHW5qfF4kfUNW98sjk+BbHIX7k+6p
         U2/IPHeLSBy1KLbKuY+WImXyITYi+sDZukiMUhWMJqtMk8xCQmO8KSif5ka7pKy6xB
         Vw8khUgEbLeBCafX6RqLVrzoBTuo4JlwtIzaHoMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 034/255] drm/panfrost: move devfreq_init()/fini() in device
Date:   Tue, 17 Nov 2020 14:02:54 +0100
Message-Id: <20201117122140.601935147@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit 25e247bbf85af3ad721dfeb2e2caf405f43b7e66 ]

Later we will introduce devfreq probing regulator if they
are present. As regulator should be probe only one time we
need to get this logic in the device_init().

panfrost_device is already taking care of devfreq_resume()
and devfreq_suspend(), so it's not totally illogic to move
the devfreq_init() and devfreq_fini() here.

Reviewed-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200710095409.407087-9-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_device.c | 12 +++++++++++-
 drivers/gpu/drm/panfrost/panfrost_drv.c    | 15 ++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index 9f89984f652a6..36b5c8fea3eba 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -214,9 +214,16 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 		return err;
 	}
 
+	err = panfrost_devfreq_init(pfdev);
+	if (err) {
+		if (err != -EPROBE_DEFER)
+			dev_err(pfdev->dev, "devfreq init failed %d\n", err);
+		goto out_clk;
+	}
+
 	err = panfrost_regulator_init(pfdev);
 	if (err)
-		goto out_clk;
+		goto out_devfreq;
 
 	err = panfrost_reset_init(pfdev);
 	if (err) {
@@ -265,6 +272,8 @@ out_reset:
 	panfrost_reset_fini(pfdev);
 out_regulator:
 	panfrost_regulator_fini(pfdev);
+out_devfreq:
+	panfrost_devfreq_fini(pfdev);
 out_clk:
 	panfrost_clk_fini(pfdev);
 	return err;
@@ -278,6 +287,7 @@ void panfrost_device_fini(struct panfrost_device *pfdev)
 	panfrost_gpu_fini(pfdev);
 	panfrost_pm_domain_fini(pfdev);
 	panfrost_reset_fini(pfdev);
+	panfrost_devfreq_fini(pfdev);
 	panfrost_regulator_fini(pfdev);
 	panfrost_clk_fini(pfdev);
 }
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index f6d5d03201fad..f2dd259f28995 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -14,7 +14,6 @@
 #include <drm/drm_utils.h>
 
 #include "panfrost_device.h"
-#include "panfrost_devfreq.h"
 #include "panfrost_gem.h"
 #include "panfrost_mmu.h"
 #include "panfrost_job.h"
@@ -606,13 +605,6 @@ static int panfrost_probe(struct platform_device *pdev)
 		goto err_out0;
 	}
 
-	err = panfrost_devfreq_init(pfdev);
-	if (err) {
-		if (err != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "Fatal error during devfreq init\n");
-		goto err_out1;
-	}
-
 	pm_runtime_set_active(pfdev->dev);
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_enable(pfdev->dev);
@@ -625,16 +617,14 @@ static int panfrost_probe(struct platform_device *pdev)
 	 */
 	err = drm_dev_register(ddev, 0);
 	if (err < 0)
-		goto err_out2;
+		goto err_out1;
 
 	panfrost_gem_shrinker_init(ddev);
 
 	return 0;
 
-err_out2:
-	pm_runtime_disable(pfdev->dev);
-	panfrost_devfreq_fini(pfdev);
 err_out1:
+	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
 err_out0:
 	drm_dev_put(ddev);
@@ -650,7 +640,6 @@ static int panfrost_remove(struct platform_device *pdev)
 	panfrost_gem_shrinker_cleanup(ddev);
 
 	pm_runtime_get_sync(pfdev->dev);
-	panfrost_devfreq_fini(pfdev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_put_sync_suspend(pfdev->dev);
 	pm_runtime_disable(pfdev->dev);
-- 
2.27.0



