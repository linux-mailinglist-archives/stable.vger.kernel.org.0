Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D520ACACA3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388428AbfJCQNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732701AbfJCQNt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:13:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FA420865;
        Thu,  3 Oct 2019 16:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119228;
        bh=tX/U8aujwjTxyRxka83R53J89nL+5YHZAjZBtNZPeIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIiuUvFwYP5FysDvbFus3RlqccsmidMdKnypAV3P215QjfimtZGcVbYPnQVBqhGyp
         nIBRe7lXAu7Lh7XUt5MBiexhN3+T+u64RP0ndQKjMWu2oyyWQjfBDCkaHmaQDEYTAI
         q23KezIlG2sBK1j4dUNJARD4TzZLiJg0lwpd9A0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com>
Subject: [PATCH 4.14 174/185] /dev/mem: Bail out upon SIGKILL.
Date:   Thu,  3 Oct 2019 17:54:12 +0200
Message-Id: <20191003154520.113837237@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 8619e5bdeee8b2c685d686281f2d2a6017c4bc15 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/mem.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -97,6 +97,13 @@ void __weak unxlate_dev_mem_ptr(phys_add
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
@@ -175,6 +182,8 @@ static ssize_t read_mem(struct file *fil
 		p += sz;
 		count -= sz;
 		read += sz;
+		if (should_stop_iteration())
+			break;
 	}
 	kfree(bounce);
 
@@ -251,6 +260,8 @@ static ssize_t write_mem(struct file *fi
 		p += sz;
 		count -= sz;
 		written += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += written;
@@ -464,6 +475,10 @@ static ssize_t read_kmem(struct file *fi
 			read += sz;
 			low_count -= sz;
 			count -= sz;
+			if (should_stop_iteration()) {
+				count = 0;
+				break;
+			}
 		}
 	}
 
@@ -488,6 +503,8 @@ static ssize_t read_kmem(struct file *fi
 			buf += sz;
 			read += sz;
 			p += sz;
+			if (should_stop_iteration())
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -540,6 +557,8 @@ static ssize_t do_write_kmem(unsigned lo
 		p += sz;
 		count -= sz;
 		written += sz;
+		if (should_stop_iteration())
+			break;
 	}
 
 	*ppos += written;
@@ -591,6 +610,8 @@ static ssize_t write_kmem(struct file *f
 			buf += sz;
 			virtr += sz;
 			p += sz;
+			if (should_stop_iteration())
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}


