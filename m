Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0241F44A310
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhKIBZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242474AbhKIBRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:17:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D20611CC;
        Tue,  9 Nov 2021 01:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420034;
        bh=Atx7ZiO0oLOeVSGrVDTeC+qmbeDayM/96As/GANmrOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PD8rRBE+nXU1q3NGAsXFAbjdiQg1dPwbgguymi+vhJcmng7S4PM6YvNBulUfEag3U
         AQti1Nn9ndF6OPKPhvvkStBSwVzbcqsmdxwzcHnIXwJhU5LAmX4qGcKx13k0LjTOWq
         0V+xgGsxTxiGyuicAUDGkgYHy/azykZNkAx+mM1Gs053tDslXB2Whx74o0WM2haBQG
         4ZDRKBwcoP7qRq8vgNBPpl7wcwuLh4AvqYgDkzk2YRLdS6G1sWkkBE/sCNhGY0q0K8
         UsJd6n4/PQ++C/O6PI1McpSvrCcUvICkP65u2beTdeREZRnu7D+8K4Xrd3lNQXDBsr
         gSP7qD+JHcjEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/39] media: uvcvideo: Set capability in s_param
Date:   Mon,  8 Nov 2021 20:06:24 -0500
Message-Id: <20211109010649.1191041-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index fae811b9cde96..2b0ca32d71965 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -446,10 +446,13 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
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

