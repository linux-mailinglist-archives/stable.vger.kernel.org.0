Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E191B699A
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgDWXY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48216 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zz-Tu; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6fs-6A; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.cz>, "Chris Mason" <clm@fb.com>
Date:   Fri, 24 Apr 2020 00:04:09 +0100
Message-ID: <lsq.1587683028.215054256@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 022/245] btrfs: add more checks to btrfs_read_sys_array
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

commit e3540eab29e1b2260bc4b9b3979a49a00e3e3af8 upstream.

Verify that the sys_array has enough bytes to read the next item.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6071,20 +6071,34 @@ int btrfs_read_sys_array(struct btrfs_ro
 
 	while (cur_offset < array_size) {
 		disk_key = (struct btrfs_disk_key *)array_ptr;
+		len = sizeof(*disk_key);
+		if (cur_offset + len > array_size)
+			goto out_short_read;
+
 		btrfs_disk_key_to_cpu(&key, disk_key);
 
-		len = sizeof(*disk_key);
 		array_ptr += len;
 		sb_array_offset += len;
 		cur_offset += len;
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
 			chunk = (struct btrfs_chunk *)sb_array_offset;
+			/*
+			 * At least one btrfs_chunk with one stripe must be
+			 * present, exact stripe count check comes afterwards
+			 */
+			len = btrfs_chunk_item_size(1);
+			if (cur_offset + len > array_size)
+				goto out_short_read;
+
+			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
+			len = btrfs_chunk_item_size(num_stripes);
+			if (cur_offset + len > array_size)
+				goto out_short_read;
+
 			ret = read_one_chunk(root, &key, sb, chunk);
 			if (ret)
 				break;
-			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
-			len = btrfs_chunk_item_size(num_stripes);
 		} else {
 			ret = -EIO;
 			break;
@@ -6095,6 +6109,12 @@ int btrfs_read_sys_array(struct btrfs_ro
 	}
 	free_extent_buffer(sb);
 	return ret;
+
+out_short_read:
+	printk(KERN_ERR "BTRFS: sys_array too short to read %u bytes at offset %u\n",
+			len, cur_offset);
+	free_extent_buffer(sb);
+	return -EIO;
 }
 
 int btrfs_read_chunk_tree(struct btrfs_root *root)

