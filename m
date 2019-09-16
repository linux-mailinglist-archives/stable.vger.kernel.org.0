Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 205FBB364B
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfIPIRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 04:17:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:43586 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbfIPIRa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 04:17:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59BB8AF5C;
        Mon, 16 Sep 2019 08:17:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH for-4.14 1/2] btrfs: compression: add helper for type to string conversion
Date:   Mon, 16 Sep 2019 10:17:25 +0200
Message-Id: <20190916081726.7983-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190916081726.7983-1-jthumshirn@suse.de>
References: <20190916081726.7983-1-jthumshirn@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

[ Upstream commit e128f9c3f7242318e1c76d204c7ae32bc878b8c7 ]

There are several places opencoding this conversion, add a helper now
that we have 3 compression algorithms.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/compression.c | 15 +++++++++++++++
 fs/btrfs/compression.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 280384bf34f1..d7aa96e1fc36 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -43,6 +43,21 @@
 #include "extent_io.h"
 #include "extent_map.h"
 
+static const char* const btrfs_compress_types[] = { "", "zlib", "lzo", "zstd" };
+
+const char* btrfs_compress_type2str(enum btrfs_compression_type type)
+{
+	switch (type) {
+	case BTRFS_COMPRESS_ZLIB:
+	case BTRFS_COMPRESS_LZO:
+	case BTRFS_COMPRESS_ZSTD:
+	case BTRFS_COMPRESS_NONE:
+		return btrfs_compress_types[type];
+	}
+
+	return NULL;
+}
+
 static int btrfs_decompress_bio(struct compressed_bio *cb);
 
 static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index d2781ff8f994..adb704757955 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -130,6 +130,8 @@ extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
 extern const struct btrfs_compress_op btrfs_zstd_compress;
 
+const char* btrfs_compress_type2str(enum btrfs_compression_type type);
+
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
 
 #endif
-- 
2.16.4

