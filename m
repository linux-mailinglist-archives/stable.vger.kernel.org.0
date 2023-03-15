Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE236BB020
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjCOMPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjCOMPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830CA7FD51
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEECDCE19A7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93ECC433D2;
        Wed, 15 Mar 2023 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882525;
        bh=xjva1b0XeKlkk/6d7coBEibhbVHw3AyKO+7DBAkFyyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzufCY/odgstVhWX/7ppBIn8GyQm+4UPMgI7QFtbuTAA/J3KHvejzWLTGo4cnZjEw
         020ybA3Q+UnzhishBiUMDinKaay1/Vi0dS0xdqzbIZzcQRW0Gl/3lKsGMcaAQqrjFK
         9JTil/sFVxOwQDwPZjS9nXyb8O4knDOB2BLhGAFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/39] udf: Remove pointless union in udf_inode_info
Date:   Wed, 15 Mar 2023 13:12:25 +0100
Message-Id: <20230315115721.667907736@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 382a2287bf9cd283206764572f66ab12657218aa ]

We use only a single member out of the i_ext union in udf_inode_info.
Just remove the pointless union.

Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: fc8033a34a3c ("udf: Preserve link count of system files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/directory.c |  2 +-
 fs/udf/file.c      |  7 +++----
 fs/udf/ialloc.c    | 14 +++++++-------
 fs/udf/inode.c     | 36 +++++++++++++++++-------------------
 fs/udf/misc.c      |  6 +++---
 fs/udf/namei.c     |  7 +++----
 fs/udf/partition.c |  2 +-
 fs/udf/super.c     |  4 ++--
 fs/udf/symlink.c   |  2 +-
 fs/udf/udf_i.h     |  6 +-----
 10 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index d9523013096f9..73720320f0ab7 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -34,7 +34,7 @@ struct fileIdentDesc *udf_fileident_read(struct inode *dir, loff_t *nf_pos,
 	fibh->soffset = fibh->eoffset;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		fi = udf_get_fileident(iinfo->i_ext.i_data -
+		fi = udf_get_fileident(iinfo->i_data -
 				       (iinfo->i_efe ?
 					sizeof(struct extendedFileEntry) :
 					sizeof(struct fileEntry)),
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 88b7fb8e9998c..8fff7ffc33a81 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -50,7 +50,7 @@ static void __udf_adinicb_readpage(struct page *page)
 	 * So just sample it once and use the same value everywhere.
 	 */
 	kaddr = kmap_atomic(page);
-	memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr, isize);
+	memcpy(kaddr, iinfo->i_data + iinfo->i_lenEAttr, isize);
 	memset(kaddr + isize, 0, PAGE_SIZE - isize);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -76,8 +76,7 @@ static int udf_adinicb_writepage(struct page *page,
 	BUG_ON(!PageLocked(page));
 
 	kaddr = kmap_atomic(page);
-	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr,
-		i_size_read(inode));
+	memcpy(iinfo->i_data + iinfo->i_lenEAttr, kaddr, i_size_read(inode));
 	SetPageUptodate(page);
 	kunmap_atomic(kaddr);
 	mark_inode_dirty(inode);
@@ -213,7 +212,7 @@ long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return put_user(UDF_I(inode)->i_lenEAttr, (int __user *)arg);
 	case UDF_GETEABLOCK:
 		return copy_to_user((char __user *)arg,
-				    UDF_I(inode)->i_ext.i_data,
+				    UDF_I(inode)->i_data,
 				    UDF_I(inode)->i_lenEAttr) ? -EFAULT : 0;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index f8e5872f7cc27..cdaa86e077b29 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -67,16 +67,16 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode)
 		iinfo->i_efe = 1;
 		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
 			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
-		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
-					    sizeof(struct extendedFileEntry),
-					    GFP_KERNEL);
+		iinfo->i_data = kzalloc(inode->i_sb->s_blocksize -
+					sizeof(struct extendedFileEntry),
+					GFP_KERNEL);
 	} else {
 		iinfo->i_efe = 0;
-		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
-					    sizeof(struct fileEntry),
-					    GFP_KERNEL);
+		iinfo->i_data = kzalloc(inode->i_sb->s_blocksize -
+					sizeof(struct fileEntry),
+					GFP_KERNEL);
 	}
-	if (!iinfo->i_ext.i_data) {
+	if (!iinfo->i_data) {
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 99d297b667ce1..415f1186d250f 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -150,8 +150,8 @@ void udf_evict_inode(struct inode *inode)
 	truncate_inode_pages_final(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-	kfree(iinfo->i_ext.i_data);
-	iinfo->i_ext.i_data = NULL;
+	kfree(iinfo->i_data);
+	iinfo->i_data = NULL;
 	udf_clear_extent_cache(inode);
 	if (want_delete) {
 		udf_free_inode(inode);
@@ -278,14 +278,14 @@ int udf_expand_file_adinicb(struct inode *inode)
 		kaddr = kmap_atomic(page);
 		memset(kaddr + iinfo->i_lenAlloc, 0x00,
 		       PAGE_SIZE - iinfo->i_lenAlloc);
-		memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr,
+		memcpy(kaddr, iinfo->i_data + iinfo->i_lenEAttr,
 			iinfo->i_lenAlloc);
 		flush_dcache_page(page);
 		SetPageUptodate(page);
 		kunmap_atomic(kaddr);
 	}
 	down_write(&iinfo->i_data_sem);
-	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0x00,
+	memset(iinfo->i_data + iinfo->i_lenEAttr, 0x00,
 	       iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
@@ -303,8 +303,7 @@ int udf_expand_file_adinicb(struct inode *inode)
 		lock_page(page);
 		down_write(&iinfo->i_data_sem);
 		kaddr = kmap_atomic(page);
-		memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr,
-		       inode->i_size);
+		memcpy(iinfo->i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
 		kunmap_atomic(kaddr);
 		unlock_page(page);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
@@ -392,8 +391,7 @@ struct buffer_head *udf_expand_dir_adinicb(struct inode *inode,
 	}
 	mark_buffer_dirty_inode(dbh, inode);
 
-	memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr, 0,
-		iinfo->i_lenAlloc);
+	memset(iinfo->i_data + iinfo->i_lenEAttr, 0, iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
 	eloc.logicalBlockNum = *block;
 	eloc.partitionReferenceNum =
@@ -1241,7 +1239,7 @@ int udf_setsize(struct inode *inode, loff_t newsize)
 		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
 			udf_clear_extent_cache(inode);
-			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
+			memset(iinfo->i_data + iinfo->i_lenEAttr + newsize,
 			       0x00, bsize - newsize -
 			       udf_file_entry_alloc_offset(inode));
 			iinfo->i_lenAlloc = newsize;
@@ -1390,7 +1388,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 					sizeof(struct extendedFileEntry));
 		if (ret)
 			goto out;
-		memcpy(iinfo->i_ext.i_data,
+		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct extendedFileEntry),
 		       bs - sizeof(struct extendedFileEntry));
 	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_FE)) {
@@ -1399,7 +1397,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = udf_alloc_i_data(inode, bs - sizeof(struct fileEntry));
 		if (ret)
 			goto out;
-		memcpy(iinfo->i_ext.i_data,
+		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct fileEntry),
 		       bs - sizeof(struct fileEntry));
 	} else if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_USE)) {
@@ -1412,7 +1410,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 					sizeof(struct unallocSpaceEntry));
 		if (ret)
 			goto out;
-		memcpy(iinfo->i_ext.i_data,
+		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
 		return 0;
@@ -1591,8 +1589,8 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 static int udf_alloc_i_data(struct inode *inode, size_t size)
 {
 	struct udf_inode_info *iinfo = UDF_I(inode);
-	iinfo->i_ext.i_data = kmalloc(size, GFP_KERNEL);
-	if (!iinfo->i_ext.i_data)
+	iinfo->i_data = kmalloc(size, GFP_KERNEL);
+	if (!iinfo->i_data)
 		return -ENOMEM;
 	return 0;
 }
@@ -1666,7 +1664,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 		use->lengthAllocDescs = cpu_to_le32(iinfo->i_lenAlloc);
 		memcpy(bh->b_data + sizeof(struct unallocSpaceEntry),
-		       iinfo->i_ext.i_data, inode->i_sb->s_blocksize -
+		       iinfo->i_data, inode->i_sb->s_blocksize -
 					sizeof(struct unallocSpaceEntry));
 		use->descTag.tagIdent = cpu_to_le16(TAG_IDENT_USE);
 		crclen = sizeof(struct unallocSpaceEntry);
@@ -1735,7 +1733,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	if (iinfo->i_efe == 0) {
 		memcpy(bh->b_data + sizeof(struct fileEntry),
-		       iinfo->i_ext.i_data,
+		       iinfo->i_data,
 		       inode->i_sb->s_blocksize - sizeof(struct fileEntry));
 		fe->logicalBlocksRecorded = cpu_to_le64(lb_recorded);
 
@@ -1754,7 +1752,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		crclen = sizeof(struct fileEntry);
 	} else {
 		memcpy(bh->b_data + sizeof(struct extendedFileEntry),
-		       iinfo->i_ext.i_data,
+		       iinfo->i_data,
 		       inode->i_sb->s_blocksize -
 					sizeof(struct extendedFileEntry));
 		efe->objectSize =
@@ -2050,7 +2048,7 @@ void udf_write_aext(struct inode *inode, struct extent_position *epos,
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	if (!epos->bh)
-		ptr = iinfo->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
 			iinfo->i_lenEAttr;
 	else
@@ -2142,7 +2140,7 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 	if (!epos->bh) {
 		if (!epos->offset)
 			epos->offset = udf_file_entry_alloc_offset(inode);
-		ptr = iinfo->i_ext.i_data + epos->offset -
+		ptr = iinfo->i_data + epos->offset -
 			udf_file_entry_alloc_offset(inode) +
 			iinfo->i_lenEAttr;
 		alen = udf_file_entry_alloc_offset(inode) +
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 853bcff51043f..1614d308d0f06 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -52,9 +52,9 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 	uint16_t crclen;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	ea = iinfo->i_ext.i_data;
+	ea = iinfo->i_data;
 	if (iinfo->i_lenEAttr) {
-		ad = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
+		ad = iinfo->i_data + iinfo->i_lenEAttr;
 	} else {
 		ad = ea;
 		size += sizeof(struct extendedAttrHeaderDesc);
@@ -153,7 +153,7 @@ struct genericFormat *udf_get_extendedattr(struct inode *inode, uint32_t type,
 	uint32_t offset;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	ea = iinfo->i_ext.i_data;
+	ea = iinfo->i_data;
 
 	if (iinfo->i_lenEAttr) {
 		struct extendedAttrHeaderDesc *eahd;
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index ef251622da137..05dd1f45ba90b 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -478,8 +478,7 @@ static struct fileIdentDesc *udf_add_entry(struct inode *dir,
 		if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			block = dinfo->i_location.logicalBlockNum;
 			fi = (struct fileIdentDesc *)
-					(dinfo->i_ext.i_data +
-					 fibh->soffset -
+					(dinfo->i_data + fibh->soffset -
 					 udf_ext0_offset(dir) +
 					 dinfo->i_lenEAttr);
 		} else {
@@ -962,7 +961,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 		mark_buffer_dirty_inode(epos.bh, inode);
 		ea = epos.bh->b_data + udf_ext0_offset(inode);
 	} else
-		ea = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
+		ea = iinfo->i_data + iinfo->i_lenEAttr;
 
 	eoffset = sb->s_blocksize - udf_ext0_offset(inode);
 	pc = (struct pathComponent *)ea;
@@ -1142,7 +1141,7 @@ static int udf_rename(struct inode *old_dir, struct dentry *old_dentry,
 		retval = -EIO;
 		if (old_iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
 			dir_fi = udf_get_fileident(
-					old_iinfo->i_ext.i_data -
+					old_iinfo->i_data -
 					  (old_iinfo->i_efe ?
 					   sizeof(struct extendedFileEntry) :
 					   sizeof(struct fileEntry)),
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 090baff83990a..4cbf40575965e 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -65,7 +65,7 @@ uint32_t udf_get_pblock_virt15(struct super_block *sb, uint32_t block,
 	}
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		loc = le32_to_cpu(((__le32 *)(iinfo->i_ext.i_data +
+		loc = le32_to_cpu(((__le32 *)(iinfo->i_data +
 			vdata->s_start_offset))[block]);
 		goto translate;
 	}
diff --git a/fs/udf/super.c b/fs/udf/super.c
index ec082b27e9fba..cdaef406f3899 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -174,7 +174,7 @@ static void init_once(void *foo)
 {
 	struct udf_inode_info *ei = (struct udf_inode_info *)foo;
 
-	ei->i_ext.i_data = NULL;
+	ei->i_data = NULL;
 	inode_init_once(&ei->vfs_inode);
 }
 
@@ -1207,7 +1207,7 @@ static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
 			vat20 = (struct virtualAllocationTable20 *)bh->b_data;
 		} else {
 			vat20 = (struct virtualAllocationTable20 *)
-							vati->i_ext.i_data;
+							vati->i_data;
 		}
 
 		map->s_type_specific.s_virtual.s_start_offset =
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 6023c97c6da2f..aef3e4d9014d2 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -122,7 +122,7 @@ static int udf_symlink_filler(struct file *file, struct page *page)
 
 	down_read(&iinfo->i_data_sem);
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		symlink = iinfo->i_ext.i_data + iinfo->i_lenEAttr;
+		symlink = iinfo->i_data + iinfo->i_lenEAttr;
 	} else {
 		bh = sb_bread(inode->i_sb, pos);
 
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 00d773d1b7cf0..2a4731314d51f 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -44,11 +44,7 @@ struct udf_inode_info {
 	unsigned		i_strat4096 : 1;
 	unsigned		i_streamdir : 1;
 	unsigned		reserved : 25;
-	union {
-		struct short_ad	*i_sad;
-		struct long_ad		*i_lad;
-		__u8		*i_data;
-	} i_ext;
+	__u8			*i_data;
 	struct kernel_lb_addr	i_locStreamdir;
 	__u64			i_lenStreams;
 	struct rw_semaphore	i_data_sem;
-- 
2.39.2



