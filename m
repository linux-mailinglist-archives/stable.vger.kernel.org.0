Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E763401459
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242881AbhIFBc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351488AbhIFBae (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:30:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B3B611C2;
        Mon,  6 Sep 2021 01:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891431;
        bh=hrvckz5zgTtjPQZh4rLELH8lNg+zFQ0ABt3RKIeG+OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYMptqPfCRPwGru/dVHgOQXYo1ySl4dSHmyUTjIwuNgIFyYXWPPrj/0RR1D5B2D5U
         MI12DSPCFP3YQXjDMYmsjORvsHJr1wEjOwtqVniXSfUu4VnFRF+cbsVKTDfT5EDjmp
         ARL5BfjJ/vV4QJ1d2S4w3kqTjT3GRdyYa+Pxem+os7erlNEjN7JGAL6BQ78gN4MNUj
         PpxUTXDIgUosTg+64xi2GoMk8FmVdNzU29eU+S3lW6op7N3iIuYFeOnrM9cEL8aRDk
         ZBy9+JhSgBe4uWZJFsg5HfYepNdQy+F4s0pJ9prGB3od+ZIlzpJhGBSywBSkRT2cEp
         36r7ufZIQailw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 22/23] fcntl: fix potential deadlock for &fasync_struct.fa_lock
Date:   Sun,  5 Sep 2021 21:23:21 -0400
Message-Id: <20210906012322.930668-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012322.930668-1-sashal@kernel.org>
References: <20210906012322.930668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 2f488f698fda820f8e6fa0407630154eceb145d6 ]

There is an existing lock hierarchy of
&dev->event_lock --> &fasync_struct.fa_lock --> &f->f_owner.lock
from the following call chain:

  input_inject_event():
    spin_lock_irqsave(&dev->event_lock,...);
    input_handle_event():
      input_pass_values():
        input_to_handler():
          evdev_events():
            evdev_pass_values():
              spin_lock(&client->buffer_lock);
              __pass_event():
                kill_fasync():
                  kill_fasync_rcu():
                    read_lock(&fa->fa_lock);
                    send_sigio():
                      read_lock_irqsave(&fown->lock,...);

&dev->event_lock is HARDIRQ-safe, so interrupts have to be disabled
while grabbing &fasync_struct.fa_lock, otherwise we invert the lock
hierarchy. However, since kill_fasync which calls kill_fasync_rcu is
an exported symbol, it may not necessarily be called with interrupts
disabled.

As kill_fasync_rcu may be called with interrupts disabled (for
example, in the call chain above), we replace calls to
read_lock/read_unlock on &fasync_struct.fa_lock in kill_fasync_rcu
with read_lock_irqsave/read_unlock_irqrestore.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index e039af1872ab..dffb5245ae72 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -993,13 +993,14 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 {
 	while (fa) {
 		struct fown_struct *fown;
+		unsigned long flags;
 
 		if (fa->magic != FASYNC_MAGIC) {
 			printk(KERN_ERR "kill_fasync: bad magic number in "
 			       "fasync_struct!\n");
 			return;
 		}
-		read_lock(&fa->fa_lock);
+		read_lock_irqsave(&fa->fa_lock, flags);
 		if (fa->fa_file) {
 			fown = &fa->fa_file->f_owner;
 			/* Don't send SIGURG to processes which have not set a
@@ -1008,7 +1009,7 @@ static void kill_fasync_rcu(struct fasync_struct *fa, int sig, int band)
 			if (!(sig == SIGURG && fown->signum == 0))
 				send_sigio(fown, fa->fa_fd, band);
 		}
-		read_unlock(&fa->fa_lock);
+		read_unlock_irqrestore(&fa->fa_lock, flags);
 		fa = rcu_dereference(fa->fa_next);
 	}
 }
-- 
2.30.2

