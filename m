Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553AB323D3B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbhBXNGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232920AbhBXNAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 810E164F5B;
        Wed, 24 Feb 2021 12:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171174;
        bh=i12ALCUQkYtMSF6dXFAE5v2VtKSrWquxNH5mQhDou5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GipHEQ493WcBNPowJisG59vVQs+tUddvL0RIW3Ot9qzXbv4c9Y+1ScQFDbDwYtxHx
         Vn/OBj9EsX0g6jD7hILhQEVhvxdtqg3NgkmD0eilfxwLXauy3fqJ3aKb+BvTyIy5rZ
         4YkrhwrEgg6jta4TTII5+9ecDvaDl+hsYzyIH0yk6e/Ny/5vnEqiOvU2cO6q3y8T/l
         9GT3Z+O0k/Gss4eNS3Z9xP74exr0zE2ye60BIb/vozM5Tgx+tAj8Y8f3d59L1qTPrd
         qBr+tEyMXJS0eV52gMDmR46IXUWZp/W2lRsNHW5TQumGhsVxeDCCDzmaYj46bUH6UF
         EOIjEgoASFLrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+42d8c7c3d3e594b34346@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/56] media: v4l2-ctrls.c: fix shift-out-of-bounds in std_validate
Date:   Wed, 24 Feb 2021 07:51:47 -0500
Message-Id: <20210224125212.482485-31-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index bd7f330c941c4..cfe422d9f439b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1987,7 +1987,8 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
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

