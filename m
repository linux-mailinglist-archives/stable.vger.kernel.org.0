Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925393C4939
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237094AbhGLGnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238626AbhGLGlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C636113A;
        Mon, 12 Jul 2021 06:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071911;
        bh=zSotkfngwV/n6iBL2G1niE6abch1cGZL+Sg9+kATzwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmhcMzJmGql3ustnNR/Kgs+cqnBw72MlOogLyNi/iL1pVBAUPBbGOFd38XPMOot8T
         84e5zbzduJVF8c0+7HQKL1+Z4ciHErxRMQsSBMdtV4Yqjc/xLrzuGrJDMblgg37Y4I
         MexpZ2Xa0QlEU9IXkGm7L9pz/GZ5JOOxldHS6qBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/593] media: video-mux: Skip dangling endpoints
Date:   Mon, 12 Jul 2021 08:07:13 +0200
Message-Id: <20210712060913.807733304@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 7b280dfca727..640ce76fe0d9 100644
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
 			&vmux->notifier, ep, sizeof(*asd));
 
-- 
2.30.2



