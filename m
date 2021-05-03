Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FDF3719F0
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhECQiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhECQhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7554F613C1;
        Mon,  3 May 2021 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059762;
        bh=308qQXQhSWXSTdVFU1aE1Ow89JdTwneYMum15svZK/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpRk9mwcWb2c+Ki490vzxo6Gr/4aKSXd2BXmBIysro3Q5Xcty0z4ZItaSpMjXm8r0
         x6O5IVngG7uPmQUczpy7Q1oaRJcnuNLvHchjRSVR/xENtyU2SOtEsWqcne2EvHBlpN
         9WsPblmyBolH8lX8wO0cihdaFOXRb/urdNxM3XPpJ+9RN93MZ2JUbewejgjdFd5VYy
         lKTDnynruipe1X5KVXVXpYWcs/K4FiDiWJFXm0MLVHN5ZlGhLqjOxD9HI7rVROheKp
         01DZhXHaIwLbWnoJmOtDYzFYfjCWsYiv1xeK6cTobcyEujG05xEX0dlXZ3FekLJLbO
         D8RnBKgrNCC1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 031/134] media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()
Date:   Mon,  3 May 2021 12:33:30 -0400
Message-Id: <20210503163513.2851510-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit cc271b6754691af74d710b761eaf027e3743e243 ]

The correct return code to report an invalid pipeline configuration is
-EPIPE. Return it instead of -EINVAL from __capture_legacy_try_fmt()
when the capture format doesn't match the media bus format of the
connected subdev.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index e10ce103a5b4..94a0467d673b 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -557,7 +557,7 @@ static int capture_validate_fmt(struct capture_priv *priv)
 		priv->vdev.fmt.fmt.pix.height != f.fmt.pix.height ||
 		priv->vdev.cc->cs != cc->cs ||
 		priv->vdev.compose.width != compose.width ||
-		priv->vdev.compose.height != compose.height) ? -EINVAL : 0;
+		priv->vdev.compose.height != compose.height) ? -EPIPE : 0;
 }
 
 static int capture_start_streaming(struct vb2_queue *vq, unsigned int count)
-- 
2.30.2

