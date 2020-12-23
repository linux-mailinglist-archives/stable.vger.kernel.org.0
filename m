Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CEE2E1652
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgLWCSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgLWCSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4097F22955;
        Wed, 23 Dec 2020 02:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689834;
        bh=hCW/it/g77Aj7RN5m1MC9PS3Hvxp3zWGZFGJpeXSXkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f93wvcqtSjlL4/EwC2i9qJ5EymyghpD7pkONMrdVQrR9P/uyHiuIqi8ubPiF15zkX
         VZ3GmDnitVjZRbmswMS3YBk9ZHmJjCuI79p7fcoBmG8F+W3gnj97IRvWIeFBT3YTMd
         r0vJbU5RfjiBnkZunUNNQwP29q1l57Gb348GEyG43hI2hxRAtQNwCWoiMXlt22v42m
         UGsrxlAflNA7Bk5pI0RUDNeCvkBDQck7Yn9+6euDqwXffU08zwvckPlpRiqKlF8Rhc
         JtehtDlY6OVjdGKvsVV5z5L6O0F+LBWhauOsDa04ZVH3sJCcXtS2sxUk+gLS1kgqPk
         rwt8Zjc18XTwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        syzbot+22e87cdf94021b984aa6@syzkaller.appspotmail.com,
        syzbot+c5e32344981ad9f33750@syzkaller.appspotmail.com,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 035/217] fcntl: Fix potential deadlock in send_sig{io, urg}()
Date:   Tue, 22 Dec 2020 21:13:24 -0500
Message-Id: <20201223021626.2790791-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 8d1ddb5e79374fb277985a6b3faa2ed8631c5b4c ]

Syzbot reports a potential deadlock found by the newly added recursive
read deadlock detection in lockdep:

[...] ========================================================
[...] WARNING: possible irq lock inversion dependency detected
[...] 5.9.0-rc2-syzkaller #0 Not tainted
[...] --------------------------------------------------------
[...] syz-executor.1/10214 just changed the state of lock:
[...] ffff88811f506338 (&f->f_owner.lock){.+..}-{2:2}, at: send_sigurg+0x1d/0x200
[...] but this lock was taken by another, HARDIRQ-safe lock in the past:
[...]  (&dev->event_lock){-...}-{2:2}
[...]
[...]
[...] and interrupts could create inverse lock ordering between them.
[...]
[...]
[...] other info that might help us debug this:
[...] Chain exists of:
[...]   &dev->event_lock --> &new->fa_lock --> &f->f_owner.lock
[...]
[...]  Possible interrupt unsafe locking scenario:
[...]
[...]        CPU0                    CPU1
[...]        ----                    ----
[...]   lock(&f->f_owner.lock);
[...]                                local_irq_disable();
[...]                                lock(&dev->event_lock);
[...]                                lock(&new->fa_lock);
[...]   <Interrupt>
[...]     lock(&dev->event_lock);
[...]
[...]  *** DEADLOCK ***

The corresponding deadlock case is as followed:

	CPU 0		CPU 1		CPU 2
	read_lock(&fown->lock);
			spin_lock_irqsave(&dev->event_lock, ...)
					write_lock_irq(&filp->f_owner.lock); // wait for the lock
			read_lock(&fown-lock); // have to wait until the writer release
					       // due to the fairness
	<interrupted>
	spin_lock_irqsave(&dev->event_lock); // wait for the lock

The lock dependency on CPU 1 happens if there exists a call sequence:

	input_inject_event():
	  spin_lock_irqsave(&dev->event_lock,...);
	  input_handle_event():
	    input_pass_values():
	      input_to_handler():
	        handler->event(): // evdev_event()
	          evdev_pass_values():
	            spin_lock(&client->buffer_lock);
	            __pass_event():
	              kill_fasync():
	                kill_fasync_rcu():
	                  read_lock(&fa->fa_lock);
	                  send_sigio():
	                    read_lock(&fown->lock);

To fix this, make the reader in send_sigurg() and send_sigio() use
read_lock_irqsave() and read_lock_irqrestore().

Reported-by: syzbot+22e87cdf94021b984aa6@syzkaller.appspotmail.com
Reported-by: syzbot+c5e32344981ad9f33750@syzkaller.appspotmail.com
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 19ac5baad50fd..05b36b28f2e87 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -781,9 +781,10 @@ void send_sigio(struct fown_struct *fown, int fd, int band)
 {
 	struct task_struct *p;
 	enum pid_type type;
+	unsigned long flags;
 	struct pid *pid;
 	
-	read_lock(&fown->lock);
+	read_lock_irqsave(&fown->lock, flags);
 
 	type = fown->pid_type;
 	pid = fown->pid;
@@ -804,7 +805,7 @@ void send_sigio(struct fown_struct *fown, int fd, int band)
 		read_unlock(&tasklist_lock);
 	}
  out_unlock_fown:
-	read_unlock(&fown->lock);
+	read_unlock_irqrestore(&fown->lock, flags);
 }
 
 static void send_sigurg_to_task(struct task_struct *p,
@@ -819,9 +820,10 @@ int send_sigurg(struct fown_struct *fown)
 	struct task_struct *p;
 	enum pid_type type;
 	struct pid *pid;
+	unsigned long flags;
 	int ret = 0;
 	
-	read_lock(&fown->lock);
+	read_lock_irqsave(&fown->lock, flags);
 
 	type = fown->pid_type;
 	pid = fown->pid;
@@ -844,7 +846,7 @@ int send_sigurg(struct fown_struct *fown)
 		read_unlock(&tasklist_lock);
 	}
  out_unlock_fown:
-	read_unlock(&fown->lock);
+	read_unlock_irqrestore(&fown->lock, flags);
 	return ret;
 }
 
-- 
2.27.0

