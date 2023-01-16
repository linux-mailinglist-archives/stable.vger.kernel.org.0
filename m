Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8378266CB9A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbjAPRP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjAPRPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:15:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8264C6E8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2509B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05949C433EF;
        Mon, 16 Jan 2023 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888134;
        bh=ncR10ObcXnmBEoNAM16monO+RokhQ7VTe0S5BKXjw68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcu7MUfGUc23IxhKOASLBZeHCSoZkjl+60QYDFzpt9mi7mDSKp72FXiAdXMl4ZCNf
         S4g8fLVP5whbCM7gJdtDFYNCs7SgWYf4c1mbRNUgap8un0iEaxMaqzBbHQWAXuG3Yu
         kuxq2CDU/UqlFflLnYqoMfAutkoohDRn24+MEkHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Sandeen <sandeen@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.19 413/521] ext4: avoid BUG_ON when creating xattrs
Date:   Mon, 16 Jan 2023 16:51:15 +0100
Message-Id: <20230116154905.585203777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit b40ebaf63851b3a401b0dc9263843538f64f5ce6 upstream.

Commit fb0a387dcdcd ("ext4: limit block allocations for indirect-block
files to < 2^32") added code to try to allocate xattr block with 32-bit
block number for indirect block based files on the grounds that these
files cannot use larger block numbers. It also added BUG_ON when
allocated block could not fit into 32 bits. This is however bogus
reasoning because xattr block is stored in inode->i_file_acl and
inode->i_file_acl_hi and as such even indirect block based files can
happily use full 48 bits for xattr block number. The proper handling
seems to be there basically since 64-bit block number support was added.
So remove the bogus limitation and BUG_ON.

Cc: Eric Sandeen <sandeen@redhat.com>
Fixes: fb0a387dcdcd ("ext4: limit block allocations for indirect-block files to < 2^32")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221121130929.32031-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2070,19 +2070,11 @@ inserted:
 
 			goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-
-			/* non-extent files can't have physical blocks past 2^32 */
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
-
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
 			if (error)
 				goto cleanup;
 
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
-
 			ea_idebug(inode, "creating block %llu",
 				  (unsigned long long)block);
 


