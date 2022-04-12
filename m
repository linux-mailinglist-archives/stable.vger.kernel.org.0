Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96164FD937
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353179AbiDLHh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353770AbiDLHZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BAC6370;
        Tue, 12 Apr 2022 00:04:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0052BB81A8F;
        Tue, 12 Apr 2022 07:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABA2C385A8;
        Tue, 12 Apr 2022 07:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747063;
        bh=v8vZV7VrgaNKnGheucSUgWakZ1UVVzDmQ8si1q9HAqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHVFBJ/FimaenXdsdS3SkIde6QDW4v728pZ/+tOp6LOkMbEefk4AzA845uTG7P2IC
         rF8JqNJPnbGpMJ5LbCUSE/RvB5QY555k0IEicRI7g3NG0xzvSUS2raQNty8lEmq1g5
         SZp84xlrQbwyW6AWGeR+cPBADHAUYzP9RlgGOGf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 203/285] io_uring: nospec index for tags on files update
Date:   Tue, 12 Apr 2022 08:31:00 +0200
Message-Id: <20220412062949.518858054@linuxfoundation.org>
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
index 49cafa0a8b8f..c744b9910d9e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8640,7 +8640,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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



