Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9044F29FC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355591AbiDEKUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347031AbiDEJYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:24:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84403A94C1;
        Tue,  5 Apr 2022 02:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72204B81C6D;
        Tue,  5 Apr 2022 09:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3351C385A0;
        Tue,  5 Apr 2022 09:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150058;
        bh=GkMbuM0N3bx8zk89Q8KBknMKfuJoWp/romGhKcSfTfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgbkzFZVy7a5SVtecpCW1e9iJcnJW12qMp/+74q4l95h0izTuaCR6MI9RzPIK3WHb
         G6y7tqiN4VKfeBf2jovtpme647V+oKImwF+0Hb5XBfsDTJKNF4VVcF6ph4xigqMziZ
         1s5AGdPLZ9HziskTzZzRbLWfOt63NJUzzKzY869M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+25ea042ae28f3888727a@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        David Howells <dhowells@redhat.com>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0939/1017] watch_queue: Free the page array when watch_queue is dismantled
Date:   Tue,  5 Apr 2022 09:30:52 +0200
Message-Id: <20220405070422.088329614@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b490207017ba237d97b735b2aa66dc241ccd18f5 upstream.

Commit 7ea1a0124b6d ("watch_queue: Free the alloc bitmap when the
watch_queue is torn down") took care of the bitmap, but not the page
array.

  BUG: memory leak
  unreferenced object 0xffff88810d9bc140 (size 32):
  comm "syz-executor335", pid 3603, jiffies 4294946994 (age 12.840s)
  hex dump (first 32 bytes):
    40 a7 40 04 00 ea ff ff 00 00 00 00 00 00 00 00  @.@.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
     kmalloc_array include/linux/slab.h:621 [inline]
     kcalloc include/linux/slab.h:652 [inline]
     watch_queue_set_size+0x12f/0x2e0 kernel/watch_queue.c:251
     pipe_ioctl+0x82/0x140 fs/pipe.c:632
     vfs_ioctl fs/ioctl.c:51 [inline]
     __do_sys_ioctl fs/ioctl.c:874 [inline]
     __se_sys_ioctl fs/ioctl.c:860 [inline]
     __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:860
     do_syscall_x64 arch/x86/entry/common.c:50 [inline]

Reported-by: syzbot+25ea042ae28f3888727a@syzkaller.appspotmail.com
Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20220322004654.618274-1-eric.dumazet@gmail.com/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -373,6 +373,7 @@ static void __put_watch_queue(struct kre
 
 	for (i = 0; i < wqueue->nr_pages; i++)
 		__free_page(wqueue->notes[i]);
+	kfree(wqueue->notes);
 	bitmap_free(wqueue->notes_bitmap);
 
 	wfilter = rcu_access_pointer(wqueue->filter);


