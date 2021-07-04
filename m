Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949623BAFE6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGDXHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhGDXHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F7E5613D2;
        Sun,  4 Jul 2021 23:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439876;
        bh=hSjnugpCRJfdhSCYyqirPRHugjApYrssbPiR6eQSbaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pw9SqdNOgCSpZoXHW7vcoNBRGE8NqQv5vhwfcgWM8bj46EUuBTj08DE6vMwaT6C4e
         A2EDUyE3d2iCVj7BDaZhjiFBBydbqe4tWJauh3XbkWdNuwCAaRlWoZmP1fws8JcuTH
         YNlUvXN+BZCzd84BEZNtftZCyaT+zXF/XgSe9NPxDSDoB5yI4upxQUr3uIVj3fcQLS
         wCRwFXwjhnAk1Zibcw+nuof76deBKo5Nu0wgwjZeO9hWIQqogvACvWkbkOEgXLL0PH
         a+75fy8Y2wKeZUUchoopkXNg1cSSYBEQhqyHv6QMbvJtfHJiX9yUhFbs+hsLZ62nNm
         cCHYSoJ8E+U2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 11/85] media: s5p-jpeg: fix pm_runtime_get_sync() usage count
Date:   Sun,  4 Jul 2021 19:03:06 -0400
Message-Id: <20210704230420.1488358-11-sashal@kernel.org>
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
index 026111505f5a..d402e456f27d 100644
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

