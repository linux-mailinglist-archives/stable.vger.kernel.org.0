Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80DC91E5
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfJBTMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:12:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35436 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729131AbfJBTIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-00036F-W7; Wed, 02 Oct 2019 20:08:07 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003cz-4V; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Andrei Vagin" <avagin@gmail.com>,
        syzbot+0d602a1b0d8c95bdf299@syzkaller.appspotmail.com
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.591039887@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 39/87] signal/ptrace: Don't leak unitialized kernel
 memory with PTRACE_PEEK_SIGINFO
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit f6e2aa91a46d2bc79fce9b93a988dbe7655c90c0 upstream.

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
Reported-by: syzbot+0d602a1b0d8c95bdf299@syzkaller.appspotmail.com
Fixes: 84c751bd4aeb ("ptrace: add ability to retrieve signals without removing from a queue (v4)")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/ptrace.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -711,6 +711,10 @@ static int ptrace_peek_siginfo(struct ta
 	if (arg.nr < 0)
 		return -EINVAL;
 
+	/* Ensure arg.off fits in an unsigned long */
+	if (arg.off > ULONG_MAX)
+		return 0;
+
 	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
 		pending = &child->signal->shared_pending;
 	else
@@ -718,18 +722,20 @@ static int ptrace_peek_siginfo(struct ta
 
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

