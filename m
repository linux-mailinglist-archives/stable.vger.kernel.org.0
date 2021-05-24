Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E610A38EF08
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhEXPzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234194AbhEXPyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6025461400;
        Mon, 24 May 2021 15:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870779;
        bh=PUcFZFfMlxrF6KIC44lRkzF2bo/Fg2nBQPLL+pmSMp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6vn1Bu6Fs4QRqofPhPzcVHvU3GG2pyJ0O7m7YiMwUDimXIWqbfXbofPkMZccm3rn
         0dEv9Np26fBEOjGciWp7uirNuf4xb1lNPeQNSVQT5kewC2uPbvpTH9V+nua3XPW1pn
         Yd5bTyLNsuZxJyIs/7zhpw93LBqLVkKeGm/z78Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 031/104] btrfs: avoid RCU stalls while running delayed iputs
Date:   Mon, 24 May 2021 17:25:26 +0200
Message-Id: <20210524152333.849600830@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 71795ee590111e3636cc3c148289dfa9fa0a5fc3 upstream.

Generally a delayed iput is added when we might do the final iput, so
usually we'll end up sleeping while processing the delayed iputs
naturally.  However there's no guarantee of this, especially for small
files.  In production we noticed 5 instances of RCU stalls while testing
a kernel release overnight across 1000 machines, so this is relatively
common:

  host count: 5
  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: ....: (20998 ticks this GP) idle=59e/1/0x4000000000000002 softirq=12333372/12333372 fqs=3208
   	(t=21031 jiffies g=27810193 q=41075) NMI backtrace for cpu 1
  CPU: 1 PID: 1713 Comm: btrfs-cleaner Kdump: loaded Not tainted 5.6.13-0_fbk12_rc1_5520_gec92bffc1ec9 #1
  Call Trace:
    <IRQ> dump_stack+0x50/0x70
    nmi_cpu_backtrace.cold.6+0x30/0x65
    ? lapic_can_unplug_cpu.cold.30+0x40/0x40
    nmi_trigger_cpumask_backtrace+0xba/0xca
    rcu_dump_cpu_stacks+0x99/0xc7
    rcu_sched_clock_irq.cold.90+0x1b2/0x3a3
    ? trigger_load_balance+0x5c/0x200
    ? tick_sched_do_timer+0x60/0x60
    ? tick_sched_do_timer+0x60/0x60
    update_process_times+0x24/0x50
    tick_sched_timer+0x37/0x70
    __hrtimer_run_queues+0xfe/0x270
    hrtimer_interrupt+0xf4/0x210
    smp_apic_timer_interrupt+0x5e/0x120
    apic_timer_interrupt+0xf/0x20 </IRQ>
   RIP: 0010:queued_spin_lock_slowpath+0x17d/0x1b0
   RSP: 0018:ffffc9000da5fe48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
   RAX: 0000000000000000 RBX: ffff889fa81d0cd8 RCX: 0000000000000029
   RDX: ffff889fff86c0c0 RSI: 0000000000080000 RDI: ffff88bfc2da7200
   RBP: ffff888f2dcdd768 R08: 0000000001040000 R09: 0000000000000000
   R10: 0000000000000001 R11: ffffffff82a55560 R12: ffff88bfc2da7200
   R13: 0000000000000000 R14: ffff88bff6c2a360 R15: ffffffff814bd870
   ? kzalloc.constprop.57+0x30/0x30
   list_lru_add+0x5a/0x100
   inode_lru_list_add+0x20/0x40
   iput+0x1c1/0x1f0
   run_delayed_iput_locked+0x46/0x90
   btrfs_run_delayed_iputs+0x3f/0x60
   cleaner_kthread+0xf2/0x120
   kthread+0x10b/0x130

Fix this by adding a cond_resched_lock() to the loop processing delayed
iputs so we can avoid these sort of stalls.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2967,6 +2967,7 @@ void btrfs_run_delayed_iputs(struct btrf
 		inode = list_first_entry(&fs_info->delayed_iputs,
 				struct btrfs_inode, delayed_iput);
 		run_delayed_iput_locked(fs_info, inode);
+		cond_resched_lock(&fs_info->delayed_iput_lock);
 	}
 	spin_unlock(&fs_info->delayed_iput_lock);
 }


