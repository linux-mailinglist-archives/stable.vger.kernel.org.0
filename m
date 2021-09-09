Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29635404E5F
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346920AbhIIMLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350443AbhIIMIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9969617E4;
        Thu,  9 Sep 2021 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188072;
        bh=CFxoJqTD6D2XgEUt9WJ2SR1eXohXAMMWRfLmxb/Gz8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSMKEKwtZ8kb0sYaVbqRkgSBr2kZA1UOBa8CqmgOLvYLBj6dxNbGyxD5OklHiNxbJ
         V+DMz4QuWRK0E9jCYSaEIPueR852r7Jpant3ICo6xXVh3Wm1GH+BG6DN5TNgciPG8b
         OB2sAlEA1wt4ooeI2j4OVr0VouoA5fs6ie+/fw+TrquGF/mFAo+1+m2VFcUCpO55HD
         KTfsVSJqIlRFKEPTbwfEt7rp5r96BQoRTco17JIeZoQSYhpW60KCFrklwwNt/tsFuS
         08d1P5nm1plWjKjcSEnxcd/Xkad42YbZYFxHd3xZ0+7dKIqaHekg2A7SGLeCS9gvY3
         e4wNewHR5q9nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 059/219] video: fbdev: asiliantfb: Error out if 'pixclock' equals zero
Date:   Thu,  9 Sep 2021 07:43:55 -0400
Message-Id: <20210909114635.143983-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit b36b242d4b8ea178f7fd038965e3cac7f30c3f09 ]

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of 'pixclock',
it may cause divide error.

Fix this by checking whether 'pixclock' is zero first.

The following log reveals it:

[   43.861711] divide error: 0000 [#1] PREEMPT SMP KASAN PTI
[   43.861737] CPU: 2 PID: 11764 Comm: i740 Not tainted 5.14.0-rc2-00513-gac532c9bbcfb-dirty #224
[   43.861756] RIP: 0010:asiliantfb_check_var+0x4e/0x730
[   43.861843] Call Trace:
[   43.861848]  ? asiliantfb_remove+0x190/0x190
[   43.861858]  fb_set_var+0x2e4/0xeb0
[   43.861866]  ? fb_blank+0x1a0/0x1a0
[   43.861873]  ? lock_acquire+0x1ef/0x530
[   43.861884]  ? lock_release+0x810/0x810
[   43.861892]  ? lock_is_held_type+0x100/0x140
[   43.861903]  ? ___might_sleep+0x1ee/0x2d0
[   43.861914]  ? __mutex_lock+0x620/0x1190
[   43.861921]  ? do_fb_ioctl+0x313/0x700
[   43.861929]  ? mutex_lock_io_nested+0xfa0/0xfa0
[   43.861936]  ? __this_cpu_preempt_check+0x1d/0x30
[   43.861944]  ? _raw_spin_unlock_irqrestore+0x46/0x60
[   43.861952]  ? lockdep_hardirqs_on+0x59/0x100
[   43.861959]  ? _raw_spin_unlock_irqrestore+0x46/0x60
[   43.861967]  ? trace_hardirqs_on+0x6a/0x1c0
[   43.861978]  do_fb_ioctl+0x31e/0x700

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1627293835-17441-2-git-send-email-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/asiliantfb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/asiliantfb.c b/drivers/video/fbdev/asiliantfb.c
index 3e006da47752..84c56f525889 100644
--- a/drivers/video/fbdev/asiliantfb.c
+++ b/drivers/video/fbdev/asiliantfb.c
@@ -227,6 +227,9 @@ static int asiliantfb_check_var(struct fb_var_screeninfo *var,
 {
 	unsigned long Ftarget, ratio, remainder;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	ratio = 1000000 / var->pixclock;
 	remainder = 1000000 % var->pixclock;
 	Ftarget = 1000000 * ratio + (1000000 * remainder) / var->pixclock;
-- 
2.30.2

