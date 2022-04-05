Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6D84F2FC5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350125AbiDEKvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345620AbiDEJnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:43:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99723C29;
        Tue,  5 Apr 2022 02:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B4F4616BD;
        Tue,  5 Apr 2022 09:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95817C385A0;
        Tue,  5 Apr 2022 09:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150960;
        bh=4lI4hnSkgIv5RGKjm3QIurZf7pNPW8XJsLWWlKGO3Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2bmuKKPIJkhNIp4FcGghFj7RKZsX1QqIQJR4oZGL9U7YwxS/1Mj/mEEFMlAerbPA
         muxszx6KKKkum2KqsBXYw58CTJ4trKe82wOkljtHlJ3x6M9wGD+IkX11zWT4DVl5E/
         POBECA0EQJWA31u+wQjptfwRSjNTtEIrUIifuhOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/913] io_uring: dont check unrelated req->open.how in accept request
Date:   Tue,  5 Apr 2022 09:21:44 +0200
Message-Id: <20220405070347.111537778@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

[ Upstream commit adf3a9e9f556613197583a1884f0de40a8bb6fb9 ]

Looks like a victim of too much copy/paste, we should not be looking
at req->open.how in accept. The point is to check CLOEXEC and error
out, which we don't invalid direct descriptors on exec. Hence any
attempt to get a direct descriptor with CLOEXEC is invalid.

No harm is done here, as req->open.how.flags overlaps with
req->accept.flags, but it's very confusing and might change if either of
those command structs are modified.

Fixes: aaa4db12ef7b ("io_uring: accept directly into fixed file table")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 156c54ebb62b..70e85f64dc38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5154,8 +5154,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->nofile = rlimit(RLIMIT_NOFILE);
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && ((req->open.how.flags & O_CLOEXEC) ||
-				  (accept->flags & SOCK_CLOEXEC)))
+	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
 		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
-- 
2.34.1



