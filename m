Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD28D1B699F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgDWXZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48190 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728085AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zx-T7; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6fo-4I; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chris Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.cz>
Date:   Fri, 24 Apr 2020 00:04:08 +0100
Message-ID: <lsq.1587683028.580410033@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 021/245] btrfs: cleanup, rename a few variables in
 btrfs_read_sys_array
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

commit 1ffb22cf8c322bbfea6b35fe23d025841b49fede upstream.

There's a pointer to buffer, integer offset and offset passed as
pointer, try to find matching names for them.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
[bwh: Backported to 3.16 as dependency of fixes to this function]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6032,13 +6032,13 @@ int btrfs_read_sys_array(struct btrfs_ro
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
-	u8 *ptr;
-	unsigned long sb_ptr;
+	u8 *array_ptr;
+	unsigned long sb_array_offset;
 	int ret = 0;
 	u32 num_stripes;
 	u32 array_size;
 	u32 len = 0;
-	u32 cur;
+	u32 cur_offset;
 	struct btrfs_key key;
 
 	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
@@ -6065,20 +6065,21 @@ int btrfs_read_sys_array(struct btrfs_ro
 	write_extent_buffer(sb, super_copy, 0, BTRFS_SUPER_INFO_SIZE);
 	array_size = btrfs_super_sys_array_size(super_copy);
 
-	ptr = super_copy->sys_chunk_array;
-	sb_ptr = offsetof(struct btrfs_super_block, sys_chunk_array);
-	cur = 0;
+	array_ptr = super_copy->sys_chunk_array;
+	sb_array_offset = offsetof(struct btrfs_super_block, sys_chunk_array);
+	cur_offset = 0;
 
-	while (cur < array_size) {
-		disk_key = (struct btrfs_disk_key *)ptr;
+	while (cur_offset < array_size) {
+		disk_key = (struct btrfs_disk_key *)array_ptr;
 		btrfs_disk_key_to_cpu(&key, disk_key);
 
-		len = sizeof(*disk_key); ptr += len;
-		sb_ptr += len;
-		cur += len;
+		len = sizeof(*disk_key);
+		array_ptr += len;
+		sb_array_offset += len;
+		cur_offset += len;
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
-			chunk = (struct btrfs_chunk *)sb_ptr;
+			chunk = (struct btrfs_chunk *)sb_array_offset;
 			ret = read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
@@ -6088,9 +6089,9 @@ int btrfs_read_sys_array(struct btrfs_ro
 			ret = -EIO;
 			break;
 		}
-		ptr += len;
-		sb_ptr += len;
-		cur += len;
+		array_ptr += len;
+		sb_array_offset += len;
+		cur_offset += len;
 	}
 	free_extent_buffer(sb);
 	return ret;

