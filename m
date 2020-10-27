Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADE329C2C6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902454AbgJ0Odb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760116AbgJ0Od3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:33:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05D7020709;
        Tue, 27 Oct 2020 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809208;
        bh=UW694r2BT7GJBFMAXNwWYlh4G2VDwzaQsxzntQ1VTUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMqLZ6ZvnALiOEzl14hxl/ngFKHYyGpP7B313/Vn5zJn3QEoy4fcIqxoN9bVbRhHv
         NmkBVXcgN4SPSbL2F2spg0XTGiCWT1HdOLIVAcBcJl5GPWwgBEEbTrObAnmXqQ2uAu
         G7gs/0oYGTHbS+ydY1x/ILs01vaKYYm9MaXU0Z1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/408] media: rcar-csi2: Allocate v4l2_async_subdev dynamically
Date:   Tue, 27 Oct 2020 14:50:22 +0100
Message-Id: <20201027135458.964377685@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 2cac7cbfb4099980e78244359ab9c6f056d6a7ec ]

v4l2_async_notifier_add_subdev() requires the asd to be allocated
dynamically, but the rcar-csi2 driver embeds it in the rcar_csi2
structure. This causes memory corruption when the notifier is destroyed
at remove time with v4l2_async_notifier_cleanup().

Fix this issue by registering the asd with
v4l2_async_notifier_add_fwnode_subdev(), which allocates it dynamically
internally.

Fixes: 769afd212b16 ("media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 24 +++++++++------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index c14af1b929dff..d27eccfa57cae 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -361,7 +361,6 @@ struct rcar_csi2 {
 	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
 
 	struct v4l2_async_notifier notifier;
-	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *remote;
 
 	struct v4l2_mbus_framefmt mf;
@@ -810,6 +809,8 @@ static int rcsi2_parse_v4l2(struct rcar_csi2 *priv,
 
 static int rcsi2_parse_dt(struct rcar_csi2 *priv)
 {
+	struct v4l2_async_subdev *asd;
+	struct fwnode_handle *fwnode;
 	struct device_node *ep;
 	struct v4l2_fwnode_endpoint v4l2_ep = { .bus_type = 0 };
 	int ret;
@@ -833,24 +834,19 @@ static int rcsi2_parse_dt(struct rcar_csi2 *priv)
 		return ret;
 	}
 
-	priv->asd.match.fwnode =
-		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
-	priv->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-
+	fwnode = fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
 	of_node_put(ep);
 
-	v4l2_async_notifier_init(&priv->notifier);
-
-	ret = v4l2_async_notifier_add_subdev(&priv->notifier, &priv->asd);
-	if (ret) {
-		fwnode_handle_put(priv->asd.match.fwnode);
-		return ret;
-	}
+	dev_dbg(priv->dev, "Found '%pOF'\n", to_of_node(fwnode));
 
+	v4l2_async_notifier_init(&priv->notifier);
 	priv->notifier.ops = &rcar_csi2_notify_ops;
 
-	dev_dbg(priv->dev, "Found '%pOF'\n",
-		to_of_node(priv->asd.match.fwnode));
+	asd = v4l2_async_notifier_add_fwnode_subdev(&priv->notifier, fwnode,
+						    sizeof(*asd));
+	fwnode_handle_put(fwnode);
+	if (IS_ERR(asd))
+		return PTR_ERR(asd);
 
 	ret = v4l2_async_subdev_notifier_register(&priv->subdev,
 						  &priv->notifier);
-- 
2.25.1



