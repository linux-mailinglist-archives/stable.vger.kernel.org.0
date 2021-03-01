Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175A23289DD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbhCASHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238446AbhCASBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 795A965319;
        Mon,  1 Mar 2021 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620600;
        bh=aCzIOW8nxMmO1Kpwz8TKbV75oBREFmR3a8tv0qBT4qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmeIUwJyBWkgTvOgl0MlGFjQcEllfm7443XW+PnK26uIJvOktSsoKzF6AuzU/uan4
         JZtx8rnkOq171iEe19Xj+O6ejvNity68NCZG/sBJyJbK9DlaZnqMkTny0E0HFBDnZN
         APgLrAyHx18COOXAEU55s69Kx7M4YkJEfoLqu2oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 212/775] media: imx7: csi: Fix regression for parallel cameras on i.MX6UL
Date:   Mon,  1 Mar 2021 17:06:20 +0100
Message-Id: <20210301161212.111978371@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 9bac67214fbf4b5f23463f7742ccf69bfe684cbd ]

Commit 86e02d07871c ("media: imx5/6/7: csi: Mark a bound video mux as
a CSI mux") made an incorrect assumption that for imx7-media-csi,
the bound subdev must always be a CSI mux. On i.MX6UL/i.MX6ULL there
is no CSI mux at all, so do not return an error when the entity is not a
video mux and assign the IMX_MEDIA_GRP_ID_CSI_MUX group id only when
appropriate.

This is the same approach as done in imx-media-csi.c and it fixes the
csi probe regression on i.MX6UL.

Tested on a imx6ull-evk board.

Fixes: 86e02d07871c ("media: imx5/6/7: csi: Mark a bound video mux as a CSI mux")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx7-media-csi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index a3f3df9017046..31e36168f9d0f 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1164,12 +1164,12 @@ static int imx7_csi_notify_bound(struct v4l2_async_notifier *notifier,
 	struct imx7_csi *csi = imx7_csi_notifier_to_dev(notifier);
 	struct media_pad *sink = &csi->sd.entity.pads[IMX7_CSI_PAD_SINK];
 
-	/* The bound subdev must always be the CSI mux */
-	if (WARN_ON(sd->entity.function != MEDIA_ENT_F_VID_MUX))
-		return -ENXIO;
-
-	/* Mark it as such via its group id */
-	sd->grp_id = IMX_MEDIA_GRP_ID_CSI_MUX;
+	/*
+	 * If the subdev is a video mux, it must be one of the CSI
+	 * muxes. Mark it as such via its group id.
+	 */
+	if (sd->entity.function == MEDIA_ENT_F_VID_MUX)
+		sd->grp_id = IMX_MEDIA_GRP_ID_CSI_MUX;
 
 	return v4l2_create_fwnode_links_to_pad(sd, sink);
 }
-- 
2.27.0



