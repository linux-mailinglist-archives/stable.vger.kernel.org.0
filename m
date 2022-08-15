Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C875594818
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346599AbiHOXEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347613AbiHOXCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DEE86060;
        Mon, 15 Aug 2022 12:58:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56D2BB80EAD;
        Mon, 15 Aug 2022 19:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1DCC433C1;
        Mon, 15 Aug 2022 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593496;
        bh=LYJU9PjhnyJ0TJ5XqVYXIt0a/jVRtvtlLt94h9j8mpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lhgv5HsUgEtORzQ/406q4IoEH7jbgfdy+M8G+56i/Du7VXXULsbXiHdHckEMI7+0A
         JydvFGO2b52SO5akA43yjsVYFEXDC71XNRQm0AdRz3KCW10Wehw9AVkJOzZtwEqN8y
         zKoKO7Fy9JdFyF4WSsppL1H5qjj54o66qt8ufj0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeong-Jun Kim <hj514.kim@samsung.com>,
        Chao Yu <chao.yu@oppo.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0926/1095] f2fs: fix to invalidate META_MAPPING before DIO write
Date:   Mon, 15 Aug 2022 20:05:25 +0200
Message-Id: <20220815180507.554706160@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 67ca06872eb02944b4c6f92cffa9242e92c63109 ]

Quoted from commit e3b49ea36802 ("f2fs: invalidate META_MAPPING before
IPU/DIO write")

"
Encrypted pages during GC are read and cached in META_MAPPING.
However, due to cached pages in META_MAPPING, there is an issue where
newly written pages are lost by IPU or DIO writes.

Thread A - f2fs_gc()            Thread B
/* phase 3 */
down_write(i_gc_rwsem)
ra_data_block()       ---- (a)
up_write(i_gc_rwsem)
                                f2fs_direct_IO() :
                                 - down_read(i_gc_rwsem)
                                 - __blockdev_direct_io()
                                 - get_data_block_dio_write()
                                 - f2fs_dio_submit_bio()  ---- (b)
                                 - up_read(i_gc_rwsem)
/* phase 4 */
down_write(i_gc_rwsem)
move_data_block()     ---- (c)
up_write(i_gc_rwsem)

(a) In phase 3 of f2fs_gc(), up-to-date page is read from storage and
    cached in META_MAPPING.
(b) In thread B, writing new data by IPU or DIO write on same blkaddr as
    read in (a). cached page in META_MAPPING become out-dated.
(c) In phase 4 of f2fs_gc(), out-dated page in META_MAPPING is copied to
    new blkaddr. In conclusion, the newly written data in (b) is lost.

To address this issue, invalidating pages in META_MAPPING before IPU or
DIO write.
"

In previous commit, we missed to cover extent cache hit case, and passed
wrong value for parameter @end of invalidate_mapping_pages(), fix both
issues.

Fixes: 6aa58d8ad20a ("f2fs: readahead encrypted block during GC")
Fixes: e3b49ea36802 ("f2fs: invalidate META_MAPPING before IPU/DIO write")
Cc: Hyeong-Jun Kim <hj514.kim@samsung.com>
Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9a1a526f2092..1862b03a9982 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1436,9 +1436,12 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map,
 			*map->m_next_extent = pgofs + map->m_len;
 
 		/* for hardware encryption, but to avoid potential issue in future */
-		if (flag == F2FS_GET_BLOCK_DIO)
+		if (flag == F2FS_GET_BLOCK_DIO) {
 			f2fs_wait_on_block_writeback_range(inode,
 						map->m_pblk, map->m_len);
+			invalidate_mapping_pages(META_MAPPING(sbi),
+				map->m_pblk, map->m_pblk + map->m_len - 1);
+		}
 
 		if (map->m_multidev_dio) {
 			block_t blk_addr = map->m_pblk;
@@ -1655,7 +1658,7 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map,
 		f2fs_wait_on_block_writeback_range(inode,
 						map->m_pblk, map->m_len);
 		invalidate_mapping_pages(META_MAPPING(sbi),
-						map->m_pblk, map->m_pblk);
+				map->m_pblk, map->m_pblk + map->m_len - 1);
 
 		if (map->m_multidev_dio) {
 			block_t blk_addr = map->m_pblk;
-- 
2.35.1



