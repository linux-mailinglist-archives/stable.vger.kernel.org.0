Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943453CDD3F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbhGSO4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241866AbhGSOzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A426128E;
        Mon, 19 Jul 2021 15:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708806;
        bh=eeiL00fmRrNxQ69+yVHATXuGZ2valWmbYO4DIbEZfCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlrYx6ZQiqWbFL3IZ6XC847iLJnD+KY0194jcgTOw9lpHK+kIIVcuv3oKR8Yt3GUB
         wVroQ2I9bnvi0d0aSCJf21Xim2AchX9OEttahGeay85g+u3852bxzPdBsb1eWMiS6h
         hSqU8WQJ1SBWXg+gqikFbaZ8s7l0GnHEZInYvVZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dillon Min <dillon.minfei@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/421] media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx
Date:   Mon, 19 Jul 2021 16:48:41 +0200
Message-Id: <20210719144950.384661200@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Min <dillon.minfei@gmail.com>

[ Upstream commit 5d11e6aad1811ea293ee2996cec9124f7fccb661 ]

The m2m_ctx resources was allocated by v4l2_m2m_ctx_init() in g2d_open()
should be freed from g2d_release() when it's not used.

Fix it

Fixes: 918847341af0 ("[media] v4l: add G2D driver for s5p device family")
Signed-off-by: Dillon Min <dillon.minfei@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-g2d/g2d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 1f58574d0b96..4cf5b559420f 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -285,6 +285,9 @@ static int g2d_release(struct file *file)
 	struct g2d_dev *dev = video_drvdata(file);
 	struct g2d_ctx *ctx = fh2ctx(file->private_data);
 
+	mutex_lock(&dev->mutex);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	mutex_unlock(&dev->mutex);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-- 
2.30.2



