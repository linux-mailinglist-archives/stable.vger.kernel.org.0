Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7349A2B7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365948AbiAXXwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843478AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CDCC061A7C;
        Mon, 24 Jan 2022 13:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EB7CB811FB;
        Mon, 24 Jan 2022 21:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FC5C340E5;
        Mon, 24 Jan 2022 21:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058893;
        bh=14/r+hbS3Go8S3OHeRGpUygNx3H7+e9c8m+YWqIr+MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpxPhhaj+AbaTHGnTkM0/ARnXPAZMGZr3kMiKpGSBAdLJtNM+khj0gS8fS3U9AIei
         uS5QP+BOU1JkXajajtC+DvXMu2Tqf5dTyzR4DL6qTszOuJ4R313pi4XEg37wgCNLJc
         1Vj5xN77RURn6gkGaQNPcbKOAjqSRXmKxuGR2RS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0435/1039] can: rcar_canfd: rcar_canfd_channel_probe(): make sure we free CAN network device
Date:   Mon, 24 Jan 2022 19:37:04 +0100
Message-Id: <20220124184139.921784434@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 72b1e360572f9fa7d08ee554f1da29abce23f288 ]

Make sure we free CAN network device in the error path. There are
several jumps to fail label after allocating the CAN network device
successfully. This patch places the free_candev() under fail label so
that in failure path a jump to fail label frees the CAN network
device.

Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
Link: https://lore.kernel.org/all/20220106114801.20563-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_canfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ff9d0f5ae0dd2..388521e70837f 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1640,8 +1640,7 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	ndev = alloc_candev(sizeof(*priv), RCANFD_FIFO_DEPTH);
 	if (!ndev) {
 		dev_err(&pdev->dev, "alloc_candev() failed\n");
-		err = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 	priv = netdev_priv(ndev);
 
@@ -1735,8 +1734,8 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 
 fail_candev:
 	netif_napi_del(&priv->napi);
-	free_candev(ndev);
 fail:
+	free_candev(ndev);
 	return err;
 }
 
-- 
2.34.1



