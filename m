Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91284412274
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351559AbhITSPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358727AbhITSHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 455AE61A3C;
        Mon, 20 Sep 2021 17:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158314;
        bh=lLd16bR7KFDAcQyJi/kQnKCTrzwAXDW4mmvfvqiwpbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEfm04KGalgUK0dnI0t8gUh8SuKCwWiSWNmSDNZ3n01SWF8xy3k4HjEP67+JmzB3W
         yEKENVoEJ5rouHZ8fzDQEvUVLzhzTBhp+LEgPZ7/dVnzEC1oQrafXjOs38tligC16s
         8DMcJ35ww9id2GMv67iywLJzBZsodmXTFp2IRbNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/260] video: fbdev: riva: Error out if pixclock equals zero
Date:   Mon, 20 Sep 2021 18:41:58 +0200
Message-Id: <20210920163934.532567660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit f92763cb0feba247e0939ed137b495601fd072a5 ]

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of 'pixclock',
it may cause divide error.

Fix this by checking whether 'pixclock' is zero first.

The following log reveals it:

[   33.396850] divide error: 0000 [#1] PREEMPT SMP KASAN PTI
[   33.396864] CPU: 5 PID: 11754 Comm: i740 Not tainted 5.14.0-rc2-00513-gac532c9bbcfb-dirty #222
[   33.396883] RIP: 0010:riva_load_video_mode+0x417/0xf70
[   33.396969] Call Trace:
[   33.396973]  ? debug_smp_processor_id+0x1c/0x20
[   33.396984]  ? tick_nohz_tick_stopped+0x1a/0x90
[   33.396996]  ? rivafb_copyarea+0x3c0/0x3c0
[   33.397003]  ? wake_up_klogd.part.0+0x99/0xd0
[   33.397014]  ? vprintk_emit+0x110/0x4b0
[   33.397024]  ? vprintk_default+0x26/0x30
[   33.397033]  ? vprintk+0x9c/0x1f0
[   33.397041]  ? printk+0xba/0xed
[   33.397054]  ? record_print_text.cold+0x16/0x16
[   33.397063]  ? __kasan_check_read+0x11/0x20
[   33.397074]  ? profile_tick+0xc0/0x100
[   33.397084]  ? __sanitizer_cov_trace_const_cmp4+0x24/0x80
[   33.397094]  ? riva_set_rop_solid+0x2a0/0x2a0
[   33.397102]  rivafb_set_par+0xbe/0x610
[   33.397111]  ? riva_set_rop_solid+0x2a0/0x2a0
[   33.397119]  fb_set_var+0x5bf/0xeb0
[   33.397127]  ? fb_blank+0x1a0/0x1a0
[   33.397134]  ? lock_acquire+0x1ef/0x530
[   33.397143]  ? lock_release+0x810/0x810
[   33.397151]  ? lock_is_held_type+0x100/0x140
[   33.397159]  ? ___might_sleep+0x1ee/0x2d0
[   33.397170]  ? __mutex_lock+0x620/0x1190
[   33.397180]  ? trace_hardirqs_on+0x6a/0x1c0
[   33.397190]  do_fb_ioctl+0x31e/0x700

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1627293835-17441-4-git-send-email-zheyuma97@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/riva/fbdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/riva/fbdev.c b/drivers/video/fbdev/riva/fbdev.c
index ca593a3e41d7..51c9d9508c0b 100644
--- a/drivers/video/fbdev/riva/fbdev.c
+++ b/drivers/video/fbdev/riva/fbdev.c
@@ -1088,6 +1088,9 @@ static int rivafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 	int mode_valid = 0;
 	
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 1 ... 8:
 		var->red.offset = var->green.offset = var->blue.offset = 0;
-- 
2.30.2



