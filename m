Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA275F53A4
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiJELh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 07:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiJELhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 07:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A03451400;
        Wed,  5 Oct 2022 04:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 047376166F;
        Wed,  5 Oct 2022 11:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E25C433C1;
        Wed,  5 Oct 2022 11:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664969689;
        bh=RHMNw4VDHSb0eehitrExluPSxkriKJXv1C+tOQe7P18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgGoEQAM654okGfmMj7zf51t9kYX4cq8N8hUJAqCNonKsxzZopftALmCinL3Qc79t
         g/6nYQHXnuCDMDWt6NZWOh27c0ZBwgrO+es6uZu+phSESbaxBcZHoWzNYj/flQC2H/
         qL65DltX6hX+bkgq6wZ2sdbRSedAgzv7sdNtSnOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 45/51] xfs: move incore structures out of xfs_da_format.h
Date:   Wed,  5 Oct 2022 13:32:33 +0200
Message-Id: <20221005113212.349623056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
References: <20221005113210.255710920@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit a39f089a25e75c3d17b955d8eb8bc781f23364f3 upstream.

Move the abstract in-memory version of various btree block headers
out of xfs_da_format.h as they aren't on-disk formats.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.h |   23 ++++++++++++++++
 fs/xfs/libxfs/xfs_da_btree.h  |   13 +++++++++
 fs/xfs/libxfs/xfs_da_format.c |    1 
 fs/xfs/libxfs/xfs_da_format.h |   57 ------------------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |    2 +
 fs/xfs/libxfs/xfs_dir2_priv.h |   19 ++++++++++++++
 6 files changed, 58 insertions(+), 57 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -17,6 +17,29 @@ struct xfs_inode;
 struct xfs_trans;
 
 /*
+ * Incore version of the attribute leaf header.
+ */
+struct xfs_attr3_icleaf_hdr {
+	uint32_t	forw;
+	uint32_t	back;
+	uint16_t	magic;
+	uint16_t	count;
+	uint16_t	usedbytes;
+	/*
+	 * Firstused is 32-bit here instead of 16-bit like the on-disk variant
+	 * to support maximum fsb size of 64k without overflow issues throughout
+	 * the attr code. Instead, the overflow condition is handled on
+	 * conversion to/from disk.
+	 */
+	uint32_t	firstused;
+	__u8		holes;
+	struct {
+		uint16_t	base;
+		uint16_t	size;
+	} freemap[XFS_ATTR_LEAF_MAPSIZE];
+};
+
+/*
  * Used to keep a list of "remote value" extents when unlinking an inode.
  */
 typedef struct xfs_attr_inactive_list {
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -127,6 +127,19 @@ typedef struct xfs_da_state {
 } xfs_da_state_t;
 
 /*
+ * In-core version of the node header to abstract the differences in the v2 and
+ * v3 disk format of the headers. Callers need to convert to/from disk format as
+ * appropriate.
+ */
+struct xfs_da3_icnode_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		level;
+};
+
+/*
  * Utility macros to aid in logging changed structure fields.
  */
 #define XFS_DA_LOGOFF(BASE, ADDR)	((char *)(ADDR) - (char *)(BASE))
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 
 /*
  * Shortform directory ops
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -94,19 +94,6 @@ struct xfs_da3_intnode {
 };
 
 /*
- * In-core version of the node header to abstract the differences in the v2 and
- * v3 disk format of the headers. Callers need to convert to/from disk format as
- * appropriate.
- */
-struct xfs_da3_icnode_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	level;
-};
-
-/*
  * Directory version 2.
  *
  * There are 4 possible formats:
@@ -434,14 +421,6 @@ struct xfs_dir3_leaf_hdr {
 	__be32			pad;		/* 64 bit alignment */
 };
 
-struct xfs_dir3_icleaf_hdr {
-	uint32_t		forw;
-	uint32_t		back;
-	uint16_t		magic;
-	uint16_t		count;
-	uint16_t		stale;
-};
-
 /*
  * Leaf block entry.
  */
@@ -521,19 +500,6 @@ struct xfs_dir3_free {
 #define XFS_DIR3_FREE_CRC_OFF  offsetof(struct xfs_dir3_free, hdr.hdr.crc)
 
 /*
- * In core version of the free block header, abstracted away from on-disk format
- * differences. Use this in the code, and convert to/from the disk version using
- * xfs_dir3_free_hdr_from_disk/xfs_dir3_free_hdr_to_disk.
- */
-struct xfs_dir3_icfree_hdr {
-	uint32_t	magic;
-	uint32_t	firstdb;
-	uint32_t	nvalid;
-	uint32_t	nused;
-
-};
-
-/*
  * Single block format.
  *
  * The single block format looks like the following drawing on disk:
@@ -710,29 +676,6 @@ struct xfs_attr3_leafblock {
 };
 
 /*
- * incore, neutral version of the attribute leaf header
- */
-struct xfs_attr3_icleaf_hdr {
-	uint32_t	forw;
-	uint32_t	back;
-	uint16_t	magic;
-	uint16_t	count;
-	uint16_t	usedbytes;
-	/*
-	 * firstused is 32-bit here instead of 16-bit like the on-disk variant
-	 * to support maximum fsb size of 64k without overflow issues throughout
-	 * the attr code. Instead, the overflow condition is handled on
-	 * conversion to/from disk.
-	 */
-	uint32_t	firstused;
-	__u8		holes;
-	struct {
-		uint16_t	base;
-		uint16_t	size;
-	} freemap[XFS_ATTR_LEAF_MAPSIZE];
-};
-
-/*
  * Special value to represent fs block size in the leaf header firstused field.
  * Only used when block size overflows the 2-bytes available on disk.
  */
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -18,6 +18,8 @@ struct xfs_dir2_sf_entry;
 struct xfs_dir2_data_hdr;
 struct xfs_dir2_data_entry;
 struct xfs_dir2_data_unused;
+struct xfs_dir3_icfree_hdr;
+struct xfs_dir3_icleaf_hdr;
 
 extern struct xfs_name	xfs_name_dotdot;
 
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -8,6 +8,25 @@
 
 struct dir_context;
 
+/*
+ * In-core version of the leaf and free block headers to abstract the
+ * differences in the v2 and v3 disk format of the headers.
+ */
+struct xfs_dir3_icleaf_hdr {
+	uint32_t		forw;
+	uint32_t		back;
+	uint16_t		magic;
+	uint16_t		count;
+	uint16_t		stale;
+};
+
+struct xfs_dir3_icfree_hdr {
+	uint32_t		magic;
+	uint32_t		firstdb;
+	uint32_t		nvalid;
+	uint32_t		nused;
+};
+
 /* xfs_dir2.c */
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);


