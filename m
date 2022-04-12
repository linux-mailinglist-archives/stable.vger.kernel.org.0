Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C5F4FD9F0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344401AbiDLHhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353717AbiDLHZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BA9F6E;
        Tue, 12 Apr 2022 00:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E16C761045;
        Tue, 12 Apr 2022 07:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6D2C385A1;
        Tue, 12 Apr 2022 07:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747047;
        bh=QfgYC+KY/2KOvHfkTtApVBJJ78wgukpzMTQSv8FIaSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GoCRUkCC3qqnJ3QRFmGptNRVvcdk5RgRl+jpDhYCokPitCkh3PjnVCzAcXh8AdCDl
         138J0ekY8j2bYpp0gXPTHZSgXDD77dxr9SBN4sO8KJoB4p0Q6gdqFsSUJe5i9jsC7R
         5LvgmZSRdAbEf6sJgh/3EsfRMUEHa4vN/HYJTOnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 224/285] io_uring: dont check req->file in io_fsync_prep()
Date:   Tue, 12 Apr 2022 08:31:21 +0200
Message-Id: <20220412062950.122417427@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jens Axboe <axboe@kernel.dk>

commit ec858afda857e361182ceafc3d2ba2b164b8e889 upstream.

This is a leftover from the really old days where we weren't able to
track and error early if we need a file and it wasn't assigned. Kill
the check.

Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4155,9 +4155,6 @@ static int io_fsync_prep(struct io_kiocb
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->file)
-		return -EBADF;
-
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||


