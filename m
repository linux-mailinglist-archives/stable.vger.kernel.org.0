Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E328F2E144A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgLWCXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729940AbgLWCXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3800E22482;
        Wed, 23 Dec 2020 02:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690174;
        bh=Iv5f45ChYLpTMHlwxxtdoZWBmiNeU1y8uPPFLZlXcBk=;
        h=From:To:Cc:Subject:Date:From;
        b=r3UCaSe8FLRjSH1XNvBMFxFsj+7NhA2XznzrAzznwlo6gLuqlNAw7q0+26P2jC49X
         usRkXOYH9NKGM0X1MwosU0Xyybh2c4uFSqSysU8QGURJL8yDT4kpVd0V8NM+rKmW2K
         Zumk5jkflgACZCEbREsA24NBa5ZuIU2rr00FuWqjC4BYa3U+mxb2X/DtKe0gYBYw6w
         ITOKz8KNKcy+RuGUN6zxfH6ZdYIfXDJqYm2FP6/sKWmkD+IiU7ao1k+Vi+7D5idA4j
         ED4lyt+/I0x+4NoMLjj8iXzQ9UV7El+3NUUmgTJHfTDg56VFYxRb4ONlacABaopmye
         wE/PyrIssuBaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo Meng <luomeng12@huawei.com>, Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/66] locks: Fix UBSAN undefined behaviour in flock64_to_posix_lock
Date:   Tue, 22 Dec 2020 21:21:47 -0500
Message-Id: <20201223022253.2793452-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

[ Upstream commit 16238415eb9886328a89fe7a3cb0b88c7335fe16 ]

When the sum of fl->fl_start and l->l_len overflows,
UBSAN shows the following warning:

UBSAN: Undefined behaviour in fs/locks.c:482:29
signed integer overflow: 2 + 9223372036854775806
cannot be represented in type 'long long int'
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xe4/0x14e lib/dump_stack.c:118
 ubsan_epilogue+0xe/0x81 lib/ubsan.c:161
 handle_overflow+0x193/0x1e2 lib/ubsan.c:192
 flock64_to_posix_lock fs/locks.c:482 [inline]
 flock_to_posix_lock+0x595/0x690 fs/locks.c:515
 fcntl_setlk+0xf3/0xa90 fs/locks.c:2262
 do_fcntl+0x456/0xf60 fs/fcntl.c:387
 __do_sys_fcntl fs/fcntl.c:483 [inline]
 __se_sys_fcntl fs/fcntl.c:468 [inline]
 __x64_sys_fcntl+0x12d/0x180 fs/fcntl.c:468
 do_syscall_64+0xc8/0x5a0 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix it by parenthesizing 'l->l_len - 1'.

Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 1a40e277eb5e1..11bb382a23c2e 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -488,7 +488,7 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	if (l->l_len > 0) {
 		if (l->l_len - 1 > OFFSET_MAX - fl->fl_start)
 			return -EOVERFLOW;
-		fl->fl_end = fl->fl_start + l->l_len - 1;
+		fl->fl_end = fl->fl_start + (l->l_len - 1);
 
 	} else if (l->l_len < 0) {
 		if (fl->fl_start + l->l_len < 0)
-- 
2.27.0

