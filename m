Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9403534431E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhCVMsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhCVMpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C4A660C41;
        Mon, 22 Mar 2021 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416937;
        bh=QfKI6yQoe9slRkUT7coyMfC8efUgbwkBYlWPIGMqm3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaAKU347ufrU9kR5cKkBheUZTH5W+moNA8Z06ZtrPYm6uSyZhqPGzyy/DfrqtBu7t
         +Cp2yisDWdhCdjKH6gwJPL+5EEL2wVJ+K71EYKwLTI180PZqF9OegcpX5ML/SfFiaf
         7JiULS7d22VzNTyA/JOBy9QkAP9Cj0oG1F8ehZy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Korty <joe.korty@concurrent-rt.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 23/60] NFSD: Repair misuse of sv_lock in 5.10.16-rt30.
Date:   Mon, 22 Mar 2021 13:28:11 +0100
Message-Id: <20210322121923.143455870@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Korty <joe.korty@concurrent-rt.com>

commit c7de87ff9dac5f396f62d584f3908f80ddc0e07b upstream.

[ This problem is in mainline, but only rt has the chops to be
able to detect it. ]

Lockdep reports a circular lock dependency between serv->sv_lock and
softirq_ctl.lock on system shutdown, when using a kernel built with
CONFIG_PREEMPT_RT=y, and a nfs mount exists.

This is due to the definition of spin_lock_bh on rt:

	local_bh_disable();
	rt_spin_lock(lock);

which forces a softirq_ctl.lock -> serv->sv_lock dependency.  This is
not a problem as long as _every_ lock of serv->sv_lock is a:

	spin_lock_bh(&serv->sv_lock);

but there is one of the form:

	spin_lock(&serv->sv_lock);

This is what is causing the circular dependency splat.  The spin_lock()
grabs the lock without first grabbing softirq_ctl.lock via local_bh_disable.
If later on in the critical region,  someone does a local_bh_disable, we
get a serv->sv_lock -> softirq_ctrl.lock dependency established.  Deadlock.

Fix is to make serv->sv_lock be locked with spin_lock_bh everywhere, no
exceptions.

[  OK  ] Stopped target NFS client services.
         Stopping Logout off all iSCSI sessions on shutdown...
         Stopping NFS server and services...
[  109.442380]
[  109.442385] ======================================================
[  109.442386] WARNING: possible circular locking dependency detected
[  109.442387] 5.10.16-rt30 #1 Not tainted
[  109.442389] ------------------------------------------------------
[  109.442390] nfsd/1032 is trying to acquire lock:
[  109.442392] ffff994237617f60 ((softirq_ctrl.lock).lock){+.+.}-{2:2}, at: __local_bh_disable_ip+0xd9/0x270
[  109.442405]
[  109.442405] but task is already holding lock:
[  109.442406] ffff994245cb00b0 (&serv->sv_lock){+.+.}-{0:0}, at: svc_close_list+0x1f/0x90
[  109.442415]
[  109.442415] which lock already depends on the new lock.
[  109.442415]
[  109.442416]
[  109.442416] the existing dependency chain (in reverse order) is:
[  109.442417]
[  109.442417] -> #1 (&serv->sv_lock){+.+.}-{0:0}:
[  109.442421]        rt_spin_lock+0x2b/0xc0
[  109.442428]        svc_add_new_perm_xprt+0x42/0xa0
[  109.442430]        svc_addsock+0x135/0x220
[  109.442434]        write_ports+0x4b3/0x620
[  109.442438]        nfsctl_transaction_write+0x45/0x80
[  109.442440]        vfs_write+0xff/0x420
[  109.442444]        ksys_write+0x4f/0xc0
[  109.442446]        do_syscall_64+0x33/0x40
[  109.442450]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  109.442454]
[  109.442454] -> #0 ((softirq_ctrl.lock).lock){+.+.}-{2:2}:
[  109.442457]        __lock_acquire+0x1264/0x20b0
[  109.442463]        lock_acquire+0xc2/0x400
[  109.442466]        rt_spin_lock+0x2b/0xc0
[  109.442469]        __local_bh_disable_ip+0xd9/0x270
[  109.442471]        svc_xprt_do_enqueue+0xc0/0x4d0
[  109.442474]        svc_close_list+0x60/0x90
[  109.442476]        svc_close_net+0x49/0x1a0
[  109.442478]        svc_shutdown_net+0x12/0x40
[  109.442480]        nfsd_destroy+0xc5/0x180
[  109.442482]        nfsd+0x1bc/0x270
[  109.442483]        kthread+0x194/0x1b0
[  109.442487]        ret_from_fork+0x22/0x30
[  109.442492]
[  109.442492] other info that might help us debug this:
[  109.442492]
[  109.442493]  Possible unsafe locking scenario:
[  109.442493]
[  109.442493]        CPU0                    CPU1
[  109.442494]        ----                    ----
[  109.442495]   lock(&serv->sv_lock);
[  109.442496]                                lock((softirq_ctrl.lock).lock);
[  109.442498]                                lock(&serv->sv_lock);
[  109.442499]   lock((softirq_ctrl.lock).lock);
[  109.442501]
[  109.442501]  *** DEADLOCK ***
[  109.442501]
[  109.442501] 3 locks held by nfsd/1032:
[  109.442503]  #0: ffffffff93b49258 (nfsd_mutex){+.+.}-{3:3}, at: nfsd+0x19a/0x270
[  109.442508]  #1: ffff994245cb00b0 (&serv->sv_lock){+.+.}-{0:0}, at: svc_close_list+0x1f/0x90
[  109.442512]  #2: ffffffff93a81b20 (rcu_read_lock){....}-{1:2}, at: rt_spin_lock+0x5/0xc0
[  109.442518]
[  109.442518] stack backtrace:
[  109.442519] CPU: 0 PID: 1032 Comm: nfsd Not tainted 5.10.16-rt30 #1
[  109.442522] Hardware name: Supermicro X9DRL-3F/iF/X9DRL-3F/iF, BIOS 3.2 09/22/2015
[  109.442524] Call Trace:
[  109.442527]  dump_stack+0x77/0x97
[  109.442533]  check_noncircular+0xdc/0xf0
[  109.442546]  __lock_acquire+0x1264/0x20b0
[  109.442553]  lock_acquire+0xc2/0x400
[  109.442564]  rt_spin_lock+0x2b/0xc0
[  109.442570]  __local_bh_disable_ip+0xd9/0x270
[  109.442573]  svc_xprt_do_enqueue+0xc0/0x4d0
[  109.442577]  svc_close_list+0x60/0x90
[  109.442581]  svc_close_net+0x49/0x1a0
[  109.442585]  svc_shutdown_net+0x12/0x40
[  109.442588]  nfsd_destroy+0xc5/0x180
[  109.442590]  nfsd+0x1bc/0x270
[  109.442595]  kthread+0x194/0x1b0
[  109.442600]  ret_from_fork+0x22/0x30
[  109.518225] nfsd: last server has exited, flushing export cache
[  OK  ] Stopped NFSv4 ID-name mapping service.
[  OK  ] Stopped GSSAPI Proxy Daemon.
[  OK  ] Stopped NFS Mount Daemon.
[  OK  ] Stopped NFS status monitor for NFSv2/3 locking..

Fixes: 719f8bcc883e ("svcrpc: fix xpt_list traversal locking on shutdown")
Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc_xprt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1072,7 +1072,7 @@ static int svc_close_list(struct svc_ser
 	struct svc_xprt *xprt;
 	int ret = 0;
 
-	spin_lock(&serv->sv_lock);
+	spin_lock_bh(&serv->sv_lock);
 	list_for_each_entry(xprt, xprt_list, xpt_list) {
 		if (xprt->xpt_net != net)
 			continue;
@@ -1080,7 +1080,7 @@ static int svc_close_list(struct svc_ser
 		set_bit(XPT_CLOSE, &xprt->xpt_flags);
 		svc_xprt_enqueue(xprt);
 	}
-	spin_unlock(&serv->sv_lock);
+	spin_unlock_bh(&serv->sv_lock);
 	return ret;
 }
 


