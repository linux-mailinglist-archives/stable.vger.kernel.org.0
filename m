Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69874D82A8
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbiCNMGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240556AbiCNMFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:05:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8BB47AF3;
        Mon, 14 Mar 2022 05:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 836A2612FB;
        Mon, 14 Mar 2022 12:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851D1C340E9;
        Mon, 14 Mar 2022 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259351;
        bh=jSQBdgjmG/0puOUtBTQLeaUF/iDNY/kxEsrAKEP7R2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1SbI+Wj+UyFgzxrwXqoo0z8wsXP5WF1oR2w9l/dWrj7tS77yz4hlKr469KGzwFNV
         ZgDV1lpQ7tmVKzPcyXVtZiEH8Y+wDemrOCOQ3fypKgVZl8SP3ToRavyJOlxrCXwARZ
         YuODNLWJqqV5dSNTeL2VtsMnUqFHxhZqgOLKK//s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 59/71] watch_queue, pipe: Free watchqueue state after clearing pipe ring
Date:   Mon, 14 Mar 2022 12:53:52 +0100
Message-Id: <20220314112739.582363593@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
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

commit db8facfc9fafacefe8a835416a6b77c838088f8b upstream.

In free_pipe_info(), free the watchqueue state after clearing the pipe
ring as each pipe ring descriptor has a release function, and in the
case of a notification message, this is watch_queue_pipe_buf_release()
which tries to mark the allocation bitmap that was previously released.

Fix this by moving the put of the pipe's ref on the watch queue to after
the ring has been cleared.  We still need to call watch_queue_clear()
before doing that to make sure that the pipe is disconnected from any
notification sources first.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -830,10 +830,8 @@ void free_pipe_info(struct pipe_inode_in
 	int i;
 
 #ifdef CONFIG_WATCH_QUEUE
-	if (pipe->watch_queue) {
+	if (pipe->watch_queue)
 		watch_queue_clear(pipe->watch_queue);
-		put_watch_queue(pipe->watch_queue);
-	}
 #endif
 
 	(void) account_pipe_buffers(pipe->user, pipe->nr_accounted, 0);
@@ -843,6 +841,10 @@ void free_pipe_info(struct pipe_inode_in
 		if (buf->ops)
 			pipe_buf_release(pipe, buf);
 	}
+#ifdef CONFIG_WATCH_QUEUE
+	if (pipe->watch_queue)
+		put_watch_queue(pipe->watch_queue);
+#endif
 	if (pipe->tmp_page)
 		__free_page(pipe->tmp_page);
 	kfree(pipe->bufs);


