Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756DD40DFAF
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhIPQM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236194AbhIPQK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D244A61359;
        Thu, 16 Sep 2021 16:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808522;
        bh=MxxWNK/Ar+X6mIo8tPVERAmcZPj2c31xcA0uylciFss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7PP7Lnv1HRn/pI2GwF2MFYEVaOqoyDhIImxlYJfoNohgALFkvVhAT6VCEEh5O1si
         ek2MTW8+55OOTgEBXZNLb/q/GeeIgSiJBNwNSplGR0Iy0fzbtYAr4EqSCVxE7LN2Yc
         GHanxhktw3KNYBQ45x1Ee/nbX609d1RwHW/hoIeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/306] f2fs: deallocate compressed pages when error happens
Date:   Thu, 16 Sep 2021 17:57:30 +0200
Message-Id: <20210916155757.656735859@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index f94b13075ea4..30987ea011f1 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1308,12 +1308,6 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 
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
@@ -1324,6 +1318,12 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
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



