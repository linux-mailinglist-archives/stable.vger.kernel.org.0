Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5947140E65D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbhIPRVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346367AbhIPRSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31E8361B93;
        Thu, 16 Sep 2021 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810468;
        bh=TD+BqpQc9GtFzId14Bx/2YU+1CKC56nOUGWnhYF2vws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPsG85v5k8jaJ+ukfozn+VPMp1PE7h5FV0zlgi8kCHy8jv++A/jWfvKVcVOpiYcF2
         o3/CDbwlj2amykVi3qsvQ0Kb5PJOZuXYMKH/kTWVGhmV7Q4/icP2YzILUpso/R0h8p
         4Ob7eCQ5e52c9dESBQh2Y/8rzOX+f1lNqqJB7YA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 152/432] f2fs: deallocate compressed pages when error happens
Date:   Thu, 16 Sep 2021 17:58:21 +0200
Message-Id: <20210916155815.895756640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 827f02842e40ea2e00f401e8f4cb1bccf3b8cd86 ]

In f2fs_write_multi_pages(), f2fs_compress_pages() allocates pages for
compression work in cc->cpages[]. Then, f2fs_write_compressed_pages() initiates
bio submission. But, if there's any error before submitting the IOs like early
f2fs_cp_error(), previously it didn't free cpages by f2fs_compress_free_page().
Let's fix memory leak by putting that just before deallocating cc->cpages.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 455561826c7d..b8b3f1160afa 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1340,12 +1340,6 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
 	for (--i; i >= 0; i--)
 		fscrypt_finalize_bounce_page(&cc->cpages[i]);
-	for (i = 0; i < cc->nr_cpages; i++) {
-		if (!cc->cpages[i])
-			continue;
-		f2fs_compress_free_page(cc->cpages[i]);
-		cc->cpages[i] = NULL;
-	}
 out_put_cic:
 	kmem_cache_free(cic_entry_slab, cic);
 out_put_dnode:
@@ -1356,6 +1350,12 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	else
 		f2fs_unlock_op(sbi);
 out_free:
+	for (i = 0; i < cc->nr_cpages; i++) {
+		if (!cc->cpages[i])
+			continue;
+		f2fs_compress_free_page(cc->cpages[i]);
+		cc->cpages[i] = NULL;
+	}
 	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
 	return -EAGAIN;
-- 
2.30.2



