Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF73455D3C3
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiF1CXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244017AbiF1CWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:22:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553292529C;
        Mon, 27 Jun 2022 19:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E517A6185D;
        Tue, 28 Jun 2022 02:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37BDC341CE;
        Tue, 28 Jun 2022 02:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382926;
        bh=1C8Fs1ISNAAjb8GPeVY86Ikuad8K9+kLhmyylZ5CFzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5fuT0CsQvXaMGTbLSJINwrRFPGoMuA/HmSaVm/7xdLLdNDw+zOT8X9yVpKFFs6ct
         vtxG2LOKj7fbeLBMl0gV3wOySnOWo4ws+fwOf19zL7wjfm9dH7nfCSAelY6nEHZzp6
         Bug4eef/gmrl/ccv2jAE8aZR2JMlp1zd0toOYbOXyG+upErmDTdbooPfvKWL1L0DpA
         cmJfPS2VjuZq0aB7uF+i/dln2WmFF2LlEq9a7qCdl+fU0ME1KcDaAVOq7h6kqUbcpg
         stBXOcJRfuzm+GuEaNWMOwqDk3TUN3Iz9lRNOqqeIo3iCNpRa9W+Wb+Q6bzkqtJTTP
         ZkKJI/QqlhEhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/41] io_uring: fix merge error in checking send/recv addr2 flags
Date:   Mon, 27 Jun 2022 22:20:45 -0400
Message-Id: <20220628022100.595243-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b60cac14bb3c88cff2a7088d9095b01a80938c41 ]

With the dropping of the IOPOLL checking in the per-opcode handlers,
we inadvertently left two checks in the recv/recvmsg and send/sendmsg
prep handlers for the same thing, and one of them includes addr2 which
holds the flags for these opcodes.

Fix it up and kill the redundant checks.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be2176575353..263d79cb7b31 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4786,8 +4786,6 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -5009,8 +5007,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-- 
2.35.1

