Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09EBEB5D5B
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfIRGUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727764AbfIRGUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:20:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A90218AF;
        Wed, 18 Sep 2019 06:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787611;
        bh=fwcXE3+ff7XDDD7ue7mjmrUCE7f6Rj6+NyZ1oujrTAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+y2Ie3xVI03yBEkq8isUGl7s+CUgOxzl7xOvZkB8fPXuDJp81JKJRHadJVim/AI0
         Hb8vq7prMwVw/ZG2eqg4IdBA2D+PfJk0G6mfUssA2yiPx+iDN9kriAqwC/p55Uxcff
         487zymPf92jFICknflSfkTv6Pz09pzsbNF5VGAD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 14/45] btrfs: compression: add helper for type to string conversion
Date:   Wed, 18 Sep 2019 08:18:52 +0200
Message-Id: <20190918061224.325794824@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit e128f9c3f7242318e1c76d204c7ae32bc878b8c7 upstream.

There are several places opencoding this conversion, add a helper now
that we have 3 compression algorithms.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/compression.c |   15 +++++++++++++++
 fs/btrfs/compression.h |    2 ++
 2 files changed, 17 insertions(+)

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
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -130,6 +130,8 @@ extern const struct btrfs_compress_op bt
 extern const struct btrfs_compress_op btrfs_lzo_compress;
 extern const struct btrfs_compress_op btrfs_zstd_compress;
 
+const char* btrfs_compress_type2str(enum btrfs_compression_type type);
+
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
 
 #endif


