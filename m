Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE66309C8
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiKSCSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiKSCSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:18:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9198EB3886;
        Fri, 18 Nov 2022 18:13:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE30ECE2104;
        Sat, 19 Nov 2022 02:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1998C43141;
        Sat, 19 Nov 2022 02:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824032;
        bh=Fu6DzExXhRgqLhgG4YGKf6SpJ0oVOOjKmdZ+iEn3Rjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wig7QjyQ71m3Y32KcvRQgzQ3Eaq4Rvn0C91S7ub02WmkR2nTeX9dG8KMEqxVuUiXz
         832lcovCKo6pjhZw6s7s9/3gia4J/HDJdZQFUSEcYxEQjPqV72XRHnfKN805v0V4cp
         ctlaFvV7Flqq5BIC5m3wM4gVBNb1PQvsBDy2n1002ezRpoir20RD8KdNfKAFwddE4p
         5xduK1PHrnI0Ka+BmP3l6SeRXvZw0K2+PkD1eUfydEBYSJcf+9OegDRPGCcYkgPfFN
         nZYie8iNL6u07ARXHiwpHUVSOIidi1Y2pY72b4H+fe11hJWGn8VNnbt+eXf/WCejTF
         R+EObOiSpxSLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 44/44] io_uring/poll: lockdep annote io_poll_req_insert_locked
Date:   Fri, 18 Nov 2022 21:11:24 -0500
Message-Id: <20221119021124.1773699-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 5576035f15dfcc6cb1cec236db40c2c0733b0ba4 ]

Add a lockdep annotation in io_poll_req_insert_locked().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8115d8e702733754d0aea119e9b5bb63d1eb8b24.1668184658.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..810425ec2736 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -116,6 +116,8 @@ static void io_poll_req_insert_locked(struct io_kiocb *req)
 	struct io_hash_table *table = &req->ctx->cancel_table_locked;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
 
+	lockdep_assert_held(&req->ctx->uring_lock);
+
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
-- 
2.35.1

