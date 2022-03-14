Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71EF4D8344
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbiCNMMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242917AbiCNMLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A73233A28;
        Mon, 14 Mar 2022 05:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCBF7B80DF7;
        Mon, 14 Mar 2022 12:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9AEC340EC;
        Mon, 14 Mar 2022 12:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259805;
        bh=jSQBdgjmG/0puOUtBTQLeaUF/iDNY/kxEsrAKEP7R2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k06gW234fdo8rx7UK6d3USApiKWYvHZ7mBVizPwWbbKaJYhwj+Fw18EECOwogUsqh
         0YRjguvWTQB/QpCOlpD8oORnhtK3/8V+mBhjyKVr7kQbgMKqFsOUf/Y/24VFyP+6Ua
         NM+AXEHz1IK6iVEUbgIS71qotfvbdXPRWIG1P9QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 094/110] watch_queue, pipe: Free watchqueue state after clearing pipe ring
Date:   Mon, 14 Mar 2022 12:54:36 +0100
Message-Id: <20220314112745.651950510@linuxfoundation.org>
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


