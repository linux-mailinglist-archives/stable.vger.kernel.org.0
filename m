Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CFA205D13
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbgFWUIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388208AbgFWUIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D58C20FC3;
        Tue, 23 Jun 2020 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942920;
        bh=xez/82YlJ7SYV4iZ5OSzgj55WpYE4zP+9siTcqExYDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYkOYRnyEiMcJKBd22HGCOeAZ9vx9TNeONjuz60sV989sEOUjkRO85W0xqgsbVE1c
         CYW7gTK0EatKR4dRPiuYmal8mlLZkvW/awbNBgj3IL0RU3AM+0fzQAjQ+nXNcQRf3M
         f0WC0cI8M4wr4vz2X+mxULXNUn0Iv3Rmjit2+cMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 187/477] f2fs: compress: fix zstd data corruption
Date:   Tue, 23 Jun 2020 21:53:04 +0200
Message-Id: <20200623195416.427934605@linuxfoundation.org>
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

[ Upstream commit 1454c978efbb57b052670d50023f48c759d704ce ]

During zstd compression, ZSTD_endStream() may return non-zero value
because distination buffer is full, but there is still compressed data
remained in intermediate buffer, it means that zstd algorithm can not
save at last one block space, let's just writeback raw data instead of
compressed one, this can fix data corruption when decompressing
incomplete stored compression data.

Fixes: 50cfa66f0de0 ("f2fs: compress: support zstd compress algorithm")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index c05801758a358..a5b2e72174bb1 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -369,6 +369,13 @@ static int zstd_compress_pages(struct compress_ctx *cc)
 		return -EIO;
 	}
 
+	/*
+	 * there is compressed data remained in intermediate buffer due to
+	 * no more space in cbuf.cdata
+	 */
+	if (ret)
+		return -EAGAIN;
+
 	cc->clen = outbuf.pos;
 	return 0;
 }
-- 
2.25.1



