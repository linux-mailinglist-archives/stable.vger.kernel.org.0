Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543FF49325
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfFQV16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730462AbfFQV15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:27:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C43020861;
        Mon, 17 Jun 2019 21:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806876;
        bh=cFx4VBLzAal3G0rBA32RUb0yH6Y2uo0QIMRMn9lE+cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VntWxLC/PAzlV3j6nqXlGSVBphtTvKvFZpGuBHol4lUvukp0PTWvXE+1lFlQNE+N0
         5aLTyG2vJ14AySntvSELS9QvgHlR9CfRYI2sGDaJ6DBhsZgvWZH8OX56HucoQClyfs
         fWjRi8ERC7Sr0QdaQEDkDH6AI2EELsZ0HGdMjkRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 4.14 13/53] ptrace: restore smp_rmb() in __ptrace_may_access()
Date:   Mon, 17 Jun 2019 23:09:56 +0200
Message-Id: <20190617210747.887165718@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit f6581f5b55141a95657ef5742cf6a6bfa20a109f upstream.

Restore the read memory barrier in __ptrace_may_access() that was deleted
a couple years ago. Also add comments on this barrier and the one it pairs
with to explain why they're there (as far as I understand).

Fixes: bfedb589252c ("mm: Add a user_ns owner to mm_struct and fix ptrace permission checks")
Cc: stable@vger.kernel.org
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cred.c   |    9 +++++++++
 kernel/ptrace.c |   10 ++++++++++
 2 files changed, 19 insertions(+)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -448,6 +448,15 @@ int commit_creds(struct cred *new)
 		if (task->mm)
 			set_dumpable(task->mm, suid_dumpable);
 		task->pdeath_signal = 0;
+		/*
+		 * If a task drops privileges and becomes nondumpable,
+		 * the dumpability change must become visible before
+		 * the credential change; otherwise, a __ptrace_may_access()
+		 * racing with this change may be able to attach to a task it
+		 * shouldn't be able to attach to (as if the task had dropped
+		 * privileges without becoming nondumpable).
+		 * Pairs with a read barrier in __ptrace_may_access().
+		 */
 		smp_wmb();
 	}
 
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -323,6 +323,16 @@ static int __ptrace_may_access(struct ta
 	return -EPERM;
 ok:
 	rcu_read_unlock();
+	/*
+	 * If a task drops privileges and becomes nondumpable (through a syscall
+	 * like setresuid()) while we are trying to access it, we must ensure
+	 * that the dumpability is read after the credentials; otherwise,
+	 * we may be able to attach to a task that we shouldn't be able to
+	 * attach to (as if the task had dropped privileges without becoming
+	 * nondumpable).
+	 * Pairs with a write barrier in commit_creds().
+	 */
+	smp_rmb();
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&


