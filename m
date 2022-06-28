Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE9155D1E0
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243699AbiF1CVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbiF1CUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1646F24BE9;
        Mon, 27 Jun 2022 19:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1345B818E4;
        Tue, 28 Jun 2022 02:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D36C341CB;
        Tue, 28 Jun 2022 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382819;
        bh=XM3i6EZiXJSmAOc14cgHOFg6vFsrcGc3wuo9ksDVE+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPJjZXMOoc7jUQwbKbElazJWFR+WPoqK4qzqFUUyJh1vQ/YygUfO1RuQYyECwZ1wu
         GWepZj6MKGE/WLD7vOzgbiEItucTJGWFUAqf3EWMzXGDuoWW0duCqa/kgcnb1asb1a
         TUsUQN/x+wZrHVsgJKIS2vfcP4n6ZCr9y1+DDcL+gkNjL+1fW9UF3hwuh+74vN/wt9
         jWU3vRTAI3Wu+KyQKYAJnSF4ToZlkgL2Nu2AUj++bYXxiCQVlcZrRCOttrbK68M6WP
         D6cbNTZhdkAglr1zbYhLDNbsq4Xr1IQCzyDJzZqfibAxJ5WlHtTLuK3mxAoIhOjq6T
         OpiB9QSbkRHdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 37/53] io_uring: fix merge error in checking send/recv addr2 flags
Date:   Mon, 27 Jun 2022 22:18:23 -0400
Message-Id: <20220628021839.594423-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
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
index 725c59c734f1..9eb20f8865ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5252,8 +5252,6 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -5465,8 +5463,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-- 
2.35.1

