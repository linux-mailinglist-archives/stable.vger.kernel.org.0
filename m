Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F1B3831BB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbhEQOkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241008AbhEQOhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7037E613F7;
        Mon, 17 May 2021 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261062;
        bh=oDtYYsMwzqTiLIRhGvRZZhL5SsVAlpf8L9z9T+Q0lpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k3kO8X6g+1EtcaV9SRvx1w3WHbH7NhMtGYiAHj3ui5ULIbVHVIkoF5IYUTmfXWpfb
         1GOGCE7aIXR763av4LEt4BqqfcvaRQ/flLgEbRHUJIyo1tWAGXWs1wEojyR5Z5AWg5
         7zk/WRouS8QkFZcH5bGl9UJ3srucwjjRckesEui4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 300/363] f2fs: compress: fix to free compress page correctly
Date:   Mon, 17 May 2021 16:02:46 +0200
Message-Id: <20210517140312.742488519@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a12cc5b423d4f36dc1a1ea3911e49cf9dff43898 ]

In error path of f2fs_write_compressed_pages(), it needs to call
f2fs_compress_free_page() to release temporary page.

Fixes: 5e6bbde95982 ("f2fs: introduce mempool for {,de}compress intermediate page allocation")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 77fa342de38f..146a8eb3891b 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1383,7 +1383,8 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	for (i = 0; i < cc->nr_cpages; i++) {
 		if (!cc->cpages[i])
 			continue;
-		f2fs_put_page(cc->cpages[i], 1);
+		f2fs_compress_free_page(cc->cpages[i]);
+		cc->cpages[i] = NULL;
 	}
 out_put_cic:
 	kmem_cache_free(cic_entry_slab, cic);
-- 
2.30.2



