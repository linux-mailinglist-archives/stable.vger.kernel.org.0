Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FEF40530D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355390AbhIIMtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:49:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353047AbhIIMno (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:43:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6991613A0;
        Thu,  9 Sep 2021 11:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188544;
        bh=d7EUfqwWWpV7h3TBHRCTu2b8IRuzuCKWsO/Z6kfeEZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ph6HzA22fLhJGh7v3dQ9uWDJuO9ezWKkWQCSaKLNjAxm0yq8SGu6lUSUliV1lXBQj
         7lmmRKmkH9qK+yTvZY4vvdOINFcKGZzEiDSCxChYNTARZS8P+WkongQAl85EzNIvjH
         mqG8E+UMWcJTcbyEmsls2Hp3p0pD6d/wOZGtkStgnE/IJQTPY3onjdPE4bz0nleB0P
         IrxzXS6cGFOnHjxCjsvqAHLNopbhGpA6zcNrfkNvnBFzfXvywf9/IjJilSYvDXisE7
         /1RSvuwuc2femDGyN+Ck6wtOlKQRGsBwkCtxiEUNl5g8vsqyfM2mOeobGkXoFI+/bI
         utuNGCvFLNfyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 029/109] video: fbdev: kyro: Error out if 'pixclock' equals zero
Date:   Thu,  9 Sep 2021 07:53:46 -0400
Message-Id: <20210909115507.147917-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 1520b4b7ba964f8eec2e7dd14c571d50de3e5191 ]

The userspace program could pass any values to the driver through
ioctl() interface. if the driver doesn't check the value of 'pixclock',
it may cause divide error because the value of 'lineclock' and
'frameclock' will be zero.

Fix this by checking whether 'pixclock' is zero in kyrofb_check_var().

The following log reveals it:

[  103.073930] divide error: 0000 [#1] PREEMPT SMP KASAN PTI
[  103.073942] CPU: 4 PID: 12483 Comm: syz-executor Not tainted 5.14.0-rc2-00478-g2734d6c1b1a0-dirty #118
[  103.073959] RIP: 0010:kyrofb_set_par+0x316/0xc80
[  103.074045] Call Trace:
[  103.074048]  ? ___might_sleep+0x1ee/0x2d0
[  103.074060]  ? kyrofb_ioctl+0x330/0x330
[  103.074069]  fb_set_var+0x5bf/0xeb0
[  103.074078]  ? fb_blank+0x1a0/0x1a0
[  103.074085]  ? lock_acquire+0x3bd/0x530
[  103.074094]  ? lock_release+0x810/0x810
[  103.074103]  ? ___might_sleep+0x1ee/0x2d0
[  103.074114]  ? __mutex_lock+0x620/0x1190
[  103.074126]  ? trace_hardirqs_on+0x6a/0x1c0
[  103.074137]  do_fb_ioctl+0x31e/0x700
[  103.074144]  ? fb_getput_cmap+0x280/0x280
[  103.074152]  ? rcu_read_lock_sched_held+0x11/0x80
[  103.074162]  ? rcu_read_lock_sched_held+0x11/0x80
[  103.074171]  ? __sanitizer_cov_trace_switch+0x67/0xf0
[  103.074181]  ? __sanitizer_cov_trace_const_cmp2+0x20/0x80
[  103.074191]  ? do_vfs_ioctl+0x14b/0x16c0
[  103.074199]  ? vfs_fileattr_set+0xb60/0xb60
[  103.074207]  ? rcu_read_lock_sched_held+0x11/0x80
[  103.074216]  ? lock_release+0x483/0x810
[  103.074224]  ? __fget_files+0x217/0x3d0
[  103.074234]  ? __fget_files+0x239/0x3d0
[  103.074243]  ? do_fb_ioctl+0x700/0x700
[  103.074250]  fb_ioctl+0xe6/0x130

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1627293835-17441-3-git-send-email-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index d7aa431e6846..74bf26b527b9 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -399,6 +399,9 @@ static int kyrofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct kyrofb_info *par = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->bits_per_pixel != 16 && var->bits_per_pixel != 32) {
 		printk(KERN_WARNING "kyrofb: depth not supported: %u\n", var->bits_per_pixel);
 		return -EINVAL;
-- 
2.30.2

