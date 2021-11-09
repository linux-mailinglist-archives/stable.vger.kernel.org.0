Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE044B6F5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344868AbhKIWay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344899AbhKIW2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C528161A60;
        Tue,  9 Nov 2021 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496435;
        bh=VkGIgQI/Q4vnAShDJpYhnKrHk+3p99DTLWYI3OrhNnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij1lC7bwR3NahGoDXSODhlTneeMTlCgWO9tsZhGM0WE/GDD5YTsDLOaioRk5PGUoe
         QlFn46zMYkb8ZoJ/35k+xyIB7XwL7xpBnzTcQCZPP8giInDA0ZHd7PozsSSc53tu1D
         s1j+3f280FS9dj/uFLq/nC27+YCi78g1YpHdKCEwCbinbkoZSt/pVImFKb5xBw2642
         Dg1bWy9KAXMBvbVoR4QqiEDbl6fVxI8nw7ZnkjJK+uawNAgNspMZeJDziNFFXhX9lu
         KWMoGe+YqEtwK1RhxxgyPeh0VeeWHr11L+SaLC6KwTOl1Y/JNFRgSRZ2rxxwrLXuzc
         5Ismgqr0LIDUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guanghui Feng <guanghuifeng@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jslaby@suse.com
Subject: [PATCH AUTOSEL 5.14 56/75] tty: tty_buffer: Fix the softlockup issue in flush_to_ldisc
Date:   Tue,  9 Nov 2021 17:18:46 -0500
Message-Id: <20211109221905.1234094-56-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 3968ddcf05fb4b9409cd1859feb06a5b0550a1c1 ]

When running ltp testcase(ltp/testcases/kernel/pty/pty04.c) with arm64, there is a soft lockup,
which look like this one:

  Workqueue: events_unbound flush_to_ldisc
  Call trace:
   dump_backtrace+0x0/0x1ec
   show_stack+0x24/0x30
   dump_stack+0xd0/0x128
   panic+0x15c/0x374
   watchdog_timer_fn+0x2b8/0x304
   __run_hrtimer+0x88/0x2c0
   __hrtimer_run_queues+0xa4/0x120
   hrtimer_interrupt+0xfc/0x270
   arch_timer_handler_phys+0x40/0x50
   handle_percpu_devid_irq+0x94/0x220
   __handle_domain_irq+0x88/0xf0
   gic_handle_irq+0x84/0xfc
   el1_irq+0xc8/0x180
   slip_unesc+0x80/0x214 [slip]
   tty_ldisc_receive_buf+0x64/0x80
   tty_port_default_receive_buf+0x50/0x90
   flush_to_ldisc+0xbc/0x110
   process_one_work+0x1d4/0x4b0
   worker_thread+0x180/0x430
   kthread+0x11c/0x120

In the testcase pty04, The first process call the write syscall to send
data to the pty master. At the same time, the workqueue will do the
flush_to_ldisc to pop data in a loop until there is no more data left.
When the sender and workqueue running in different core, the sender sends
data fastly in full time which will result in workqueue doing work in loop
for a long time and occuring softlockup in flush_to_ldisc with kernel
configured without preempt. So I add need_resched check and cond_resched
in the flush_to_ldisc loop to avoid it.

Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Link: https://lore.kernel.org/r/1633961304-24759-1-git-send-email-guanghuifeng@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_buffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 635d0af229b72..6c7e65b1d9a1c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -544,6 +544,9 @@ static void flush_to_ldisc(struct work_struct *work)
 		if (!count)
 			break;
 		head->read += count;
+
+		if (need_resched())
+			cond_resched();
 	}
 
 	mutex_unlock(&buf->lock);
-- 
2.33.0

