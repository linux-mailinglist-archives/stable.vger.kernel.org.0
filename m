Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB4C4054DF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353600AbhIINDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357167AbhIIM7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 921E36327B;
        Thu,  9 Sep 2021 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188748;
        bh=9sqIlj1TMlzStrSfKyBBB4xXAtrh/JOARt+Z0euvc/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2DiXCsM2ckQVKym2gFTovWkbOOMW9AjDDOkeH9DEcxg/KuRfeFxvu9gUC8Urq2qr
         6TE/6SsNAmkCxH9Ppz5xSKXm2HJOvvG61pCr34fjq7n73hJDyUvcZ1OG180pdnEMC6
         gEkOKyqWwyNWvEreImXAjSI8/TAbyGxBamHZ5ABU0/tB9z/FiAWqNIE7jPNHC3re9B
         +qfpA9DAw5GVDCHfWyBrTa0H+2g7/mVxcEykT0rsmEE56In/W+w2H8f5EcYIUy9dvt
         oWP7OsXxnHZZwqBmOa6XK5rwvG7IrmQL5i2Z2tp/aBzT2Esai9JzUeV3s0la/ovol1
         dfv37TQ/IAETA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/59] video: fbdev: kyro: fix a DoS bug by restricting user input
Date:   Thu,  9 Sep 2021 07:58:07 -0400
Message-Id: <20210909115900.149795-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index a7bd9f25911b..d7aa431e6846 100644
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

