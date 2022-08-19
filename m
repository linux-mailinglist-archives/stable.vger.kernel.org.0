Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC2E59A0C9
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351455AbiHSQLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351887AbiHSQKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:10:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D62112F88;
        Fri, 19 Aug 2022 08:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B64DB8280D;
        Fri, 19 Aug 2022 15:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD35C433C1;
        Fri, 19 Aug 2022 15:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924623;
        bh=ANp5/WgIDqRyMIC57uBIBNKXBydsllsjWz8DlfgB8ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPh9KpA63lYSkm2ZmeJg4RJoeFLyJd97CVWBjeaOETegzS0WzvV6Q1EED5K7yizy0
         iGf8tbIbqvX/zQ/YhiD+bACb1JWmGchyS0nhJAMjw74rHrKtO9pniV9cvMH69DyYZp
         WKu82LN+e9giDTLArJIB7BUQ7x+lSfApXHO7fffM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/545] fs: check FMODE_LSEEK to control internal pipe splicing
Date:   Fri, 19 Aug 2022 17:40:00 +0200
Message-Id: <20220819153839.648613517@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 97ef77c52b789ec1411d360ed99dca1efe4b2c81 ]

The original direct splicing mechanism from Jens required the input to
be a regular file because it was avoiding the special socket case. It
also recognized blkdevs as being close enough to a regular file. But it
forgot about chardevs, which behave the same way and work fine here.

This is an okayish heuristic, but it doesn't totally work. For example,
a few chardevs should be spliceable here. And a few regular files
shouldn't. This patch fixes this by instead checking whether FMODE_LSEEK
is set, which represents decently enough what we need rewinding for when
splicing to internal pipes.

Fixes: b92ce5589374 ("[PATCH] splice: add direct fd <-> fd splicing support")
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 866d5c2367b2..6610e55c0e2a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -806,17 +806,15 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 {
 	struct pipe_inode_info *pipe;
 	long ret, bytes;
-	umode_t i_mode;
 	size_t len;
 	int i, flags, more;
 
 	/*
-	 * We require the input being a regular file, as we don't want to
-	 * randomly drop data for eg socket -> socket splicing. Use the
-	 * piped splicing for that!
+	 * We require the input to be seekable, as we don't want to randomly
+	 * drop data for eg socket -> socket splicing. Use the piped splicing
+	 * for that!
 	 */
-	i_mode = file_inode(in)->i_mode;
-	if (unlikely(!S_ISREG(i_mode) && !S_ISBLK(i_mode)))
+	if (unlikely(!(in->f_mode & FMODE_LSEEK)))
 		return -EINVAL;
 
 	/*
-- 
2.35.1



