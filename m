Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD884378816
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbhEJLUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232753AbhEJLIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7DBB61A19;
        Mon, 10 May 2021 11:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644658;
        bh=308qQXQhSWXSTdVFU1aE1Ow89JdTwneYMum15svZK/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4V1yFaB4cvYsyDRJx6w2FRl/rMP1JMTNcYdx5Q7+5H4dkPEworIM9R/FhgVNiocY
         X9V6XVZLVWPvjIIvmPf75VaK9nSA5PRrOV0g+PcltT3cWC+0Y6trm49NtNoOEX+CjT
         hwsSkjWwuqOSFi9DvMuZ37c3D7MGAc+XepxUysxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 171/384] media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()
Date:   Mon, 10 May 2021 12:19:20 +0200
Message-Id: <20210510102020.514783336@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



