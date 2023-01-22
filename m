Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10825676FDA
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjAVPZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjAVPZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD3C22A01
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF0EB80B1A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5B5C433D2;
        Sun, 22 Jan 2023 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401153;
        bh=PdUoBRzklo3agrs2oOBjncZKyQKJk5C3zdryrEw3sHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cU7/1SNfcOsBXbGxAttqZPuweGAysQTTYijovSqSogYTv/VccvI7+ZQVK1xGMFPLS
         xduP2bfDbWrvJN7nSj31wzm6jGP6M/y9zNvLeyCIxV969mlZXCkHZS2MuEsCWg+ivt
         usrV05Y3o+0v9nHXSonpayrLdMB8MIsxDpSM2d80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>
Subject: [PATCH 6.1 100/193] io_uring/poll: dont reissue in case of poll race on multishot request
Date:   Sun, 22 Jan 2023 16:03:49 +0100
Message-Id: <20230122150250.899030527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 8caa03f10bf92cb8657408a6ece6a8a73f96ce13 upstream.

A previous commit fixed a poll race that can occur, but it's only
applicable for multishot requests. For a multishot request, we can safely
ignore a spurious wakeup, as we never leave the waitqueue to begin with.

A blunt reissue of a multishot armed request can cause us to leak a
buffer, if they are ring provided. While this seems like a bug in itself,
it's not really defined behavior to reissue a multishot request directly.
It's less efficient to do so as well, and not required to rearm anything
like it is for singleshot poll requests.

Cc: stable@vger.kernel.org
Fixes: 6e5aedb9324a ("io_uring/poll: attempt request issue after racy poll wakeup")
Reported-and-tested-by: Olivier Langlois <olivier@trillion01.com>
Link: https://github.com/axboe/liburing/issues/778
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -281,8 +281,12 @@ static int io_poll_check_events(struct i
 			 * to the waitqueue, so if we get nothing back, we
 			 * should be safe and attempt a reissue.
 			 */
-			if (unlikely(!req->cqe.res))
+			if (unlikely(!req->cqe.res)) {
+				/* Multishot armed need not reissue */
+				if (!(req->apoll_events & EPOLLONESHOT))
+					continue;
 				return IOU_POLL_REISSUE;
+			}
 		}
 		if (req->apoll_events & EPOLLONESHOT)
 			return IOU_POLL_DONE;


