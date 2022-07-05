Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D0566D7E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiGEMYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237106AbiGEMW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:22:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A91EED3;
        Tue,  5 Jul 2022 05:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D94CB817C7;
        Tue,  5 Jul 2022 12:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C15FC341C7;
        Tue,  5 Jul 2022 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023405;
        bh=P3bKUJYb8976Oy40u/qKUXR7LPBIJvpj5mASDUwINQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bmhq1EpOeFr/seLMkoaXZUkLMZTvfxI2bjK6izzDDJI30GWzj9yOxfapFI+G5TWap
         AiF8hAvIFvMHVN6pSJK3wA+ZvQnYJTO/EN0cgv25DwIQ70I36EViZymEUhRB97Sp2s
         kVEousVjKVNcTYRtUOZvU5CM0RNKoYv/256KDuEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.18 049/102] io_uring: ensure that send/sendmsg and recv/recvmsg check sqe->ioprio
Date:   Tue,  5 Jul 2022 13:58:15 +0200
Message-Id: <20220705115619.800016858@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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

commit 73911426aaaadbae54fa72359b33a7b6a56947db upstream.

All other opcodes correctly check if this is set and -EINVAL if it is
and they don't support that field, for some reason the these were
forgotten.

This was unified a bit differently in the upstream tree, but had the
same effect as making sure we error on this field. Rather than have
a painful backport of the upstream commit, just fixup the mentioned
opcodes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5254,7 +5254,7 @@ static int io_sendmsg_prep(struct io_kio
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -5467,7 +5467,7 @@ static int io_recvmsg_prep(struct io_kio
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
+	if (unlikely(sqe->addr2 || sqe->file_index || sqe->ioprio))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));


