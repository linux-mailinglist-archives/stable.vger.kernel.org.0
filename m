Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2838122A9FA
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 09:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgGWHr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 03:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGWHr0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 03:47:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2823B2086A;
        Thu, 23 Jul 2020 07:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595490445;
        bh=Ush+2kHIL5PX/Zyjr3BD+q9nJtdA4hlJQGr7FUDoKc4=;
        h=Subject:To:From:Date:From;
        b=2hsDsygC3iyQzosCEuOnC/MsvtN6kqGIlwXeQuUC943LPysKOWR+ygJaVCZ3P6+sH
         d3jOG4V01NYswWZhKDf38y04o4+MSmnBbj06TMm54rnIdSPWFccjE6bBAwxvYSB6VQ
         8fWO5j0I3YLFOtgMYUm80gSVpA2KD/i5QFx1S82U=
Subject: patch "binder: Don't use mmput() from shrinker function." added to char-misc-linus
To:     penguin-kernel@i-love.sakura.ne.jp, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org, mhocko@suse.com,
        penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org,
        syzbot+1068f09c44d151250c33@syzkaller.appspotmail.com,
        syzbot+e5344baa319c9a96edec@syzkaller.appspotmail.com,
        tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Jul 2020 09:47:30 +0200
Message-ID: <159549045037170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: Don't use mmput() from shrinker function.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f867c771f98891841c217fa8459244ed0dd28921 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Fri, 17 Jul 2020 00:12:15 +0900
Subject: binder: Don't use mmput() from shrinker function.

syzbot is reporting that mmput() from shrinker function has a risk of
deadlock [1], for delayed_uprobe_add() from update_ref_ctr() calls
kzalloc(GFP_KERNEL) with delayed_uprobe_lock held, and
uprobe_clear_state() from __mmput() also holds delayed_uprobe_lock.

Commit a1b2289cef92ef0e ("android: binder: drop lru lock in isolate
callback") replaced mmput() with mmput_async() in order to avoid sleeping
with spinlock held. But this patch replaces mmput() with mmput_async() in
order not to start __mmput() from shrinker context.

[1] https://syzkaller.appspot.com/bug?id=bc9e7303f537c41b2b0cc2dfcea3fc42964c2d45

Reported-by: syzbot <syzbot+1068f09c44d151250c33@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+e5344baa319c9a96edec@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Acked-by: Todd Kjos <tkjos@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4ba9adb2-43f5-2de0-22de-f6075c1fab50@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 42c672f1584e..cbe6aa77d50d 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -947,7 +947,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
 		trace_binder_unmap_user_end(alloc, index);
 	}
 	mmap_read_unlock(mm);
-	mmput(mm);
+	mmput_async(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 
-- 
2.27.0


