Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FA3540643
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244116AbiFGRd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347601AbiFGRaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6223B100524;
        Tue,  7 Jun 2022 10:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98B95CE1D50;
        Tue,  7 Jun 2022 17:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFA9C385A5;
        Tue,  7 Jun 2022 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622858;
        bh=G8qUnbTp31LiWUYOdhxaEF0Eo0c93bjPktO+ImQYsLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRdUzpvi3Yu1+pWrbWBicTIZ0V8iMHhSgqWB4LcNd1WiKp7C/P87IBN/VCtHK7mG3
         KRGtjEKA+MYjBjahMm6KnhZw/XCE+65AzaduIoVcDOD3oUtdR5d2R65gjUxBXSLFVX
         6fyrL2sXsYPlTtH/v31xVMVJNSCa7Hq5TzbuGxqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/452] media: aspeed: Fix an error handling path in aspeed_video_probe()
Date:   Tue,  7 Jun 2022 19:01:06 +0200
Message-Id: <20220607164914.790856395@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 757a58829a51..9d9124308f6a 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -1723,6 +1723,7 @@ static int aspeed_video_probe(struct platform_device *pdev)
 
 	rc = aspeed_video_setup_video(video);
 	if (rc) {
+		aspeed_video_free_buf(video, &video->jpeg);
 		clk_unprepare(video->vclk);
 		clk_unprepare(video->eclk);
 		return rc;
@@ -1748,8 +1749,7 @@ static int aspeed_video_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(v4l2_dev);
 
-	dma_free_coherent(video->dev, VE_JPEG_HEADER_SIZE, video->jpeg.virt,
-			  video->jpeg.dma);
+	aspeed_video_free_buf(video, &video->jpeg);
 
 	of_reserved_mem_device_release(dev);
 
-- 
2.35.1



