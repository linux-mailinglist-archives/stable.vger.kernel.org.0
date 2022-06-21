Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B841C553C5F
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355813AbiFUVBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356251AbiFUU7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:59:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D8233EBC;
        Tue, 21 Jun 2022 13:52:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAD00B81B3D;
        Tue, 21 Jun 2022 20:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D80AC385A5;
        Tue, 21 Jun 2022 20:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844661;
        bh=dQQbgxLPlCd0qRsLW7X0QIDDIpmisiiXEDialW26d4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akqCFdvg9CLtiMvtBp7ugLaPm9PF03sHoGkAjtzZHxMYWh2MNtndxpSWwfJsH+0Av
         bDW+ci4KdTsCXJ+2F0c2i88B+PslwewRnufrsEqxcD+6tPDLEGTv6w4Ph1pyoFVTH7
         f9znZFSp0/fR2eW+ZjPH63JKFYfr/lHbkV4wjurOsy+6vrzyxJcd6uVms99pFBufEo
         iPbtuh8YNGPcMCVH6VOOlw1lG+Q4kEzAixwuFvw+VLNJCObDsFrk9amRO+DafXJnHF
         8Nmo+IO4UI8hWCsNDH9lXSMdLCqTIdlRpnyHMiY91ygFa8zBl2LECH735MJ8L8R1tt
         fYIZ6E8Dc0i0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/17] ext4: improve write performance with disabled delalloc
Date:   Tue, 21 Jun 2022 16:50:37 -0400
Message-Id: <20220621205041.250426-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205041.250426-1-sashal@kernel.org>
References: <20220621205041.250426-1-sashal@kernel.org>
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
index f0350d60ba50..e83a2887c1a4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -823,7 +823,7 @@ int ext4_get_block_unwritten(struct inode *inode, sector_t iblock,
 	ext4_debug("ext4_get_block_unwritten: inode %lu, create flag %d\n",
 		   inode->i_ino, create);
 	return _ext4_get_block(inode, iblock, bh_result,
-			       EXT4_GET_BLOCKS_IO_CREATE_EXT);
+			       EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
 }
 
 /* Maximum number of blocks we map for direct IO at once. */
-- 
2.35.1

