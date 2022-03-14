Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE55B4D847B
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiCNMYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbiCNMVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B67213E2A;
        Mon, 14 Mar 2022 05:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EAD5B80DF5;
        Mon, 14 Mar 2022 12:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3D7C340E9;
        Mon, 14 Mar 2022 12:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260384;
        bh=jSQBdgjmG/0puOUtBTQLeaUF/iDNY/kxEsrAKEP7R2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5ldQgIExWWnNNi2rbqK6wadbGkR0N1kkUFXJ8wL2PMRrksaNfo0RpyAxS52Vo7Dr
         heigFBZGfxjv+ilKftp3WtjJPQ2yn4U4DfNDiqm49i59i9jYMLShIRhHNHF5d/vypw
         o+iYdk5Tq0Ab/8AIf8sdxFI6I5f5cjIbcQXsaLSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 106/121] watch_queue, pipe: Free watchqueue state after clearing pipe ring
Date:   Mon, 14 Mar 2022 12:54:49 +0100
Message-Id: <20220314112747.070105171@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
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


