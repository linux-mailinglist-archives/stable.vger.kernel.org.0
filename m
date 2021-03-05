Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7350332E964
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhCEMcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232721AbhCEMcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:32:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C3E865004;
        Fri,  5 Mar 2021 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947534;
        bh=zQ3c41de3iFOtsTazGYd/iCfnQMLSYcltfhMKkZerPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0hPRkU8TsYCvOapoCV6X/+C/mAski+dqaBpvN1V1ppVrRNV+mYVpaGkkTYpIMCt2
         MhjW4i7jqscIpVysCj1lL8iIWSpfhJq4PyisIbjRHTMs08//WoSkqW4XG3F9dGPb2R
         Af4XQqK3CKUcIdiRjAN6Zke21DWP9sdrXvQ+qEcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 097/102] tty: teach n_tty line discipline about the new "cookie continuations"
Date:   Fri,  5 Mar 2021 13:21:56 +0100
Message-Id: <20210305120908.050286869@linuxfoundation.org>
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

commit 15ea8ae8e03fdb845ed3ff5d9f11dd5f4f60252c upstream.

With the conversion to do the tty ldisc read operations in small chunks,
the n_tty line discipline became noticeably slower for throughput
oriented loads, because rather than read things in up to 2kB chunks, it
would return at most 64 bytes per read() system call.

The cost is mainly all in the "do system calls over and over", not
really in the new "copy to an extra kernel buffer".

This can be fixed by teaching the n_tty line discipline about the
"cookie continuation" model, which the chunking code supports because
things like hdlc need to be able to handle packets up to 64kB in size.

Doing that doesn't just get us back to the old performace, but to much
better performance: my stupid "copy 10MB of data over a pty" test
program is now almost twice as fast as it used to be (going down from
0.1s to 0.054s).

This is entirely because it now creates maximal chunks (which happens to
be "one byte less than one page" due to how we do the circular tty
buffers).

NOTE! This case only handles the simpler non-icanon case, which is the
one where people may care about throughput.  I'm going to do the icanon
case later too, because while performance isn't a major issue for that,
there may be programs that think they'll always get a full line and
don't like the 64-byte chunking for that reason.

Such programs are arguably buggy (signals etc can cause random partial
results from tty reads anyway), and good programs will handle such
partial reads, but expecting everybody to write "good programs" has
never been a winning policy for the kernel..

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_tty.c |   52 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 10 deletions(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1943,19 +1943,17 @@ static inline int input_available_p(stru
  *	Helper function to speed up n_tty_read.  It is only called when
  *	ICANON is off; it copies characters straight from the tty queue.
  *
- *	It can be profitably called twice; once to drain the space from
- *	the tail pointer to the (physical) end of the buffer, and once
- *	to drain the space from the (physical) beginning of the buffer
- *	to head pointer.
- *
  *	Called under the ldata->atomic_read_lock sem
  *
+ *	Returns true if it successfully copied data, but there is still
+ *	more data to be had.
+ *
  *	n_tty_read()/consumer path:
  *		caller holds non-exclusive termios_rwsem
  *		read_tail published
  */
 
-static void copy_from_read_buf(struct tty_struct *tty,
+static bool copy_from_read_buf(struct tty_struct *tty,
 				      unsigned char **kbp,
 				      size_t *nr)
 
@@ -1978,10 +1976,14 @@ static void copy_from_read_buf(struct tt
 		/* Turn single EOF into zero-length read */
 		if (L_EXTPROC(tty) && ldata->icanon && is_eof &&
 		    (head == ldata->read_tail))
-			n = 0;
+			return false;
 		*kbp += n;
 		*nr -= n;
+
+		/* If we have more to copy, let the caller know */
+		return head != ldata->read_tail;
 	}
+	return false;
 }
 
 /**
@@ -2129,6 +2131,25 @@ static ssize_t n_tty_read(struct tty_str
 	int packet;
 	size_t tail;
 
+	/*
+	 * Is this a continuation of a read started earler?
+	 *
+	 * If so, we still hold the atomic_read_lock and the
+	 * termios_rwsem, and can just continue to copy data.
+	 */
+	if (*cookie) {
+		if (copy_from_read_buf(tty, &kb, &nr))
+			return kb - kbuf;
+
+		/* No more data - release locks and stop retries */
+		n_tty_kick_worker(tty);
+		n_tty_check_unthrottle(tty);
+		up_read(&tty->termios_rwsem);
+		mutex_unlock(&ldata->atomic_read_lock);
+		*cookie = NULL;
+		return kb - kbuf;
+	}
+
 	c = job_control(tty, file);
 	if (c < 0)
 		return c;
@@ -2223,9 +2244,20 @@ static ssize_t n_tty_read(struct tty_str
 				nr--;
 			}
 
-			/* See comment above copy_from_read_buf() why twice */
-			copy_from_read_buf(tty, &kb, &nr);
-			copy_from_read_buf(tty, &kb, &nr);
+			/*
+			 * Copy data, and if there is more to be had
+			 * and we have nothing more to wait for, then
+			 * let's mark us for retries.
+			 *
+			 * NOTE! We return here with both the termios_sem
+			 * and atomic_read_lock still held, the retries
+			 * will release them when done.
+			 */
+			if (copy_from_read_buf(tty, &kb, &nr) && kb - kbuf >= minimum) {
+				remove_wait_queue(&tty->read_wait, &wait);
+				*cookie = cookie;
+				return kb - kbuf;
+			}
 		}
 
 		n_tty_check_unthrottle(tty);


