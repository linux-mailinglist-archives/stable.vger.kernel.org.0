Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01BC2AB96A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbgKINJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731766AbgKINJC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:09:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECE2220663;
        Mon,  9 Nov 2020 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927341;
        bh=GA0zwwui2qgUENftB8za4Im3485L53l9jiFKcf5d2NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwTFu4BbfWrJF0qCPz0Nue9Qz/V0tOLaKZL/UH660gM21j9i0fFsrfsM5ZWZxmAn9
         n/UiZMBAiWDfFlPjLSYDT+WJZepVJXePkvq6Q2kgw0TYaCelnF/yuSuwhhH8puhFWK
         dGh94XxmoEVPS5iI7hfLU3JalUpGiX0AV3RkEXcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 26/71] btrfs: tree-checker: Verify dev item
Date:   Mon,  9 Nov 2020 13:55:20 +0100
Message-Id: <20201109125021.133720668@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit ab4ba2e133463c702b37242560d7fabedd2dc750 upstream.

[BUG]
For fuzzed image whose DEV_ITEM has invalid total_bytes as 0, then
kernel will just panic:
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
  #PF error: [normal kernel read fault]
  PGD 800000022b2bd067 P4D 800000022b2bd067 PUD 22b2bc067 PMD 0
  Oops: 0000 [#1] SMP PTI
  CPU: 0 PID: 1106 Comm: mount Not tainted 5.0.0-rc8+ #9
  RIP: 0010:btrfs_verify_dev_extents+0x2a5/0x5a0
  Call Trace:
   open_ctree+0x160d/0x2149
   btrfs_mount_root+0x5b2/0x680

[CAUSE]
If device extent verification finds a deivce with 0 total_bytes, then it
assumes it's a seed dummy, then search for seed devices.

But in this case, there is no seed device at all, causing NULL pointer.

[FIX]
Since this is caused by fuzzed image, let's go the tree-check way, just
add a new verification for device item.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202691
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c      |    9 -----
 fs/btrfs/volumes.h      |    9 +++++
 3 files changed, 83 insertions(+), 9 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -600,6 +600,77 @@ int btrfs_check_chunk_valid(struct btrfs
 	return 0;
 }
 
+__printf(4, 5)
+__cold
+static void dev_item_err(const struct btrfs_fs_info *fs_info,
+			 const struct extent_buffer *eb, int slot,
+			 const char *fmt, ...)
+{
+	struct btrfs_key key;
+	struct va_format vaf;
+	va_list args;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	btrfs_crit(fs_info,
+	"corrupt %s: root=%llu block=%llu slot=%d devid=%llu %pV",
+		btrfs_header_level(eb) == 0 ? "leaf" : "node",
+		btrfs_header_owner(eb), btrfs_header_bytenr(eb), slot,
+		key.objectid, &vaf);
+	va_end(args);
+}
+
+static int check_dev_item(struct btrfs_fs_info *fs_info,
+			  struct extent_buffer *leaf,
+			  struct btrfs_key *key, int slot)
+{
+	struct btrfs_dev_item *ditem;
+	u64 max_devid = max(BTRFS_MAX_DEVS(fs_info), BTRFS_MAX_DEVS_SYS_CHUNK);
+
+	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid objectid: has=%llu expect=%llu",
+			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
+		return -EUCLEAN;
+	}
+	if (key->offset > max_devid) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid devid: has=%llu expect=[0, %llu]",
+			     key->offset, max_devid);
+		return -EUCLEAN;
+	}
+	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
+	if (btrfs_device_id(leaf, ditem) != key->offset) {
+		dev_item_err(fs_info, leaf, slot,
+			     "devid mismatch: key has=%llu item has=%llu",
+			     key->offset, btrfs_device_id(leaf, ditem));
+		return -EUCLEAN;
+	}
+
+	/*
+	 * For device total_bytes, we don't have reliable way to check it, as
+	 * it can be 0 for device removal. Device size check can only be done
+	 * by dev extents check.
+	 */
+	if (btrfs_device_bytes_used(leaf, ditem) >
+	    btrfs_device_total_bytes(leaf, ditem)) {
+		dev_item_err(fs_info, leaf, slot,
+			     "invalid bytes used: have %llu expect [0, %llu]",
+			     btrfs_device_bytes_used(leaf, ditem),
+			     btrfs_device_total_bytes(leaf, ditem));
+		return -EUCLEAN;
+	}
+	/*
+	 * Remaining members like io_align/type/gen/dev_group aren't really
+	 * utilized.  Skip them to make later usage of them easier.
+	 */
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -630,6 +701,9 @@ static int check_leaf_item(struct btrfs_
 		ret = btrfs_check_chunk_valid(fs_info, leaf, chunk,
 					      key->offset);
 		break;
+	case BTRFS_DEV_ITEM_KEY:
+		ret = check_dev_item(fs_info, leaf, key, slot);
+		break;
 	}
 	return ret;
 }
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4606,15 +4606,6 @@ static void check_raid56_incompat_flag(s
 	btrfs_set_fs_incompat(info, RAID56);
 }
 
-#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
-			- sizeof(struct btrfs_chunk))		\
-			/ sizeof(struct btrfs_stripe) + 1)
-
-#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
-				- 2 * sizeof(struct btrfs_disk_key)	\
-				- 2 * sizeof(struct btrfs_chunk))	\
-				/ sizeof(struct btrfs_stripe) + 1)
-
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			       u64 start, u64 type)
 {
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -257,6 +257,15 @@ struct btrfs_fs_devices {
 
 #define BTRFS_BIO_INLINE_CSUM_SIZE	64
 
+#define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
+			- sizeof(struct btrfs_chunk))		\
+			/ sizeof(struct btrfs_stripe) + 1)
+
+#define BTRFS_MAX_DEVS_SYS_CHUNK ((BTRFS_SYSTEM_CHUNK_ARRAY_SIZE	\
+				- 2 * sizeof(struct btrfs_disk_key)	\
+				- 2 * sizeof(struct btrfs_chunk))	\
+				/ sizeof(struct btrfs_stripe) + 1)
+
 /*
  * we need the mirror number and stripe index to be passed around
  * the call chain while we are processing end_io (especially errors).


