Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18304D8318
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiCNMMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242888AbiCNMLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0863033A1D;
        Mon, 14 Mar 2022 05:10:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC885B80DF6;
        Mon, 14 Mar 2022 12:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA970C340EC;
        Mon, 14 Mar 2022 12:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259801;
        bh=blSzkE0diLpAz0nAF+i5aaDVUw3yAONYwdMGUTE07xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoxgLUajrnwCjuXTqRkn1JOj1FmJfU7Q2+0Cw+SafznZvagWFbBaH9lqRQR/zpqE6
         zUbLmD2zWRY7wEY/LHidLqRuRmVRxPnZrHrsVVyuGDHCh9H1rM3zFOMGeLtmBeHIxP
         Iw94Y3LHI5sfgD7MQQoXEd7afmeLT2W+SYn9q0Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 093/110] watch_queue: Fix filter limit check
Date:   Mon, 14 Mar 2022 12:54:35 +0100
Message-Id: <20220314112745.624808982@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit c993ee0f9f81caf5767a50d1faeba39a0dc82af2 upstream.

In watch_queue_set_filter(), there are a couple of places where we check
that the filter type value does not exceed what the type_filter bitmap
can hold.  One place calculates the number of bits by:

   if (tf[i].type >= sizeof(wfilter->type_filter) * 8)

which is fine, but the second does:

   if (tf[i].type >= sizeof(wfilter->type_filter) * BITS_PER_LONG)

which is not.  This can lead to a couple of out-of-bounds writes due to
a too-large type:

 (1) __set_bit() on wfilter->type_filter
 (2) Writing more elements in wfilter->filters[] than we allocated.

Fix this by just using the proper WATCH_TYPE__NR instead, which is the
number of types we actually know about.

The bug may cause an oops looking something like:

  BUG: KASAN: slab-out-of-bounds in watch_queue_set_filter+0x659/0x740
  Write of size 4 at addr ffff88800d2c66bc by task watch_queue_oob/611
  ...
  Call Trace:
   <TASK>
   dump_stack_lvl+0x45/0x59
   print_address_description.constprop.0+0x1f/0x150
   ...
   kasan_report.cold+0x7f/0x11b
   ...
   watch_queue_set_filter+0x659/0x740
   ...
   __x64_sys_ioctl+0x127/0x190
   do_syscall_64+0x43/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

  Allocated by task 611:
   kasan_save_stack+0x1e/0x40
   __kasan_kmalloc+0x81/0xa0
   watch_queue_set_filter+0x23a/0x740
   __x64_sys_ioctl+0x127/0x190
   do_syscall_64+0x43/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

  The buggy address belongs to the object at ffff88800d2c66a0
   which belongs to the cache kmalloc-32 of size 32
  The buggy address is located 28 bytes inside of
   32-byte region [ffff88800d2c66a0, ffff88800d2c66c0)

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/watch_queue.h |    3 ++-
 kernel/watch_queue.c        |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/watch_queue.h
+++ b/include/linux/watch_queue.h
@@ -28,7 +28,8 @@ struct watch_type_filter {
 struct watch_filter {
 	union {
 		struct rcu_head	rcu;
-		unsigned long	type_filter[2];	/* Bitmask of accepted types */
+		/* Bitmask of accepted types */
+		DECLARE_BITMAP(type_filter, WATCH_TYPE__NR);
 	};
 	u32			nr_filters;	/* Number of filters */
 	struct watch_type_filter filters[];
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -320,7 +320,7 @@ long watch_queue_set_filter(struct pipe_
 		    tf[i].info_mask & WATCH_INFO_LENGTH)
 			goto err_filter;
 		/* Ignore any unknown types */
-		if (tf[i].type >= sizeof(wfilter->type_filter) * 8)
+		if (tf[i].type >= WATCH_TYPE__NR)
 			continue;
 		nr_filter++;
 	}
@@ -336,7 +336,7 @@ long watch_queue_set_filter(struct pipe_
 
 	q = wfilter->filters;
 	for (i = 0; i < filter.nr_filters; i++) {
-		if (tf[i].type >= sizeof(wfilter->type_filter) * BITS_PER_LONG)
+		if (tf[i].type >= WATCH_TYPE__NR)
 			continue;
 
 		q->type			= tf[i].type;


