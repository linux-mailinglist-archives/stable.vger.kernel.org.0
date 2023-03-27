Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840E36CAF27
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjC0Tt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjC0Ttu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:49:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A274492;
        Mon, 27 Mar 2023 12:49:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 236DEB818CF;
        Mon, 27 Mar 2023 19:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4EE5C433EF;
        Mon, 27 Mar 2023 19:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679946577;
        bh=PV4seUUzuOiGZWyqTrF3bKEurH+BkPbi21B6FZjHngY=;
        h=Date:To:From:Subject:From;
        b=sUWOLIJPIfhydYHzQ3uVBciniFDN9Bn0RWEtiAbEP4Yl1O92HbvmuE3zDQhsC+zis
         r8flKDjvTNYTIEwnbSzUluyASATU7cqHo3S0n7PYgb8vZ7F/zUmnUz7I+mA622lVps
         8DFBfW7o8m41J+N86AYzS0kaWF5wOYnjJmflCbSY=
Date:   Mon, 27 Mar 2023 12:49:37 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch added to mm-hotfixes-unstable branch
Message-Id: <20230327194937.B4EE5C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
Date: Tue, 28 Mar 2023 02:53:18 +0900

The finalization of nilfs_segctor_thread() can race with
nilfs_segctor_kill_thread() which terminates that thread, potentially
causing a use-after-free BUG as KASAN detected.

At the end of nilfs_segctor_thread(), it assigns NULL to "sc_task" member
of "struct nilfs_sc_info" to indicate the thread has finished, and then
notifies nilfs_segctor_kill_thread() of this using waitqueue
"sc_wait_task" on the struct nilfs_sc_info.

However, here, immediately after the NULL assignment to "sc_task", it is
possible that nilfs_segctor_kill_thread() will detect it and return to
continue the deallocation, freeing the nilfs_sc_info structure before the
thread does the notification.

This fixes the issue by protecting the NULL assignment to "sc_task" and
its notification, with spinlock "sc_state_lock" of the struct
nilfs_sc_info.  Since nilfs_segctor_kill_thread() does a final check to
see if "sc_task" is NULL with "sc_state_lock" locked, this can eliminate
the race.

Link: https://lkml.kernel.org/r/20230327175318.8060-1-konishi.ryusuke@gmail.com
Reported-by: syzbot+b08ebcc22f8f3e6be43a@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/00000000000000660d05f7dfa877@google.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread
+++ a/fs/nilfs2/segment.c
@@ -2609,11 +2609,10 @@ static int nilfs_segctor_thread(void *ar
 	goto loop;
 
  end_thread:
-	spin_unlock(&sci->sc_state_lock);
-
 	/* end sync. */
 	sci->sc_task = NULL;
 	wake_up(&sci->sc_wait_task); /* for nilfs_segctor_kill_thread() */
+	spin_unlock(&sci->sc_state_lock);
 	return 0;
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch

