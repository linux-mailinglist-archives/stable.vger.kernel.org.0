Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1F6ECF0D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjDXNhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjDXNhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F7A25F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9909C623E9
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D60C433D2;
        Mon, 24 Apr 2023 13:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343421;
        bh=cbV8s1f+4nwaatZU50V3X98LAnibAaJCKZ6/RQO63Ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgbyB1gU+jmijORTICYJOLBaqCxM15fpmw3onF525ghuQWuvE0rqNzSGgccx5RFf1
         1Lh7PYhlDbkRuo/Oq5QQW1DXrkXS1hiY7tEJ3WGvMsuR7avoijG/kBzajcP58RbVhP
         mTOyhcuaXd8ab43U3dbhGsHymSWEvstqDw1HZQzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 4.14 19/28] ext4: remove duplicate definition of ext4_xattr_ibody_inline_set()
Date:   Mon, 24 Apr 2023 15:18:40 +0200
Message-Id: <20230424131121.966701590@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit 310c097c2bdbea253d6ee4e064f3e65580ef93ac ]

ext4_xattr_ibody_inline_set() & ext4_xattr_ibody_set() have the exact
same definition.  Hence remove ext4_xattr_ibody_inline_set() and all
its call references. Convert the callers of it to call
ext4_xattr_ibody_set() instead.

[ Modified to preserve ext4_xattr_ibody_set() and remove
  ext4_xattr_ibody_inline_set() instead. -- TYT ]

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/fd566b799bbbbe9b668eb5eecde5b5e319e3694f.1622685482.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |   11 +++++------
 fs/ext4/xattr.c  |   26 +-------------------------
 fs/ext4/xattr.h  |    6 +++---
 3 files changed, 9 insertions(+), 34 deletions(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -212,7 +212,7 @@ out:
 /*
  * write the buffer to the inline inode.
  * If 'create' is set, we don't need to do the extra copy in the xattr
- * value since it is already handled by ext4_xattr_ibody_inline_set.
+ * value since it is already handled by ext4_xattr_ibody_set.
  * That saves us one memcpy.
  */
 static void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
@@ -294,7 +294,7 @@ static int ext4_create_inline_data(handl
 
 	BUG_ON(!is.s.not_found);
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error) {
 		if (error == -ENOSPC)
 			ext4_clear_inode_state(inode,
@@ -366,7 +366,7 @@ static int ext4_update_inline_data(handl
 	i.value = value;
 	i.value_len = len;
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error)
 		goto out;
 
@@ -439,7 +439,7 @@ static int ext4_destroy_inline_data_nolo
 	if (error)
 		goto out;
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error)
 		goto out;
 
@@ -1951,8 +1951,7 @@ int ext4_inline_data_truncate(struct ino
 			i.value = value;
 			i.value_len = i_size > EXT4_MIN_INLINE_DATA_SIZE ?
 					i_size - EXT4_MIN_INLINE_DATA_SIZE : 0;
-			err = ext4_xattr_ibody_inline_set(handle, inode,
-							  &i, &is);
+			err = ext4_xattr_ibody_set(handle, inode, &i, &is);
 			if (err)
 				goto out_error;
 		}
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2221,31 +2221,7 @@ int ext4_xattr_ibody_find(struct inode *
 	return 0;
 }
 
-int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
-				struct ext4_xattr_info *i,
-				struct ext4_xattr_ibody_find *is)
-{
-	struct ext4_xattr_ibody_header *header;
-	struct ext4_xattr_search *s = &is->s;
-	int error;
-
-	if (EXT4_I(inode)->i_extra_isize == 0)
-		return -ENOSPC;
-	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
-	if (error)
-		return error;
-	header = IHDR(inode, ext4_raw_inode(&is->iloc));
-	if (!IS_LAST_ENTRY(s->first)) {
-		header->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
-		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-	} else {
-		header->h_magic = cpu_to_le32(0);
-		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
-	}
-	return 0;
-}
-
-static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 				struct ext4_xattr_info *i,
 				struct ext4_xattr_ibody_find *is)
 {
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -198,9 +198,9 @@ extern int ext4_xattr_ibody_find(struct
 extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
 				const char *name,
 				void *buffer, size_t buffer_size);
-extern int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
-				       struct ext4_xattr_info *i,
-				       struct ext4_xattr_ibody_find *is);
+extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+				struct ext4_xattr_info *i,
+				struct ext4_xattr_ibody_find *is);
 
 extern struct mb_cache *ext4_xattr_create_cache(void);
 extern void ext4_xattr_destroy_cache(struct mb_cache *);


