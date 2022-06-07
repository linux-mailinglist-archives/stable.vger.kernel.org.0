Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37372541BFE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382375AbiFGVzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384193AbiFGVyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:54:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F3A249308;
        Tue,  7 Jun 2022 12:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34E3BB8237B;
        Tue,  7 Jun 2022 19:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D41BC385A2;
        Tue,  7 Jun 2022 19:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629185;
        bh=WDi9eZKrDjNID0ZsV7FKg95K6kjV/su4UXky+RTVxQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnwghS/UT82E3L2xFdeF4W6T+g74lLAqb2Zr7leLhbhFw1EfajpLHEuRsdZ94DA2I
         FGI9Xgf/tz1PfxXJl/P5no9yaEDwVaYAlCCUcuXyjopnF2uKgUpoa0/DOwoCnZ3dhY
         /PJWQ2acFltySjt/Zx57HhtP2ThzjjoZFg1cU39I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        syzbot+bdd6e38a1ed5ee58d8bd@syzkaller.appspotmail.com,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.18 601/879] list: fix a data-race around ep->rdllist
Date:   Tue,  7 Jun 2022 19:01:59 +0200
Message-Id: <20220607165020.297489097@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

[ Upstream commit d679ae94fdd5d3ab00c35078f5af5f37e068b03d ]

ep_poll() first calls ep_events_available() with no lock held and checks
if ep->rdllist is empty by list_empty_careful(), which reads
rdllist->prev.  Thus all accesses to it need some protection to avoid
store/load-tearing.

Note INIT_LIST_HEAD_RCU() already has the annotation for both prev
and next.

Commit bf3b9f6372c4 ("epoll: Add busy poll support to epoll with socket
fds.") added the first lockless ep_events_available(), and commit
c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")
made some ep_events_available() calls lockless and added single call under
a lock, finally commit e59d3c64cba6 ("epoll: eliminate unnecessary lock
for zero timeout") made the last ep_events_available() lockless.

BUG: KCSAN: data-race in do_epoll_wait / do_epoll_wait

write to 0xffff88810480c7d8 of 8 bytes by task 1802 on cpu 0:
 INIT_LIST_HEAD include/linux/list.h:38 [inline]
 list_splice_init include/linux/list.h:492 [inline]
 ep_start_scan fs/eventpoll.c:622 [inline]
 ep_send_events fs/eventpoll.c:1656 [inline]
 ep_poll fs/eventpoll.c:1806 [inline]
 do_epoll_wait+0x4eb/0xf40 fs/eventpoll.c:2234
 do_epoll_pwait fs/eventpoll.c:2268 [inline]
 __do_sys_epoll_pwait fs/eventpoll.c:2281 [inline]
 __se_sys_epoll_pwait+0x12b/0x240 fs/eventpoll.c:2275
 __x64_sys_epoll_pwait+0x74/0x80 fs/eventpoll.c:2275
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88810480c7d8 of 8 bytes by task 1799 on cpu 1:
 list_empty_careful include/linux/list.h:329 [inline]
 ep_events_available fs/eventpoll.c:381 [inline]
 ep_poll fs/eventpoll.c:1797 [inline]
 do_epoll_wait+0x279/0xf40 fs/eventpoll.c:2234
 do_epoll_pwait fs/eventpoll.c:2268 [inline]
 __do_sys_epoll_pwait fs/eventpoll.c:2281 [inline]
 __se_sys_epoll_pwait+0x12b/0x240 fs/eventpoll.c:2275
 __x64_sys_epoll_pwait+0x74/0x80 fs/eventpoll.c:2275
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffff88810480c7d0 -> 0xffff888103c15098

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1799 Comm: syz-fuzzer Tainted: G        W         5.17.0-rc7-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Link: https://lkml.kernel.org/r/20220322002653.33865-3-kuniyu@amazon.co.jp
Fixes: e59d3c64cba6 ("epoll: eliminate unnecessary lock for zero timeout")
Fixes: c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")
Fixes: bf3b9f6372c4 ("epoll: Add busy poll support to epoll with socket fds.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Reported-by: syzbot+bdd6e38a1ed5ee58d8bd@syzkaller.appspotmail.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>
Cc: "Soheil Hassas Yeganeh" <soheil@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Sridhar Samudrala" <sridhar.samudrala@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/list.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 0f7d8ec5b4ed..0df13cb03028 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -35,7 +35,7 @@
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	WRITE_ONCE(list->next, list);
-	list->prev = list;
+	WRITE_ONCE(list->prev, list);
 }
 
 #ifdef CONFIG_DEBUG_LIST
@@ -306,7 +306,7 @@ static inline int list_empty(const struct list_head *head)
 static inline void list_del_init_careful(struct list_head *entry)
 {
 	__list_del_entry(entry);
-	entry->prev = entry;
+	WRITE_ONCE(entry->prev, entry);
 	smp_store_release(&entry->next, entry);
 }
 
@@ -326,7 +326,7 @@ static inline void list_del_init_careful(struct list_head *entry)
 static inline int list_empty_careful(const struct list_head *head)
 {
 	struct list_head *next = smp_load_acquire(&head->next);
-	return list_is_head(next, head) && (next == head->prev);
+	return list_is_head(next, head) && (next == READ_ONCE(head->prev));
 }
 
 /**
-- 
2.35.1



