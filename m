Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE9D451FCB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbhKPApW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343856AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6569B635F5;
        Mon, 15 Nov 2021 18:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002039;
        bh=fFfgs6BPiAXfMalW/bs2mDiMhnNmpggZk00gi9GwpGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmKawOfg1EGE3bfWL544turHPtRwJo4p+iIk6YrkG9ELHVExMRk+pzlo5lNjEFZxQ
         ti9dzhpw1piTrKbi/iNWQ2O4kjTwBayBaDqQqEDhfM2J9T4rF4jO+HPoWKbDnMzJL5
         fOv+oi23GdeF8tqEPMHNw11WA/ZoENUdcbyUGej4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 383/917] media: v4l2-ioctl: S_CTRL output the right value
Date:   Mon, 15 Nov 2021 17:57:58 +0100
Message-Id: <20211115165441.758119905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit c87ed93574e3cd8346c05bd934c617596c12541b ]

If the driver does not implement s_ctrl, but it does implement
s_ext_ctrls, we convert the call.

When that happens we have also to convert back the response from
s_ext_ctrls.

Fixes v4l2_compliance:
Control ioctls (Input 0):
		fail: v4l2-test-controls.cpp(411): returned control value out of range
		fail: v4l2-test-controls.cpp(507): invalid control 00980900
	test VIDIOC_G/S_CTRL: FAIL

Fixes: 35ea11ff8471 ("V4L/DVB (8430): videodev: move some functions from v4l2-dev.h to v4l2-common.h or v4l2-ioctl.h")
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index da5b4002a466a..f4f67b385d00a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2224,6 +2224,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 		test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) ? fh : NULL;
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
+	int ret;
 
 	if (vfh && vfh->ctrl_handler)
 		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, p);
@@ -2239,9 +2240,11 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
 	ctrl.value = p->value;
-	if (check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
-		return ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
-	return -EINVAL;
+	if (!check_ext_ctrls(&ctrls, VIDIOC_S_CTRL))
+		return -EINVAL;
+	ret = ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
+	p->value = ctrl.value;
+	return ret;
 }
 
 static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
-- 
2.33.0



