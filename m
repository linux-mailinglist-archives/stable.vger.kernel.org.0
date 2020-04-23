Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC471B6906
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgDWXGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48324 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728153AbgDWXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:30 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004ag-0j; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6h5-SS; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>, "Jeff Mahoney" <jeffm@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:24 +0100
Message-ID: <lsq.1587683028.434914047@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 037/245] btrfs: struct-funcs, constify readers
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

From: Jeff Mahoney <jeffm@suse.com>

commit 1cbb1f454e5321e47fc1e6b233066c7ccc979d15 upstream.

We have reader helpers for most of the on-disk structures that use
an extent_buffer and pointer as offset into the buffer that are
read-only.  We should mark them as const and, in turn, allow consumers
of these interfaces to mark the buffers const as well.

No impact on code, but serves as documentation that a buffer is intended
not to be modified.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/ctree.h        | 128 +++++++++++++++++++++-------------------
 fs/btrfs/extent_io.c    |  24 ++++----
 fs/btrfs/extent_io.h    |  19 +++---
 fs/btrfs/struct-funcs.c |   9 +--
 4 files changed, 91 insertions(+), 89 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2138,7 +2138,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
 struct btrfs_map_token {
-	struct extent_buffer *eb;
+	const struct extent_buffer *eb;
 	char *kaddr;
 	unsigned long offset;
 };
@@ -2169,18 +2169,19 @@ static inline void btrfs_init_map_token
 			   sizeof(((type *)0)->member)))
 
 #define DECLARE_BTRFS_SETGET_BITS(bits)					\
-u##bits btrfs_get_token_##bits(struct extent_buffer *eb, void *ptr,	\
-			       unsigned long off,			\
-                              struct btrfs_map_token *token);		\
-void btrfs_set_token_##bits(struct extent_buffer *eb, void *ptr,	\
+u##bits btrfs_get_token_##bits(const struct extent_buffer *eb,		\
+			       const void *ptr, unsigned long off,	\
+			       struct btrfs_map_token *token);		\
+void btrfs_set_token_##bits(struct extent_buffer *eb, const void *ptr,	\
 			    unsigned long off, u##bits val,		\
 			    struct btrfs_map_token *token);		\
-static inline u##bits btrfs_get_##bits(struct extent_buffer *eb, void *ptr, \
+static inline u##bits btrfs_get_##bits(const struct extent_buffer *eb,	\
+				       const void *ptr,			\
 				       unsigned long off)		\
 {									\
 	return btrfs_get_token_##bits(eb, ptr, off, NULL);		\
 }									\
-static inline void btrfs_set_##bits(struct extent_buffer *eb, void *ptr, \
+static inline void btrfs_set_##bits(struct extent_buffer *eb, void *ptr,\
 				    unsigned long off, u##bits val)	\
 {									\
        btrfs_set_token_##bits(eb, ptr, off, val, NULL);			\
@@ -2192,7 +2193,8 @@ DECLARE_BTRFS_SETGET_BITS(32)
 DECLARE_BTRFS_SETGET_BITS(64)
 
 #define BTRFS_SETGET_FUNCS(name, type, member, bits)			\
-static inline u##bits btrfs_##name(struct extent_buffer *eb, type *s)	\
+static inline u##bits btrfs_##name(const struct extent_buffer *eb,	\
+				   const type *s)			\
 {									\
 	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
 	return btrfs_get_##bits(eb, s, offsetof(type, member));		\
@@ -2203,7 +2205,8 @@ static inline void btrfs_set_##name(stru
 	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
 	btrfs_set_##bits(eb, s, offsetof(type, member), val);		\
 }									\
-static inline u##bits btrfs_token_##name(struct extent_buffer *eb, type *s, \
+static inline u##bits btrfs_token_##name(const struct extent_buffer *eb,\
+					 const type *s,			\
 					 struct btrfs_map_token *token)	\
 {									\
 	BUILD_BUG_ON(sizeof(u##bits) != sizeof(((type *)0))->member);	\
@@ -2218,9 +2221,9 @@ static inline void btrfs_set_token_##nam
 }
 
 #define BTRFS_SETGET_HEADER_FUNCS(name, type, member, bits)		\
-static inline u##bits btrfs_##name(struct extent_buffer *eb)		\
+static inline u##bits btrfs_##name(const struct extent_buffer *eb)	\
 {									\
-	type *p = page_address(eb->pages[0]);				\
+	const type *p = page_address(eb->pages[0]);			\
 	u##bits res = le##bits##_to_cpu(p->member);			\
 	return res;							\
 }									\
@@ -2232,7 +2235,7 @@ static inline void btrfs_set_##name(stru
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\
-static inline u##bits btrfs_##name(type *s)				\
+static inline u##bits btrfs_##name(const type *s)			\
 {									\
 	return le##bits##_to_cpu(s->member);				\
 }									\
@@ -2558,7 +2561,7 @@ static inline unsigned long btrfs_node_k
 		sizeof(struct btrfs_key_ptr) * nr;
 }
 
-void btrfs_node_key(struct extent_buffer *eb,
+void btrfs_node_key(const struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr);
 
 static inline void btrfs_set_node_key(struct extent_buffer *eb,
@@ -2587,28 +2590,28 @@ static inline struct btrfs_item *btrfs_i
 	return (struct btrfs_item *)btrfs_item_nr_offset(nr);
 }
 
-static inline u32 btrfs_item_end(struct extent_buffer *eb,
+static inline u32 btrfs_item_end(const struct extent_buffer *eb,
 				 struct btrfs_item *item)
 {
 	return btrfs_item_offset(eb, item) + btrfs_item_size(eb, item);
 }
 
-static inline u32 btrfs_item_end_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_end_nr(const struct extent_buffer *eb, int nr)
 {
 	return btrfs_item_end(eb, btrfs_item_nr(nr));
 }
 
-static inline u32 btrfs_item_offset_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_offset_nr(const struct extent_buffer *eb, int nr)
 {
 	return btrfs_item_offset(eb, btrfs_item_nr(nr));
 }
 
-static inline u32 btrfs_item_size_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_size_nr(const struct extent_buffer *eb, int nr)
 {
 	return btrfs_item_size(eb, btrfs_item_nr(nr));
 }
 
-static inline void btrfs_item_key(struct extent_buffer *eb,
+static inline void btrfs_item_key(const struct extent_buffer *eb,
 			   struct btrfs_disk_key *disk_key, int nr)
 {
 	struct btrfs_item *item = btrfs_item_nr(nr);
@@ -2644,8 +2647,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_dir_name_
 BTRFS_SETGET_STACK_FUNCS(stack_dir_transid, struct btrfs_dir_item,
 			 transid, 64);
 
-static inline void btrfs_dir_item_key(struct extent_buffer *eb,
-				      struct btrfs_dir_item *item,
+static inline void btrfs_dir_item_key(const struct extent_buffer *eb,
+				      const struct btrfs_dir_item *item,
 				      struct btrfs_disk_key *key)
 {
 	read_eb_member(eb, item, struct btrfs_dir_item, location, key);
@@ -2653,7 +2656,7 @@ static inline void btrfs_dir_item_key(st
 
 static inline void btrfs_set_dir_item_key(struct extent_buffer *eb,
 					  struct btrfs_dir_item *item,
-					  struct btrfs_disk_key *key)
+					  const struct btrfs_disk_key *key)
 {
 	write_eb_member(eb, item, struct btrfs_dir_item, location, key);
 }
@@ -2665,8 +2668,8 @@ BTRFS_SETGET_FUNCS(free_space_bitmaps, s
 BTRFS_SETGET_FUNCS(free_space_generation, struct btrfs_free_space_header,
 		   generation, 64);
 
-static inline void btrfs_free_space_key(struct extent_buffer *eb,
-					struct btrfs_free_space_header *h,
+static inline void btrfs_free_space_key(const struct extent_buffer *eb,
+					const struct btrfs_free_space_header *h,
 					struct btrfs_disk_key *key)
 {
 	read_eb_member(eb, h, struct btrfs_free_space_header, location, key);
@@ -2674,7 +2677,7 @@ static inline void btrfs_free_space_key(
 
 static inline void btrfs_set_free_space_key(struct extent_buffer *eb,
 					    struct btrfs_free_space_header *h,
-					    struct btrfs_disk_key *key)
+					    const struct btrfs_disk_key *key)
 {
 	write_eb_member(eb, h, struct btrfs_free_space_header, location, key);
 }
@@ -2701,25 +2704,25 @@ static inline void btrfs_cpu_key_to_disk
 	disk->objectid = cpu_to_le64(cpu->objectid);
 }
 
-static inline void btrfs_node_key_to_cpu(struct extent_buffer *eb,
-				  struct btrfs_key *key, int nr)
+static inline void btrfs_node_key_to_cpu(const struct extent_buffer *eb,
+					 struct btrfs_key *key, int nr)
 {
 	struct btrfs_disk_key disk_key;
 	btrfs_node_key(eb, &disk_key, nr);
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
 
-static inline void btrfs_item_key_to_cpu(struct extent_buffer *eb,
-				  struct btrfs_key *key, int nr)
+static inline void btrfs_item_key_to_cpu(const struct extent_buffer *eb,
+					 struct btrfs_key *key, int nr)
 {
 	struct btrfs_disk_key disk_key;
 	btrfs_item_key(eb, &disk_key, nr);
 	btrfs_disk_key_to_cpu(key, &disk_key);
 }
 
-static inline void btrfs_dir_item_key_to_cpu(struct extent_buffer *eb,
-				      struct btrfs_dir_item *item,
-				      struct btrfs_key *key)
+static inline void btrfs_dir_item_key_to_cpu(const struct extent_buffer *eb,
+					     const struct btrfs_dir_item *item,
+					     struct btrfs_key *key)
 {
 	struct btrfs_disk_key disk_key;
 	btrfs_dir_item_key(eb, item, &disk_key);
@@ -2752,7 +2755,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_header_nr
 			 nritems, 32);
 BTRFS_SETGET_STACK_FUNCS(stack_header_bytenr, struct btrfs_header, bytenr, 64);
 
-static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
+static inline int btrfs_header_flag(const struct extent_buffer *eb, u64 flag)
 {
 	return (btrfs_header_flags(eb) & flag) == flag;
 }
@@ -2771,7 +2774,7 @@ static inline int btrfs_clear_header_fla
 	return (flags & flag) == flag;
 }
 
-static inline int btrfs_header_backref_rev(struct extent_buffer *eb)
+static inline int btrfs_header_backref_rev(const struct extent_buffer *eb)
 {
 	u64 flags = btrfs_header_flags(eb);
 	return flags >> BTRFS_BACKREF_REV_SHIFT;
@@ -2791,12 +2794,12 @@ static inline unsigned long btrfs_header
 	return offsetof(struct btrfs_header, fsid);
 }
 
-static inline unsigned long btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
+static inline unsigned long btrfs_header_chunk_tree_uuid(const struct extent_buffer *eb)
 {
 	return offsetof(struct btrfs_header, chunk_tree_uuid);
 }
 
-static inline int btrfs_is_leaf(struct extent_buffer *eb)
+static inline int btrfs_is_leaf(const struct extent_buffer *eb)
 {
 	return btrfs_header_level(eb) == 0;
 }
@@ -2830,12 +2833,12 @@ BTRFS_SETGET_STACK_FUNCS(root_stransid,
 BTRFS_SETGET_STACK_FUNCS(root_rtransid, struct btrfs_root_item,
 			 rtransid, 64);
 
-static inline bool btrfs_root_readonly(struct btrfs_root *root)
+static inline bool btrfs_root_readonly(const struct btrfs_root *root)
 {
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
 }
 
-static inline bool btrfs_root_dead(struct btrfs_root *root)
+static inline bool btrfs_root_dead(const struct btrfs_root *root)
 {
 	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_DEAD)) != 0;
 }
@@ -2892,51 +2895,51 @@ BTRFS_SETGET_STACK_FUNCS(backup_num_devi
 /* struct btrfs_balance_item */
 BTRFS_SETGET_FUNCS(balance_flags, struct btrfs_balance_item, flags, 64);
 
-static inline void btrfs_balance_data(struct extent_buffer *eb,
-				      struct btrfs_balance_item *bi,
+static inline void btrfs_balance_data(const struct extent_buffer *eb,
+				      const struct btrfs_balance_item *bi,
 				      struct btrfs_disk_balance_args *ba)
 {
 	read_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
 }
 
 static inline void btrfs_set_balance_data(struct extent_buffer *eb,
-					  struct btrfs_balance_item *bi,
-					  struct btrfs_disk_balance_args *ba)
+				  struct btrfs_balance_item *bi,
+				  const struct btrfs_disk_balance_args *ba)
 {
 	write_eb_member(eb, bi, struct btrfs_balance_item, data, ba);
 }
 
-static inline void btrfs_balance_meta(struct extent_buffer *eb,
-				      struct btrfs_balance_item *bi,
+static inline void btrfs_balance_meta(const struct extent_buffer *eb,
+				      const struct btrfs_balance_item *bi,
 				      struct btrfs_disk_balance_args *ba)
 {
 	read_eb_member(eb, bi, struct btrfs_balance_item, meta, ba);
 }
 
 static inline void btrfs_set_balance_meta(struct extent_buffer *eb,
-					  struct btrfs_balance_item *bi,
-					  struct btrfs_disk_balance_args *ba)
+				  struct btrfs_balance_item *bi,
+				  const struct btrfs_disk_balance_args *ba)
 {
 	write_eb_member(eb, bi, struct btrfs_balance_item, meta, ba);
 }
 
-static inline void btrfs_balance_sys(struct extent_buffer *eb,
-				     struct btrfs_balance_item *bi,
+static inline void btrfs_balance_sys(const struct extent_buffer *eb,
+				     const struct btrfs_balance_item *bi,
 				     struct btrfs_disk_balance_args *ba)
 {
 	read_eb_member(eb, bi, struct btrfs_balance_item, sys, ba);
 }
 
 static inline void btrfs_set_balance_sys(struct extent_buffer *eb,
-					 struct btrfs_balance_item *bi,
-					 struct btrfs_disk_balance_args *ba)
+				 struct btrfs_balance_item *bi,
+				 const struct btrfs_disk_balance_args *ba)
 {
 	write_eb_member(eb, bi, struct btrfs_balance_item, sys, ba);
 }
 
 static inline void
 btrfs_disk_balance_args_to_cpu(struct btrfs_balance_args *cpu,
-			       struct btrfs_disk_balance_args *disk)
+			       const struct btrfs_disk_balance_args *disk)
 {
 	memset(cpu, 0, sizeof(*cpu));
 
@@ -2954,7 +2957,7 @@ btrfs_disk_balance_args_to_cpu(struct bt
 
 static inline void
 btrfs_cpu_balance_args_to_disk(struct btrfs_disk_balance_args *disk,
-			       struct btrfs_balance_args *cpu)
+			       const struct btrfs_balance_args *cpu)
 {
 	memset(disk, 0, sizeof(*disk));
 
@@ -3022,7 +3025,7 @@ BTRFS_SETGET_STACK_FUNCS(super_magic, st
 BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
 			 uuid_tree_generation, 64);
 
-static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
+static inline int btrfs_super_csum_size(const struct btrfs_super_block *s)
 {
 	u16 t = btrfs_super_csum_type(s);
 	/*
@@ -3041,8 +3044,8 @@ static inline unsigned long btrfs_leaf_d
  * this returns the address of the start of the last item,
  * which is the stop of the leaf data stack
  */
-static inline unsigned int leaf_data_end(struct btrfs_root *root,
-					 struct extent_buffer *leaf)
+static inline unsigned int leaf_data_end(const struct btrfs_root *root,
+					 const struct extent_buffer *leaf)
 {
 	u32 nr = btrfs_header_nritems(leaf);
 
@@ -3067,7 +3070,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_exte
 			 struct btrfs_file_extent_item, compression, 8);
 
 static inline unsigned long
-btrfs_file_extent_inline_start(struct btrfs_file_extent_item *e)
+btrfs_file_extent_inline_start(const struct btrfs_file_extent_item *e)
 {
 	return (unsigned long)e + BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
@@ -3101,8 +3104,9 @@ BTRFS_SETGET_FUNCS(file_extent_other_enc
  * size of any extent headers.  If a file is compressed on disk, this is
  * the compressed size
  */
-static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
-						    struct btrfs_item *e)
+static inline u32 btrfs_file_extent_inline_item_len(
+						const struct extent_buffer *eb,
+						struct btrfs_item *e)
 {
 	return btrfs_item_size(eb, e) - BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
@@ -3110,9 +3114,9 @@ static inline u32 btrfs_file_extent_inli
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
  */
-static inline u32 btrfs_file_extent_inline_len(struct extent_buffer *eb,
-					       int slot,
-					       struct btrfs_file_extent_item *fi)
+static inline u32 btrfs_file_extent_inline_len(const struct extent_buffer *eb,
+					int slot,
+					const struct btrfs_file_extent_item *fi)
 {
 	struct btrfs_map_token token;
 
@@ -3134,8 +3138,8 @@ static inline u32 btrfs_file_extent_inli
 
 
 /* btrfs_dev_stats_item */
-static inline u64 btrfs_dev_stats_value(struct extent_buffer *eb,
-					struct btrfs_dev_stats_item *ptr,
+static inline u64 btrfs_dev_stats_value(const struct extent_buffer *eb,
+					const struct btrfs_dev_stats_item *ptr,
 					int index)
 {
 	u64 val;
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5111,9 +5111,8 @@ unlock_exit:
 	return ret;
 }
 
-void read_extent_buffer(struct extent_buffer *eb, void *dstv,
-			unsigned long start,
-			unsigned long len)
+void read_extent_buffer(const struct extent_buffer *eb, void *dstv,
+			unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5142,9 +5141,9 @@ void read_extent_buffer(struct extent_bu
 	}
 }
 
-int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
-			unsigned long start,
-			unsigned long len)
+int read_extent_buffer_to_user(const struct extent_buffer *eb,
+			       void __user *dstv,
+			       unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
@@ -5179,10 +5178,10 @@ int read_extent_buffer_to_user(struct ex
 	return ret;
 }
 
-int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
-			       unsigned long min_len, char **map,
-			       unsigned long *map_start,
-			       unsigned long *map_len)
+int map_private_extent_buffer(const struct extent_buffer *eb,
+			      unsigned long start, unsigned long min_len,
+			      char **map, unsigned long *map_start,
+			      unsigned long *map_len)
 {
 	size_t offset = start & (PAGE_CACHE_SIZE - 1);
 	char *kaddr;
@@ -5217,9 +5216,8 @@ int map_private_extent_buffer(struct ext
 	return 0;
 }
 
-int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
-			  unsigned long start,
-			  unsigned long len)
+int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
+			 unsigned long start, unsigned long len)
 {
 	size_t cur;
 	size_t offset;
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -291,14 +291,13 @@ static inline void extent_buffer_get(str
 	atomic_inc(&eb->refs);
 }
 
-int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
-			  unsigned long start,
-			  unsigned long len);
-void read_extent_buffer(struct extent_buffer *eb, void *dst,
+int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
+			 unsigned long start, unsigned long len);
+void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
-int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dst,
-			       unsigned long start,
+int read_extent_buffer_to_user(const struct extent_buffer *eb,
+			       void __user *dst, unsigned long start,
 			       unsigned long len);
 void write_extent_buffer(struct extent_buffer *eb, const void *src,
 			 unsigned long start, unsigned long len);
@@ -317,10 +316,10 @@ int set_extent_buffer_uptodate(struct ex
 int clear_extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_under_io(struct extent_buffer *eb);
-int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
-		      unsigned long min_len, char **map,
-		      unsigned long *map_start,
-		      unsigned long *map_len);
+int map_private_extent_buffer(const struct extent_buffer *eb,
+			      unsigned long offset, unsigned long min_len,
+			      char **map, unsigned long *map_start,
+			      unsigned long *map_len);
 int extent_range_clear_dirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -50,8 +50,8 @@ static inline void put_unaligned_le8(u8
  */
 
 #define DEFINE_BTRFS_SETGET_BITS(bits)					\
-u##bits btrfs_get_token_##bits(struct extent_buffer *eb, void *ptr,	\
-			       unsigned long off,			\
+u##bits btrfs_get_token_##bits(const struct extent_buffer *eb,		\
+			       const void *ptr, unsigned long off,	\
 			       struct btrfs_map_token *token)		\
 {									\
 	unsigned long part_offset = (unsigned long)ptr;			\
@@ -90,7 +90,8 @@ u##bits btrfs_get_token_##bits(struct ex
 	return res;							\
 }									\
 void btrfs_set_token_##bits(struct extent_buffer *eb,			\
-			    void *ptr, unsigned long off, u##bits val,	\
+			    const void *ptr, unsigned long off,		\
+			    u##bits val,				\
 			    struct btrfs_map_token *token)		\
 {									\
 	unsigned long part_offset = (unsigned long)ptr;			\
@@ -133,7 +134,7 @@ DEFINE_BTRFS_SETGET_BITS(16)
 DEFINE_BTRFS_SETGET_BITS(32)
 DEFINE_BTRFS_SETGET_BITS(64)
 
-void btrfs_node_key(struct extent_buffer *eb,
+void btrfs_node_key(const struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr)
 {
 	unsigned long ptr = btrfs_node_key_ptr_offset(nr);

