Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAAA1A5909
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgDKXeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgDKXJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 833D720787;
        Sat, 11 Apr 2020 23:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646564;
        bh=QlHYEWGn7a3elbcxUrFdddKG91fI9pOgb+Q8z/TN5D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMhWPxroFw4c5Tq9BYm6MvVj0Z23IZlnoZ0gJYQqP57lXyAzk3GFr44+2iX1reIJf
         1yqshU7Nd7bbAIQGxoTD53Wf+Qli2ta3c6Rj+u30R7xjKvseNSwcqfnbDpriDTlP/v
         cU2dw7v5O1tufbw87WKD5DEfCZDwNELwWUmjyfqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 112/121] rtc: cmos: Use spin_lock_irqsave() in cmos_interrupt()
Date:   Sat, 11 Apr 2020 19:06:57 -0400
Message-Id: <20200411230706.23855-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 66e4f4a9cc389b277e187c115a285fad2cba5485 ]

cmos_interrupt() isn't always called from hardirq context, so
we must use spin_lock_irqsave() & co.

================================
WARNING: inconsistent lock state
5.6.0-rc2-CI-CI_DRM_7981+ #1 Tainted: G     U
--------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
rtcwake/4315 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffffffff82635198 (rtc_lock){?...}, at: cmos_interrupt+0x18/0x100
{IN-HARDIRQ-W} state was registered at:
  lock_acquire+0xa7/0x1c0
  _raw_spin_lock+0x2a/0x40
  cmos_interrupt+0x18/0x100
  rtc_handler+0x75/0xc0
  acpi_ev_fixed_event_detect+0xf9/0x132
  acpi_ev_sci_xrupt_handler+0xb/0x28
  acpi_irq+0x13/0x30
  __handle_irq_event_percpu+0x41/0x2c0
  handle_irq_event_percpu+0x2b/0x70
  handle_irq_event+0x2f/0x50
  handle_fasteoi_irq+0x8e/0x150
  do_IRQ+0x7e/0x160
  ret_from_intr+0x0/0x35
  mwait_idle+0x7e/0x200
  do_idle+0x1bb/0x260
  cpu_startup_entry+0x14/0x20
  start_secondary+0x15f/0x1b0
  secondary_startup_64+0xa4/0xb0
irq event stamp: 42003
hardirqs last  enabled at (42003): [<ffffffff81a36567>] _raw_spin_unlock_irqrestore+0x47/0x60
hardirqs last disabled at (42002): [<ffffffff81a362ed>] _raw_spin_lock_irqsave+0xd/0x50
softirqs last  enabled at (41848): [<ffffffff81e00385>] __do_softirq+0x385/0x47f
softirqs last disabled at (41841): [<ffffffff810bab3a>] irq_exit+0xba/0xc0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rtc_lock);
  <Interrupt>
    lock(rtc_lock);

 *** DEADLOCK ***

6 locks held by rtcwake/4315:
 #0: ffff888175dc9408 (sb_writers#5){.+.+}, at: vfs_write+0x1a4/0x1d0
 #1: ffff88817406ca80 (&of->mutex){+.+.}, at: kernfs_fop_write+0xdd/0x1b0
 #2: ffff888179be85e0 (kn->count#236){.+.+}, at: kernfs_fop_write+0xe6/0x1b0
 #3: ffffffff82641e00 (system_transition_mutex){+.+.}, at: pm_suspend+0xb3/0x3b0
 #4: ffffffff826b3ee0 (acpi_scan_lock){+.+.}, at: acpi_suspend_begin+0x47/0x80
 #5: ffff888178fc3960 (&dev->mutex){....}, at: device_resume+0x92/0x1c0

stack backtrace:
CPU: 3 PID: 4315 Comm: rtcwake Tainted: G     U            5.6.0-rc2-CI-CI_DRM_7981+ #1
Hardware name: Google Soraka/Soraka, BIOS MrChromebox-4.10 08/25/2019
Call Trace:
 dump_stack+0x71/0x9b
 mark_lock+0x49a/0x500
 ? print_shortest_lock_dependencies+0x200/0x200
 __lock_acquire+0x6d4/0x15d0
 ? __lock_acquire+0x460/0x15d0
 lock_acquire+0xa7/0x1c0
 ? cmos_interrupt+0x18/0x100
 _raw_spin_lock+0x2a/0x40
 ? cmos_interrupt+0x18/0x100
 cmos_interrupt+0x18/0x100
 cmos_resume+0x1fd/0x290
 ? __acpi_pm_set_device_wakeup+0x24/0x100
 pnp_bus_resume+0x5e/0x90
 ? pnp_bus_suspend+0x10/0x10
 dpm_run_callback+0x64/0x280
 device_resume+0xd4/0x1c0
 ? dpm_watchdog_set+0x60/0x60
 dpm_resume+0x106/0x410
 ? dpm_resume_early+0x38c/0x3e0
 dpm_resume_end+0x8/0x10
 suspend_devices_and_enter+0x16f/0xbe0
 ? rcu_read_lock_sched_held+0x4d/0x80
 pm_suspend+0x344/0x3b0
 state_store+0x78/0xe0
 kernfs_fop_write+0x112/0x1b0
 vfs_write+0xb9/0x1d0
 ksys_write+0x9f/0xe0
 do_syscall_64+0x4f/0x220
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7ff934307154
Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 b1 07 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5
RSP: 002b:00007ffe2647c168 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007ff934307154
RDX: 0000000000000004 RSI: 000055de3ec4e5a0 RDI: 000000000000000a
RBP: 000055de3ec4e5a0 R08: 000055de3ec4c5e0 R09: 00007ff9349f3740
R10: 000055de3ec4a010 R11: 0000000000000246 R12: 000055de3ec4c500
R13: 0000000000000004 R14: 00007ff9345df2a0 R15: 00007ff9345de760

Fixes: c6d3a278cc12 ("rtc: cmos: acknowledge ACPI driven wake alarms upon resume")
Fixes: 311ee9c151ad ("rtc: cmos: allow using ACPI for RTC alarm instead of HPET")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/20200221144739.11746-1-ville.syrjala@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index cb28bbdc9e17f..ecbe89b039ee6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -649,10 +649,11 @@ static struct cmos_rtc	cmos_rtc;
 
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
+	unsigned long	flags;
 	u8		irqstat;
 	u8		rtc_control;
 
-	spin_lock(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/* When the HPET interrupt handler calls us, the interrupt
 	 * status is passed as arg1 instead of the irq number.  But
@@ -686,7 +687,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
-- 
2.20.1

