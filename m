Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24951A40E1
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgDJDqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgDJDqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBDD32137B;
        Fri, 10 Apr 2020 03:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490402;
        bh=gRsQNMLbwAKVeC0Gb+JWu5Kd2OwoKKeUa99fqZnlHeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzqkF1Ojt7Ydep5NN2mSLv4BRslgpa0JSg5GqjKpBG2hQG3Ixs7OpquD0Yz0/oDUS
         CnNsDVeB7+KPzL8Zgww0VgYEYLFn0HO+ljBeJVokie2vZi9soLD2dWIiO1IZqLqjmt
         MZu1wzAPV03AFZGS8TZ/lPDpWIUr6j8PZdMx5buA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.6 06/68] media: hantro: fix extra MV/MC sync space calculation
Date:   Thu,  9 Apr 2020 23:45:31 -0400
Message-Id: <20200410034634.7731-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 042584e9055b615ac917239884fb0d65690f56ec ]

Add space for MVs and MC sync data to the capture buffers depending on
whether the post processor will be enabled for the new capture format
passed to TRY_FMT, not the currently set capture format.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_v4l2.c b/drivers/staging/media/hantro/hantro_v4l2.c
index 0198bcda26b75..f4ae2cee0f189 100644
--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -295,7 +295,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f,
 		 * +---------------------------+
 		 */
 		if (ctx->vpu_src_fmt->fourcc == V4L2_PIX_FMT_H264_SLICE &&
-		    !hantro_needs_postproc(ctx, ctx->vpu_dst_fmt))
+		    !hantro_needs_postproc(ctx, fmt))
 			pix_mp->plane_fmt[0].sizeimage +=
 				64 * MB_WIDTH(pix_mp->width) *
 				     MB_WIDTH(pix_mp->height) + 32;
-- 
2.20.1

