Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922BB2B62C9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbgKQNbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732021AbgKQNbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E6B24199;
        Tue, 17 Nov 2020 13:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619879;
        bh=m0nnMRgpm6Gra6JClJyUN1D8QztDZ535HcvNblV4kck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdrzgzr8Yz6tytPcdaZbiog0MmWGTYTrTQPHc0xqEm3c7As8xahgE1EdwI3j9JoqX
         8jmwI+pfIYKttXnLFO/nKrKIOYlm1V5dQXP8gcwaq6aGTPAxNg0zrKLtkci8Fua4WU
         UIlz8FjgXf2zsqzZzpTPoePAwNokqav75E3ncdk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 035/255] drm/panfrost: Fix module unload
Date:   Tue, 17 Nov 2020 14:02:55 +0100
Message-Id: <20201117122140.650754935@linuxfoundation.org>
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

From: Steven Price <steven.price@arm.com>

[ Upstream commit 876b15d2c88d8c005f1aebeaa23f1e448d834757 ]

When unloading the call to pm_runtime_put_sync_suspend() will attempt to
turn the GPU cores off, however panfrost_device_fini() will have turned
the clocks off. This leads to the hardware locking up.

Instead don't call pm_runtime_put_sync_suspend() and instead simply mark
the device as suspended using pm_runtime_set_suspended(). And also
include this on the error path in panfrost_probe().

Fixes: aebe8c22a912 ("drm/panfrost: Fix possible suspend in panfrost_remove")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201030145833.29006-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index f2dd259f28995..5d95917f923a1 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -626,6 +626,7 @@ static int panfrost_probe(struct platform_device *pdev)
 err_out1:
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
+	pm_runtime_set_suspended(pfdev->dev);
 err_out0:
 	drm_dev_put(ddev);
 	return err;
@@ -640,9 +641,9 @@ static int panfrost_remove(struct platform_device *pdev)
 	panfrost_gem_shrinker_cleanup(ddev);
 
 	pm_runtime_get_sync(pfdev->dev);
-	panfrost_device_fini(pfdev);
-	pm_runtime_put_sync_suspend(pfdev->dev);
 	pm_runtime_disable(pfdev->dev);
+	panfrost_device_fini(pfdev);
+	pm_runtime_set_suspended(pfdev->dev);
 
 	drm_dev_put(ddev);
 	return 0;
-- 
2.27.0



