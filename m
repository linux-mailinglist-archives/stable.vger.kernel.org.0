Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3783A8102
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 13:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfIDLXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 07:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfIDLXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 07:23:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ACA522CED;
        Wed,  4 Sep 2019 11:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567596221;
        bh=kNdT3Sdz9nEDkpbuhtRwb2sBGV3ARuXSIE2OIZTlIkU=;
        h=Subject:To:From:Date:From;
        b=Y3Kmo7B3tZnqgF62HkGfkNnnPAbfZxAEX0ILB232IoM+Er03Fo5qIsyLhpZeMvE0l
         6MlJCDKdaggvHiktLtMNLuYK+nFU5Cd55R5i0KtynGAx/8vbcfonItXE9FTT5fYsRN
         e8NaSy85k74ZfEYRclrPt7AS4Ikglo+/pxYnhAh8=
Subject: patch "/dev/mem: Bail out upon SIGKILL." added to char-misc-testing
To:     penguin-kernel@I-love.SAKURA.ne.jp, gregkh@linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Sep 2019 13:23:39 +0200
Message-ID: <15675962191711@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    /dev/mem: Bail out upon SIGKILL.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e1b19733d5a9e0aed3f5594a51b21601b4618578 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 26 Aug 2019 22:13:25 +0900
Subject: /dev/mem: Bail out upon SIGKILL.

syzbot found that a thread can stall for minutes inside read_mem() or
write_mem() after that thread was killed by SIGKILL [1]. Reading from
iomem areas of /dev/mem can be slow, depending on the hardware.
While reading 2GB at one read() is legal, delaying termination of killed
thread for minutes is bad. Thus, allow reading/writing /dev/mem and
/dev/kmem to be preemptible and killable.

  [ 1335.912419][T20577] read_mem: sz=4096 count=2134565632
  [ 1335.943194][T20577] read_mem: sz=4096 count=2134561536
  [ 1335.978280][T20577] read_mem: sz=4096 count=2134557440
  [ 1336.011147][T20577] read_mem: sz=4096 count=2134553344
  [ 1336.041897][T20577] read_mem: sz=4096 count=2134549248

Theoretically, reading/writing /dev/mem and /dev/kmem can become
"interruptible". But this patch chose "killable". Future patch will make
them "interruptible" so that we can revert to "killable" if some program
regressed.

[1] https://syzkaller.appspot.com/bug?id=a0e3436829698d5824231251fad9d8e998f94f5e

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot <syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com>
Link: https://lore.kernel.org/r/1566825205-10703-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/mem.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index b08dc50f9f26..9eb564c002f6 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -97,6 +97,13 @@ void __weak unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 }
 #endif
 
+static inline bool should_stop_iteration(void)
+{
+	if (need_resched())
+		cond_resched();
+	return fatal_signal_pending(current);
+}
+
 /*
  * This funcion reads the *physical* memory. The f_pos points directly to the
  * memory location.
@@ -175,6 +182,8 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 		p += sz;
 		count -= sz;
 		read += sz;
+		if (should_stop_iteration())
+			break;
 	}
 	kfree(bounce);
 
@@ -251,6 +260,8 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 		p += sz;
 		count -= sz;
 		written += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += written;
@@ -468,6 +479,10 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 			read += sz;
 			low_count -= sz;
 			count -= sz;
+			if (should_stop_iteration()) {
+				count = 0;
+				break;
+			}
 		}
 	}
 
@@ -492,6 +507,8 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 			buf += sz;
 			read += sz;
 			p += sz;
+			if (should_stop_iteration())
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -544,6 +561,8 @@ static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
 		p += sz;
 		count -= sz;
 		written += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += written;
@@ -595,6 +614,8 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 			buf += sz;
 			virtr += sz;
 			p += sz;
+			if (should_stop_iteration())
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
-- 
2.23.0


