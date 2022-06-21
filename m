Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB52553CE2
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355186AbiFUU5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 16:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355185AbiFUU4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6058031922;
        Tue, 21 Jun 2022 13:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A6B061893;
        Tue, 21 Jun 2022 20:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF20C385A2;
        Tue, 21 Jun 2022 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844604;
        bh=PoBRNYUSXCDhO5G+264qrVu0RywmHcC94lxe/M0er2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsKUzxsekzm4GLth/3ns92J4LNEjdfTB3azcZ4tX1SvZY28/ovfHfc795qGsqJycF
         fmeWMvjIjC3mdzosyMUCh8L/qqrwgQdHkgc7ib7cw5DchR+zIsOV2h7oiAFYL8Pn94
         EUv9Iy4KwbQ/6yV3VD38FgEHlIRydor8jO2uL+OWxg7NnftBrBFISwRWvpIBfbXl54
         c7byTuNrljdN+JOpFKEDxtwHDK0i6hlo4iuzuILi42g9yA/gZUzCNJxL/ExaTlHW8k
         R0a0PKM4hKUXJ/H2DnQWkv4X9BkUp2JfGQ+RowgeUoOgOHadxD2RLENnvUJRaFEFIA
         HF/wqIi3nru2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 17/22] ext4: improve write performance with disabled delalloc
Date:   Tue, 21 Jun 2022 16:49:23 -0400
Message-Id: <20220621204928.249907-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621204928.249907-1-sashal@kernel.org>
References: <20220621204928.249907-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 8d5459c11f548131ce48b2fbf45cccc5c382558f ]

When delayed allocation is disabled (either through mount option or
because we are running low on free space), ext4_write_begin() allocates
blocks with EXT4_GET_BLOCKS_IO_CREATE_EXT flag. With this flag extent
merging is disabled and since ext4_write_begin() is called for each page
separately, we end up with a *lot* of 1 block extents in the extent tree
and following writeback is writing 1 block at a time which results in
very poor write throughput (4 MB/s instead of 200 MB/s). These days when
ext4_get_block_unwritten() is used only by ext4_write_begin(),
ext4_page_mkwrite() and inline data conversion, we can safely allow
extent merging to happen from these paths since following writeback will
happen on different boundaries anyway. So use
EXT4_GET_BLOCKS_CREATE_UNRIT_EXT instead which restores the performance.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220520111402.4252-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index beed9e32571c..767528daecb5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -822,7 +822,7 @@ int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 	ext4_debug("ext4_get_block_unwritten: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
 	return _ext4_get_block(inode, iblock, bh_result,
-			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
+			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
 }
 
 /* Maximum number of blocks we map for direct IO at once. */
-- 
2.35.1

