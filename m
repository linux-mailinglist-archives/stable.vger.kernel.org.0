Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575503BAFF7
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhGDXHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhGDXHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE47613E9;
        Sun,  4 Jul 2021 23:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439881;
        bh=ju547HHSoJneoZh4O62JWafGwz9NI9kYJ8MtTLOeHjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPO4NVTZMoPNA3XQKtHSaXEJrnvcPhP0MB5r+HKlVuEWJzKTRJePxVX+nFyzmDghV
         7h3seivDnBvw7Y7ygagJdHiO+WziPVC7HlGDu+dC1rQgEKknCM7ZvkYcuBV37f8SFu
         Ps6zNY7F/FjRACvD7xuTivvnrdE5cA2zjlpXX3mI3AliyhSbzIAYsys7D4T12crsK2
         D8TPaZ59YkFEun2Sgn/C+hZyHnOH473kOvqmgwpbbHRfgNz0VEzRjcur7T0BdqP9V9
         SpiDxroectHGC2NpL9PWtQbqAgXNiNg6XuPqTI677zDVBjJIlpqi0Kd6lJ6pCuyrKG
         iwMMXaKh5x45A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 15/85] media: exynos-gsc: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:03:10 -0400
Message-Id: <20210704230420.1488358-15-sashal@kernel.org>
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
index 27a3c92c73bc..f1cf847d1cc2 100644
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

