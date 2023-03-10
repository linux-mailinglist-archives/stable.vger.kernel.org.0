Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA666B4195
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjCJNyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCJNya (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:54:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE6028E65
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2669617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAC5C4339B;
        Fri, 10 Mar 2023 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456467;
        bh=muR00quUMrGE9lCMB9cIq5+pwzBFjaf/e5at22Q5aFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QHhCQuh8dv/Ke03EZJvrT+puAWehV+3Bv/O1UdWGHxR63Bd+GsU0sFxIUlSfDas3c
         Z0DvxhX08jV1r5QmZ1jAi/JVR6PuK4VCL52uJhFd9GtFeE3u6wYJFDypJ1+G7va+06
         qsAcNOzahrC5AuLiv2u9cZEZV4uJ9Z1fnov8HZiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 005/211] f2fs: dont rely on F2FS_MAP_* in f2fs_iomap_begin
Date:   Fri, 10 Mar 2023 14:36:25 +0100
Message-Id: <20230310133718.884555974@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 8d3c1fa3fa5eacfd14f5b018eddb6c1a91c57783 ]

When testing with a mixed zoned / convention device combination, there
are regular but not 100% reproducible failures in xfstests generic/113
where the __is_valid_data_blkaddr assert hits due to finding a hole.

This seems to be because f2fs_map_blocks can set this flag on a hole
when it was found in the extent cache.

Rework f2fs_iomap_begin to just check the special block numbers directly.
This has the added benefits of the WARN_ON showing which invalid block
address we found, and being properly error out on delalloc blocks that
are confusingly called unwritten but not actually suitable for direct
I/O.

Fixes: 1517c1a7a445 ("f2fs: implement iomap operations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8cca566baf3ab..5263d97bef1dd 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4155,20 +4155,24 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 */
 	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
 
-	if (map.m_flags & (F2FS_MAP_MAPPED | F2FS_MAP_UNWRITTEN)) {
-		iomap->length = blks_to_bytes(inode, map.m_len);
-		if (map.m_flags & F2FS_MAP_MAPPED) {
-			iomap->type = IOMAP_MAPPED;
-			iomap->flags |= IOMAP_F_MERGED;
-		} else {
-			iomap->type = IOMAP_UNWRITTEN;
-		}
-		if (WARN_ON_ONCE(!__is_valid_data_blkaddr(map.m_pblk)))
-			return -EINVAL;
+	/*
+	 * We should never see delalloc or compressed extents here based on
+	 * prior flushing and checks.
+	 */
+	if (WARN_ON_ONCE(map.m_pblk == NEW_ADDR))
+		return -EINVAL;
+	if (WARN_ON_ONCE(map.m_pblk == COMPRESS_ADDR))
+		return -EINVAL;
 
+	if (map.m_pblk != NULL_ADDR) {
+		iomap->length = blks_to_bytes(inode, map.m_len);
+		iomap->type = IOMAP_MAPPED;
+		iomap->flags |= IOMAP_F_MERGED;
 		iomap->bdev = map.m_bdev;
 		iomap->addr = blks_to_bytes(inode, map.m_pblk);
 	} else {
+		if (flags & IOMAP_WRITE)
+			return -ENOTBLK;
 		iomap->length = blks_to_bytes(inode, next_pgofs) -
 				iomap->offset;
 		iomap->type = IOMAP_HOLE;
-- 
2.39.2



