Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6842C6648DD
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbjAJSP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239041AbjAJSP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEE719294
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:13:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E7FD6182C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CACC433F1;
        Tue, 10 Jan 2023 18:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374401;
        bh=crB9Rdh0h9jCxbbNJhNtCqjf7ifM9NLkH7Fa0seJnfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWwazh+sd3RASvIz97Oyj4t7m/3fTfjf6e6y/djAPm5R9LjKw9pkDmuapPlBtKAbx
         mByelzUw6E78gnQJeath9BG3IItOA6s462eIOf6RHJIrHFKEdzgu9vcs9N1fUb4WD2
         icBjOx1NstLrZfYvmvlTcI4dXdfwugnSiky0dNCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 6.0 143/148] ksmbd: fix infinite loop in ksmbd_conn_handler_loop()
Date:   Tue, 10 Jan 2023 19:04:07 +0100
Message-Id: <20230110180021.715411224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 83dcedd5540d4ac61376ddff5362f7d9f866a6ec upstream.

If kernel_recvmsg() return -EAGAIN in ksmbd_tcp_readv() and go round
again, It will cause infinite loop issue. And all threads from next
connections would be doing that. This patch add max retry count(2) to
avoid it. kernel_recvmsg() will wait during 7sec timeout and try to
retry two time if -EAGAIN is returned. And add flags of kvmalloc to
__GFP_NOWARN and __GFP_NORETRY to disconnect immediately without
retrying on memory alloation failure.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-18259
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c    |    7 +++++--
 fs/ksmbd/transport_tcp.c |    5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -310,9 +310,12 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size, GFP_KERNEL);
+		conn->request_buf = kvmalloc(size,
+					     GFP_KERNEL |
+					     __GFP_NOWARN |
+					     __GFP_NORETRY);
 		if (!conn->request_buf)
-			continue;
+			break;
 
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 		if (!ksmbd_smb_request(conn))
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -295,6 +295,7 @@ static int ksmbd_tcp_readv(struct tcp_tr
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
+	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -321,9 +322,11 @@ static int ksmbd_tcp_readv(struct tcp_tr
 		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
 			total_read = -EAGAIN;
 			break;
-		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
+			   max_retry) {
 			usleep_range(1000, 2000);
 			length = 0;
+			max_retry--;
 			continue;
 		} else if (length <= 0) {
 			total_read = -EAGAIN;


