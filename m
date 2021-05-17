Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABCB3837D4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbhEQPrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344688AbhEQPp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E20861D30;
        Mon, 17 May 2021 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262620;
        bh=nN1uSXNQ8a3lbhzgN5HKgVVjjEN2FZoqB+Fq4mndZOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw+K+riCHOcjHKkmsLdI8BFV2M7YfcBm43GbU+IlN6cezBfhyw8g0qma13tB7ekHR
         f8YG1XxFmirdBfa2TtJmU6BUAWGOsGT4V6CjAb3/UZy/R8+lqeP/uQrNavbA9/ggCl
         endRdGmb7F9sw5UFgVWscqHoDLDrvqbUdSr80Qv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/289] f2fs: compress: fix to free compress page correctly
Date:   Mon, 17 May 2021 16:02:39 +0200
Message-Id: <20210517140313.052870849@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index d3f407ba64c9..b6b7b1552769 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1321,7 +1321,8 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
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



