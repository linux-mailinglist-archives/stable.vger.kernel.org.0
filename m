Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFAA593AD7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347220AbiHOUXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347326AbiHOUWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E21F33427;
        Mon, 15 Aug 2022 12:02:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDB661281;
        Mon, 15 Aug 2022 19:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3CBC433D6;
        Mon, 15 Aug 2022 19:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590147;
        bh=uLFx4RHYD59OS7NFdOPVWAzPXWiJpunBElMg6vgcyso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxVtU3AiDJQg3kdN3HuT9eAXfb0lka6ED/Bb8AVUgl9YL2NQIRIpmmap+pWJU2wDF
         PAXrgc2zy8X4cpo/tO6uQQMFD73D0NPxlYo9c4+qYt3ZSs3GQzgTCRLw3p7yruGk8V
         lMIbG385VteoWY/jI00BGzvyAYOqN5psB5qu9vu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Roman Penyaev <rpenyaev@suse.de>,
        Jason Baron <jbaron@akamai.com>,
        Khazhismel Kumykov <khazhy@google.com>, Heiher <r@hev.cc>,
        stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 0134/1095] epoll: autoremove wakers even more aggressively
Date:   Mon, 15 Aug 2022 19:52:13 +0200
Message-Id: <20220815180435.143346938@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Benjamin Segall <bsegall@google.com>

commit a16ceb13961068f7209e34d7984f8e42d2c06159 upstream.

If a process is killed or otherwise exits while having active network
connections and many threads waiting on epoll_wait, the threads will all
be woken immediately, but not removed from ep->wq.  Then when network
traffic scans ep->wq in wake_up, every wakeup attempt will fail, and will
not remove the entries from the list.

This means that the cost of the wakeup attempt is far higher than usual,
does not decrease, and this also competes with the dying threads trying to
actually make progress and remove themselves from the wq.

Handle this by removing visited epoll wq entries unconditionally, rather
than only when the wakeup succeeds - the structure of ep_poll means that
the only potential loss is the timed_out->eavail heuristic, which now can
race and result in a redundant ep_send_events attempt.  (But only when
incoming data and a timeout actually race, not on every timeout)

Shakeel added:

: We are seeing this issue in production with real workloads and it has
: caused hard lockups.  Particularly network heavy workloads with a lot
: of threads in epoll_wait() can easily trigger this issue if they get
: killed (oom-killed in our case).

Link: https://lkml.kernel.org/r/xm26fsjotqda.fsf@google.com
Signed-off-by: Ben Segall <bsegall@google.com>
Tested-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Roman Penyaev <rpenyaev@suse.de>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Heiher <r@hev.cc>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1747,6 +1747,21 @@ static struct timespec64 *ep_timeout_to_
 	return to;
 }
 
+/*
+ * autoremove_wake_function, but remove even on failure to wake up, because we
+ * know that default_wake_function/ttwu will only fail if the thread is already
+ * woken, and in that case the ep_poll loop will remove the entry anyways, not
+ * try to reuse it.
+ */
+static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
+				       unsigned int mode, int sync, void *key)
+{
+	int ret = default_wake_function(wq_entry, mode, sync, key);
+
+	list_del_init(&wq_entry->entry);
+	return ret;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -1828,8 +1843,15 @@ static int ep_poll(struct eventpoll *ep,
 		 * normal wakeup path no need to call __remove_wait_queue()
 		 * explicitly, thus ep->lock is not taken, which halts the
 		 * event delivery.
+		 *
+		 * In fact, we now use an even more aggressive function that
+		 * unconditionally removes, because we don't reuse the wait
+		 * entry between loop iterations. This lets us also avoid the
+		 * performance issue if a process is killed, causing all of its
+		 * threads to wake up without being removed normally.
 		 */
 		init_wait(&wait);
+		wait.func = ep_autoremove_wake_function;
 
 		write_lock_irq(&ep->lock);
 		/*


