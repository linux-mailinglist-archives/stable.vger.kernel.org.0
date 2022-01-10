Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C79E489F10
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 19:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbiAJSTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 13:19:32 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:59740 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbiAJSTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 13:19:31 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8BDD61F380;
        Mon, 10 Jan 2022 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641838770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Tc6uSLPqv62h4JI1ptGbmPdCKWGxhmbcPM9/hq73LKg=;
        b=WXWn6ovnn62O+AKmwKyp1zCVlOJWK4Qvg4vFVMfhNTvtivwtBVtnojRNVz+oD70RyFkmT0
        +03Mbimxxd64R8ljcsgArqAEzFziVn1niWTstd124DH0FUcsXuN9q3c6MyL3Zy7BXVqPJB
        a+0V70kuWiEa84Fqti+7TlYIAU5xNpk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641838770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Tc6uSLPqv62h4JI1ptGbmPdCKWGxhmbcPM9/hq73LKg=;
        b=4+LwV5fDiwutxbus7lpsrmWy4qKYKzpTsfsHP3FnyKyUIlFQ6GsdQDC4oAmBNIJoQPkvDj
        mbd61UN7Cnjs+RAg==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7CCC3A3B88;
        Mon, 10 Jan 2022 18:19:30 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 265BDA05A2; Mon, 10 Jan 2022 19:19:27 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH v2] select: Fix indefinitely sleeping task in poll_schedule_timeout()
Date:   Mon, 10 Jan 2022 19:19:23 +0100
Message-Id: <20220110181923.5340-1-jack@suse.cz>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3997; h=from:subject; bh=lnTSGez6Q9eImCh8FdjJFqJchZTtgEYbqvsPKds/zgY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBh3HiqiV0DU4uw6pew4XLkDsl6GTheYha3jjbCcxtr FaChu/aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYdx4qgAKCRCcnaoHP2RA2azqB/ 43htG4GA3mcQSeADLe+MmvELA7tb0mgy6vgcdZB8HdS+/8C7YRackdNf9zP2seujMd8BtYdUBC1Xpf s4bN9duKCihjnNl3eO5ab8lA8TtdLi3Cu7z+vyYpLranaNUkd9CyYtfiiIi1IBvRGj8YJH2xd2qIYH xB3AnlxB8iLywgL7vKixRgEf2zq8dacG7pC+kueGvs3IRofFTryuhpg0+MA7XiQJQ7LRLtMytH4SJM WvUwXeF+25mU0CgLsqIHtRzvgknfC6nxsNZv/snckwovfWnTerpfxLh1oZ3ZzT/mtAQ83/31Sj9Bb3 aLA8sOKi6mMFi5oY1L6hVWGrKMpcyx
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
  loop back in do_select() but fdget() in the setup of poll_wqueues
fails now so we never find 'fd' is ready for reading and sleep in
poll_schedule_timeout() indefinitely.

Treat fd that got closed as a fd on which some event happened. This
makes sure cannot block indefinitely in do_select().

Another option would be to return -EBADF in this case but that has a
potential of subtly breaking applications that excercise this behavior
and it happens to work for them. So returning fd as active seems like a
safer choice.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/select.c | 63 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 945896d0ac9e..5edffee1162c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -458,9 +458,11 @@ static int max_select_fd(unsigned long n, fd_set_bits *fds)
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
@@ -527,6 +529,7 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
 					break;
 				if (!(bit & all_bits))
 					continue;
+				mask = EPOLLNVAL;
 				f = fdget(i);
 				if (f.file) {
 					wait_key_set(wait, in, out, bit,
@@ -534,34 +537,34 @@ static int do_select(int n, fd_set_bits *fds, struct timespec64 *end_time)
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
-- 
2.31.1

