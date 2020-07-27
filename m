Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E480822F2B2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731024AbgG0Olh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbgG0OIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:08:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D4A207FC;
        Mon, 27 Jul 2020 14:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858880;
        bh=MvE8PBdhmj1aPuM+2+7Ys0uzDZuPAyzzJmWgWV9775M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnAtT4i4VkAHLWTCbIUIQ7KLqVkCbtYJ7HN1RzroHRaHK1K09Qh0ghe3S4KQ4YK45
         MJOlt4C0v7HQOUd2WvJ3gKDTgkeWqYoqpxShCC8fjaxIlTeu7GL1f2KvBmlpWV2TSW
         7zG9+UzgcZMvnHTEWkZ9RRUCfW6M1k8TGJoz+YGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+1068f09c44d151250c33@syzkaller.appspotmail.com>,
        syzbot <syzbot+e5344baa319c9a96edec@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Michal Hocko <mhocko@suse.com>, Todd Kjos <tkjos@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 4.14 46/64] binder: Dont use mmput() from shrinker function.
Date:   Mon, 27 Jul 2020 16:04:25 +0200
Message-Id: <20200727134913.470444240@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit f867c771f98891841c217fa8459244ed0dd28921 upstream.

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
 drivers/android/binder_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -968,7 +968,7 @@ enum lru_status binder_alloc_free_page(s
 		trace_binder_unmap_user_end(alloc, index);
 	}
 	up_read(&mm->mmap_sem);
-	mmput(mm);
+	mmput_async(mm);
 
 	trace_binder_unmap_kernel_start(alloc, index);
 


