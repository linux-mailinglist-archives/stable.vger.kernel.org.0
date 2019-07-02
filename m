Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35ABF5CBD6
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfGBIDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbfGBIDq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:03:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 478A721479;
        Tue,  2 Jul 2019 08:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054625;
        bh=pgr4lMIt6R9jlG/y2bAE8ZAcSMfZIODCILhoxOWYumg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eK+Ypg5I+JgEWy/OP46iZPqrlPF4vXiMSMHNc/OWUjqGSrkx6RGSSYdFqOWYBMcc6
         T7vC6c662ZmFm2GkVBIgd/VL0WR/vSE9nNi9ZYhxUCz+mSYjo3TjV7k9CB4SAd6UFc
         Z7YsEViTgok18bsl2+f1mjN4TVB76iRiR8XJYXEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Jan Luebbe <jlu@pengutronix.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.1 04/55] fs/proc/array.c: allow reporting eip/esp for all coredumping threads
Date:   Tue,  2 Jul 2019 10:01:12 +0200
Message-Id: <20190702080124.301015287@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

commit cb8f381f1613cafe3aec30809991cd56e7135d92 upstream.

0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in /proc/PID/stat")
stopped reporting eip/esp and fd7d56270b52 ("fs/proc: Report eip/esp in
/prod/PID/stat for coredumping") reintroduced the feature to fix a
regression with userspace core dump handlers (such as minicoredumper).

Because PF_DUMPCORE is only set for the primary thread, this didn't fix
the original problem for secondary threads.  Allow reporting the eip/esp
for all threads by checking for PF_EXITING as well.  This is set for all
the other threads when they are killed.  coredump_wait() waits for all the
tasks to become inactive before proceeding to invoke a core dumper.

Link: http://lkml.kernel.org/r/87y32p7i7a.fsf@linutronix.de
Link: http://lkml.kernel.org/r/20190522161614.628-1-jlu@pengutronix.de
Fixes: fd7d56270b526ca3 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reported-by: Jan Luebbe <jlu@pengutronix.de>
Tested-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -462,7 +462,7 @@ static int do_task_stat(struct seq_file
 		 * a program is not able to use ptrace(2) in that case. It is
 		 * safe because the task has stopped executing permanently.
 		 */
-		if (permitted && (task->flags & PF_DUMPCORE)) {
+		if (permitted && (task->flags & (PF_EXITING|PF_DUMPCORE))) {
 			if (try_get_task_stack(task)) {
 				eip = KSTK_EIP(task);
 				esp = KSTK_ESP(task);


