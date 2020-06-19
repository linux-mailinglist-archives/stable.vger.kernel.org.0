Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14930200F5C
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404109AbgFSPQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392258AbgFSPQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84C742080C;
        Fri, 19 Jun 2020 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579807;
        bh=PURkuQjDd4uIDSMLujFEZ60c931LKLsJlFRXqNsQ6kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlQDWUh3CE1HPrXiMYZTZZoHB9StlUH6yB+AblLQwCxlRym9tbW5FWmkVH2mEmF8q
         P2i28kC0fTO528Jf5R1sU42LNFvMt+C8mMq8cYanUbTPzNvjH4jbWkhrbNxD4pC7RJ
         2Y3iceB/RogIRdBB4MuB3n8HKFeb9kJ/NGyEGK7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 012/376] media: v4l2-ctrls: v4l2_ctrl_g/s_ctrl*(): dont continue when WARN_ON
Date:   Fri, 19 Jun 2020 16:28:50 +0200
Message-Id: <20200619141710.943422485@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



