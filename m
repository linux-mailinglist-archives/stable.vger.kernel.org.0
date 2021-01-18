Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEE52FA2C4
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392860AbhAROTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390645AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D9BA22DA9;
        Mon, 18 Jan 2021 11:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970245;
        bh=6xw/orLRngAYtsAKZSKyza04nqp+Y+eZI6PyCUEThFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/axQomDOB/PN1BjV8MzZd6Irg4lbrurH5izX/NVoVgotnc6EU2OdJiOPSA2tFJQD
         QVxUP2d/5ApmET8k55eC/LvTbjD/500uquff8dl0vBNLE/TA/xM5ppLOAmgtYFdcX+
         VDOVmkN2V4l/gDB/2uhxdnzmPKnLEfOKSOIYz7Zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/152] poll: fix performance regression due to out-of-line __put_user()
Date:   Mon, 18 Jan 2021 12:34:32 +0100
Message-Id: <20210118113357.395875851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit ef0ba05538299f1391cbe097de36895bb36ecfe6 ]

The kernel test robot reported a -5.8% performance regression on the
"poll2" test of will-it-scale, and bisected it to commit d55564cfc222
("x86: Make __put_user() generate an out-of-line call").

I didn't expect an out-of-line __put_user() to matter, because no normal
core code should use that non-checking legacy version of user access any
more.  But I had overlooked the very odd poll() usage, which does a
__put_user() to update the 'revents' values of the poll array.

Now, Al Viro correctly points out that instead of updating just the
'revents' field, it would be much simpler to just copy the _whole_
pollfd entry, and then we could just use "copy_to_user()" on the whole
array of entries, the same way we use "copy_from_user()" a few lines
earlier to get the original values.

But that is not what we've traditionally done, and I worry that threaded
applications might be concurrently modifying the other fields of the
pollfd array.  So while Al's suggestion is simpler - and perhaps worth
trying in the future - this instead keeps the "just update revents"
model.

To fix the performance regression, use the modern "unsafe_put_user()"
instead of __put_user(), with the proper "user_write_access_begin()"
guarding in place. This improves code generation enormously.

Link: https://lore.kernel.org/lkml/20210107134723.GA28532@xsang-OptiPlex-9020/
Reported-by: kernel test robot <oliver.sang@intel.com>
Tested-by: Oliver Sang <oliver.sang@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Laight <David.Laight@aculab.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/select.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index ebfebdfe5c69a..37aaa8317f3ae 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -1011,14 +1011,17 @@ static int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 	fdcount = do_poll(head, &table, end_time);
 	poll_freewait(&table);
 
+	if (!user_write_access_begin(ufds, nfds * sizeof(*ufds)))
+		goto out_fds;
+
 	for (walk = head; walk; walk = walk->next) {
 		struct pollfd *fds = walk->entries;
 		int j;
 
-		for (j = 0; j < walk->len; j++, ufds++)
-			if (__put_user(fds[j].revents, &ufds->revents))
-				goto out_fds;
+		for (j = walk->len; j; fds++, ufds++, j--)
+			unsafe_put_user(fds->revents, &ufds->revents, Efault);
   	}
+	user_write_access_end();
 
 	err = fdcount;
 out_fds:
@@ -1030,6 +1033,11 @@ out_fds:
 	}
 
 	return err;
+
+Efault:
+	user_write_access_end();
+	err = -EFAULT;
+	goto out_fds;
 }
 
 static long do_restart_poll(struct restart_block *restart_block)
-- 
2.27.0



