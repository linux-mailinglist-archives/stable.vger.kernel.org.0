Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E0A3C55DA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349490AbhGLIMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354009AbhGLIDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B35619B0;
        Mon, 12 Jul 2021 07:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076759;
        bh=MO3L9GUWQ4SPW8CtGB+ziSv713OE+wGyQWzffo4TqsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSEdrlpUTFkJgcs0P54H82swinoE1l9WW59n9quqtgoMt0JUpkTtUJyVMW5M9v+o4
         WMkUD+FHQ88CJdwMV4rhfaMIObtVZ9LW+wmeN3et46pfTrDhLPnMG511W7gla2Q96D
         EOvrPISLy+hviDWAlTIxt6O+o0sd5K3KUJLVGXos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Cramer <flrncrmr@gmail.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Chris Down <chris@chrisdown.name>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.13 781/800] exfat: handle wrong stream entry size in exfat_readdir()
Date:   Mon, 12 Jul 2021 08:13:24 +0200
Message-Id: <20210712061049.935138869@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -63,7 +63,7 @@ static void exfat_get_uniname_from_ext_e
 static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_entry *dir_entry)
 {
 	int i, dentries_per_clu, dentries_per_clu_bits = 0, num_ext;
-	unsigned int type, clu_offset;
+	unsigned int type, clu_offset, max_dentries;
 	sector_t sector;
 	struct exfat_chain dir, clu;
 	struct exfat_uni_name uni_name;
@@ -86,6 +86,8 @@ static int exfat_readdir(struct inode *i
 
 	dentries_per_clu = sbi->dentries_per_clu;
 	dentries_per_clu_bits = ilog2(dentries_per_clu);
+	max_dentries = (unsigned int)min_t(u64, MAX_EXFAT_DENTRIES,
+					   (u64)sbi->num_clusters << dentries_per_clu_bits);
 
 	clu_offset = dentry >> dentries_per_clu_bits;
 	exfat_chain_dup(&clu, &dir);
@@ -109,7 +111,7 @@ static int exfat_readdir(struct inode *i
 		}
 	}
 
-	while (clu.dir != EXFAT_EOF_CLUSTER) {
+	while (clu.dir != EXFAT_EOF_CLUSTER && dentry < max_dentries) {
 		i = dentry & (dentries_per_clu - 1);
 
 		for ( ; i < dentries_per_clu; i++, dentry++) {
@@ -245,7 +247,7 @@ static int exfat_iterate(struct file *fi
 	if (err)
 		goto unlock;
 get_new:
-	if (cpos >= i_size_read(inode))
+	if (ei->flags == ALLOC_NO_FAT_CHAIN && cpos >= i_size_read(inode))
 		goto end_of_dir;
 
 	err = exfat_readdir(inode, &cpos, &de);


