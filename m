Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BA55011DE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245234AbiDNNsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343915AbiDNNja (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A450892844;
        Thu, 14 Apr 2022 06:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 23056CE29B1;
        Thu, 14 Apr 2022 13:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0F7C385A5;
        Thu, 14 Apr 2022 13:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943320;
        bh=M43zBSh0J1qFOy7MbpredyPB4xIiw+Rzryk0cRsz4ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV9vft4YH07IRanM7Y0r6XFYqenqf1wcHjQ3/KxQ/qGN54slnxXTYUd7cAJyQqMXS
         XKoQXg9S1IiX+L+8BKEq4JiBz5H7NBtiOjRc0KfP4l6tEwYf7ydNaxUAZqs4bB+b9I
         Opyr6AF96bVJoyw7CZsO5EWe8r9rj0JBSybB/S2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/475] media: bttv: fix WARNING regression on tunerless devices
Date:   Thu, 14 Apr 2022 15:08:18 +0200
Message-Id: <20220414110858.315509848@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Zary <linux@zary.sk>

[ Upstream commit ef058cc8b7193d15a771272359c7454839ae74ee ]

Commit 2161536516ed ("media: media/pci: set device_caps in struct video_device")
introduced a regression: V4L2_CAP_TUNER is always present in device_caps,
even when the device has no tuner.

This causes a warning:
WARNING: CPU: 0 PID: 249 at drivers/media/v4l2-core/v4l2-ioctl.c:1102 v4l_querycap+0xa0/0xb0 [videodev]

Fixes: 2161536516ed ("media: media/pci: set device_caps in struct video_device")
Signed-off-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 570530d976d2..6441e7d63d97 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3898,7 +3898,7 @@ static int bttv_register_video(struct bttv *btv)
 
 	/* video */
 	vdev_init(btv, &btv->video_dev, &bttv_video_template, "video");
-	btv->video_dev.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
+	btv->video_dev.device_caps = V4L2_CAP_VIDEO_CAPTURE |
 				     V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	if (btv->tuner_type != TUNER_ABSENT)
 		btv->video_dev.device_caps |= V4L2_CAP_TUNER;
@@ -3919,7 +3919,7 @@ static int bttv_register_video(struct bttv *btv)
 	/* vbi */
 	vdev_init(btv, &btv->vbi_dev, &bttv_video_template, "vbi");
 	btv->vbi_dev.device_caps = V4L2_CAP_VBI_CAPTURE | V4L2_CAP_READWRITE |
-				   V4L2_CAP_STREAMING | V4L2_CAP_TUNER;
+				   V4L2_CAP_STREAMING;
 	if (btv->tuner_type != TUNER_ABSENT)
 		btv->vbi_dev.device_caps |= V4L2_CAP_TUNER;
 
-- 
2.34.1



