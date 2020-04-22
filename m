Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA59E1B3EA0
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbgDVK3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730768AbgDVK0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:26:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4AB02075A;
        Wed, 22 Apr 2020 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551207;
        bh=DancS/jE/qVPq2YgrwJDoEAbIRcgJGeQhXOSY2s0B1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jg7uFIi1TbLCYZMTrm7JqDIFCpY0O0ZsdN4Nu4onY94onBbzecRepkAaYwMrLbkUZ
         cGKeGo88+ydtdpFo3Jz+zc8KmT3RRWCtfvhdYGWQTxJc5CMXfS14/byf63RbA8Q1pi
         uNP4anFc0ARfz+anBoMneuALfhVPx79wROJJinUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 143/166] f2fs: fix leaking uninitialized memory in compressed clusters
Date:   Wed, 22 Apr 2020 11:57:50 +0200
Message-Id: <20200422095103.977899777@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 7fa6d59816e7d81cfd4f854468c477c12b85c789 ]

When the compressed data of a cluster doesn't end on a page boundary,
the remainder of the last page must be zeroed in order to avoid leaking
uninitialized memory to disk.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 11b13b881ada5..837e14b7ef523 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -385,11 +385,15 @@ static int f2fs_compress_pages(struct compress_ctx *cc)
 	for (i = 0; i < COMPRESS_DATA_RESERVED_SIZE; i++)
 		cc->cbuf->reserved[i] = cpu_to_le32(0);
 
+	nr_cpages = DIV_ROUND_UP(cc->clen + COMPRESS_HEADER_SIZE, PAGE_SIZE);
+
+	/* zero out any unused part of the last page */
+	memset(&cc->cbuf->cdata[cc->clen], 0,
+	       (nr_cpages * PAGE_SIZE) - (cc->clen + COMPRESS_HEADER_SIZE));
+
 	vunmap(cc->cbuf);
 	vunmap(cc->rbuf);
 
-	nr_cpages = DIV_ROUND_UP(cc->clen + COMPRESS_HEADER_SIZE, PAGE_SIZE);
-
 	for (i = nr_cpages; i < cc->nr_cpages; i++) {
 		f2fs_put_compressed_page(cc->cpages[i]);
 		cc->cpages[i] = NULL;
-- 
2.20.1



