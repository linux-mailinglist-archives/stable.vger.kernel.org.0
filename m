Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CEC4F27A6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiDEIHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiDEH6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C7A205D;
        Tue,  5 Apr 2022 00:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47940B81B90;
        Tue,  5 Apr 2022 07:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB7FC340EE;
        Tue,  5 Apr 2022 07:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145149;
        bh=jnkCMnl/4rUMdPzGe48qoPlC/WeFENB7x3XyNchNE/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8DV7l6YsIwSw2HMVO53vDnWu9Z0VBtVxCDKUXRgszn9yLKw8tzhK96umcreyhXU2
         e12hP+16ImrXefm+3a28mPXGuU3UTAnXy5fxpveCwUsvKt7DxgreV9SONjn1b8cYSj
         6vdBQW7dsHTcPNC+FcIhg/060BG62ubKlPQdTius=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0264/1126] io_uring: dont check unrelated req->open.how in accept request
Date:   Tue,  5 Apr 2022 09:16:51 +0200
Message-Id: <20220405070415.360010671@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 1d79e5548de2..5ea7650b74eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5264,8 +5264,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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



