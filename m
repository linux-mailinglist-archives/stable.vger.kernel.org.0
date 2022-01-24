Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D287499034
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352149AbiAXT7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356682AbiAXTxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1824C0613A6;
        Mon, 24 Jan 2022 11:26:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D6CCB81240;
        Mon, 24 Jan 2022 19:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E1DC339CC;
        Mon, 24 Jan 2022 19:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052398;
        bh=lUHBLmJPWPHY9xfX0f7oW/LhUvOKBWyNMSXZN69tKvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1esuzkOf5o2e8ciRTwNfR4YdyyQ6fV3vkARvZxCqG0npTBw/jUuMLUnCF9fLYfuI
         Gx8XXGsjtdYWpRMeZuFdOhkF4W/dspi4seoyCxlkw9Mj9B1CDF4bX8orH4BizaPRLw
         YadGTTkNl23zjDvDyqbolR2bLgKRK0NsNcwHoYN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jammy Huang <jammy_huang@aspeedtech.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/320] media: aspeed: Update signal status immediately to ensure sane hw state
Date:   Mon, 24 Jan 2022 19:40:29 +0100
Message-Id: <20220124183955.277750504@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jammy Huang <jammy_huang@aspeedtech.com>

[ Upstream commit af6d1bde395cac174ee71adcd3fa43f6435c7206 ]

If res-chg, VE_INTERRUPT_MODE_DETECT_WD irq will be raised. But
v4l2_input_status won't be updated to no-signal immediately until
aspeed_video_get_resolution() in aspeed_video_resolution_work().

During the period of time, aspeed_video_start_frame() could be called
because it doesn't know signal becomes unstable now. If it goes with
aspeed_video_init_regs() of aspeed_video_irq_res_change()
simultaneously, it will mess up hw state.

To fix this problem, v4l2_input_status is updated to no-signal
immediately for VE_INTERRUPT_MODE_DETECT_WD irq.

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Signed-off-by: Jammy Huang <jammy_huang@aspeedtech.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index be1238f22b8ae..1e0867016bf37 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -533,6 +533,8 @@ static void aspeed_video_irq_res_change(struct aspeed_video *video, ulong delay)
 	set_bit(VIDEO_RES_CHANGE, &video->flags);
 	clear_bit(VIDEO_FRAME_INPRG, &video->flags);
 
+	video->v4l2_input_status = V4L2_IN_ST_NO_SIGNAL;
+
 	aspeed_video_off(video);
 	aspeed_video_bufs_done(video, VB2_BUF_STATE_ERROR);
 
@@ -1315,7 +1317,6 @@ static void aspeed_video_resolution_work(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
 						  res_work);
-	u32 input_status = video->v4l2_input_status;
 
 	aspeed_video_on(video);
 
@@ -1328,8 +1329,7 @@ static void aspeed_video_resolution_work(struct work_struct *work)
 	aspeed_video_get_resolution(video);
 
 	if (video->detected_timings.width != video->active_timings.width ||
-	    video->detected_timings.height != video->active_timings.height ||
-	    input_status != video->v4l2_input_status) {
+	    video->detected_timings.height != video->active_timings.height) {
 		static const struct v4l2_event ev = {
 			.type = V4L2_EVENT_SOURCE_CHANGE,
 			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
-- 
2.34.1



