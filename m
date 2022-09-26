Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D015EA541
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiIZL7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239320AbiIZL6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B617B78E;
        Mon, 26 Sep 2022 03:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A921609FE;
        Mon, 26 Sep 2022 10:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF980C433C1;
        Mon, 26 Sep 2022 10:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189480;
        bh=Q2ax4nHmUIsuSF4ftZGVkIdUdYbh9VYCFtJUZ59qKPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B320SmzzShhxg0Q0uuOMg5jRTo9vTQU8Mz0G3JyHhGMKhD2RK9asptIzi2Feepama
         4Vy9gdKHSwPmIU1ZddtEUxqRuTgn7+i8Bd/DVhnW/2S7ubG6K2fezyJghiEiSEVJsW
         4p6TNMSO2fO+53TdRYeHRG8oFcZj+5OzeA0mig8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 172/207] drm/gma500: Fix BUG: sleeping function called from invalid context errors
Date:   Mon, 26 Sep 2022 12:12:41 +0200
Message-Id: <20220926100814.362842799@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 63e37a79f7bd939314997e29c2f5a9f0ef184281 ]

gma_crtc_page_flip() was holding the event_lock spinlock while calling
crtc_funcs->mode_set_base() which takes ww_mutex.

The only reason to hold event_lock is to clear gma_crtc->page_flip_event
on mode_set_base() errors.

Instead unlock it after setting gma_crtc->page_flip_event and on
errors re-take the lock and clear gma_crtc->page_flip_event it
it is still set.

This fixes the following WARN/stacktrace:

[  512.122953] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:870
[  512.123004] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1253, name: gnome-shell
[  512.123031] preempt_count: 1, expected: 0
[  512.123048] RCU nest depth: 0, expected: 0
[  512.123066] INFO: lockdep is turned off.
[  512.123080] irq event stamp: 0
[  512.123094] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  512.123134] hardirqs last disabled at (0): [<ffffffff8d0ec28c>] copy_process+0x9fc/0x1de0
[  512.123176] softirqs last  enabled at (0): [<ffffffff8d0ec28c>] copy_process+0x9fc/0x1de0
[  512.123207] softirqs last disabled at (0): [<0000000000000000>] 0x0
[  512.123233] Preemption disabled at:
[  512.123241] [<0000000000000000>] 0x0
[  512.123275] CPU: 3 PID: 1253 Comm: gnome-shell Tainted: G        W         5.19.0+ #1
[  512.123304] Hardware name: Packard Bell dot s/SJE01_CT, BIOS V1.10 07/23/2013
[  512.123323] Call Trace:
[  512.123346]  <TASK>
[  512.123370]  dump_stack_lvl+0x5b/0x77
[  512.123412]  __might_resched.cold+0xff/0x13a
[  512.123458]  ww_mutex_lock+0x1e/0xa0
[  512.123495]  psb_gem_pin+0x2c/0x150 [gma500_gfx]
[  512.123601]  gma_pipe_set_base+0x76/0x240 [gma500_gfx]
[  512.123708]  gma_crtc_page_flip+0x95/0x130 [gma500_gfx]
[  512.123808]  drm_mode_page_flip_ioctl+0x57d/0x5d0
[  512.123897]  ? drm_mode_cursor2_ioctl+0x10/0x10
[  512.123936]  drm_ioctl_kernel+0xa1/0x150
[  512.123984]  drm_ioctl+0x21f/0x420
[  512.124025]  ? drm_mode_cursor2_ioctl+0x10/0x10
[  512.124070]  ? rcu_read_lock_bh_held+0xb/0x60
[  512.124104]  ? lock_release+0x1ef/0x2d0
[  512.124161]  __x64_sys_ioctl+0x8d/0xd0
[  512.124203]  do_syscall_64+0x58/0x80
[  512.124239]  ? do_syscall_64+0x67/0x80
[  512.124267]  ? trace_hardirqs_on_prepare+0x55/0xe0
[  512.124300]  ? do_syscall_64+0x67/0x80
[  512.124340]  ? rcu_read_lock_sched_held+0x10/0x80
[  512.124377]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  512.124411] RIP: 0033:0x7fcc4a70740f
[  512.124442] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28 00 00
[  512.124470] RSP: 002b:00007ffda73f5390 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  512.124503] RAX: ffffffffffffffda RBX: 000055cc9e474500 RCX: 00007fcc4a70740f
[  512.124524] RDX: 00007ffda73f5420 RSI: 00000000c01864b0 RDI: 0000000000000009
[  512.124544] RBP: 00007ffda73f5420 R08: 000055cc9c0b0cb0 R09: 0000000000000034
[  512.124564] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000c01864b0
[  512.124584] R13: 0000000000000009 R14: 000055cc9df484d0 R15: 000055cc9af5d0c0
[  512.124647]  </TASK>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220906203852.527663-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/gma_display.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/gma500/gma_display.c b/drivers/gpu/drm/gma500/gma_display.c
index 34ec3fca09ba..12287c9bb4d8 100644
--- a/drivers/gpu/drm/gma500/gma_display.c
+++ b/drivers/gpu/drm/gma500/gma_display.c
@@ -531,15 +531,18 @@ int gma_crtc_page_flip(struct drm_crtc *crtc,
 		WARN_ON(drm_crtc_vblank_get(crtc) != 0);
 
 		gma_crtc->page_flip_event = event;
+		spin_unlock_irqrestore(&dev->event_lock, flags);
 
 		/* Call this locked if we want an event at vblank interrupt. */
 		ret = crtc_funcs->mode_set_base(crtc, crtc->x, crtc->y, old_fb);
 		if (ret) {
-			gma_crtc->page_flip_event = NULL;
-			drm_crtc_vblank_put(crtc);
+			spin_lock_irqsave(&dev->event_lock, flags);
+			if (gma_crtc->page_flip_event) {
+				gma_crtc->page_flip_event = NULL;
+				drm_crtc_vblank_put(crtc);
+			}
+			spin_unlock_irqrestore(&dev->event_lock, flags);
 		}
-
-		spin_unlock_irqrestore(&dev->event_lock, flags);
 	} else {
 		ret = crtc_funcs->mode_set_base(crtc, crtc->x, crtc->y, old_fb);
 	}
-- 
2.35.1



