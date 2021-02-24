Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06174323CCE
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbhBXMzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235317AbhBXMxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:53:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D097064F16;
        Wed, 24 Feb 2021 12:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171078;
        bh=ft1+jyJEByQFMktY6awt1dNLeoWTW6Oo1qBOu7mh04s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoFD3MOj7soTJ4pQ6s2FaiMDsW64uOOWmlsHNPdy3Qug/O8gFDOvSKcwq1WSFACDK
         JSSHrAmUpxvEMYJezdCMQZlNXdlfoSe0eZRLakBqjdSF4o6HDY4MUUeo6f2tQjNK6V
         Z4TubT8ipaF6DhJtQdyo8J6elaB+994+rD+wWzKmYu4+Pd8ZHS7SwMtqcPzMpkm7fW
         7gbI4zGmTnnbgPed7zVNYAZeK3dtNcm852Yx3lZsjMPnG5RMsOUYBSyeN0AFSTBVwe
         eKbLH7RDAG0sQ1Kn2coahZDSlGBHXJWvuQBqy7FXHyIaphRnFPVmlmyI5NQsX9qH8Z
         epCL0kOXTKlaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+42d8c7c3d3e594b34346@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 38/67] media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate
Date:   Wed, 24 Feb 2021 07:49:56 -0500
Message-Id: <20210224125026.481804-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 048c96e28674f15c0403deba2104ffba64544a06 ]

If a menu has more than 64 items, then don't check menu_skip_mask
for items 65 and up.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+42d8c7c3d3e594b34346@syzkaller.appspotmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5cbe0ffbf501f..9dc151431a5c6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2165,7 +2165,8 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
 		if (ptr.p_s32[idx] < ctrl->minimum || ptr.p_s32[idx] > ctrl->maximum)
 			return -ERANGE;
-		if (ctrl->menu_skip_mask & (1ULL << ptr.p_s32[idx]))
+		if (ptr.p_s32[idx] < BITS_PER_LONG_LONG &&
+		    (ctrl->menu_skip_mask & BIT_ULL(ptr.p_s32[idx])))
 			return -EINVAL;
 		if (ctrl->type == V4L2_CTRL_TYPE_MENU &&
 		    ctrl->qmenu[ptr.p_s32[idx]][0] == '\0')
-- 
2.27.0

