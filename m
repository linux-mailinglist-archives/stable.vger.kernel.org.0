Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059711E2D77
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392037AbgEZTLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391525AbgEZTLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:11:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915A420888;
        Tue, 26 May 2020 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520263;
        bh=LT8LrH50b5S9Ylv0GfXkR5aMNPboBN/KdvdNtqstb+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+YzlWr1v/TxLE1eURhibqB1X1aaH3wiMnEywp1BLNOjtgWxJq9rPxPm6zWPEjiJr
         15WVznXg/7WkM78bRuN6J2YaYGvzvaj5mImBL5vdIeawZtx2QmTDQne7oAFsnme+9l
         vYNPRGkvbjWlHdAgCKpxYaryWWoQaXN97TEfhHQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b48daca8639150bc5e73@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 011/126] pipe: Fix pipe_full() test in opipe_prep().
Date:   Tue, 26 May 2020 20:52:28 +0200
Message-Id: <20200526183938.503364244@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



