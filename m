Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84D63C5093
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344461AbhGLHdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344533AbhGLH3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B8236141F;
        Mon, 12 Jul 2021 07:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074737;
        bh=7fbMYirB/mGtYtE6wJI6Dx6xC3KIBZASpqlwif7Pb+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTa7IW9U8ns2x5TsqZ2dhkBUkyLCc6+fIvYTUwkvNllBTL5sJQXUB7qD9Rhy4Myrl
         FxtxH2XyHyF5LgcfBEFvtasPUp2/Vrs3rhyCO47csCp0ZV3LRfpdLB97MaJap+CKlt
         pTU2lFs/mualS2QbFY9+tknsInESJeEt+WtCWdcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Cramer <flrncrmr@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Chris Down <chris@chrisdown.name>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.12 681/700] exfat: handle wrong stream entry size in exfat_readdir()
Date:   Mon, 12 Jul 2021 08:12:44 +0200
Message-Id: <20210712061048.343155408@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 1e5654de0f51890f88abd409ebf4867782431e81 upstream.

The compatibility issue between linux exfat and exfat of some camera
company was reported from Florian. In their exfat, if the number of files
exceeds any limit, the DataLength in stream entry of the directory is
no longer updated. So some files created from camera does not show in
linux exfat. because linux exfat doesn't allow that cpos becomes larger
than DataLength of stream entry. This patch check DataLength in stream
entry only if the type is ALLOC_NO_FAT_CHAIN and add the check ensure
that dentry offset does not exceed max dentries size(256 MB) to avoid
the circular FAT chain issue.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org # v5.9
Reported-by: Florian Cramer <flrncrmr@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exfat/dir.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -62,7 +62,7 @@ static void exfat_get_uniname_from_ext_e
 static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_entry *dir_entry)
 {
 	int i, dentries_per_clu, dentries_per_clu_bits = 0, num_ext;
-	unsigned int type, clu_offset;
+	unsigned int type, clu_offset, max_dentries;
 	sector_t sector;
 	struct exfat_chain dir, clu;
 	struct exfat_uni_name uni_name;
@@ -85,6 +85,8 @@ static int exfat_readdir(struct inode *i
 
 	dentries_per_clu = sbi->dentries_per_clu;
 	dentries_per_clu_bits = ilog2(dentries_per_clu);
+	max_dentries = (unsigned int)min_t(u64, MAX_EXFAT_DENTRIES,
+					   (u64)sbi->num_clusters << dentries_per_clu_bits);
 
 	clu_offset = dentry >> dentries_per_clu_bits;
 	exfat_chain_dup(&clu, &dir);
@@ -108,7 +110,7 @@ static int exfat_readdir(struct inode *i
 		}
 	}
 
-	while (clu.dir != EXFAT_EOF_CLUSTER) {
+	while (clu.dir != EXFAT_EOF_CLUSTER && dentry < max_dentries) {
 		i = dentry & (dentries_per_clu - 1);
 
 		for ( ; i < dentries_per_clu; i++, dentry++) {
@@ -244,7 +246,7 @@ static int exfat_iterate(struct file *fi
 	if (err)
 		goto unlock;
 get_new:
-	if (cpos >= i_size_read(inode))
+	if (ei->flags == ALLOC_NO_FAT_CHAIN && cpos >= i_size_read(inode))
 		goto end_of_dir;
 
 	err = exfat_readdir(inode, &cpos, &de);


