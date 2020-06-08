Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B131F2DD9
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgFHXOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbgFHXOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD9B214D8;
        Mon,  8 Jun 2020 23:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658040;
        bh=LT8LrH50b5S9Ylv0GfXkR5aMNPboBN/KdvdNtqstb+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlJmF3zvTv+7o/V9tNjFIJWFdr6y+BBxmQX1i1CvNbUlOKXjmcYpBUuJCiV+jAf13
         QwmuSre11gDswMPTJKqGyi7UUreZ41kgf5EW0wGb8dkykQnsF+nKtvg9nJx3PJLBgI
         YezOudo1Mx8tPlJRCZijvH9TJSwY5lzd81iiWvyQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot+b48daca8639150bc5e73@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 090/606] pipe: Fix pipe_full() test in opipe_prep().
Date:   Mon,  8 Jun 2020 19:03:35 -0400
Message-Id: <20200608231211.3363633-90-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 566d136289dc57816ac290de87a9a0f7d9bd3cbb ]

syzbot is reporting that splice()ing from non-empty read side to
already-full write side causes unkillable task, for opipe_prep() is by
error not inverting pipe_full() test.

  CPU: 0 PID: 9460 Comm: syz-executor.5 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:rol32 include/linux/bitops.h:105 [inline]
  RIP: 0010:iterate_chain_key kernel/locking/lockdep.c:369 [inline]
  RIP: 0010:__lock_acquire+0x6a3/0x5270 kernel/locking/lockdep.c:4178
  Call Trace:
     lock_acquire+0x197/0x420 kernel/locking/lockdep.c:4720
     __mutex_lock_common kernel/locking/mutex.c:956 [inline]
     __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
     pipe_lock_nested fs/pipe.c:66 [inline]
     pipe_double_lock+0x1a0/0x1e0 fs/pipe.c:104
     splice_pipe_to_pipe fs/splice.c:1562 [inline]
     do_splice+0x35f/0x1520 fs/splice.c:1141
     __do_sys_splice fs/splice.c:1447 [inline]
     __se_sys_splice fs/splice.c:1427 [inline]
     __x64_sys_splice+0x2b5/0x320 fs/splice.c:1427
     do_syscall_64+0xf6/0x790 arch/x86/entry/common.c:295
     entry_SYSCALL_64_after_hwframe+0x49/0xbe

Reported-by: syzbot+b48daca8639150bc5e73@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=9386d051e11e09973d5a4cf79af5e8cedf79386d
Fixes: 8cefc107ca54c8b0 ("pipe: Use head and tail pointers for the ring, not cursor and length")
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index d671936d0aad..39b11a9a6b98 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1503,7 +1503,7 @@ static int opipe_prep(struct pipe_inode_info *pipe, unsigned int flags)
 	 * Check pipe occupancy without the inode lock first. This function
 	 * is speculative anyways, so missing one is ok.
 	 */
-	if (pipe_full(pipe->head, pipe->tail, pipe->max_usage))
+	if (!pipe_full(pipe->head, pipe->tail, pipe->max_usage))
 		return 0;
 
 	ret = 0;
-- 
2.25.1

