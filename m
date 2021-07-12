Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC963C48DD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbhGLGlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34399 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236827AbhGLGhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:37:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED853610D0;
        Mon, 12 Jul 2021 06:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071640;
        bh=ju547HHSoJneoZh4O62JWafGwz9NI9kYJ8MtTLOeHjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Afdd4HYIAE2sprgxrEC2T0Zd3zNaQaIK1LVTH6XfdV1Vw+GzYZ4UJqxM3qQ7CRNQS
         SXwmbGca4nJFnwVPw1wImuYNk8EIb2kwJgNS3DvOfdIA4Q5HJjl4zGcmyHvgmX/Z1s
         KVP1RbBSYv//M5LSeVCQbDOxnuXGC0x9fTNdaMfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/593] media: exynos-gsc: fix pm_runtime_get_sync() usage count
Date:   Mon, 12 Jul 2021 08:04:33 +0200
Message-Id: <20210712060855.610154491@linuxfoundation.org>
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



