Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3904939D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfFQVcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbfFQV1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:27:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92DBD2063F;
        Mon, 17 Jun 2019 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806874;
        bh=sQNVE6RHEotGyfdePzut0/p7rwfGAcTEDQqpQHblAUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2skfVA349we0sA9PlVQtz2/F2sHxzR+eypDp+0WceOngkfKbox9onduKGXZAbv/l
         pbPd3YNbOynXhYHcwupchcTksZtrlFLwTDcpoTs2LG2Uo+Fc5ZmXkMPawJpAlaXZsS
         a9p1DGTam5Ol7SvropTS7SMCz6zXm5J1nYl5pWt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
        syzbot+0d602a1b0d8c95bdf299@syzkaller.appspotmail.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/53] [PATCH] signal/ptrace: Dont leak unitialized kernel memory with PTRACE_PEEK_SIGINFO
Date:   Mon, 17 Jun 2019 23:09:55 +0200
Message-Id: <20190617210747.812259426@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f6e2aa91a46d2bc79fce9b93a988dbe7655c90c0 ]

Recently syzbot in conjunction with KMSAN reported that
ptrace_peek_siginfo can copy an uninitialized siginfo to userspace.
Inspecting ptrace_peek_siginfo confirms this.

The problem is that off when initialized from args.off can be
initialized to a negaive value.  At which point the "if (off >= 0)"
test to see if off became negative fails because off started off
negative.

Prevent the core problem by adding a variable found that is only true
if a siginfo is found and copied to a temporary in preparation for
being copied to userspace.

Prevent args.off from being truncated when being assigned to off by
testing that off is <= the maximum possible value of off.  Convert off
to an unsigned long so that we should not have to truncate args.off,
we have well defined overflow behavior so if we add another check we
won't risk fighting undefined compiler behavior, and so that we have a
type whose maximum value is easy to test for.

Cc: Andrei Vagin <avagin@gmail.com>
Cc: stable@vger.kernel.org
Reported-by: syzbot+0d602a1b0d8c95bdf299@syzkaller.appspotmail.com
Fixes: 84c751bd4aeb ("ptrace: add ability to retrieve signals without removing from a queue (v4)")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ptrace.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f1c85b6c39ae..f6b452e3c204 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -704,6 +704,10 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 	if (arg.nr < 0)
 		return -EINVAL;
 
+	/* Ensure arg.off fits in an unsigned long */
+	if (arg.off > ULONG_MAX)
+		return 0;
+
 	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
 		pending = &child->signal->shared_pending;
 	else
@@ -711,18 +715,20 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 
 	for (i = 0; i < arg.nr; ) {
 		siginfo_t info;
-		s32 off = arg.off + i;
+		unsigned long off = arg.off + i;
+		bool found = false;
 
 		spin_lock_irq(&child->sighand->siglock);
 		list_for_each_entry(q, &pending->list, list) {
 			if (!off--) {
+				found = true;
 				copy_siginfo(&info, &q->info);
 				break;
 			}
 		}
 		spin_unlock_irq(&child->sighand->siglock);
 
-		if (off >= 0) /* beyond the end of the list */
+		if (!found) /* beyond the end of the list */
 			break;
 
 #ifdef CONFIG_COMPAT
-- 
2.20.1



