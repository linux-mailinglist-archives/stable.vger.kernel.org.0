Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E9B53CF12
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345387AbiFCRw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345602AbiFCRuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:50:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A925258391;
        Fri,  3 Jun 2022 10:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59D62B8243A;
        Fri,  3 Jun 2022 17:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE27C385A9;
        Fri,  3 Jun 2022 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278362;
        bh=JK1DF1VgNAq4TDyPSFj/H5fnS9OR7dFiNc1Idiqfw2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg9HsXlk9LQRb6sViR/Bf/atwLDeo9W9UUYU+FWAlkpVwmyC9JjNlt4GyiP8cU8E6
         WcN+QuV3QzESLyfZkmtWLnLE8r9/E442Epcs2wsddEjkeVbFA6EIcvMuF2Hlo1xau1
         xg+CmQTWU1Ki0ik7qEGDlXdnl3f+T7U8Uz/5PFWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.4 08/34] media: vim2m: initialize the media device earlier
Date:   Fri,  3 Jun 2022 19:43:04 +0200
Message-Id: <20220603173816.239438872@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 1a28dce222a6ece725689ad58c0cf4a1b48894f4 upstream.

Before the video device node is registered, the v4l2_dev.mdev
pointer must be set in order to correctly associate the video
device with the media device. Move the initialization of the
media device up.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/vim2m.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1347,12 +1347,6 @@ static int vim2m_probe(struct platform_d
 		goto error_dev;
 	}
 
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto error_m2m;
-	}
-
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
 	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
@@ -1361,7 +1355,15 @@ static int vim2m_probe(struct platform_d
 	media_device_init(&dev->mdev);
 	dev->mdev.ops = &m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
+#endif
 
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto error_m2m;
+	}
+
+#ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {


