Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FDA6D8C71
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjDFBHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 21:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjDFBHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 21:07:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9190872BE;
        Wed,  5 Apr 2023 18:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AECD5642A5;
        Thu,  6 Apr 2023 01:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A94DC433EF;
        Thu,  6 Apr 2023 01:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743219;
        bh=bJhoSyTaSwQ4oOvkzZIvhKh4+dyuQQFrFJRaIgv+zX0=;
        h=Date:To:From:Subject:From;
        b=YQKmBqpsivPqVjxO0FXh4WlRSxMorzxKdeAo/hZkaam/ulmPGo6kA0d+4RCwRZe+Q
         s9N4ojGY8ZhFeeTiNECxmZGvZGzJDR6iVo7MpZhXS34ceZt34JoqyU2CMq8FBxreuS
         WKTlC+C5iKg2GyOHlLGnh88drur0Y0/9KxCRWsK0=
Date:   Wed, 05 Apr 2023 18:06:58 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch removed from -mm tree
Message-Id: <20230406010659.0A94DC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix potential UAF of struct nilfs_sc_info in nilfs_segctor_thread()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


