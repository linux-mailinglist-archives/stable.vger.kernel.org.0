Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05693405669
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359688AbhIINTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358450AbhIINLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 416FA61462;
        Thu,  9 Sep 2021 12:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188882;
        bh=tVvaw6HlpLk74LVq/wGIqdRnM0lfG0tiM0yTIJlP9E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VzmX1h+kbOnNYs7mk3gjMSyrGe3FgXGcQcMfjDVfnTt7SN0D3M4qF39PlrejcByKI
         /gxlkZFG20trN/3rsIAvIBRDYgkQBPaYrvhgGFIm4kZ6cUCHLh7HScsEOBXEWSXuqH
         /n/QC7whnTSoHiDSuViDUD2/0A8ZKktqD45cxPUZDwbs0FbFy0ktvEbD5DyRDAP9ky
         AHD2RtJGQfWVA/nlFHbzFsrwnlEbCYEhWCWsPA4bbEaa5vLdTHL09Nrf1FtATz1eoQ
         5XPe0N/F2ShvXkLGM42KyNWPU9Un3a/2l1ZjC97XPeX0/a9w03/PuPIHmwefE3FXQ8
         42ux/ATHy8u7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/35] video: fbdev: kyro: fix a DoS bug by restricting user input
Date:   Thu,  9 Sep 2021 08:00:45 -0400
Message-Id: <20210909120116.150912-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120116.150912-1-sashal@kernel.org>
References: <20210909120116.150912-1-sashal@kernel.org>
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
index 5bb01533271e..8482444259ce 100644
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

