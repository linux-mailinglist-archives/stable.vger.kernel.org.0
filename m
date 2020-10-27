Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BFC29C1A8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782527AbgJ0R0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775700AbgJ0OxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:53:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBCF822202;
        Tue, 27 Oct 2020 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810387;
        bh=bKe3MNMrhUKZGjJmilsT28wL8uxdUhmboq/eRPyBLps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQ5Mo/iWLZgJm9tS0tX3YKvByQgcnAnrzWryhyNPTVLxQyFML4LY/rIulegSpU1B+
         WI5dr7gNo5k5LSoF8o4gA0nkpCMpuQXNGSrJR/jmXtx8xmAikvr3yizSCNvJaJYa0P
         xkMDFOEa9iEHBJ2yVKu5Dr+wmod5u4K1I0aonr0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 122/633] media: rcar_drif: Fix fwnode reference leak when parsing DT
Date:   Tue, 27 Oct 2020 14:47:45 +0100
Message-Id: <20201027135528.429841113@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit cdd4f7824994c9254acc6e415750529ea2d2cfe0 ]

The fwnode reference corresponding to the endpoint is leaked in an error
path of the rcar_drif_parse_subdevs() function. Fix it, and reorganize
fwnode reference handling in the function to release references early,
simplifying error paths.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_drif.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 3d2451ac347d7..3f1e5cb8b1976 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1227,28 +1227,22 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 	if (!ep)
 		return 0;
 
+	/* Get the endpoint properties */
+	rcar_drif_get_ep_properties(sdr, ep);
+
 	fwnode = fwnode_graph_get_remote_port_parent(ep);
+	fwnode_handle_put(ep);
 	if (!fwnode) {
 		dev_warn(sdr->dev, "bad remote port parent\n");
-		fwnode_handle_put(ep);
 		return -EINVAL;
 	}
 
 	sdr->ep.asd.match.fwnode = fwnode;
 	sdr->ep.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	ret = v4l2_async_notifier_add_subdev(notifier, &sdr->ep.asd);
-	if (ret) {
-		fwnode_handle_put(fwnode);
-		return ret;
-	}
-
-	/* Get the endpoint properties */
-	rcar_drif_get_ep_properties(sdr, ep);
-
 	fwnode_handle_put(fwnode);
-	fwnode_handle_put(ep);
 
-	return 0;
+	return ret;
 }
 
 /* Check if the given device is the primary bond */
-- 
2.25.1



