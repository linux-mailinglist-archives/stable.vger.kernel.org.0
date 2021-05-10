Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019193783EB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhEJKsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhEJKpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05D3B619A2;
        Mon, 10 May 2021 10:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642980;
        bh=8xW11yx65LCj4/dPIjgckIblW+bhn6N20VnQPTGV54c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zycDBI4cU813dgw76neFRpY73UQreMSl1P7J3C+LAfF0HaJb2Fz5IoZ6pNg0/ITub
         5u7y1Aj/xmxPqxSAbvI+5aB1THs69lUBAVsny/3eIOKrNCOQ7Ms5pU6o1lR80KMjC2
         ne5L9Dm/DpwkTWMFVfGwQBPSLGgDhgp/xyizkL0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/299] media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()
Date:   Mon, 10 May 2021 12:18:48 +0200
Message-Id: <20210510102009.299999808@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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



