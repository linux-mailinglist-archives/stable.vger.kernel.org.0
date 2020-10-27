Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A8E29AE36
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 14:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503997AbgJ0N6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753016AbgJ0N6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:58:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398492068D;
        Tue, 27 Oct 2020 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807086;
        bh=TeV0Txlh83tBG+QN8IwUa4jEh0uWbHD+kGWnEEdWiqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAduVHkWjW3exh6pOcgxFNuwcr42aS3A0Jibsc5nYk4TmFSb+cnGkB7fEGD+S1Hja
         8+7RJ8C0jXdjP55LIq1dDGJ9ziG1BVexr30PGfS5QFdEEYxW/vECbbKwT8oz+ZUL11
         A+Q4nYrQlfT9WUKKPdmoJR6ytUqZZVP6l1Gj1nvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Savkov <asavkov@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 038/112] pty: do tty_flip_buffer_push without port->lock in pty_write
Date:   Tue, 27 Oct 2020 14:49:08 +0100
Message-Id: <20201027134902.360675185@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Artem Savkov <asavkov@redhat.com>

[ Upstream commit 71a174b39f10b4b93223d374722aa894b5d8a82e ]

b6da31b2c07c "tty: Fix data race in tty_insert_flip_string_fixed_flag"
puts tty_flip_buffer_push under port->lock introducing the following
possible circular locking dependency:

[30129.876566] ======================================================
[30129.876566] WARNING: possible circular locking dependency detected
[30129.876567] 5.9.0-rc2+ #3 Tainted: G S      W
[30129.876568] ------------------------------------------------------
[30129.876568] sysrq.sh/1222 is trying to acquire lock:
[30129.876569] ffffffff92c39480 (console_owner){....}-{0:0}, at: console_unlock+0x3fe/0xa90

[30129.876572] but task is already holding lock:
[30129.876572] ffff888107cb9018 (&pool->lock/1){-.-.}-{2:2}, at: show_workqueue_state.cold.55+0x15b/0x6ca

[30129.876576] which lock already depends on the new lock.

[30129.876577] the existing dependency chain (in reverse order) is:

[30129.876578] -> #3 (&pool->lock/1){-.-.}-{2:2}:
[30129.876581]        _raw_spin_lock+0x30/0x70
[30129.876581]        __queue_work+0x1a3/0x10f0
[30129.876582]        queue_work_on+0x78/0x80
[30129.876582]        pty_write+0x165/0x1e0
[30129.876583]        n_tty_write+0x47f/0xf00
[30129.876583]        tty_write+0x3d6/0x8d0
[30129.876584]        vfs_write+0x1a8/0x650

[30129.876588] -> #2 (&port->lock#2){-.-.}-{2:2}:
[30129.876590]        _raw_spin_lock_irqsave+0x3b/0x80
[30129.876591]        tty_port_tty_get+0x1d/0xb0
[30129.876592]        tty_port_default_wakeup+0xb/0x30
[30129.876592]        serial8250_tx_chars+0x3d6/0x970
[30129.876593]        serial8250_handle_irq.part.12+0x216/0x380
[30129.876593]        serial8250_default_handle_irq+0x82/0xe0
[30129.876594]        serial8250_interrupt+0xdd/0x1b0
[30129.876595]        __handle_irq_event_percpu+0xfc/0x850

[30129.876602] -> #1 (&port->lock){-.-.}-{2:2}:
[30129.876605]        _raw_spin_lock_irqsave+0x3b/0x80
[30129.876605]        serial8250_console_write+0x12d/0x900
[30129.876606]        console_unlock+0x679/0xa90
[30129.876606]        register_console+0x371/0x6e0
[30129.876607]        univ8250_console_init+0x24/0x27
[30129.876607]        console_init+0x2f9/0x45e

[30129.876609] -> #0 (console_owner){....}-{0:0}:
[30129.876611]        __lock_acquire+0x2f70/0x4e90
[30129.876612]        lock_acquire+0x1ac/0xad0
[30129.876612]        console_unlock+0x460/0xa90
[30129.876613]        vprintk_emit+0x130/0x420
[30129.876613]        printk+0x9f/0xc5
[30129.876614]        show_pwq+0x154/0x618
[30129.876615]        show_workqueue_state.cold.55+0x193/0x6ca
[30129.876615]        __handle_sysrq+0x244/0x460
[30129.876616]        write_sysrq_trigger+0x48/0x4a
[30129.876616]        proc_reg_write+0x1a6/0x240
[30129.876617]        vfs_write+0x1a8/0x650

[30129.876619] other info that might help us debug this:

[30129.876620] Chain exists of:
[30129.876621]   console_owner --> &port->lock#2 --> &pool->lock/1

[30129.876625]  Possible unsafe locking scenario:

[30129.876626]        CPU0                    CPU1
[30129.876626]        ----                    ----
[30129.876627]   lock(&pool->lock/1);
[30129.876628]                                lock(&port->lock#2);
[30129.876630]                                lock(&pool->lock/1);
[30129.876631]   lock(console_owner);

[30129.876633]  *** DEADLOCK ***

[30129.876634] 5 locks held by sysrq.sh/1222:
[30129.876634]  #0: ffff8881d3ce0470 (sb_writers#3){.+.+}-{0:0}, at: vfs_write+0x359/0x650
[30129.876637]  #1: ffffffff92c612c0 (rcu_read_lock){....}-{1:2}, at: __handle_sysrq+0x4d/0x460
[30129.876640]  #2: ffffffff92c612c0 (rcu_read_lock){....}-{1:2}, at: show_workqueue_state+0x5/0xf0
[30129.876642]  #3: ffff888107cb9018 (&pool->lock/1){-.-.}-{2:2}, at: show_workqueue_state.cold.55+0x15b/0x6ca
[30129.876645]  #4: ffffffff92c39980 (console_lock){+.+.}-{0:0}, at: vprintk_emit+0x123/0x420

[30129.876648] stack backtrace:
[30129.876649] CPU: 3 PID: 1222 Comm: sysrq.sh Tainted: G S      W         5.9.0-rc2+ #3
[30129.876649] Hardware name: Intel Corporation 2012 Client Platform/Emerald Lake 2, BIOS ACRVMBY1.86C.0078.P00.1201161002 01/16/2012
[30129.876650] Call Trace:
[30129.876650]  dump_stack+0x9d/0xe0
[30129.876651]  check_noncircular+0x34f/0x410
[30129.876653]  __lock_acquire+0x2f70/0x4e90
[30129.876656]  lock_acquire+0x1ac/0xad0
[30129.876658]  console_unlock+0x460/0xa90
[30129.876660]  vprintk_emit+0x130/0x420
[30129.876660]  printk+0x9f/0xc5
[30129.876661]  show_pwq+0x154/0x618
[30129.876662]  show_workqueue_state.cold.55+0x193/0x6ca
[30129.876664]  __handle_sysrq+0x244/0x460
[30129.876665]  write_sysrq_trigger+0x48/0x4a
[30129.876665]  proc_reg_write+0x1a6/0x240
[30129.876666]  vfs_write+0x1a8/0x650

It looks like the commit was aimed to protect tty_insert_flip_string and
there is no need for tty_flip_buffer_push to be under this lock.

Fixes: b6da31b2c07c ("tty: Fix data race in tty_insert_flip_string_fixed_flag")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20200902120045.3693075-1-asavkov@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/pty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index c8a2e5b0eff76..8ee146b14aae8 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -115,10 +115,10 @@ static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 		spin_lock_irqsave(&to->port->lock, flags);
 		/* Stuff the data into the input queue of the other end */
 		c = tty_insert_flip_string(to->port, buf, c);
+		spin_unlock_irqrestore(&to->port->lock, flags);
 		/* And shovel */
 		if (c)
 			tty_flip_buffer_push(to->port);
-		spin_unlock_irqrestore(&to->port->lock, flags);
 	}
 	return c;
 }
-- 
2.25.1



