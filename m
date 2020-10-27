Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439C129B6BA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797587AbgJ0PY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:24:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797583AbgJ0PY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA57422202;
        Tue, 27 Oct 2020 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812265;
        bh=8dY6wm1gJfitlu3ZFizi9O43Lh8fT2w4dmwJbNcIrUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQDjg1jwd5HF+72OFB8d/B9/JPCxKVp5Sk9gqewlPHyx1kwaq23D7OjDX51JEvwja
         rd3thuunhqsUO5QZJzcWrNF8dydCAoFD/uiG4AWWiKqvIF6dR++dh4QTvPbJUeNZ5q
         6kXBWtjE9uuFueTa6FutVlacjGsFlwpqq6mEhs7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 141/757] media: rcar_drif: Allocate v4l2_async_subdev dynamically
Date:   Tue, 27 Oct 2020 14:46:31 +0100
Message-Id: <20201027135457.214682304@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 468e986dac0e94194334ca6d0abf3af8c250792e ]

v4l2_async_notifier_add_subdev() requires the asd to be allocated
dynamically, but the rcar-drif driver embeds it in the
rcar_drif_graph_ep structure. This causes memory corruption when the
notifier is destroyed at remove time with v4l2_async_notifier_cleanup().

Fix this issue by registering the asd with
v4l2_async_notifier_add_fwnode_subdev(), which allocates it dynamically
internally.

Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_drif.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 3f1e5cb8b1976..f318cd4b8086f 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -185,7 +185,6 @@ struct rcar_drif_frame_buf {
 /* OF graph endpoint's V4L2 async data */
 struct rcar_drif_graph_ep {
 	struct v4l2_subdev *subdev;	/* Async matched subdev */
-	struct v4l2_async_subdev asd;	/* Async sub-device descriptor */
 };
 
 /* DMA buffer */
@@ -1109,12 +1108,6 @@ static int rcar_drif_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rcar_drif_sdr *sdr =
 		container_of(notifier, struct rcar_drif_sdr, notifier);
 
-	if (sdr->ep.asd.match.fwnode !=
-	    of_fwnode_handle(subdev->dev->of_node)) {
-		rdrif_err(sdr, "subdev %s cannot bind\n", subdev->name);
-		return -EINVAL;
-	}
-
 	v4l2_set_subdev_hostdata(subdev, sdr);
 	sdr->ep.subdev = subdev;
 	rdrif_dbg(sdr, "bound asd %s\n", subdev->name);
@@ -1218,7 +1211,7 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 {
 	struct v4l2_async_notifier *notifier = &sdr->notifier;
 	struct fwnode_handle *fwnode, *ep;
-	int ret;
+	struct v4l2_async_subdev *asd;
 
 	v4l2_async_notifier_init(notifier);
 
@@ -1237,12 +1230,13 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 		return -EINVAL;
 	}
 
-	sdr->ep.asd.match.fwnode = fwnode;
-	sdr->ep.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-	ret = v4l2_async_notifier_add_subdev(notifier, &sdr->ep.asd);
+	asd = v4l2_async_notifier_add_fwnode_subdev(notifier, fwnode,
+						    sizeof(*asd));
 	fwnode_handle_put(fwnode);
+	if (IS_ERR(asd))
+		return PTR_ERR(asd);
 
-	return ret;
+	return 0;
 }
 
 /* Check if the given device is the primary bond */
-- 
2.25.1



