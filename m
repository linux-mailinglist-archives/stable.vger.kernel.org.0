Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24D5594881
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355445AbiHOX4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355395AbiHOXwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:52:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5EA2CCB2;
        Mon, 15 Aug 2022 13:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C45DB80EB1;
        Mon, 15 Aug 2022 20:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642FFC433C1;
        Mon, 15 Aug 2022 20:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594608;
        bh=X9e1ULn5u8dN/vWtVUa60/Uy8EpTPSSad7gGvaqhSkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2jq8s3y63RKPKZXCOuc41vW0KgVLKNAQzSOm459RUD79eaSssTkTDI1ntvlOCqRk
         dRdCPayOKQmFhAkN0UTTNLDkTlSB2YoWP92ip3V99ykXQK9u3hT+lc81o5oUmBwHYS
         aI6LT8ORL7I/IfYlb+t5trHO4F+Um4Z7vkj0LYVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0502/1157] fs: check FMODE_LSEEK to control internal pipe splicing
Date:   Mon, 15 Aug 2022 19:57:38 +0200
Message-Id: <20220815180459.771925815@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 047b79db8eb5..93a2c9bf6249 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -814,17 +814,15 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
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



