Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A45318EB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239588AbiEWRIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239577AbiEWRHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DC76AA77;
        Mon, 23 May 2022 10:07:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E12614D8;
        Mon, 23 May 2022 17:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADD9C385A9;
        Mon, 23 May 2022 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325639;
        bh=N9Cqymp8pKXu4Y9O5HZccS0xfN9veRewpmqi8BaRNzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TaPZtg+KhSXhlHwdznq1poXjK6ijcVJd0l4k+fBCYpLZLi9JPYCZ6H3WQDAPwJ1X
         DAM41ONg/rUWOWePuMemqXX5Gi8faNb/XGxEJMSA4l760NLngU/Eq7akIigV2d3dlz
         RxOnhAh+qvDSkDSi5rL5AJkVtbQkXpo/0v1ACgG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 02/97] io_uring: always grab file table for deferred statx
Date:   Mon, 23 May 2022 19:05:06 +0200
Message-Id: <20220523165812.675707833@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165812.244140613@linuxfoundation.org>
References: <20220523165812.244140613@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Lee reports that there's a use-after-free of the process file table.
There's an assumption that we don't need the file table for some
variants of statx invocation, but that turns out to be false and we
end up with not grabbing a reference for the request even if the
deferred execution uses it.

Get rid of the REQ_F_NO_FILE_TABLE optimization for statx, and always
grab that reference.

This issues doesn't exist upstream since the native workers got
introduced with 5.12.

Link: https://lore.kernel.org/io-uring/YoOJ%2FT4QRKC+fAZE@google.com/
Reported-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4252,12 +4252,8 @@ static int io_statx(struct io_kiocb *req
 	struct io_statx *ctx = &req->statx;
 	int ret;
 
-	if (force_nonblock) {
-		/* only need file table for an actual valid fd */
-		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
-			req->flags |= REQ_F_NO_FILE_TABLE;
+	if (force_nonblock)
 		return -EAGAIN;
-	}
 
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);


