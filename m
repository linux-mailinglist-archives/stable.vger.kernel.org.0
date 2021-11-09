Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E8344A38E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243474AbhKIB1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:27:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244224AbhKIBZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:25:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D84061B47;
        Tue,  9 Nov 2021 01:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420179;
        bh=sHv9dwUtlJ5iihueYcUBeW5m+em2fUoVqnhZ9bHlrDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hclZycGxIdqaNmlxOVWIPgP+WCXlbXz9e65hTOtKISXV8Pou0RjScM3cGARLJo9/O
         y4kKoV+sZvDVMRbcEvZ0CJhDwWu/MLEuDxBqgrfes3i1bmN7vYaUna1cmXA1JV1mwb
         9qSXmO/I72f4jbotz0RERlChFfPAZ3/FCxxob3iIoZ+ICxaZ+abcyZZv+GXPaoX1C1
         oRnRpV5hs0emuy/SQvLNh8UcJ3dnP8kuWdWbkZkRi1RjkR+aYtbNvURE3hNUT90FH3
         /3SmgN/HnI29yzwspTNACvYgrVSyG/qJT8+xSvWjDwRRpUVHrzaPENh40RuWPDWWRq
         tGtCMhm99EQVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/30] media: uvcvideo: Set capability in s_param
Date:   Mon,  8 Nov 2021 20:08:59 -0500
Message-Id: <20211109010918.1192063-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 97a2777a96070afb7da5d587834086c0b586c8cc ]

Fixes v4l2-compliance:

Format ioctls (Input 0):
                warn: v4l2-test-formats.cpp(1339): S_PARM is supported but doesn't report V4L2_CAP_TIMEPERFRAME
                fail: v4l2-test-formats.cpp(1241): node->has_frmintervals && !cap->capability

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 049d664e94f07..8ac231f6b2d16 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -436,10 +436,13 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 	uvc_simplify_fraction(&timeperframe.numerator,
 		&timeperframe.denominator, 8, 333);
 
-	if (parm->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (parm->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		parm->parm.capture.timeperframe = timeperframe;
-	else
+		parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	} else {
 		parm->parm.output.timeperframe = timeperframe;
+		parm->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
+	}
 
 	return 0;
 }
-- 
2.33.0

