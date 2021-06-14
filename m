Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBBC3A63E5
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhFNLSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235491AbhFNLQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:16:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FA8F6196E;
        Mon, 14 Jun 2021 10:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667795;
        bh=zliHzBfQkAPL0zkRE45qcUvleE/kh27HiV17G0VzZmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LN3gF7k0uC7F+MF1UFJ9Xc2amYrOgrWDXZwojl9sYDoarLAXp9QZvdw/DirHnW289
         tbGk6lvLUqO9pcZrP+hGr6bqMMd9wQDn0F+bhOCH+nB4UP7chwyQ+uvW/EUNlUo9hf
         DkUunWqLdXooxDKewMjvYNPep3VEIiSiXfrdvtAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 078/173] coredump: Limit what can interrupt coredumps
Date:   Mon, 14 Jun 2021 12:26:50 +0200
Message-Id: <20210614102700.753193742@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 06af8679449d4ed282df13191fc52d5ba28ec536 upstream.

Olivier Langlois has been struggling with coredumps being incompletely written in
processes using io_uring.

Olivier Langlois <olivier@trillion01.com> writes:
> io_uring is a big user of task_work and any event that io_uring made a
> task waiting for that occurs during the core dump generation will
> generate a TIF_NOTIFY_SIGNAL.
>
> Here are the detailed steps of the problem:
> 1. io_uring calls vfs_poll() to install a task to a file wait queue
>    with io_async_wake() as the wakeup function cb from io_arm_poll_handler()
> 2. wakeup function ends up calling task_work_add() with TWA_SIGNAL
> 3. task_work_add() sets the TIF_NOTIFY_SIGNAL bit by calling
>    set_notify_signal()

The coredump code deliberately supports being interrupted by SIGKILL,
and depends upon prepare_signal to filter out all other signals.   Now
that signal_pending includes wake ups for TIF_NOTIFY_SIGNAL this hack
in dump_emitted by the coredump code no longer works.

Make the coredump code more robust by explicitly testing for all of
the wakeup conditions the coredump code supports.  This prevents
new wakeup conditions from breaking the coredump code, as well
as fixing the current issue.

The filesystem code that the coredump code uses already limits
itself to only aborting on fatal_signal_pending.  So it should
not develop surprising wake-up reasons either.

v2: Don't remove the now unnecessary code in prepare_signal.

Cc: stable@vger.kernel.org
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -519,7 +519,7 @@ static bool dump_interrupted(void)
 	 * but then we need to teach dump_write() to restart and clear
 	 * TIF_SIGPENDING.
 	 */
-	return signal_pending(current);
+	return fatal_signal_pending(current) || freezing(current);
 }
 
 static void wait_for_dump_helpers(struct file *file)


