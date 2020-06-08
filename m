Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E55B1F3179
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgFIBJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 21:09:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbgFHXG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:06:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C772076C;
        Mon,  8 Jun 2020 23:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657585;
        bh=PURkuQjDd4uIDSMLujFEZ60c931LKLsJlFRXqNsQ6kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KKKP/EfVcoougZuQJA6+xLrYjf9GhGybSTAfw/FbskRW7izHTD+iZHnvodJKy3BE
         VpN1ehWSzE6DbOH2K73Bcnu7xs5/c+Ttg5fVBblh7DXVLqwCgfItDOZq9xDt2/8SKs
         x/RgPQTgpXkzMEojPyXDtn/t5bXRHroNYdaktLRs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 014/274] media: v4l2-ctrls: v4l2_ctrl_g/s_ctrl*(): don't continue when WARN_ON
Date:   Mon,  8 Jun 2020 19:01:47 -0400
Message-Id: <20200608230607.3361041-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 7c3bae3f430af6b4fcbdb7272e191e266fd94b45 ]

If the v4l2_ctrl_g_ctrl*() or __v4l2_ctrl_s_ctrl*() functions
are called for the wrong control type then they call WARN_ON
since that is a driver error. But they still continue, potentially
overwriting data. Change this to return an error (s_ctrl) or 0
(g_ctrl), just to be safe.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 93d33d1db4e8..452edd06d67d 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3794,7 +3794,8 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(!ctrl->is_int);
+	if (WARN_ON(!ctrl->is_int))
+		return 0;
 	c.value = 0;
 	get_ctrl(ctrl, &c);
 	return c.value;
@@ -3806,7 +3807,8 @@ s64 v4l2_ctrl_g_ctrl_int64(struct v4l2_ctrl *ctrl)
 	struct v4l2_ext_control c;
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	if (WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64))
+		return 0;
 	c.value64 = 0;
 	get_ctrl(ctrl, &c);
 	return c.value64;
@@ -4215,7 +4217,8 @@ int __v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(!ctrl->is_int);
+	if (WARN_ON(!ctrl->is_int))
+		return -EINVAL;
 	ctrl->val = val;
 	return set_ctrl(NULL, ctrl, 0);
 }
@@ -4226,7 +4229,8 @@ int __v4l2_ctrl_s_ctrl_int64(struct v4l2_ctrl *ctrl, s64 val)
 	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64);
+	if (WARN_ON(ctrl->is_ptr || ctrl->type != V4L2_CTRL_TYPE_INTEGER64))
+		return -EINVAL;
 	*ctrl->p_new.p_s64 = val;
 	return set_ctrl(NULL, ctrl, 0);
 }
@@ -4237,7 +4241,8 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
+	if (WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING))
+		return -EINVAL;
 	strscpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
 	return set_ctrl(NULL, ctrl, 0);
 }
@@ -4249,7 +4254,8 @@ int __v4l2_ctrl_s_ctrl_area(struct v4l2_ctrl *ctrl,
 	lockdep_assert_held(ctrl->handler->lock);
 
 	/* It's a driver bug if this happens. */
-	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_AREA);
+	if (WARN_ON(ctrl->type != V4L2_CTRL_TYPE_AREA))
+		return -EINVAL;
 	*ctrl->p_new.p_area = *area;
 	return set_ctrl(NULL, ctrl, 0);
 }
-- 
2.25.1

