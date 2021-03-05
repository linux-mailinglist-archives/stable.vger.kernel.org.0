Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048A032E96C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhCEMcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232757AbhCEMcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB25F65013;
        Fri,  5 Mar 2021 12:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947537;
        bh=H8CyxCepIbQl8DhQ65JJffsh/LdxiqPj7i6TOIhOZes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTwelOKgxYOuWr1Gkrm73rZzeqcPXDR4hGDyAlwy73Cam4o2kY2nJCyca8Mp30gDw
         awnpvmcL98lK6O012FiAHWY0xLUhC2ACzVpH4Wlth3u2I+0AsQ+DIs4OE7YKWIIEJK
         TBgSEoKsK/o5tuXmoaytMmCVW44G+FcViqTaTJ6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 098/102] tty: teach the n_tty ICANON case about the new "cookie continuations" too
Date:   Fri,  5 Mar 2021 13:21:57 +0100
Message-Id: <20210305120908.101487980@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d7fe75cbc23c7d225eee2ef04def239b6603dce7 upstream.

The ICANON case is a bit messy, since it has to look for the line
ending, and has special code to then suppress line ending characters if
they match the __DISABLED_CHAR.  So it actually looks up the line ending
even past the point where it knows it won't copy it to the result
buffer.

That said, apart from all those odd legacy N_TTY ICANON cases, the
actual "should we continue copying" logic isn't really all that
complicated or different from the non-canon case.  In fact, the lack of
"wait for at least N characters" arguably makes the repeat case slightly
simpler.  It really just boils down to "there's more of the line to be
copied".

So add the necessarily trivial logic, and now the N_TTY case will give
long result lines even when in canon mode.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2009,21 +2009,22 @@ static bool copy_from_read_buf(struct tt
  *		read_tail published
  */
 
-static void canon_copy_from_read_buf(struct tty_struct *tty,
+static bool canon_copy_from_read_buf(struct tty_struct *tty,
 				     unsigned char **kbp,
 				     size_t *nr)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t n, size, more, c;
 	size_t eol;
-	size_t tail;
+	size_t tail, canon_head;
 	int found = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
 	if (!*nr)
-		return;
+		return false;
 
-	n = min(*nr + 1, smp_load_acquire(&ldata->canon_head) - ldata->read_tail);
+	canon_head = smp_load_acquire(&ldata->canon_head);
+	n = min(*nr + 1, canon_head - ldata->read_tail);
 
 	tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
@@ -2067,7 +2068,11 @@ static void canon_copy_from_read_buf(str
 		else
 			ldata->push = 0;
 		tty_audit_push();
+		return false;
 	}
+
+	/* No EOL found - do a continuation retry if there is more data */
+	return ldata->read_tail != canon_head;
 }
 
 /**
@@ -2138,8 +2143,13 @@ static ssize_t n_tty_read(struct tty_str
 	 * termios_rwsem, and can just continue to copy data.
 	 */
 	if (*cookie) {
-		if (copy_from_read_buf(tty, &kb, &nr))
-			return kb - kbuf;
+		if (ldata->icanon && !L_EXTPROC(tty)) {
+			if (canon_copy_from_read_buf(tty, &kb, &nr))
+				return kb - kbuf;
+		} else {
+			if (copy_from_read_buf(tty, &kb, &nr))
+				return kb - kbuf;
+		}
 
 		/* No more data - release locks and stop retries */
 		n_tty_kick_worker(tty);
@@ -2236,7 +2246,8 @@ static ssize_t n_tty_read(struct tty_str
 		}
 
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			canon_copy_from_read_buf(tty, &kb, &nr);
+			if (canon_copy_from_read_buf(tty, &kb, &nr))
+				goto more_to_be_read;
 		} else {
 			/* Deal with packet mode. */
 			if (packet && kb == kbuf) {
@@ -2254,6 +2265,7 @@ static ssize_t n_tty_read(struct tty_str
 			 * will release them when done.
 			 */
 			if (copy_from_read_buf(tty, &kb, &nr) && kb - kbuf >= minimum) {
+more_to_be_read:
 				remove_wait_queue(&tty->read_wait, &wait);
 				*cookie = cookie;
 				return kb - kbuf;


