Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439E2119580
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfLJVVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbfLJVLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 591F5246A8;
        Tue, 10 Dec 2019 21:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012312;
        bh=MnjkOJzQpeys/zJdC8tULjlZdIzXW7jVsRu4TsHrD9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBNw3FRXIgSAB5/1mbeqZzh8gJyq0B/LsZ5FuXS75EsqT3EZ+Va2oLBsJonlMPfbE
         +V74QoafMGXn9c4Uuw1wVQJ19JK7XrZenDpYvQsu/gooGxqyq4Y9Ysx1okG1AIZEad
         +y6ejDOm/cFyoxEzHLvLMGL9Z1+gS87Em/WrmB+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 247/350] media: exynos4-is: fix wrong mdev and v4l2 dev order in error path
Date:   Tue, 10 Dec 2019 16:05:52 -0500
Message-Id: <20191210210735.9077-208-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seung-Woo Kim <sw0312.kim@samsung.com>

[ Upstream commit 4d741cbd58bf889c8a68cf6e592a7892b5c2802e ]

When driver is built as module and probe during insmod is deferred
because of sensor subdevs, there is NULL pointer deference because
mdev is cleaned up and then access it from v4l2_device_unregister().
Fix the wrong mdev and v4l2 dev order in error path of probe.

This fixes below null pointer deference:
   Unable to handle kernel NULL pointer dereference at virtual address 00000000
   pgd = ca026f68
   [00000000] *pgd=00000000
   Internal error: Oops: 5 [#1] PREEMPT SMP ARM
   [...]
   Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
   PC is at ida_free+0x7c/0x160
   LR is at xas_start+0x44/0x204
   [...]
   [<c0dafd60>] (ida_free) from [<c083c20c>] (__media_device_unregister_entity+0x18/0xc0)
   [<c083c20c>] (__media_device_unregister_entity) from [<c083c2e0>] (media_device_unregister_entity+0x2c/0x38)
   [<c083c2e0>] (media_device_unregister_entity) from [<c0843404>] (v4l2_device_release+0xd0/0x104)
   [<c0843404>] (v4l2_device_release) from [<c0632558>] (device_release+0x28/0x98)
   [<c0632558>] (device_release) from [<c0db1204>] (kobject_put+0xa4/0x208)
   [<c0db1204>] (kct_put) from [<bf00bac4>] (fimc_capture_subdev_unregistered+0x58/0x6c [s5p_fimc])
   [<bf00bac4>] (fimc_capture_subdev_unregistered [s5p_fimc]) from [<c084a1cc>] (v4l2_device_unregister_subdev+0x6c/0xa8)
   [<c084a1cc>] (v4l2_device_unregister_subdev) from [<c084a350>] (v4l2_device_unregister+0x64/0x94)
   [<c084a350>] (v4l2_device_unregister) from [<bf0101ac>] (fimc_md_probe+0x4ec/0xaf8 [s5p_fimc])
   [...]

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Fixes: 9832e155f1ed ("[media] media-device: split media initialization and registration")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos4-is/media-dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index a838189d44902..9aaf3b8060d50 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1457,12 +1457,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
-		return ret;
+		goto err_md;
 	}
 
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
-		goto err_md;
+		goto err_v4l2dev;
 
 	ret = fimc_md_get_pinctrl(fmd);
 	if (ret < 0) {
@@ -1519,9 +1519,10 @@ static int fimc_md_probe(struct platform_device *pdev)
 	fimc_md_unregister_entities(fmd);
 err_clk:
 	fimc_md_put_clocks(fmd);
+err_v4l2dev:
+	v4l2_device_unregister(&fmd->v4l2_dev);
 err_md:
 	media_device_cleanup(&fmd->media_dev);
-	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
 
-- 
2.20.1

