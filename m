Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CAD5949B1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245715AbiHOXO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbiHOXNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:13:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA17979ECB;
        Mon, 15 Aug 2022 13:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A0F6068D;
        Mon, 15 Aug 2022 20:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42929C433C1;
        Mon, 15 Aug 2022 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593662;
        bh=WT2HE1e9r+uBilfQpDAj/tBduX2W9ohkaAAS7aNFYyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Son1gWWKIxbX7JOCUVBIhIkw3dMdulzbTOmcW6ZWrIipWNbTE3UQD4vv584OBSSzI
         6Mh9EPc28+vLA96gQuSa1eXgr75AgT7Cw06aSdpUpCMeBhBZ6KFPgVsOpvLLDD4vSm
         pycYM/YKYCOMzMHVuNKM6HOFeWok1o1bdKP6BLiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongnan Li <hongnan.li@linux.alibaba.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0304/1157] erofs: update ctx->pos for every emitted dirent
Date:   Mon, 15 Aug 2022 19:54:20 +0200
Message-Id: <20220815180451.814972870@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongnan Li <hongnan.li@linux.alibaba.com>

[ Upstream commit ecce9212d0fd7a2d4a4998f0c4623a66887e14c8 ]

erofs_readdir update ctx->pos after filling a batch of dentries
and it may cause dir/files duplication for NFS readdirplus which
depends on ctx->pos to fill dir correctly. So update ctx->pos for
every emitted dirent in erofs_fill_dentries to fix it.

Also fix the update of ctx->pos when the initial file position has
exceeded nameoff.

Fixes: 3e917cc305c6 ("erofs: make filesystem exportable")
Signed-off-by: Hongnan Li <hongnan.li@linux.alibaba.com>
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20220722082732.30935-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/dir.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/dir.c b/fs/erofs/dir.c
index 18e59821c597..47c85f1b80d8 100644
--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -22,10 +22,9 @@ static void debug_one_dentry(unsigned char d_type, const char *de_name,
 }
 
 static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
-			       void *dentry_blk, unsigned int *ofs,
+			       void *dentry_blk, struct erofs_dirent *de,
 			       unsigned int nameoff, unsigned int maxsize)
 {
-	struct erofs_dirent *de = dentry_blk + *ofs;
 	const struct erofs_dirent *end = dentry_blk + nameoff;
 
 	while (de < end) {
@@ -59,9 +58,8 @@ static int erofs_fill_dentries(struct inode *dir, struct dir_context *ctx,
 			/* stopped by some reason */
 			return 1;
 		++de;
-		*ofs += sizeof(struct erofs_dirent);
+		ctx->pos += sizeof(struct erofs_dirent);
 	}
-	*ofs = maxsize;
 	return 0;
 }
 
@@ -95,7 +93,7 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 				  "invalid de[0].nameoff %u @ nid %llu",
 				  nameoff, EROFS_I(dir)->nid);
 			err = -EFSCORRUPTED;
-			goto skip_this;
+			break;
 		}
 
 		maxsize = min_t(unsigned int,
@@ -106,17 +104,17 @@ static int erofs_readdir(struct file *f, struct dir_context *ctx)
 			initial = false;
 
 			ofs = roundup(ofs, sizeof(struct erofs_dirent));
+			ctx->pos = blknr_to_addr(i) + ofs;
 			if (ofs >= nameoff)
 				goto skip_this;
 		}
 
-		err = erofs_fill_dentries(dir, ctx, de, &ofs,
+		err = erofs_fill_dentries(dir, ctx, de, (void *)de + ofs,
 					  nameoff, maxsize);
-skip_this:
-		ctx->pos = blknr_to_addr(i) + ofs;
-
 		if (err)
 			break;
+skip_this:
+		ctx->pos = blknr_to_addr(i) + maxsize;
 		++i;
 		ofs = 0;
 	}
-- 
2.35.1



