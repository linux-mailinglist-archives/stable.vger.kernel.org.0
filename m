Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC89D3C486B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbhGLGi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236121AbhGLGhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5044361151;
        Mon, 12 Jul 2021 06:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071621;
        bh=GS4HYO8RAoaqM24bOqToIKV1uzxOx5AOdFP2Shpm7f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fa5ZRhGDKyXm5980xDwlvIrSnFMoV0fQENTSkDPoYGeYZaCoj8RYgUJxzFvksTyr
         KV11A1IFaceT0jU6wMaFQq0CiFUsTlYqjif8L0m53rkOgq6gHaZMYlkLC0QU0dKGG9
         HGFM3j/JQKnAtm9b+J4EIQFnN1IHws2pSCjyBqnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/593] media: sti/bdisp: fix pm_runtime_get_sync() usage count
Date:   Mon, 12 Jul 2021 08:04:31 +0200
Message-Id: <20210712060855.403183265@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit c44eac5b72e23c31eefc0e10a71d9650036b8341 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.

The bdisp_start_streaming() doesn't take it into account, which
would unbalance PM usage counter at bdisp_stop_streaming().

The logic at bdisp_probe() is correct, but the best is to use
the same call along the driver.

So, replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 060ca85f64d5..85288da9d2ae 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -499,7 +499,7 @@ static int bdisp_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct bdisp_ctx *ctx = q->drv_priv;
 	struct vb2_v4l2_buffer *buf;
-	int ret = pm_runtime_get_sync(ctx->bdisp_dev->dev);
+	int ret = pm_runtime_resume_and_get(ctx->bdisp_dev->dev);
 
 	if (ret < 0) {
 		dev_err(ctx->bdisp_dev->dev, "failed to set runtime PM\n");
@@ -1364,10 +1364,10 @@ static int bdisp_probe(struct platform_device *pdev)
 
 	/* Power management */
 	pm_runtime_enable(dev);
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "failed to set PM\n");
-		goto err_pm;
+		goto err_remove;
 	}
 
 	/* Filters */
@@ -1395,6 +1395,7 @@ err_filter:
 	bdisp_hw_free_filters(bdisp->dev);
 err_pm:
 	pm_runtime_put(dev);
+err_remove:
 	bdisp_debugfs_remove(bdisp);
 	v4l2_device_unregister(&bdisp->v4l2_dev);
 err_clk:
-- 
2.30.2



