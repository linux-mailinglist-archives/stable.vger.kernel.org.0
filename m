Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD2A4F273D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiDEIFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiDEH6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74061A94CE;
        Tue,  5 Apr 2022 00:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2565D615CD;
        Tue,  5 Apr 2022 07:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B7CC340EE;
        Tue,  5 Apr 2022 07:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145184;
        bh=7wnlgHT1RIJpVnS9Yrdz9dgDs8GDXeJxl614hLxTywo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IbrtZyCEf/Rl8CClKldWQhb6LiJi58B4H4aCrba3XtkaNuuxOAkk7Cugt+rN1fhL
         c0xqKWIeDWf6Hmp5lfUZdIYDq3evfhg5wzBZB8amIzKS5mMfHeWrKjYF1UJ1/FH2sk
         ZA2J+OB2K9lk1H43rzR72UHmdH8nTMJxR7uQnEKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jammy Huang <jammy_huang@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0316/1126] media: aspeed: Correct value for h-total-pixels
Date:   Tue,  5 Apr 2022 09:17:43 +0200
Message-Id: <20220405070416.891900669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Jammy Huang <jammy_huang@aspeedtech.com>

[ Upstream commit 4b732a0016853eaff35944f900b0db66f3914374 ]

Previous reg-field, 0x98[11:0], stands for the period of the detected
hsync signal.
Use the correct reg, 0xa0, to get h-total in pixels.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Signed-off-by: Jammy Huang <jammy_huang@aspeedtech.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index 7a24daf7165a..bdeecde0d997 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -153,7 +153,7 @@
 #define  VE_SRC_TB_EDGE_DET_BOT		GENMASK(28, VE_SRC_TB_EDGE_DET_BOT_SHF)
 
 #define VE_MODE_DETECT_STATUS		0x098
-#define  VE_MODE_DETECT_H_PIXELS	GENMASK(11, 0)
+#define  VE_MODE_DETECT_H_PERIOD	GENMASK(11, 0)
 #define  VE_MODE_DETECT_V_LINES_SHF	16
 #define  VE_MODE_DETECT_V_LINES		GENMASK(27, VE_MODE_DETECT_V_LINES_SHF)
 #define  VE_MODE_DETECT_STATUS_VSYNC	BIT(28)
@@ -164,6 +164,8 @@
 #define  VE_SYNC_STATUS_VSYNC_SHF	16
 #define  VE_SYNC_STATUS_VSYNC		GENMASK(27, VE_SYNC_STATUS_VSYNC_SHF)
 
+#define VE_H_TOTAL_PIXELS		0x0A0
+
 #define VE_INTERRUPT_CTRL		0x304
 #define VE_INTERRUPT_STATUS		0x308
 #define  VE_INTERRUPT_MODE_DETECT_WD	BIT(0)
@@ -802,6 +804,7 @@ static void aspeed_video_get_resolution(struct aspeed_video *video)
 	u32 src_lr_edge;
 	u32 src_tb_edge;
 	u32 sync;
+	u32 htotal;
 	struct v4l2_bt_timings *det = &video->detected_timings;
 
 	det->width = MIN_WIDTH;
@@ -847,6 +850,7 @@ static void aspeed_video_get_resolution(struct aspeed_video *video)
 		src_tb_edge = aspeed_video_read(video, VE_SRC_TB_EDGE_DET);
 		mds = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
 		sync = aspeed_video_read(video, VE_SYNC_STATUS);
+		htotal = aspeed_video_read(video, VE_H_TOTAL_PIXELS);
 
 		video->frame_bottom = (src_tb_edge & VE_SRC_TB_EDGE_DET_BOT) >>
 			VE_SRC_TB_EDGE_DET_BOT_SHF;
@@ -863,8 +867,7 @@ static void aspeed_video_get_resolution(struct aspeed_video *video)
 			VE_SRC_LR_EDGE_DET_RT_SHF;
 		video->frame_left = src_lr_edge & VE_SRC_LR_EDGE_DET_LEFT;
 		det->hfrontporch = video->frame_left;
-		det->hbackporch = (mds & VE_MODE_DETECT_H_PIXELS) -
-			video->frame_right;
+		det->hbackporch = htotal - video->frame_right;
 		det->hsync = sync & VE_SYNC_STATUS_HSYNC;
 		if (video->frame_left > video->frame_right)
 			continue;
-- 
2.34.1



