Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F078FEDB3
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfKPPqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbfKPPqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:11 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 652172077B;
        Sat, 16 Nov 2019 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919170;
        bh=mKp2s/blIgMGrwn5l+GuCYtectkjp5AVSv8RFFXlJYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcfRhq7Bg5PBAkq0A02sTqb1MATzKNkgQXzsHmRxoXkecygxGUxJ2v3/0313ZAUxH
         9LSNb7yebYXTfcSqWqYnaSXccbO/7dq+rIgq+bHvtu6f9vvR7I9kQgHrnybBHMijSW
         Dc/kZ6YzJk3Th5kIvSU0Eb8ODEp0SrjrVqbgrQJU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changwei Ge <ge.changwei@h3c.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 180/237] ocfs2: don't use iocb when EIOCBQUEUED returns
Date:   Sat, 16 Nov 2019 10:40:15 -0500
Message-Id: <20191116154113.7417-180-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changwei Ge <ge.changwei@h3c.com>

[ Upstream commit 9e985787750db8aae87f02b67e908f28ac4d6b83 ]

When -EIOCBQUEUED returns, it means that aio_complete() will be called
from dio_complete(), which is an asynchronous progress against
write_iter.  Generally, IO is a very slow progress than executing
instruction, but we still can't take the risk to access a freed iocb.

And we do face a BUG crash issue.  Using the crash tool, iocb is
obviously freed already.

  crash> struct -x kiocb ffff881a350f5900
  struct kiocb {
    ki_filp = 0xffff881a350f5a80,
    ki_pos = 0x0,
    ki_complete = 0x0,
    private = 0x0,
    ki_flags = 0x0
  }

And the backtrace shows:
  ocfs2_file_write_iter+0xcaa/0xd00 [ocfs2]
  aio_run_iocb+0x229/0x2f0
  do_io_submit+0x291/0x540
  SyS_io_submit+0x10/0x20
  system_call_fastpath+0x16/0x75

Link: http://lkml.kernel.org/r/1523361653-14439-1-git-send-email-ge.changwei@h3c.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index a847fe52c56ee..a3e077fcfeb9b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2389,7 +2389,7 @@ static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 
 	written = __generic_file_write_iter(iocb, from);
 	/* buffered aio wouldn't have proper lock coverage today */
-	BUG_ON(written == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
+	BUG_ON(written == -EIOCBQUEUED && !direct_io);
 
 	/*
 	 * deep in g_f_a_w_n()->ocfs2_direct_IO we pass in a ocfs2_dio_end_io
@@ -2509,7 +2509,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	trace_generic_file_read_iter_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
-	BUG_ON(ret == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
+	BUG_ON(ret == -EIOCBQUEUED && !direct_io);
 
 	/* see ocfs2_file_write_iter */
 	if (ret == -EIOCBQUEUED || !ocfs2_iocb_is_rw_locked(iocb)) {
-- 
2.20.1

