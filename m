Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8378724B279
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgHTJan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgHTJag (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B48F5207DE;
        Thu, 20 Aug 2020 09:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915836;
        bh=9sLNKiGr0kKL5eCm7ftNJRKjGAReaohKKsu6DTFpr2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMnUImU52J6gsuSN6fLTr9g5SRP+iyX3i9CUzNhl5mYST/S+omiFZqyn1YQ/BI6uE
         A/Map0r7P2s7b/UVhtAeATfbItnesAUo6S/5jGUyPpR/4hU4Ix4D5yB23IwGghz8cD
         fgdVg5x5GLC4kg+Yqzz8U05Bt5BD9vvrWEGwIL+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 150/232] f2fs: compress: fix to avoid memory leak on cc->cpages
Date:   Thu, 20 Aug 2020 11:20:01 +0200
Message-Id: <20200820091620.078275416@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
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
index 1e02a8c106b0a..f6fbe61b1251e 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1353,6 +1353,8 @@ int f2fs_write_multi_pages(struct compress_ctx *cc,
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



