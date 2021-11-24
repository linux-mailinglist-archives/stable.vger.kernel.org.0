Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F2A45C645
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349719AbhKXOGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356556AbhKXOE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 131EE6333E;
        Wed, 24 Nov 2021 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759487;
        bh=qOyFa73Hp8a2WIwnzZN6yrgbgiS5xB/g3BBOJ5n14HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPtZwcd/Vtj76J4WF6j95y7HgCE1a7IH6SrWI2c2kzeVcmnVuyIKQeNOu9aFnjjLh
         2+sCe09ato2WyFDu826T84DnDUt/Y08+4VUFuHUa+QwEK0D/cbaacxPG2XvqiR8Gy3
         9C7G74D97wJxDcahfo9ydmzz1gVWrcbgC9Qx3z3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 257/279] exit/syscall_user_dispatch: Send ordinary signals on failure
Date:   Wed, 24 Nov 2021 12:59:04 +0100
Message-Id: <20211124115727.601658707@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 941edc5bf174b67f94db19817cbeab0a93e0c32a upstream.

Use force_fatal_sig instead of calling do_exit directly.  This ensures
the ordinary signal handling path gets invoked, core dumps as
appropriate get created, and for multi-threaded processes all of the
threads are terminated not just a single thread.

When asked Gabriel Krisman Bertazi <krisman@collabora.com> said [1]:
> ebiederm@xmission.com (Eric W. Biederman) asked:
>
> > Why does do_syscal_user_dispatch call do_exit(SIGSEGV) and
> > do_exit(SIGSYS) instead of force_sig(SIGSEGV) and force_sig(SIGSYS)?
> >
> > Looking at the code these cases are not expected to happen, so I would
> > be surprised if userspace depends on any particular behaviour on the
> > failure path so I think we can change this.
>
> Hi Eric,
>
> There is not really a good reason, and the use case that originated the
> feature doesn't rely on it.
>
> Unless I'm missing yet another problem and others correct me, I think
> it makes sense to change it as you described.
>
> > Is using do_exit in this way something you copied from seccomp?
>
> I'm not sure, its been a while, but I think it might be just that.  The
> first prototype of SUD was implemented as a seccomp mode.

If at some point it becomes interesting we could relax
"force_fatal_sig(SIGSEGV)" to instead say
"force_sig_fault(SIGSEGV, SEGV_MAPERR, sd->selector)".

I avoid doing that in this patch to avoid making it possible
to catch currently uncatchable signals.

Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
[1] https://lkml.kernel.org/r/87mtr6gdvi.fsf@collabora.com
Link: https://lkml.kernel.org/r/20211020174406.17889-14-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/entry/syscall_user_dispatch.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/kernel/entry/syscall_user_dispatch.c
+++ b/kernel/entry/syscall_user_dispatch.c
@@ -47,14 +47,18 @@ bool syscall_user_dispatch(struct pt_reg
 		 * access_ok() is performed once, at prctl time, when
 		 * the selector is loaded by userspace.
 		 */
-		if (unlikely(__get_user(state, sd->selector)))
-			do_exit(SIGSEGV);
+		if (unlikely(__get_user(state, sd->selector))) {
+			force_fatal_sig(SIGSEGV);
+			return true;
+		}
 
 		if (likely(state == SYSCALL_DISPATCH_FILTER_ALLOW))
 			return false;
 
-		if (state != SYSCALL_DISPATCH_FILTER_BLOCK)
-			do_exit(SIGSYS);
+		if (state != SYSCALL_DISPATCH_FILTER_BLOCK) {
+			force_fatal_sig(SIGSYS);
+			return true;
+		}
 	}
 
 	sd->on_dispatch = true;


