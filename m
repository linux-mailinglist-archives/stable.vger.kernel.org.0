Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6E73C532C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347807AbhGLHx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241718AbhGLHrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CCAC61427;
        Mon, 12 Jul 2021 07:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075757;
        bh=XoYj5fhINhNpIdEDgjtheWTTZEuJBpJiCzs98xY8jtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U59YQfSPGNdBTFlH9zOXhCgoyNHfLuCaji7lj2eIXWQl4RIJI3mW9F5aBKZ2TM2hB
         wrYEmjxWK8x6mQOWWkuyT6b7TX0BYv+ym6llGXrMo7lkFl01t1DT4uBtXsOeW2uMmC
         g7AMFcM6z5rcHIfLzBDqtkMR9k+D4YC9NDrD4xzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 352/800] media: video-mux: Skip dangling endpoints
Date:   Mon, 12 Jul 2021 08:06:15 +0200
Message-Id: <20210712061004.532551945@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 95778c2d0979618e3349b1d2324ec282a5a6adbf ]

i.MX6 device tree include files contain dangling endpoints for the
board device tree writers' convenience. These are still included in
many existing device trees.
Treat dangling endpoints as non-existent to support them.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 612b385efb1e ("media: video-mux: Create media links in bound notifier")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/video-mux.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index 133122e38515..9bc0b4d8de09 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -362,7 +362,7 @@ static int video_mux_async_register(struct video_mux *vmux,
 
 	for (i = 0; i < num_input_pads; i++) {
 		struct v4l2_async_subdev *asd;
-		struct fwnode_handle *ep;
+		struct fwnode_handle *ep, *remote_ep;
 
 		ep = fwnode_graph_get_endpoint_by_id(
 			dev_fwnode(vmux->subdev.dev), i, 0,
@@ -370,6 +370,14 @@ static int video_mux_async_register(struct video_mux *vmux,
 		if (!ep)
 			continue;
 
+		/* Skip dangling endpoints for backwards compatibility */
+		remote_ep = fwnode_graph_get_remote_endpoint(ep);
+		if (!remote_ep) {
+			fwnode_handle_put(ep);
+			continue;
+		}
+		fwnode_handle_put(remote_ep);
+
 		asd = v4l2_async_notifier_add_fwnode_remote_subdev(
 			&vmux->notifier, ep, struct v4l2_async_subdev);
 
-- 
2.30.2



