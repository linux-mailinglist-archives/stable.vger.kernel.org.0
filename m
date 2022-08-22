Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1DAA59BD5C
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiHVKIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbiHVKIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9352B7D
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A5260F98
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB3AC433C1;
        Mon, 22 Aug 2022 10:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661162929;
        bh=KTGsFdtC3mUzDRSKWfJ0pVJGgiYiEDhxPfH8pxl/h2g=;
        h=Subject:To:Cc:From:Date:From;
        b=fBk6h7pFrQl14AqGhj7pQ5KoJLPzv45mO5ehuN0Gf0QA2z+JGw1PHXS8kq9jUxBEj
         7GcNSr+fscm4B1pE9e7YI4wRhc5DQk5FQqXj6+KD1bDAd1SKoa+99fKERgswNzTda7
         eD8uwp3LwEPtHe6C5mx/1X7lOjCcSh27gGARRPGU=
Subject: FAILED: patch "[PATCH] fs/ntfs3: extend ni_insert_nonresident to return inserted" failed to apply to 5.15-stable tree
To:     almaz.alexandrovich@paragon-software.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:08:40 +0200
Message-ID: <16611629201013@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c1e0ab3789215a3dfbe95f226955e93ea4803391 Mon Sep 17 00:00:00 2001
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Date: Fri, 13 May 2022 18:25:04 +0300
Subject: [PATCH] fs/ntfs3: extend ni_insert_nonresident to return inserted
 ATTR_LIST_ENTRY

Fixes xfstest generic/300
Fixes: 4534a70b7056 ("fs/ntfs3: Add headers and misc files")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index c9b718143603..ad713f620155 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -320,7 +320,7 @@ int attr_make_nonresident(struct ntfs_inode *ni, struct ATTRIB *attr,
 
 	err = ni_insert_nonresident(ni, attr_s->type, attr_name(attr_s),
 				    attr_s->name_len, run, 0, alen,
-				    attr_s->flags, &attr, NULL);
+				    attr_s->flags, &attr, NULL, NULL);
 	if (err)
 		goto out3;
 
@@ -637,7 +637,7 @@ int attr_set_size(struct ntfs_inode *ni, enum ATTR_TYPE type,
 		/* Insert new attribute segment. */
 		err = ni_insert_nonresident(ni, type, name, name_len, run,
 					    next_svcn, vcn - next_svcn,
-					    attr_b->flags, &attr, &mi);
+					    attr_b->flags, &attr, &mi, NULL);
 		if (err)
 			goto out;
 
@@ -855,7 +855,7 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 		goto out;
 	}
 
-	asize = le64_to_cpu(attr_b->nres.alloc_size) >> sbi->cluster_bits;
+	asize = le64_to_cpu(attr_b->nres.alloc_size) >> cluster_bits;
 	if (vcn >= asize) {
 		err = -EINVAL;
 		goto out;
@@ -1047,7 +1047,7 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 	if (evcn1 > next_svcn) {
 		err = ni_insert_nonresident(ni, ATTR_DATA, NULL, 0, run,
 					    next_svcn, evcn1 - next_svcn,
-					    attr_b->flags, &attr, &mi);
+					    attr_b->flags, &attr, &mi, NULL);
 		if (err)
 			goto out;
 	}
@@ -1647,7 +1647,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 	if (evcn1 > next_svcn) {
 		err = ni_insert_nonresident(ni, ATTR_DATA, NULL, 0, run,
 					    next_svcn, evcn1 - next_svcn,
-					    attr_b->flags, &attr, &mi);
+					    attr_b->flags, &attr, &mi, NULL);
 		if (err)
 			goto out;
 	}
@@ -1812,18 +1812,12 @@ int attr_collapse_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 				err = ni_insert_nonresident(
 					ni, ATTR_DATA, NULL, 0, run, next_svcn,
 					evcn1 - eat - next_svcn, a_flags, &attr,
-					&mi);
+					&mi, &le);
 				if (err)
 					goto out;
 
 				/* Layout of records maybe changed. */
 				attr_b = NULL;
-				le = al_find_ex(ni, NULL, ATTR_DATA, NULL, 0,
-						&next_svcn);
-				if (!le) {
-					err = -EINVAL;
-					goto out;
-				}
 			}
 
 			/* Free all allocated memory. */
@@ -1936,9 +1930,10 @@ int attr_punch_hole(struct ntfs_inode *ni, u64 vbo, u64 bytes, u32 *frame_size)
 	struct ATTRIB *attr = NULL, *attr_b;
 	struct ATTR_LIST_ENTRY *le, *le_b;
 	struct mft_inode *mi, *mi_b;
-	CLST svcn, evcn1, vcn, len, end, alen, dealloc;
+	CLST svcn, evcn1, vcn, len, end, alen, dealloc, next_svcn;
 	u64 total_size, alloc_size;
 	u32 mask;
+	__le16 a_flags;
 
 	if (!bytes)
 		return 0;
@@ -2001,6 +1996,7 @@ int attr_punch_hole(struct ntfs_inode *ni, u64 vbo, u64 bytes, u32 *frame_size)
 
 	svcn = le64_to_cpu(attr_b->nres.svcn);
 	evcn1 = le64_to_cpu(attr_b->nres.evcn) + 1;
+	a_flags = attr_b->flags;
 
 	if (svcn <= vcn && vcn < evcn1) {
 		attr = attr_b;
@@ -2048,6 +2044,17 @@ int attr_punch_hole(struct ntfs_inode *ni, u64 vbo, u64 bytes, u32 *frame_size)
 			err = mi_pack_runs(mi, attr, run, evcn1 - svcn);
 			if (err)
 				goto out;
+			next_svcn = le64_to_cpu(attr->nres.evcn) + 1;
+			if (next_svcn < evcn1) {
+				err = ni_insert_nonresident(ni, ATTR_DATA, NULL,
+							    0, run, next_svcn,
+							    evcn1 - next_svcn,
+							    a_flags, &attr, &mi,
+							    &le);
+				if (err)
+					goto out;
+				/* Layout of records maybe changed. */
+			}
 		}
 		/* Free all allocated memory. */
 		run_truncate(run, 0);
@@ -2250,7 +2257,7 @@ int attr_insert_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 	if (next_svcn < evcn1 + len) {
 		err = ni_insert_nonresident(ni, ATTR_DATA, NULL, 0, run,
 					    next_svcn, evcn1 + len - next_svcn,
-					    a_flags, NULL, NULL);
+					    a_flags, NULL, NULL, NULL);
 		if (err)
 			goto out;
 	}
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 3576268ee0a1..64041152fd98 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1406,7 +1406,7 @@ int ni_insert_nonresident(struct ntfs_inode *ni, enum ATTR_TYPE type,
 			  const __le16 *name, u8 name_len,
 			  const struct runs_tree *run, CLST svcn, CLST len,
 			  __le16 flags, struct ATTRIB **new_attr,
-			  struct mft_inode **mi)
+			  struct mft_inode **mi, struct ATTR_LIST_ENTRY **le)
 {
 	int err;
 	CLST plen;
@@ -1439,7 +1439,7 @@ int ni_insert_nonresident(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	}
 
 	err = ni_insert_attr(ni, type, name, name_len, asize, name_off, svcn,
-			     &attr, mi, NULL);
+			     &attr, mi, le);
 
 	if (err)
 		goto out;
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index ba2a07dfeaf5..440328147e7e 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1347,7 +1347,7 @@ static int indx_create_allocate(struct ntfs_index *indx, struct ntfs_inode *ni,
 		goto out;
 
 	err = ni_insert_nonresident(ni, ATTR_ALLOC, in->name, in->name_len,
-				    &run, 0, len, 0, &alloc, NULL);
+				    &run, 0, len, 0, &alloc, NULL, NULL);
 	if (err)
 		goto out1;
 
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 8f05b91f3c5e..27b610c5bb29 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -529,7 +529,7 @@ int ni_insert_nonresident(struct ntfs_inode *ni, enum ATTR_TYPE type,
 			  const __le16 *name, u8 name_len,
 			  const struct runs_tree *run, CLST svcn, CLST len,
 			  __le16 flags, struct ATTRIB **new_attr,
-			  struct mft_inode **mi);
+			  struct mft_inode **mi, struct ATTR_LIST_ENTRY **le);
 int ni_insert_resident(struct ntfs_inode *ni, u32 data_size,
 		       enum ATTR_TYPE type, const __le16 *name, u8 name_len,
 		       struct ATTRIB **new_attr, struct mft_inode **mi,

