Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2904153CF45
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345581AbiFCRxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346665AbiFCRvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8515418F;
        Fri,  3 Jun 2022 10:49:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFAF9B8241E;
        Fri,  3 Jun 2022 17:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28899C385A9;
        Fri,  3 Jun 2022 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278541;
        bh=Lsl4MGIj+lFgH3ZgJ+tEmOVp6Tpf+jsCIrpUeJnyOnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVaUuKpeLNRf41/hnxvQ0i/KTsc2GlfT6bWKOQs59Iip7cfR0nLPlBEgYME/5jb/F
         D2/H3HoeXdJQITk4IkqvXOiwoV40S6/UWc2WVYs0Vv74AbkJgKYuAki6MlVvNkq4hA
         faMHqE2dlwkK1OulGbQd5+kfwG7xBg5IyGAXLaq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 13/66] pipe: make poll_usage boolean and annotate its access
Date:   Fri,  3 Jun 2022 19:42:53 +0200
Message-Id: <20220603173821.046674861@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

commit f485922d8fe4e44f6d52a5bb95a603b7c65554bb upstream.

Patch series "Fix data-races around epoll reported by KCSAN."

This series suppresses a false positive KCSAN's message and fixes a real
data-race.


This patch (of 2):

pipe_poll() runs locklessly and assigns 1 to poll_usage.  Once poll_usage
is set to 1, it never changes in other places.  However, concurrent writes
of a value trigger KCSAN, so let's make KCSAN happy.

BUG: KCSAN: data-race in pipe_poll / pipe_poll

write to 0xffff8880042f6678 of 4 bytes by task 174 on cpu 3:
 pipe_poll (fs/pipe.c:656)
 ep_item_poll.isra.0 (./include/linux/poll.h:88 fs/eventpoll.c:853)
 do_epoll_wait (fs/eventpoll.c:1692 fs/eventpoll.c:1806 fs/eventpoll.c:2234)
 __x64_sys_epoll_wait (fs/eventpoll.c:2246 fs/eventpoll.c:2241 fs/eventpoll.c:2241)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

write to 0xffff8880042f6678 of 4 bytes by task 177 on cpu 1:
 pipe_poll (fs/pipe.c:656)
 ep_item_poll.isra.0 (./include/linux/poll.h:88 fs/eventpoll.c:853)
 do_epoll_wait (fs/eventpoll.c:1692 fs/eventpoll.c:1806 fs/eventpoll.c:2234)
 __x64_sys_epoll_wait (fs/eventpoll.c:2246 fs/eventpoll.c:2241 fs/eventpoll.c:2241)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113)

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 177 Comm: epoll_race Not tainted 5.17.0-58927-gf443e374ae13 #6
Hardware name: Red Hat KVM, BIOS 1.11.0-2.amzn2 04/01/2014

Link: https://lkml.kernel.org/r/20220322002653.33865-1-kuniyu@amazon.co.jp
Link: https://lkml.kernel.org/r/20220322002653.33865-2-kuniyu@amazon.co.jp
Fixes: 3b844826b6c6 ("pipe: avoid unnecessary EPOLLET wakeups under normal loads")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kuniyuki Iwashima <kuni1840@gmail.com>
Cc: "Soheil Hassas Yeganeh" <soheil@google.com>
Cc: "Sridhar Samudrala" <sridhar.samudrala@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c                 |    2 +-
 include/linux/pipe_fs_i.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -652,7 +652,7 @@ pipe_poll(struct file *filp, poll_table
 	unsigned int head, tail;
 
 	/* Epoll has some historical nasty semantics, this enables them */
-	pipe->poll_usage = 1;
+	WRITE_ONCE(pipe->poll_usage, true);
 
 	/*
 	 * Reading pipe state only -- no need for acquiring the semaphore.
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -71,7 +71,7 @@ struct pipe_inode_info {
 	unsigned int files;
 	unsigned int r_counter;
 	unsigned int w_counter;
-	unsigned int poll_usage;
+	bool poll_usage;
 	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;


