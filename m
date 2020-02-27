Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0C171F6C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732852AbgB0Ofz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732637AbgB0N7p (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADAB624656;
        Thu, 27 Feb 2020 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811985;
        bh=jAlQ1VjaME95hBJJoVaPUKO1LJfFCsEkZPLL46+G1lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ez1/8Cz8x/Yw59IZ12Vv/+ZCMqXdUeE+djjq3+sgb9ixve+ykeIky+DfhQuEWxQ6
         VILLvEiFntclquGVibwrSRxDOedSqiX9C8NdI7879iRBLdoMSfRsmF0PjD1J4aZ0oO
         3DNDOnfLZ+Nqq6ra0REcsfiWrPnf4NnwOGyxkEfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.14 177/237] vt: selection, handle pending signals in paste_selection
Date:   Thu, 27 Feb 2020 14:36:31 +0100
Message-Id: <20200227132309.414248234@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 687bff0cd08f790d540cfb7b2349f0d876cdddec upstream.

When pasting a selection to a vt, the task is set as INTERRUPTIBLE while
waiting for a tty to unthrottle. But signals are not handled at all.
Normally, this is not a problem as tty_ldisc_receive_buf receives all
the goods and a user has no reason to interrupt the task.

There are two scenarios where this matters:
1) when the tty is throttled and a signal is sent to the process, it
   spins on a CPU until the tty is unthrottled. schedule() does not
   really echedule, but returns immediately, of course.
2) when the sel_buffer becomes invalid, KASAN prevents any reads from it
   and the loop simply does not proceed and spins forever (causing the
   tty to throttle, but the code never sleeps, the same as above). This
   sometimes happens as there is a race in the sel_buffer handling code.

So add signal handling to this ioctl (TIOCL_PASTESEL) and return -EINTR
in case a signal is pending.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210081131.23572-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/selection.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -27,6 +27,8 @@
 #include <linux/console.h>
 #include <linux/tty_flip.h>
 
+#include <linux/sched/signal.h>
+
 /* Don't take this from <ctype.h>: 011-015 on the screen aren't spaces */
 #define isspace(c)	((c) == ' ')
 
@@ -338,6 +340,7 @@ int paste_selection(struct tty_struct *t
 	unsigned int count;
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
+	int ret = 0;
 
 	console_lock();
 	poke_blanked_console();
@@ -351,6 +354,10 @@ int paste_selection(struct tty_struct *t
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
 		if (tty_throttled(tty)) {
 			schedule();
 			continue;
@@ -366,5 +373,5 @@ int paste_selection(struct tty_struct *t
 
 	tty_buffer_unlock_exclusive(&vc->port);
 	tty_ldisc_deref(ld);
-	return 0;
+	return ret;
 }


