Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1528150AFE
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgBCQUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbgBCQUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:20:50 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EEC32080D;
        Mon,  3 Feb 2020 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580746849;
        bh=ioBHRb4V/QTF8R6bPGv5A7tgDqkiLs9xIG/676Q5g7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtCjSz3/twQ1etTPXk3TKNuwkzdMFXJPTRomh7c6mzpZv1v2lLKb5PDb/g3HVuerF
         fEflAo6noFf/rSeQtm9SeK0DWJ/l8xffZHbW7+GYhpaMeoYF8FGea74qf4KR/vze7D
         vW92+16SUVIO+CP9vRu4H/8BKSa9F9XxDsWQibms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2eeef62ee31f9460ad65@syzkaller.appspotmail.com,
        Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.4 31/53] ttyprintk: fix a potential deadlock in interrupt context issue
Date:   Mon,  3 Feb 2020 16:19:23 +0000
Message-Id: <20200203161908.701223007@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
References: <20200203161902.714326084@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

commit 9a655c77ff8fc65699a3f98e237db563b37c439b upstream.

tpk_write()/tpk_close() could be interrupted when holding a mutex, then
in timer handler tpk_write() may be called again trying to acquire same
mutex, lead to deadlock.

Google syzbot reported this issue with CONFIG_DEBUG_ATOMIC_SLEEP
enabled:

BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:938
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
1 lock held by swapper/1/0:
...
Call Trace:
  <IRQ>
  dump_stack+0x197/0x210
  ___might_sleep.cold+0x1fb/0x23e
  __might_sleep+0x95/0x190
  __mutex_lock+0xc5/0x13c0
  mutex_lock_nested+0x16/0x20
  tpk_write+0x5d/0x340
  resync_tnc+0x1b6/0x320
  call_timer_fn+0x1ac/0x780
  run_timer_softirq+0x6c3/0x1790
  __do_softirq+0x262/0x98c
  irq_exit+0x19b/0x1e0
  smp_apic_timer_interrupt+0x1a3/0x610
  apic_timer_interrupt+0xf/0x20
  </IRQ>

See link https://syzkaller.appspot.com/bug?extid=2eeef62ee31f9460ad65 for
more details.

Fix it by using spinlock in process context instead of mutex and having
interrupt disabled in critical section.

Reported-by: syzbot+2eeef62ee31f9460ad65@syzkaller.appspotmail.com
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20200113034842.435-1-zhenzhong.duan@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ttyprintk.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -18,10 +18,11 @@
 #include <linux/serial.h>
 #include <linux/tty.h>
 #include <linux/module.h>
+#include <linux/spinlock.h>
 
 struct ttyprintk_port {
 	struct tty_port port;
-	struct mutex port_write_mutex;
+	spinlock_t spinlock;
 };
 
 static struct ttyprintk_port tpk_port;
@@ -107,11 +108,12 @@ static int tpk_open(struct tty_struct *t
 static void tpk_close(struct tty_struct *tty, struct file *filp)
 {
 	struct ttyprintk_port *tpkp = tty->driver_data;
+	unsigned long flags;
 
-	mutex_lock(&tpkp->port_write_mutex);
+	spin_lock_irqsave(&tpkp->spinlock, flags);
 	/* flush tpk_printk buffer */
 	tpk_printk(NULL, 0);
-	mutex_unlock(&tpkp->port_write_mutex);
+	spin_unlock_irqrestore(&tpkp->spinlock, flags);
 
 	tty_port_close(&tpkp->port, tty, filp);
 }
@@ -123,13 +125,14 @@ static int tpk_write(struct tty_struct *
 		const unsigned char *buf, int count)
 {
 	struct ttyprintk_port *tpkp = tty->driver_data;
+	unsigned long flags;
 	int ret;
 
 
 	/* exclusive use of tpk_printk within this tty */
-	mutex_lock(&tpkp->port_write_mutex);
+	spin_lock_irqsave(&tpkp->spinlock, flags);
 	ret = tpk_printk(buf, count);
-	mutex_unlock(&tpkp->port_write_mutex);
+	spin_unlock_irqrestore(&tpkp->spinlock, flags);
 
 	return ret;
 }
@@ -179,7 +182,7 @@ static int __init ttyprintk_init(void)
 {
 	int ret = -ENOMEM;
 
-	mutex_init(&tpk_port.port_write_mutex);
+	spin_lock_init(&tpk_port.spinlock);
 
 	ttyprintk_driver = tty_alloc_driver(1,
 			TTY_DRIVER_RESET_TERMIOS |


