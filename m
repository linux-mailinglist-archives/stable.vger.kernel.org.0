Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014A8499FA6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841968AbiAXXA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835803AbiAXWhf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:37:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE18C054844;
        Mon, 24 Jan 2022 12:59:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E01761355;
        Mon, 24 Jan 2022 20:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3196EC340E5;
        Mon, 24 Jan 2022 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057947;
        bh=RxIigBhFTeZ+GtzDVEchnUoTO75Wyk7sQHW98SGKpKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik06TuR3iEiaYNl9Yt+iGYlz3qaiCnxnl7splqYDFuM9TbL63KUKTOyXxvZIM30P2
         Jx9pW0oWBfGZe1UDdt0Q9BVTWe833lrTe65aOnbSEViD2qARMzPNbGF95K1qTRI7/N
         wyVL90yDGsV2VcECCqmYOK6tuLmWsbsj9lMIE0kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jammy Huang <jammy_huang@aspeedtech.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0132/1039] media: aspeed: Update signal status immediately to ensure sane hw state
Date:   Mon, 24 Jan 2022 19:32:01 +0100
Message-Id: <20220124184129.596914928@linuxfoundation.org>
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
index 136383ad0e97c..7a24daf7165a4 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -595,6 +595,8 @@ static void aspeed_video_irq_res_change(struct aspeed_video *video, ulong delay)
 	set_bit(VIDEO_RES_CHANGE, &video->flags);
 	clear_bit(VIDEO_FRAME_INPRG, &video->flags);
 
+	video->v4l2_input_status = V4L2_IN_ST_NO_SIGNAL;
+
 	aspeed_video_off(video);
 	aspeed_video_bufs_done(video, VB2_BUF_STATE_ERROR);
 
@@ -1375,7 +1377,6 @@ static void aspeed_video_resolution_work(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
 						  res_work);
-	u32 input_status = video->v4l2_input_status;
 
 	aspeed_video_on(video);
 
@@ -1388,8 +1389,7 @@ static void aspeed_video_resolution_work(struct work_struct *work)
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



