Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA44FD6EA
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377319AbiDLHtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358643AbiDLHmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2818C5372A;
        Tue, 12 Apr 2022 00:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D1FF616B2;
        Tue, 12 Apr 2022 07:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1E6C385A1;
        Tue, 12 Apr 2022 07:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747915;
        bh=fUkDqFots+8XTufGAH2Tv2H/Ed8VwBcOzlIJyBmT3h0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ko8EwjhpQoigA9L/Eq1Kku3W7sxVy+HI6hZhr4KrpeUKnip0gBC4OP4ozzyCa9+E6
         LrFCiQqO+Rd2yaLYUZjpR/07prDC/dypxLGFVr9ooyw+7Wnw5HzhdlVAP/hzWALdjv
         27NE/uEBTzbUcEBDuC5XQWVU4suh9n8KF+LSKHu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 253/343] io_uring: nospec index for tags on files update
Date:   Tue, 12 Apr 2022 08:31:11 +0200
Message-Id: <20220412062958.627766853@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 34bb77184123ae401100a4d156584f12fa630e5c ]

Don't forget to array_index_nospec() for indexes before updating rsrc
tags in __io_sqe_files_update(), just use already safe and precalculated
index @i.

Fixes: c3bdad0271834 ("io_uring: add generic rsrc update with tags")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e6788ab188f..a3e82aececd9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8700,7 +8700,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			*io_get_tag_slot(data, up->offset + done) = tag;
+			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
-- 
2.35.1



