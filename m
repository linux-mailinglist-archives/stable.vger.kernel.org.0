Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C7449E9CC
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbiA0SKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245135AbiA0SJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:09:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDCBC06175D;
        Thu, 27 Jan 2022 10:09:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ADA2B820C8;
        Thu, 27 Jan 2022 18:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9376CC340E4;
        Thu, 27 Jan 2022 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306970;
        bh=EmDU9pBT/xPBJnM3VVz+DnGxxc7WqCOmuKLje9v9Pug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aetIdn9Ew+pulrCIZ9Km7apsnhUSxk8qVb0CMqajSMeR/xLyQqxagVBmu96ebt9yN
         Xgaz+FgCyfIuI0IrU/aiPt5/ar8EjKKoGOz6JsRviNPOIUjdxwH7mQnf6xnjHuHX3w
         shmIBbfLyumYAqUcAV2JfqCj8Mb3u2DC0KsJj2TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 3/3] select: Fix indefinitely sleeping task in poll_schedule_timeout()
Date:   Thu, 27 Jan 2022 19:09:03 +0100
Message-Id: <20220127180256.943514512@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180256.837257619@linuxfoundation.org>
References: <20220127180256.837257619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 68514dacf2715d11b91ca50d88de047c086fea9c upstream.

A task can end up indefinitely sleeping in do_select() ->
poll_schedule_timeout() when the following race happens:

  TASK1 (thread1)             TASK2                   TASK1 (thread2)
  do_select()
    setup poll_wqueues table
    with 'fd'
                              write data to 'fd'
                                pollwake()
                                  table->triggered = 1
                                                      closes 'fd' thread1 is
                                                        waiting for
    poll_schedule_timeout()
      - sees table->triggered
      table->triggered = 0
      return -EINTR
    loop back in do_select()

But at this point when TASK1 loops back, the fdget() in the setup of
poll_wqueues fails.  So now so we never find 'fd' is ready for reading
and sleep in poll_schedule_timeout() indefinitely.

Treat an fd that got closed as a fd on which some event happened.  This
makes sure cannot block indefinitely in do_select().

Another option would be to return -EBADF in this case but that has a
potential of subtly breaking applications that excercise this behavior
and it happens to work for them.  So returning fd as active seems like a
safer choice.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/select.c |   63 +++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

--- a/fs/select.c
+++ b/fs/select.c
@@ -431,9 +431,11 @@ get_max:
 	return max;
 }
 
-#define POLLIN_SET (EPOLLRDNORM | EPOLLRDBAND | EPOLLIN | EPOLLHUP | EPOLLERR)
-#define POLLOUT_SET (EPOLLWRBAND | EPOLLWRNORM | EPOLLOUT | EPOLLERR)
-#define POLLEX_SET (EPOLLPRI)
+#define POLLIN_SET (EPOLLRDNORM | EPOLLRDBAND | EPOLLIN | EPOLLHUP | EPOLLERR |\
+			EPOLLNVAL)
+#define POLLOUT_SET (EPOLLWRBAND | EPOLLWRNORM | EPOLLOUT | EPOLLERR |\
+			 EPOLLNVAL)
+#define POLLEX_SET (EPOLLPRI | EPOLLNVAL)
 
 static inline void wait_key_set(poll_table *wait, unsigned long in,
 				unsigned long out, unsigned long bit,
@@ -500,6 +502,7 @@ static int do_select(int n, fd_set_bits
 					break;
 				if (!(bit & all_bits))
 					continue;
+				mask = EPOLLNVAL;
 				f = fdget(i);
 				if (f.file) {
 					wait_key_set(wait, in, out, bit,
@@ -507,34 +510,34 @@ static int do_select(int n, fd_set_bits
 					mask = vfs_poll(f.file, wait);
 
 					fdput(f);
-					if ((mask & POLLIN_SET) && (in & bit)) {
-						res_in |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					if ((mask & POLLOUT_SET) && (out & bit)) {
-						res_out |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					if ((mask & POLLEX_SET) && (ex & bit)) {
-						res_ex |= bit;
-						retval++;
-						wait->_qproc = NULL;
-					}
-					/* got something, stop busy polling */
-					if (retval) {
-						can_busy_loop = false;
-						busy_flag = 0;
-
-					/*
-					 * only remember a returned
-					 * POLL_BUSY_LOOP if we asked for it
-					 */
-					} else if (busy_flag & mask)
-						can_busy_loop = true;
-
 				}
+				if ((mask & POLLIN_SET) && (in & bit)) {
+					res_in |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				if ((mask & POLLOUT_SET) && (out & bit)) {
+					res_out |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				if ((mask & POLLEX_SET) && (ex & bit)) {
+					res_ex |= bit;
+					retval++;
+					wait->_qproc = NULL;
+				}
+				/* got something, stop busy polling */
+				if (retval) {
+					can_busy_loop = false;
+					busy_flag = 0;
+
+				/*
+				 * only remember a returned
+				 * POLL_BUSY_LOOP if we asked for it
+				 */
+				} else if (busy_flag & mask)
+					can_busy_loop = true;
+
 			}
 			if (res_in)
 				*rinp = res_in;


