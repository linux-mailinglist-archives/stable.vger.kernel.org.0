Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC105488F9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352705AbiFMLRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353445AbiFMLPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:15:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B3A37BFA;
        Mon, 13 Jun 2022 03:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF92B80E94;
        Mon, 13 Jun 2022 10:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6FDC34114;
        Mon, 13 Jun 2022 10:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116683;
        bh=+9IgQ/HHoYPDWZs3cMzOuO1R5OJJnADp6vjFwEWk9A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfgG1nIAUKGdzfZ3auxyBYvMUAPY1SiHiSbue5q/3lYXoW1Pi346zTPzbbIVI48KB
         V/++UfGH8iAEEmZ/ftRmBFYp/g87y6/uRfnGKS1pXxo55SLog6FhCzc5ee9SpuZUWC
         7gcu9LsiFjfBGnZ1OAN0MdAnhyEEFU5Yg8Fq8tS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/411] media: aspeed: Fix an error handling path in aspeed_video_probe()
Date:   Mon, 13 Jun 2022 12:06:48 +0200
Message-Id: <20220613094932.719606920@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index c87eddb1c93f..c3f0b143330a 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1688,6 +1688,7 @@ static int aspeed_video_probe(struct platform_device *pdev)
 
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
+		aspeed_video_free_buf(video, &video->jpeg);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;
@@ -1715,8 +1716,7 @@ static int aspeed_video_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(v4l2_dev);
 
-	dma_free_coherent(video->dev, VE_JPEG_HEADER_SIZE, video->jpeg.virt,
-			  video->jpeg.dma);
+	aspeed_video_free_buf(video, &video->jpeg);
 
 	of_reserved_mem_device_release(dev);
 
-- 
2.35.1



