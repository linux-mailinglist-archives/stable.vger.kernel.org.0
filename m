Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F43BAFEE
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhGDXHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhGDXHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EFD611ED;
        Sun,  4 Jul 2021 23:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439878;
        bh=7kM2a15ZQmlJKy3BAp/RcYaPlz4U1rdIR5s2Vcfglg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+nvtQs7wArLsQU0WWQrqRRnG70eZMmuc/UD8WENXsTcG0K6QII3PgNalNKjV1kLK
         /2EZAs4gvMkR6tpq/pYrx4QHpkFLNuX4bqKBRw0QQ/K8oEyutdPVypddp1paTFYcu3
         6hNxDwtBruqXIBbCTjijNooxbDpW97m9J69H8BFU8c/adghuB35y3qrtp7T0uZ5R9/
         iUyNZt+qjjgx8Vk+GobTcGphOs2UfHzQs0REh1RNNCZp5NYSu6GUuYyva0o7z1jxqC
         aEzCAtNWRSr/IVMTkseQSVnqov8QK2SJrzl37fVMvMHQZiUCFJ7gZvv0nS746jAOhA
         +FlQRbosbGxCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 13/85] media: sti/bdisp: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:03:08 -0400
Message-Id: <20210704230420.1488358-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -1395,6 +1395,7 @@ static int bdisp_probe(struct platform_device *pdev)
 	bdisp_hw_free_filters(bdisp->dev);
 err_pm:
 	pm_runtime_put(dev);
+err_remove:
 	bdisp_debugfs_remove(bdisp);
 	v4l2_device_unregister(&bdisp->v4l2_dev);
 err_clk:
-- 
2.30.2

