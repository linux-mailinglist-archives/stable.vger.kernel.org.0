Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88D44A159
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240394AbhKIBJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:09:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239732AbhKIBHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:07:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E8DD613A6;
        Tue,  9 Nov 2021 01:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419783;
        bh=6XPr30Qa6htGATQEnJrk0YD7dgGT0l9kyX5Ji03LveA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfBzC18qBHc8BVy9+Pyn70WecYGuzCZ5IGfvgRl+INwnMSLoOnQm5EOr/Qh9RyNQW
         bnHw1RYHf5fti4Bl5xv185D8qXKSh2xEyVcVsAj3/6lyaKVZxVntN7wphN2b6lv519
         jWzsPUa6AqNdtHH08IUPHoO7qvNSqActJvqKUA+D2s//3MOqiPeiFq2YyTolFcAKa7
         X7KMxH5unn3ow2p2mTR1/yd+XpEeaf0vDRLrVcR73eZ1AWty20vLE4pi5ze7gXPGzU
         j7ZCUMOCbtaAUbEIttZE7787ojmUi1eoal3DbyyeGDCYBT9SuzSX2x7Idlzgq3hFPB
         SfpujbfwgCImg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 040/138] media: uvcvideo: Return -EIO for control errors
Date:   Mon,  8 Nov 2021 12:45:06 -0500
Message-Id: <20211108174644.1187889-40-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit ffccdde5f0e17d2f0d788a9d831a027187890eaa ]

The device is doing something unexpected with the control. Either because
the protocol is not properly implemented or there has been a HW error.

Fixes v4l2-compliance:

Control ioctls (Input 0):
                fail: v4l2-test-controls.cpp(448): s_ctrl returned an error (22)
        test VIDIOC_G/S_CTRL: FAIL
                fail: v4l2-test-controls.cpp(698): s_ext_ctrls returned an error (22)
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index e16464606b140..9f37eaf28ce7e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -115,6 +115,11 @@ int uvc_query_ctrl(struct uvc_device *dev, u8 query, u8 unit,
 	case 5: /* Invalid unit */
 	case 6: /* Invalid control */
 	case 7: /* Invalid Request */
+		/*
+		 * The firmware has not properly implemented
+		 * the control or there has been a HW error.
+		 */
+		return -EIO;
 	case 8: /* Invalid value within range */
 		return -EINVAL;
 	default: /* reserved or unknown */
-- 
2.33.0

