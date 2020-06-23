Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10937205C7F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbgFWUCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387826AbgFWUC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C181220E65;
        Tue, 23 Jun 2020 20:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942548;
        bh=G6gJobnW9yi0MNv6+w9KLJ9SHXHL/JVkkUHzlJdmsLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP9T6cymzwJo4c6ksnBO9KFluWQHwtmmu2KezEr8w79/h4QSE/n1jYs6Fix0i2Uu0
         kLkJVwImVDH3iO8JwQSzqQXzTL8JghRcylooQIu2ABy05UIyqRUya6Wv98TxpZSek1
         E33YmIGkA+E7dG45XMNeNwggr/G+kQYO208xh6/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 034/477] f2fs: compress: let lz4 compressor handle output buffer budget properly
Date:   Tue, 23 Jun 2020 21:50:31 +0200
Message-Id: <20200623195409.212029184@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit f6644143c63f2eac88973f7fea087582579b0189 ]

Commonly, in order to handle lz4 worst compress case, caller should
allocate buffer with size of LZ4_compressBound(inputsize) for target
compressed data storing, however in this case, if caller didn't
allocate enough space, lz4 compressor still can handle output buffer
budget properly, and end up compressing when left space in output
buffer is not enough.

So we don't have to allocate buffer with size for worst case, then
we can avoid 2 * 4KB size intermediate buffer allocation when
log_cluster_size is 2, and avoid unnecessary compressing work of
compressor if we can not save at least 4KB space.

Suggested-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index df7b2d15eacde..c05801758a358 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -236,7 +236,12 @@ static int lz4_init_compress_ctx(struct compress_ctx *cc)
 	if (!cc->private)
 		return -ENOMEM;
 
-	cc->clen = LZ4_compressBound(PAGE_SIZE << cc->log_cluster_size);
+	/*
+	 * we do not change cc->clen to LZ4_compressBound(inputsize) to
+	 * adapt worst compress case, because lz4 compressor can handle
+	 * output budget properly.
+	 */
+	cc->clen = cc->rlen - PAGE_SIZE - COMPRESS_HEADER_SIZE;
 	return 0;
 }
 
@@ -252,11 +257,9 @@ static int lz4_compress_pages(struct compress_ctx *cc)
 
 	len = LZ4_compress_default(cc->rbuf, cc->cbuf->cdata, cc->rlen,
 						cc->clen, cc->private);
-	if (!len) {
-		printk_ratelimited("%sF2FS-fs (%s): lz4 compress failed\n",
-				KERN_ERR, F2FS_I_SB(cc->inode)->sb->s_id);
-		return -EIO;
-	}
+	if (!len)
+		return -EAGAIN;
+
 	cc->clen = len;
 	return 0;
 }
-- 
2.25.1



