Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515D21B67D0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgDWXJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50666 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728618AbgDWXGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:55 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvh-0004up-Ua; Fri, 24 Apr 2020 00:06:50 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvd-00E71n-5C; Fri, 24 Apr 2020 00:06:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Peter Hurley" <peter@hurleysoftware.com>
Date:   Fri, 24 Apr 2020 00:07:26 +0100
Message-ID: <lsq.1587683028.590718838@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 219/245] tty: vt: Fix !TASK_RUNNING diagnostic
 warning from paste_selection()
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 61e86cc90af49cecef9c54ccea1f572fbcb695ac upstream.

Pasting text with gpm on a VC produced warning [1]. Reset task state
to TASK_RUNNING in the paste_selection() loop, if the loop did not
sleep.

[1]
WARNING: CPU: 6 PID: 1960 at /home/peter/src/kernels/mainline/kernel/sched/core.c:7286 __might_sleep+0x7f/0x90()
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff8151805e>] paste_selection+0x9e/0x1a0
Modules linked in: btrfs xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c .....
CPU: 6 PID: 1960 Comm: gpm Not tainted 4.1.0-rc7+tty-xeon+debug #rc7+tty
Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
 ffffffff81c9c0a0 ffff8802b0fd3ac8 ffffffff8185778a 0000000000000001
 ffff8802b0fd3b18 ffff8802b0fd3b08 ffffffff8108039a ffffffff82ae8510
 ffffffff81c9ce00 0000000000000015 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8185778a>] dump_stack+0x4f/0x7b
 [<ffffffff8108039a>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff81080416>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810ddced>] ? __lock_acquire+0xe2d/0x13a0
 [<ffffffff8151805e>] ? paste_selection+0x9e/0x1a0
 [<ffffffff8151805e>] ? paste_selection+0x9e/0x1a0
 [<ffffffff810ad4ff>] __might_sleep+0x7f/0x90
 [<ffffffff8185f76a>] down_read+0x2a/0xa0
 [<ffffffff810bb1d8>] ? sched_clock_cpu+0xb8/0xe0
 [<ffffffff8150d1dc>] n_tty_receive_buf_common+0x4c/0xba0
 [<ffffffff810dc875>] ? mark_held_locks+0x75/0xa0
 [<ffffffff81861c95>] ? _raw_spin_unlock_irqrestore+0x65/0x80
 [<ffffffff810b49a1>] ? get_parent_ip+0x11/0x50
 [<ffffffff8150dd44>] n_tty_receive_buf2+0x14/0x20
 [<ffffffff81518117>] paste_selection+0x157/0x1a0
 [<ffffffff810b77b0>] ? wake_up_state+0x20/0x20
 [<ffffffff815203f8>] tioclinux+0xb8/0x2c0
 [<ffffffff81515bfe>] vt_ioctl+0xaee/0x11a0
 [<ffffffff810baf75>] ? sched_clock_local+0x25/0x90
 [<ffffffff810bbe11>] ? vtime_account_user+0x91/0xa0
 [<ffffffff8150810c>] tty_ioctl+0x20c/0xe20
 [<ffffffff810bbe11>] ? vtime_account_user+0x91/0xa0
 [<ffffffff810b49a1>] ? get_parent_ip+0x11/0x50
 [<ffffffff810b4a69>] ? preempt_count_sub+0x49/0x50
 [<ffffffff811ab71c>] ? context_tracking_exit+0x5c/0x290
 [<ffffffff811ab71c>] ? context_tracking_exit+0x5c/0x290
 [<ffffffff81248b98>] do_vfs_ioctl+0x318/0x570
 [<ffffffff810dca8d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff810dc9b5>] ? trace_hardirqs_on_caller+0x115/0x1e0
 [<ffffffff81254acc>] ? __fget_light+0x6c/0xa0
 [<ffffffff81248e71>] SyS_ioctl+0x81/0xa0
 [<ffffffff81862832>] system_call_fastpath+0x16/0x7a

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/vt/selection.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -356,6 +356,7 @@ int paste_selection(struct tty_struct *t
 			schedule();
 			continue;
 		}
+		__set_current_state(TASK_RUNNING);
 		count = sel_buffer_lth - pasted;
 		count = tty_ldisc_receive_buf(ld, sel_buffer + pasted, NULL,
 					      count);

