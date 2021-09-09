Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736844049D6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhIILnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237179AbhIILmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFE5611ED;
        Thu,  9 Sep 2021 11:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187703;
        bh=35atDnHr5kKPvD7ZRVCpmrxJQhwkKsyZnBkWc0xcL9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrpCArfMUVdLkRmeiFkXMk3WK7EXRot/42pj4T6na8OeubQNnXIbg6pLwWtv8V7kp
         3+6Hf7+ef057UwLnZOb5UXmV+oJ2f2lv27q6c9oXa3nYagrUEQSrmPiyMMZH0fz09g
         KUyJNmOqeEKHBY8WQj/pI0gOG2Ef/W6bfgjmhOY+mmgK2zAXRDJcIHp3E1Bw0Zv3vS
         bgnGhgYfFj+CyTeaOnFaYUveCIfXOSsWaqf+TRlY15NtiKV+Dp4ppKBsnrt1uHP5sR
         /Z0sQui+vy6j8wHcI6FZuIHHWlzD0X6w1dmtQBu8TTpk4Q9canMSld8fqwU2vZfSll
         0TOezxI6sE99g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 028/252] video: fbdev: kyro: fix a DoS bug by restricting user input
Date:   Thu,  9 Sep 2021 07:37:22 -0400
Message-Id: <20210909114106.141462-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 98a65439172dc69cb16834e62e852afc2adb83ed ]

The user can pass in any value to the driver through the 'ioctl'
interface. The driver dost not check, which may cause DoS bugs.

The following log reveals it:

divide error: 0000 [#1] PREEMPT SMP KASAN PTI
RIP: 0010:SetOverlayViewPort+0x133/0x5f0 drivers/video/fbdev/kyro/STG4000OverlayDevice.c:476
Call Trace:
 kyro_dev_overlay_viewport_set drivers/video/fbdev/kyro/fbdev.c:378 [inline]
 kyrofb_ioctl+0x2eb/0x330 drivers/video/fbdev/kyro/fbdev.c:603
 do_fb_ioctl+0x1f3/0x700 drivers/video/fbdev/core/fbmem.c:1171
 fb_ioctl+0xeb/0x130 drivers/video/fbdev/core/fbmem.c:1185
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x19b/0x220 fs/ioctl.c:739
 do_syscall_64+0x32/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1626235762-2590-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 8fbde92ae8b9..4b8c7c16b1df 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -372,6 +372,11 @@ static int kyro_dev_overlay_viewport_set(u32 x, u32 y, u32 ulWidth, u32 ulHeight
 		/* probably haven't called CreateOverlay yet */
 		return -EINVAL;
 
+	if (ulWidth == 0 || ulWidth == 0xffffffff ||
+	    ulHeight == 0 || ulHeight == 0xffffffff ||
+	    (x < 2 && ulWidth + 2 == 0))
+		return -EINVAL;
+
 	/* Stop Ramdac Output */
 	DisableRamdacOutput(deviceInfo.pSTGReg);
 
-- 
2.30.2

