Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFA94D8345
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241465AbiCNMN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240873AbiCNMLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70FA33EBD;
        Mon, 14 Mar 2022 05:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC4A4612FC;
        Mon, 14 Mar 2022 12:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768ABC340E9;
        Mon, 14 Mar 2022 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259830;
        bh=qrjcQzJJwJt0h45ZjSQPyEjka1WJolCH3qzCphW+dps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHlpu1K3Flx7iD30RrN0CBIMesA/i0JCyCaYMfiRPyK71WQOHLUyFLo4YnOpUJVr4
         Y5dH1Hu3Zu7CDWAge//5AeXyyzCUxAOOJ4VUs6DLxzWkRcVf0+rvi8ounVo1VMazdR
         lwWtRs5wOFAMiZ66zDBrN+62JcLG/j9Qt/PvHzz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 099/110] watch_queue: Fix lack of barrier/sync/lock between post and read
Date:   Mon, 14 Mar 2022 12:54:41 +0100
Message-Id: <20220314112745.789207503@linuxfoundation.org>
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

commit 2ed147f015af2b48f41c6f0b6746aa9ea85c19f3 upstream.

There's nothing to synchronise post_one_notification() versus
pipe_read().  Whilst posting is done under pipe->rd_wait.lock, the
reader only takes pipe->mutex which cannot bar notification posting as
that may need to be made from contexts that cannot sleep.

Fix this by setting pipe->head with a barrier in post_one_notification()
and reading pipe->head with a barrier in pipe_read().

If that's not sufficient, the rd_wait.lock will need to be taken,
possibly in a ->confirm() op so that it only applies to notifications.
The lock would, however, have to be dropped before copy_page_to_iter()
is invoked.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c            |    3 ++-
 kernel/watch_queue.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -252,7 +252,8 @@ pipe_read(struct kiocb *iocb, struct iov
 	 */
 	was_full = pipe_full(pipe->head, pipe->tail, pipe->max_usage);
 	for (;;) {
-		unsigned int head = pipe->head;
+		/* Read ->head with a barrier vs post_one_notification() */
+		unsigned int head = smp_load_acquire(&pipe->head);
 		unsigned int tail = pipe->tail;
 		unsigned int mask = pipe->ring_size - 1;
 
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -113,7 +113,7 @@ static bool post_one_notification(struct
 	buf->offset = offset;
 	buf->len = len;
 	buf->flags = PIPE_BUF_FLAG_WHOLE;
-	pipe->head = head + 1;
+	smp_store_release(&pipe->head, head + 1); /* vs pipe_read() */
 
 	if (!test_and_clear_bit(note, wqueue->notes_bitmap)) {
 		spin_unlock_irq(&pipe->rd_wait.lock);


