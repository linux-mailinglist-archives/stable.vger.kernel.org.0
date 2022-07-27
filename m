Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA1582B89
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiG0QfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237301AbiG0Qds (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB7E4D4C2;
        Wed, 27 Jul 2022 09:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB26619FD;
        Wed, 27 Jul 2022 16:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFDCC433C1;
        Wed, 27 Jul 2022 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939156;
        bh=TaTB8GRVljmqGovaTLx5QRJ/B7bQxZgLx0Nf/yBLeLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+cb1140ZcSUceUi/P42dImNcPFLjT5uehstrdg0VnGYEVsJc4opllTH5fdcARoV2
         M5fTibyPNGf3Q0z2lK30ELRj60C5Pb9MhLhHxEcl6Tdg1ADQWl5h/TG4voY4+nelZY
         78SGQl0EcT1gnTW6ckPBjBOdvlZMtXTr/TeSRqys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Qian Cai <cai@lca.pw>,
        Lech Perczak <l.perczak@camlintechnologies.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        kernel test robot <oliver.sang@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 33/62] Revert "Revert "char/random: silence a lockdep splat with printk()""
Date:   Wed, 27 Jul 2022 18:10:42 +0200
Message-Id: <20220727161005.505206431@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

In 2019, Sergey fixed a lockdep splat with 15341b1dd409 ("char/random:
silence a lockdep splat with printk()"), but that got reverted soon
after from 4.19 because back then it apparently caused various problems.
But the issue it was fixing is still there, and more generally, many
patches turning printk() into printk_deferred() have landed since,
making me suspect it's okay to try this out again.

This should fix the following deadlock found by the kernel test robot:

[   18.287691] WARNING: possible circular locking dependency detected
[   18.287692] 4.19.248-00165-g3d1f971aa81f #1 Not tainted
[   18.287693] ------------------------------------------------------
[   18.287712] stop/202 is trying to acquire lock:
[   18.287713] (ptrval) (console_owner){..-.}, at: console_unlock (??:?)
[   18.287717]
[   18.287718] but task is already holding lock:
[   18.287718] (ptrval) (&(&port->lock)->rlock){-...}, at: pty_write (pty.c:?)
[   18.287722]
[   18.287722] which lock already depends on the new lock.
[   18.287723]
[   18.287724]
[   18.287725] the existing dependency chain (in reverse order) is:
[   18.287725]
[   18.287726] -> #2 (&(&port->lock)->rlock){-...}:
[   18.287729] validate_chain+0x84a/0xe00
[   18.287729] __lock_acquire (lockdep.c:?)
[   18.287730] lock_acquire (??:?)
[   18.287731] _raw_spin_lock_irqsave (??:?)
[   18.287732] tty_port_tty_get (??:?)
[   18.287733] tty_port_default_wakeup (tty_port.c:?)
[   18.287734] tty_port_tty_wakeup (??:?)
[   18.287734] uart_write_wakeup (??:?)
[   18.287735] serial8250_tx_chars (??:?)
[   18.287736] serial8250_handle_irq (??:?)
[   18.287737] serial8250_default_handle_irq (8250_port.c:?)
[   18.287738] serial8250_interrupt (8250_core.c:?)
[   18.287738] __handle_irq_event_percpu (??:?)
[   18.287739] handle_irq_event_percpu (??:?)
[   18.287740] handle_irq_event (??:?)
[   18.287741] handle_edge_irq (??:?)
[   18.287742] handle_irq (??:?)
[   18.287742] do_IRQ (??:?)
[   18.287743] common_interrupt (entry_32.o:?)
[   18.287744] _raw_spin_unlock_irqrestore (??:?)
[   18.287745] uart_write (serial_core.c:?)
[   18.287746] process_output_block (n_tty.c:?)
[   18.287747] n_tty_write (n_tty.c:?)
[   18.287747] tty_write (tty_io.c:?)
[   18.287748] __vfs_write (??:?)
[   18.287749] vfs_write (??:?)
[   18.287750] ksys_write (??:?)
[   18.287750] sys_write (??:?)
[   18.287751] do_fast_syscall_32 (??:?)
[   18.287752] entry_SYSENTER_32 (??:?)
[   18.287752]
[   18.287753] -> #1 (&port_lock_key){-.-.}:
[   18.287756]
[   18.287756] -> #0 (console_owner){..-.}:
[   18.287759] check_prevs_add (lockdep.c:?)
[   18.287760] validate_chain+0x84a/0xe00
[   18.287761] __lock_acquire (lockdep.c:?)
[   18.287761] lock_acquire (??:?)
[   18.287762] console_unlock (??:?)
[   18.287763] vprintk_emit (??:?)
[   18.287764] vprintk_default (??:?)
[   18.287764] vprintk_func (??:?)
[   18.287765] printk (??:?)
[   18.287766] get_random_u32 (??:?)
[   18.287767] shuffle_freelist (slub.c:?)
[   18.287767] allocate_slab (slub.c:?)
[   18.287768] new_slab (slub.c:?)
[   18.287769] ___slab_alloc+0x6d0/0xb20
[   18.287770] __slab_alloc+0xd6/0x2e0
[   18.287770] __kmalloc (??:?)
[   18.287771] tty_buffer_alloc (tty_buffer.c:?)
[   18.287772] __tty_buffer_request_room (tty_buffer.c:?)
[   18.287773] tty_insert_flip_string_fixed_flag (??:?)
[   18.287774] pty_write (pty.c:?)
[   18.287775] process_output_block (n_tty.c:?)
[   18.287776] n_tty_write (n_tty.c:?)
[   18.287777] tty_write (tty_io.c:?)
[   18.287778] __vfs_write (??:?)
[   18.287779] vfs_write (??:?)
[   18.287780] ksys_write (??:?)
[   18.287780] sys_write (??:?)
[   18.287781] do_fast_syscall_32 (??:?)
[   18.287782] entry_SYSENTER_32 (??:?)
[   18.287783]
[   18.287783] other info that might help us debug this:
[   18.287784]
[   18.287785] Chain exists of:
[   18.287785]   console_owner --> &port_lock_key --> &(&port->lock)->rlock
[   18.287789]
[   18.287790]  Possible unsafe locking scenario:
[   18.287790]
[   18.287791]        CPU0                    CPU1
[   18.287792]        ----                    ----
[   18.287792]   lock(&(&port->lock)->rlock);
[   18.287794]                                lock(&port_lock_key);
[   18.287814]                                lock(&(&port->lock)->rlock);
[   18.287815]   lock(console_owner);
[   18.287817]
[   18.287818]  *** DEADLOCK ***
[   18.287818]
[   18.287819] 6 locks held by stop/202:
[   18.287820] #0: (ptrval) (&tty->ldisc_sem){++++}, at: ldsem_down_read (??:?)
[   18.287823] #1: (ptrval) (&tty->atomic_write_lock){+.+.}, at: tty_write_lock (tty_io.c:?)
[   18.287826] #2: (ptrval) (&o_tty->termios_rwsem/1){++++}, at: n_tty_write (n_tty.c:?)
[   18.287830] #3: (ptrval) (&ldata->output_lock){+.+.}, at: process_output_block (n_tty.c:?)
[   18.287834] #4: (ptrval) (&(&port->lock)->rlock){-...}, at: pty_write (pty.c:?)
[   18.287838] #5: (ptrval) (console_lock){+.+.}, at: console_trylock_spinning (printk.c:?)
[   18.287841]
[   18.287842] stack backtrace:
[   18.287843] CPU: 0 PID: 202 Comm: stop Not tainted 4.19.248-00165-g3d1f971aa81f #1
[   18.287843] Call Trace:
[   18.287844] dump_stack (??:?)
[   18.287845] print_circular_bug.cold+0x78/0x8b
[   18.287846] check_prev_add+0x66a/0xd20
[   18.287847] check_prevs_add (lockdep.c:?)
[   18.287848] validate_chain+0x84a/0xe00
[   18.287848] __lock_acquire (lockdep.c:?)
[   18.287849] lock_acquire (??:?)
[   18.287850] ? console_unlock (??:?)
[   18.287851] console_unlock (??:?)
[   18.287851] ? console_unlock (??:?)
[   18.287852] ? native_save_fl (??:?)
[   18.287853] vprintk_emit (??:?)
[   18.287854] vprintk_default (??:?)
[   18.287855] vprintk_func (??:?)
[   18.287855] printk (??:?)
[   18.287856] get_random_u32 (??:?)
[   18.287857] ? shuffle_freelist (slub.c:?)
[   18.287858] shuffle_freelist (slub.c:?)
[   18.287858] ? page_address (??:?)
[   18.287859] allocate_slab (slub.c:?)
[   18.287860] new_slab (slub.c:?)
[   18.287861] ? pvclock_clocksource_read (??:?)
[   18.287862] ___slab_alloc+0x6d0/0xb20
[   18.287862] ? kvm_sched_clock_read (kvmclock.c:?)
[   18.287863] ? __slab_alloc+0xbc/0x2e0
[   18.287864] ? native_wbinvd (paravirt.c:?)
[   18.287865] __slab_alloc+0xd6/0x2e0
[   18.287865] __kmalloc (??:?)
[   18.287866] ? __lock_acquire (lockdep.c:?)
[   18.287867] ? tty_buffer_alloc (tty_buffer.c:?)
[   18.287868] tty_buffer_alloc (tty_buffer.c:?)
[   18.287869] __tty_buffer_request_room (tty_buffer.c:?)
[   18.287869] tty_insert_flip_string_fixed_flag (??:?)
[   18.287870] pty_write (pty.c:?)
[   18.287871] process_output_block (n_tty.c:?)
[   18.287872] n_tty_write (n_tty.c:?)
[   18.287873] ? print_dl_stats (??:?)
[   18.287874] ? n_tty_ioctl (n_tty.c:?)
[   18.287874] tty_write (tty_io.c:?)
[   18.287875] ? n_tty_ioctl (n_tty.c:?)
[   18.287876] ? tty_write_unlock (tty_io.c:?)
[   18.287877] __vfs_write (??:?)
[   18.287877] vfs_write (??:?)
[   18.287878] ? __fget_light (file.c:?)
[   18.287879] ksys_write (??:?)

Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Lech Perczak <l.perczak@camlintechnologies.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: John Ogness <john.ogness@linutronix.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/lkml/Ytz+lo4zRQYG3JUR@xsang-OptiPlex-9020
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -183,8 +183,8 @@ static void __cold process_random_ready_
 
 #define warn_unseeded_randomness() \
 	if (IS_ENABLED(CONFIG_WARN_ALL_UNSEEDED_RANDOM) && !crng_ready()) \
-		pr_notice("%s called from %pS with crng_init=%d\n", \
-			  __func__, (void *)_RET_IP_, crng_init)
+		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n", \
+				__func__, (void *)_RET_IP_, crng_init)
 
 
 /*********************************************************************


