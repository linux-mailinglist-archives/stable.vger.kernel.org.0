Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B318C4F304E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245483AbiDEJLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244717AbiDEIwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D9B1AF0D;
        Tue,  5 Apr 2022 01:42:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 984D1B81A32;
        Tue,  5 Apr 2022 08:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A5BC385A0;
        Tue,  5 Apr 2022 08:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148160;
        bh=3jS/1+1QYAeYKa8cy05dKsvo8e3E1btsbL4192s26p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSA4FXOmo8JlRLEb+/omQfIEConP6H+p4DIbg0isqJT4+f+gcjUsaUlP/r3/kzrGQ
         TTB3fJdL5XWYsa7rGnJw+ZGlzlscKFcggom/8z8ZrDPP6UGmE2vWDmd49UgAq4nYx1
         HRiiuJ2sbR4W4nRgj5bK0QYYQPm4eem+4bF5p1WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0255/1017] io_uring: dont check unrelated req->open.how in accept request
Date:   Tue,  5 Apr 2022 09:19:28 +0200
Message-Id: <20220405070401.832562237@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 783d7380331b..974f6fb327e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5178,8 +5178,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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



