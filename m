Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6495A29C2DA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821114AbgJ0Rkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2902332AbgJ0Ocq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7405620719;
        Tue, 27 Oct 2020 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809166;
        bh=VwfiyVImG4KNBSklL8nDqKwntMq1xxLWJNG+hRC/SFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEKpTfRaRUCKbMoGnudTehWoUf793i0+ZapOh/m1XcH0b9OB2KAWsnFZNlc/gIg3a
         sj2dKuNaEJdAxLj134LCzIJeogzVRBUj3n5AxlXjv6dqOeFHCFbfrWTPrg/XbyW6B3
         qKg6sihRZVXJ2+dIq5Tus0omEAsxWu6jKpM9P7UU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/408] media: rcar_drif: Fix fwnode reference leak when parsing DT
Date:   Tue, 27 Oct 2020 14:50:20 +0100
Message-Id: <20201027135458.871522436@linuxfoundation.org>
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
index 0f267a237b424..208ff260b0c10 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1223,28 +1223,22 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
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



