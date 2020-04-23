Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C01B69A7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgDWXZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48198 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728096AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zo-Nh; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6fe-0y; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.cz>
Date:   Fri, 24 Apr 2020 00:04:06 +0100
Message-ID: <lsq.1587683028.974291496@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 019/245] btrfs: new define for the inline extent data
 start
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit 7ec20afbcb7b257aec82ea5d66e6b0b7499abaca upstream.

Use a common definition for the inline data start so we don't have to
open-code it and introduce bugs like "Btrfs: fix wrong max inline data
size limit" fixed.

Signed-off-by: David Sterba <dsterba@suse.cz>
[bwh: Backported to 3.16 as dependency of various fixes: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.c |  3 +--
 fs/btrfs/ctree.h | 16 ++++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -4609,8 +4609,7 @@ void btrfs_truncate_item(struct btrfs_ro
 				ptr = btrfs_item_ptr_offset(leaf, slot);
 				memmove_extent_buffer(leaf, ptr,
 				      (unsigned long)fi,
-				      offsetof(struct btrfs_file_extent_item,
-						 disk_bytenr));
+				      BTRFS_FILE_EXTENT_INLINE_DATA_START);
 			}
 		}
 
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -392,9 +392,11 @@ struct btrfs_header {
 				     sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->leafsize))
+#define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
+		(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 #define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
 					sizeof(struct btrfs_item) - \
-					offsetof(struct btrfs_file_extent_item, disk_bytenr))
+					BTRFS_FILE_EXTENT_INLINE_DATA_START)
 #define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r) - \
 				 sizeof(struct btrfs_item) -\
 				 sizeof(struct btrfs_dir_item))
@@ -904,6 +906,8 @@ struct btrfs_file_extent_item {
 	/*
 	 * disk space consumed by the extent, checksum blocks are included
 	 * in these numbers
+	 *
+	 * At this offset in the structure, the inline extent data start.
 	 */
 	__le64 disk_bytenr;
 	__le64 disk_num_bytes;
@@ -3050,14 +3054,12 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_exte
 static inline unsigned long
 btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
 {
-	unsigned long offset = (unsigned long)e;
-	offset += offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return offset;
+	return (unsigned long)e + BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
 static inline u32 btrfs_file_extent_calc_inline_size(u32 datasize)
 {
-	return offsetof(struct btrfs_file_extent_item, disk_bytenr) + datasize;
+	return BTRFS_FILE_EXTENT_INLINE_DATA_START + datasize;
 }
 
 BTRFS_SETGET_FUNCS(file_extent_disk_bytenr, struct btrfs_file_extent_item,
@@ -3087,9 +3089,7 @@ BTRFS_SETGET_FUNCS(file_extent_other_enc
 static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 						    struct btrfs_item *e)
 {
-	unsigned long offset;
-	offset = offsetof(struct btrfs_file_extent_item, disk_bytenr);
-	return btrfs_item_size(eb, e) - offset;
+	return btrfs_item_size(eb, e) - BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
 /* this returns the number of file bytes represented by the inline item.

