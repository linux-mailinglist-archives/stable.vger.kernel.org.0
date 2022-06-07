Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0841541413
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358495AbiFGUMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359184AbiFGUJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7DD1406F5;
        Tue,  7 Jun 2022 11:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 897CCB822C0;
        Tue,  7 Jun 2022 18:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037A2C385A2;
        Tue,  7 Jun 2022 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626404;
        bh=UHVSLT3vDh+ryRqs/NRn7rTntlqY6buyEhGndmflQXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FH00EepwySZeGNzy/BzOsk3sXEO9sP+HOM7Tlww2r6a/qu4Cnc5Jb/FOlGyfdOQJz
         L2GnTe8JlMGbDElVEnvFeCkcgQ/v3oxSD9G4OfUN8WCqsqFQCuHgKj/luCvGD//I8X
         a5IVzxPVD1TbZ4Q+9S7utj7OhRx956Q9T6rFgYyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 366/772] media: aspeed: Fix an error handling path in aspeed_video_probe()
Date:   Tue,  7 Jun 2022 18:59:18 +0200
Message-Id: <20220607164959.799761041@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 310fda622bbd38be17fb444f7f049b137af3bc0d ]

A dma_free_coherent() call is missing in the error handling path of the
probe, as already done in the remove function.

In fact, this call is included in aspeed_video_free_buf(). So use the
latter both in the error handling path of the probe and in the remove
function.
It is easier to see the relation with aspeed_video_alloc_buf() this way.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index bdeecde0d997..1e3c5c7d6dd7 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1828,6 +1828,7 @@ static int aspeed_video_probe(struct platform_device *pdev)
 
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
+		aspeed_video_free_buf(video, &video->jpeg);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;
@@ -1859,8 +1860,7 @@ static int aspeed_video_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(v4l2_dev);
 
-	dma_free_coherent(video->dev, VE_JPEG_HEADER_SIZE, video->jpeg.virt,
-			  video->jpeg.dma);
+	aspeed_video_free_buf(video, &video->jpeg);
 
 	of_reserved_mem_device_release(dev);
 
-- 
2.35.1



