Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9A371B83
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbhECQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhECQoi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:44:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B02C61584;
        Mon,  3 May 2021 16:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059938;
        bh=8xW11yx65LCj4/dPIjgckIblW+bhn6N20VnQPTGV54c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ravBJuHSXy7KnmBEB63FOrMqylBKOGbWMDBf1A+VZBDuV3NGGeZ3WhcIz/dVaChyQ
         grCBASjxD72YxdCixG/BDl2y+5h0IXV3kkvwrA25GLC8NQXVdh3Ki30WUuont8FeyV
         u2ChyhiqnFWyNS2irPg9YP57Lxdy3+bw9g0mTBo1fmMW5Z8ZQf4pjUX9UeizORg9Jl
         gad4vVHAhZ+GbBxM6L7mE8wpyMXs30ZqHO2/fzjFAJy46gdvElxfozdgHiNwG6jAho
         hP3z5PNuGew7EOsrpCAipovCRR13vMWUCatt3eZcTagIP+0Tax1pzoHQYrYVSJimbI
         Z2UnQgp6NS7Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 019/100] media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()
Date:   Mon,  3 May 2021 12:37:08 -0400
Message-Id: <20210503163829.2852775-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
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
index c1931eb2540e..b2f2cb3d6a60 100644
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

