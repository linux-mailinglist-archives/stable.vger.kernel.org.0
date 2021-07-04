Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBAA3BB2F9
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhGDXQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233403AbhGDXOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9673861935;
        Sun,  4 Jul 2021 23:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440189;
        bh=JSshXvAaGoLwfRbLDCHHeyzewaXyO04NzXWHw0dUZ7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZ4mfFgQQiEJpmRa8r/9Rbeb9BNHobYe2mIEHOwcEhBTwDotL1m9E4GvRfjtkMUV9
         Ri5wf8UBqOKJ9Ax/0nRXHSLPTsWlwTlh+RrKh8GRHkuM3Ka1olDTz5F3Yt5ce+e4Xk
         tY8TOrWrJOxibWsWivCS2PO/MraT/9+ExZAI/VK96j29vsU7xDP0MHUySI9eiHCTCT
         EQtJJyQAmN++SRrFY+hooH2UNHwHzJKpjRivhlAX/ha1fKpzOzHaxaOlf2hHvA9lUe
         qdr+yhd07/1cefv0HAUfkzZYR66rX6npXXlBgZHFLAknR3S6/Y91Gr+2lTOJ3zITff
         3C17YOodqlMOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/50] media: exynos-gsc: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:08:56 -0400
Message-Id: <20210704230938.1490742-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 59087b66ea6730c130c57d23bd9fd139b78c1ba5 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

As a bonus, as pm_runtime_get_sync() always return 0 on
success, the logic can be simplified.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 35a1d0d6dd66..42d1e4496efa 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -56,10 +56,8 @@ static void __gsc_m2m_job_abort(struct gsc_ctx *ctx)
 static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct gsc_ctx *ctx = q->drv_priv;
-	int ret;
 
-	ret = pm_runtime_get_sync(&ctx->gsc_dev->pdev->dev);
-	return ret > 0 ? 0 : ret;
+	return pm_runtime_resume_and_get(&ctx->gsc_dev->pdev->dev);
 }
 
 static void __gsc_m2m_cleanup_queue(struct gsc_ctx *ctx)
-- 
2.30.2

