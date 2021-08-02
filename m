Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD143DD44A
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 12:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhHBKsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 06:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhHBKsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 06:48:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A546460FC4;
        Mon,  2 Aug 2021 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627901313;
        bh=S6cyrJ6JsZLssI/SZySNadEOV+hRmzKaMF2xu/r8yyg=;
        h=From:To:Cc:Subject:Date:From;
        b=NqYLgyzbjl2rBCiVH36VuT2WJAiGJfDLzKKs/PPGyqWv1rtm7AL2Z0sEJZ0qPoBsU
         kM/U9JNQNZvyOYwQuplRxRzBYo1Fd/8C+rsTjFhET2dvjk0aJHeNhFr76mFpXyc3FE
         R2XDU82UxAvEgzajl9ZAGZYNocY1GUDVWq38RWNCxiNPsq+6wva3nuB7lJzpwyR9iT
         NKu+Tcp0HHVE6KkDUwp83ZLVcMsDNtR+vBXVp9BLxKopTyu/9i/IpMWjYgM0k/dqKT
         3+Gmk6rnsqggRc4UZ7pxSAup45jngEootBFhViisjdZH9Ym61bd8AIXTAtCT1eZJaK
         V9uj939WyOIEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sandeep Patil <sspatil@android.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 001/104] pipe: make pipe writes always wake up readers
Date:   Mon,  2 Aug 2021 06:46:48 -0400
Message-Id: <20210802104831.2095760-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3a34b13a88caeb2800ab44a4918f230041b37dd9 upstream.

Since commit 1b6b26ae7053 ("pipe: fix and clarify pipe write wakeup
logic") we have sanitized the pipe write logic, and would only try to
wake up readers if they needed it.

In particular, if the pipe already had data in it before the write,
there was no point in trying to wake up a reader, since any existing
readers must have been aware of the pre-existing data already.  Doing
extraneous wakeups will only cause potential thundering herd problems.

However, it turns out that some Android libraries have misused the EPOLL
interface, and expected "edge triggered" be to "any new write will
trigger it".  Even if there was no edge in sight.

Quoting Sandeep Patil:
 "The commit 1b6b26ae7053 ('pipe: fix and clarify pipe write wakeup
  logic') changed pipe write logic to wakeup readers only if the pipe
  was empty at the time of write. However, there are libraries that
  relied upon the older behavior for notification scheme similar to
  what's described in [1]

  One such library 'realm-core'[2] is used by numerous Android
  applications. The library uses a similar notification mechanism as GNU
  Make but it never drains the pipe until it is full. When Android moved
  to v5.10 kernel, all applications using this library stopped working.

  The library has since been fixed[3] but it will be a while before all
  applications incorporate the updated library"

Our regression rule for the kernel is that if applications break from
new behavior, it's a regression, even if it was because the application
did something patently wrong.  Also note the original report [4] by
Michal Kerrisk about a test for this epoll behavior - but at that point
we didn't know of any actual broken use case.

So add the extraneous wakeup, to approximate the old behavior.

[ I say "approximate", because the exact old behavior was to do a wakeup
  not for each write(), but for each pipe buffer chunk that was filled
  in. The behavior introduced by this change is not that - this is just
  "every write will cause a wakeup, whether necessary or not", which
  seems to be sufficient for the broken library use. ]

It's worth noting that this adds the extraneous wakeup only for the
write side, while the read side still considers the "edge" to be purely
about reading enough from the pipe to allow further writes.

See commit f467a6a66419 ("pipe: fix and clarify pipe read wakeup logic")
for the pipe read case, which remains that "only wake up if the pipe was
full, and we read something from it".

Link: https://lore.kernel.org/lkml/CAHk-=wjeG0q1vgzu4iJhW5juPkTsjTYmiqiMUYAebWW+0bam6w@mail.gmail.com/ [1]
Link: https://github.com/realm/realm-core [2]
Link: https://github.com/realm/realm-core/issues/4666 [3]
Link: https://lore.kernel.org/lkml/CAKgNAkjMBGeAwF=2MKK758BhxvW58wYTgYKB2V-gY1PwXxrH+Q@mail.gmail.com/ [4]
Link: https://lore.kernel.org/lkml/20210729222635.2937453-1-sspatil@android.com/
Reported-by: Sandeep Patil <sspatil@android.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index bfd946a9ad01..9ef4231cce61 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -429,20 +429,20 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 #endif
 
 	/*
-	 * Only wake up if the pipe started out empty, since
-	 * otherwise there should be no readers waiting.
+	 * Epoll nonsensically wants a wakeup whether the pipe
+	 * was already empty or not.
 	 *
 	 * If it wasn't empty we try to merge new data into
 	 * the last buffer.
 	 *
 	 * That naturally merges small writes, but it also
-	 * page-aligs the rest of the writes for large writes
+	 * page-aligns the rest of the writes for large writes
 	 * spanning multiple pages.
 	 */
 	head = pipe->head;
-	was_empty = pipe_empty(head, pipe->tail);
+	was_empty = true;
 	chars = total_len & (PAGE_SIZE-1);
-	if (chars && !was_empty) {
+	if (chars && !pipe_empty(head, pipe->tail)) {
 		unsigned int mask = pipe->ring_size - 1;
 		struct pipe_buffer *buf = &pipe->bufs[(head - 1) & mask];
 		int offset = buf->offset + buf->len;
-- 
2.30.2

