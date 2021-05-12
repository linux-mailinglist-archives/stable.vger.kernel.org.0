Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8C337C8F1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhELQOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239391AbhELQH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC23461991;
        Wed, 12 May 2021 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833878;
        bh=AwUYqJkZMUbpNVa1Q+e5kSdCXkCR3pS3pZEbk0ftjA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIxItZt9X5qWN67Aij6my//37EBbmcXi0JEj13vtLrI3+bbMwvLPGd/1+5gT00+JC
         kz+aThmiP1304tv5+3A0rtD/WA5/4Zy6UGkFewOmUZ615yT2IYSU9NiMEzILOvXQ+j
         hh4tyEw//RENjACS5/E2KW+WkZj1KItWPqLsHDqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 323/601] media: venus: core: Fix some resource leaks in the error path of venus_probe()
Date:   Wed, 12 May 2021 16:46:40 +0200
Message-Id: <20210512144838.447204852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5a465c5391a856a0c1e9554964d660676c35d1b2 ]

If an error occurs after a successful 'of_icc_get()' call, it must be
undone.

Use 'devm_of_icc_get()' instead of 'of_icc_get()' to avoid the leak.
Update the remove function accordingly and axe the now unneeded
'icc_put()' calls.

Fixes: 32f0a6ddc8c9 ("media: venus: Use on-chip interconnect API")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 7233a7311757..4b318dfd7177 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -195,11 +195,11 @@ static int venus_probe(struct platform_device *pdev)
 	if (IS_ERR(core->base))
 		return PTR_ERR(core->base);
 
-	core->video_path = of_icc_get(dev, "video-mem");
+	core->video_path = devm_of_icc_get(dev, "video-mem");
 	if (IS_ERR(core->video_path))
 		return PTR_ERR(core->video_path);
 
-	core->cpucfg_path = of_icc_get(dev, "cpu-cfg");
+	core->cpucfg_path = devm_of_icc_get(dev, "cpu-cfg");
 	if (IS_ERR(core->cpucfg_path))
 		return PTR_ERR(core->cpucfg_path);
 
@@ -334,9 +334,6 @@ static int venus_remove(struct platform_device *pdev)
 
 	hfi_destroy(core);
 
-	icc_put(core->video_path);
-	icc_put(core->cpucfg_path);
-
 	v4l2_device_unregister(&core->v4l2_dev);
 	mutex_destroy(&core->pm_lock);
 	mutex_destroy(&core->lock);
-- 
2.30.2



