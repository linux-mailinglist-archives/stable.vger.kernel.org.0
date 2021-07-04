Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B293BB1A8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhGDXMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231446AbhGDXLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C13286195C;
        Sun,  4 Jul 2021 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440097;
        bh=roqyspRFC1/DgrllRoflMHE9bkjkXJi48MaQ1+M2RGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPnaX3GIFpc2h/x8RfwgtJsp/2pGsuG8RorQGG+cU4S70qGBzLcnA/PtesgAyhyEa
         qU0ktyJ52J0c2fXGn65dkzzJss3+9R6JZz5r8IiGnDWgNn2Twl/Wdd5qBpUajhNIY3
         9Px3eXDNk5N+aTz9CfPihm2E/dGBArQiG9cltE2rhOUhLELKIrrX3FUnpMd0SWVK1v
         VFA/EuhHpNGoDED7yvquPoTivvG44o2mz2+/JeL3ipdyaLliWikUhxH4BC/7zQn+Ab
         VvhqUDITLvnjP4HKmrexGdWb3p7gi8zwhR94E0RUPY3D0F+cZ5bMA1/OUSilW6DsHN
         7C+DnozvPuBjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/70] media: s5p-jpeg: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:07:03 -0400
Message-Id: <20210704230804.1490078-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 10343de268d10cf07b092b8b525e12ad558ead77 ]

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.
Replace it by the new pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter, avoiding
a potential PM usage counter leak.

As a plus, pm_runtime_resume_and_get() doesn't return
positive numbers, so the return code validation can
be removed.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 9b22dd8e34f4..d515eb08c3ee 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2566,11 +2566,8 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
 static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
-	int ret;
-
-	ret = pm_runtime_get_sync(ctx->jpeg->dev);
 
-	return ret > 0 ? 0 : ret;
+	return pm_runtime_resume_and_get(ctx->jpeg->dev);
 }
 
 static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
-- 
2.30.2

