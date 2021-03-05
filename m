Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2158F32E963
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhCEMce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232692AbhCEMcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B95565004;
        Fri,  5 Mar 2021 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947531;
        bh=ZL/ISVxB/URfSiYGOh/8n7lxXaouo+uBF14P0qxpBoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2fipudGPlJ4g6J5KJMyAqocQ9OfbCbiPxZW9DSXolipE7fUsn0K9v9VdTWGAOgNe
         kKdCIVZXNWoP4N5B4RBw6Y37eKMcyVFTuHftNAudxZckOr/XIrXN1IHCejvSo29/KQ
         qNrsVAgDgbfccsLNSlyofzIJVzQ3+lE546u30naE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 096/102] tty: clean up legacy leftovers from n_tty line discipline
Date:   Fri,  5 Mar 2021 13:21:55 +0100
Message-Id: <20210305120908.002060146@linuxfoundation.org>
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

commit 64a69892afadd6fffaeadc65427bb7601161139d upstream.

Back when the line disciplines did their own direct user accesses, they
had to deal with the data copy possibly failing in the middle.

Now that the user copy is done by the tty_io.c code, that failure case
no longer exists.

Remove the left-over error handling code that cannot trigger.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1955,19 +1955,17 @@ static inline int input_available_p(stru
  *		read_tail published
  */
 
-static int copy_from_read_buf(struct tty_struct *tty,
+static void copy_from_read_buf(struct tty_struct *tty,
 				      unsigned char **kbp,
 				      size_t *nr)
 
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int retval;
 	size_t n;
 	bool is_eof;
 	size_t head = smp_load_acquire(&ldata->commit_head);
 	size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
 
-	retval = 0;
 	n = min(head - ldata->read_tail, N_TTY_BUF_SIZE - tail);
 	n = min(*nr, n);
 	if (n) {
@@ -1984,7 +1982,6 @@ static int copy_from_read_buf(struct tty
 		*kbp += n;
 		*nr -= n;
 	}
-	return retval;
 }
 
 /**
@@ -2010,9 +2007,9 @@ static int copy_from_read_buf(struct tty
  *		read_tail published
  */
 
-static int canon_copy_from_read_buf(struct tty_struct *tty,
-				    unsigned char **kbp,
-				    size_t *nr)
+static void canon_copy_from_read_buf(struct tty_struct *tty,
+				     unsigned char **kbp,
+				     size_t *nr)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t n, size, more, c;
@@ -2022,7 +2019,7 @@ static int canon_copy_from_read_buf(stru
 
 	/* N.B. avoid overrun if nr == 0 */
 	if (!*nr)
-		return 0;
+		return;
 
 	n = min(*nr + 1, smp_load_acquire(&ldata->canon_head) - ldata->read_tail);
 
@@ -2069,7 +2066,6 @@ static int canon_copy_from_read_buf(stru
 			ldata->push = 0;
 		tty_audit_push();
 	}
-	return 0;
 }
 
 /**
@@ -2219,24 +2215,17 @@ static ssize_t n_tty_read(struct tty_str
 		}
 
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			retval = canon_copy_from_read_buf(tty, &kb, &nr);
-			if (retval)
-				break;
+			canon_copy_from_read_buf(tty, &kb, &nr);
 		} else {
-			int uncopied;
-
 			/* Deal with packet mode. */
 			if (packet && kb == kbuf) {
 				*kb++ = TIOCPKT_DATA;
 				nr--;
 			}
 
-			uncopied = copy_from_read_buf(tty, &kb, &nr);
-			uncopied += copy_from_read_buf(tty, &kb, &nr);
-			if (uncopied) {
-				retval = -EFAULT;
-				break;
-			}
+			/* See comment above copy_from_read_buf() why twice */
+			copy_from_read_buf(tty, &kb, &nr);
+			copy_from_read_buf(tty, &kb, &nr);
 		}
 
 		n_tty_check_unthrottle(tty);


