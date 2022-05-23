Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DF6531B47
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240480AbiEWRRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240054AbiEWRRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:17:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F27CB484;
        Mon, 23 May 2022 10:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FAF8B81217;
        Mon, 23 May 2022 17:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8730C385AA;
        Mon, 23 May 2022 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326185;
        bh=ZhMgrIXZYC4JQG9l/5ruEUYXQWr7fvPDe4CE4x66zIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNtFB86ZJb8OTKKbuhpHpVqxD8+JMKQi5aku8Jl/bH8sR4Iaoq6BmbTztVfNGls6/
         YSZjtBQUEG4/CNCAeqt/VozmjrDJ8KMZoXXXU83ysJ1ZQv1o2M5XVMpLF66zTvDdd4
         AcFA7Yzkp4ruSnqHs6VM6nW0lgg9W5VYQHEalJNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 002/132] io_uring: arm poll for non-nowait files
Date:   Mon, 23 May 2022 19:03:31 +0200
Message-Id: <20220523165823.889475480@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit e74ead135bc4459f7d40b1f8edab1333a28b54e8 upstream.

Don't check if we can do nowait before arming apoll, there are several
reasons for that. First, we don't care much about files that don't
support nowait. Second, it may be useful -- we don't want to be taking
away extra workers from io-wq when it can go in some async. Even if it
will go through io-wq eventually, it make difference in the numbers of
workers actually used. And the last one, it's needed to clean nowait in
future commits.

[kernel test robot: fix unused-var]

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9d06f3cb2c8b686d970269a87986f154edb83043.1634425438.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5662,7 +5662,6 @@ static int io_arm_poll_handler(struct io
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
-	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
@@ -5672,7 +5671,6 @@ static int io_arm_poll_handler(struct io
 		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
-		rw = READ;
 		mask |= POLLIN | POLLRDNORM;
 
 		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
@@ -5680,14 +5678,9 @@ static int io_arm_poll_handler(struct io
 		    (req->sr_msg.msg_flags & MSG_ERRQUEUE))
 			mask &= ~POLLIN;
 	} else {
-		rw = WRITE;
 		mask |= POLLOUT | POLLWRNORM;
 	}
 
-	/* if we can't nonblock try, then no point in arming a poll handler */
-	if (!io_file_supports_nowait(req, rw))
-		return IO_APOLL_ABORTED;
-
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;


