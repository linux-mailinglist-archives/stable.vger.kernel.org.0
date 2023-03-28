Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1116CC495
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbjC1PGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbjC1PGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:06:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC40E3AE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:05:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE913B81D8D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBC9C433D2;
        Tue, 28 Mar 2023 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015898;
        bh=k0mWRYWKj9QpM9xoUZNLxJndbuhg1oJ2Q48RKMctrrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXznwCcyPgptaFxYmUG5gLnYRmNSmlmN8n5L6Qy/6QYbnpWUf8SzaQqSXVgv5vc7c
         ymFV+aYGVHUGsClbXO9lfJJfcGZPXd39t7JGRVhHUvZVLHKDWFG6Bok+eJb5oluf8a
         OIBwZY+F6exWVkUSsJjpdsPogGxj/GJLIpuBlvbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Hui, Chunyang" <sanqian.hcy@antgroup.com>,
        Jens Axboe <axboe@kernel.dk>, Hui@vger.kernel.org
Subject: [PATCH 6.1 186/224] io_uring/net: avoid sending -ECONNABORTED on repeated connection requests
Date:   Tue, 28 Mar 2023 16:43:02 +0200
Message-Id: <20230328142625.130125362@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 74e2e17ee1f8d8a0928b90434ad7e2df70f8483e upstream.

Since io_uring does nonblocking connect requests, if we do two repeated
ones without having a listener, the second will get -ECONNABORTED rather
than the expected -ECONNREFUSED. Treat -ECONNABORTED like a normal retry
condition if we're nonblocking, if we haven't already seen it.

Cc: stable@vger.kernel.org
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Link: https://github.com/axboe/liburing/issues/828
Reported-by: Hui, Chunyang <sanqian.hcy@antgroup.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -47,6 +47,7 @@ struct io_connect {
 	struct sockaddr __user		*addr;
 	int				addr_len;
 	bool				in_progress;
+	bool				seen_econnaborted;
 };
 
 struct io_sr_msg {
@@ -1404,7 +1405,7 @@ int io_connect_prep(struct io_kiocb *req
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
-	conn->in_progress = false;
+	conn->in_progress = conn->seen_econnaborted = false;
 	return 0;
 }
 
@@ -1441,18 +1442,24 @@ int io_connect(struct io_kiocb *req, uns
 
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
-	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
+	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
 			connect->in_progress = true;
-		} else {
-			if (req_has_async_data(req))
-				return -EAGAIN;
-			if (io_alloc_async_data(req)) {
-				ret = -ENOMEM;
+			return -EAGAIN;
+		}
+		if (ret == -ECONNABORTED) {
+			if (connect->seen_econnaborted)
 				goto out;
-			}
-			memcpy(req->async_data, &__io, sizeof(__io));
+			connect->seen_econnaborted = true;
+		}
+		if (req_has_async_data(req))
+			return -EAGAIN;
+		if (io_alloc_async_data(req)) {
+			ret = -ENOMEM;
+			goto out;
 		}
+		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)


