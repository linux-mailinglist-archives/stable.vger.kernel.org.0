Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5404F3B46
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347098AbiDELwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356894AbiDEKZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECEBC0541;
        Tue,  5 Apr 2022 03:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F166B81C89;
        Tue,  5 Apr 2022 10:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE88BC385A1;
        Tue,  5 Apr 2022 10:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153350;
        bh=efqWGlCVZtXzfOVYGtknb4pkNNmHRyeHvGSgYtkY4Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcEIQZ2T50+LifXlX4000K2q1tEYz8t+kOFfewxmysUtQ/9BIV9aZHOSyBeE7TZdX
         SziI02Ecno9NtQ5N69HyxXW0suE+ps9YOvw+PdvhKq78sCLUHeKwXGIHAn9gPz4eEe
         lFRpiGNu4ldbiiaicrvi7UXSBmBKMrx3tv9awAHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/599] media: bttv: fix WARNING regression on tunerless devices
Date:   Tue,  5 Apr 2022 09:28:04 +0200
Message-Id: <20220405070304.495025654@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 35a51e9b539d..1f0e4b913a05 100644
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



