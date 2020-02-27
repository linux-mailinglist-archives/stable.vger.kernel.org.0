Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7F17206A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbgB0Omc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731166AbgB0NuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:50:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571F120801;
        Thu, 27 Feb 2020 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811409;
        bh=cKSHBxICpc8HLDD17GSyryzs85V7J/Gd/ehm3OodqUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQRq/Q75ZajG4p6ZmR7YZrgmUmHQ0t/GgkNmWvC/NlyBUM166ZMOVoTOrkXTC0Ju0
         O+UJEjegnZr6op+77CnSwJ936LewTjpOU7N9+NqZ4X8BXpWVOVH7tUpw2DidNMRfJm
         PlVGo9u1OSMUBmcudPBDC5+RuFlhnvFXEORS1wbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.9 120/165] vt: selection, handle pending signals in paste_selection
Date:   Thu, 27 Feb 2020 14:36:34 +0100
Message-Id: <20200227132248.635930551@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
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
 drivers/tty/vt/selection.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -341,6 +341,7 @@ int paste_selection(struct tty_struct *t
 	unsigned int count;
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
+	int ret = 0;
 
 	console_lock();
 	poke_blanked_console();
@@ -354,6 +355,10 @@ int paste_selection(struct tty_struct *t
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
@@ -369,5 +374,5 @@ int paste_selection(struct tty_struct *t
 
 	tty_buffer_unlock_exclusive(&vc->port);
 	tty_ldisc_deref(ld);
-	return 0;
+	return ret;
 }


