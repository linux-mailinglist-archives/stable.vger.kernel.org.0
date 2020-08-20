Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32A924BD16
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgHTM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbgHTJkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:40:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1912320855;
        Thu, 20 Aug 2020 09:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916448;
        bh=d/jGMt1oCsLc4aGnO5K2JI8v956XOiQWLDA7FUVXzRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7RNM4jB2icLYVOPnBWayqmihC+2iN/DX5bs6kKY1T3pvSNsdTG0rSxUgBK4DBlXh
         Yf0Dy/vYCGwR2iZo71e8l4NY37kBlaHv/VuErWFbTz9t2aef9+rLYzJQ72i99WfZ6d
         oqVJ9UbLUsGY9YPFd6uiL0jceu1r4CRpoTHrCaMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 132/204] f2fs: compress: fix to avoid memory leak on cc->cpages
Date:   Thu, 20 Aug 2020 11:20:29 +0200
Message-Id: <20200820091612.871866317@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 02772fbfcba8597eef9d5c5f7f94087132d0c1d4 ]

Memory allocated for storing compressed pages' poitner should be
released after f2fs_write_compressed_pages(), otherwise it will
cause memory leak issue.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index a5b2e72174bb1..527d50edcb956 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1250,6 +1250,8 @@ int f2fs_write_multi_pages(struct compress_ctx *cc,
 		err = f2fs_write_compressed_pages(cc, submitted,
 							wbc, io_type);
 		cops->destroy_compress_ctx(cc);
+		kfree(cc->cpages);
+		cc->cpages = NULL;
 		if (!err)
 			return 0;
 		f2fs_bug_on(F2FS_I_SB(cc->inode), err != -EAGAIN);
-- 
2.25.1



