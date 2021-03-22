Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04843442E5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCVMqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231810AbhCVMoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650C4619A1;
        Mon, 22 Mar 2021 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416889;
        bh=EP/5u23yZNX1AtAEG2AMOaW3fI3o1Dqf/GqB8e0R7q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzbnfD1bqZSQbDu+i/AeIRhD1dPjngT30UEMN0b3xd3w2UWLv8yqssjpk0moAmpq0
         1TO3bpG8A/5c46HlN8AFt3CM9xa5EO3ErROzQ1zXJlksJiYyuAeTrL7xfym+gGgz/6
         jHIu+OunMSkclpO4YEPh1EUyxdk3oJCgKAv0Kfi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijie Luo <luoshijie1@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 149/157] ext4: fix potential error in ext4_do_update_inode
Date:   Mon, 22 Mar 2021 13:28:26 +0100
Message-Id: <20210322121938.468594812@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shijie Luo <luoshijie1@huawei.com>

commit 7d8bd3c76da1d94b85e6c9b7007e20e980bfcfe6 upstream.

If set_large_file = 1 and errors occur in ext4_handle_dirty_metadata(),
the error code will be overridden, go to out_brelse to avoid this
situation.

Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
Link: https://lore.kernel.org/r/20210312065051.36314-1-luoshijie1@huawei.com
Cc: stable@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5029,7 +5029,7 @@ static int ext4_do_update_inode(handle_t
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	struct super_block *sb = inode->i_sb;
-	int err = 0, rc, block;
+	int err = 0, block;
 	int need_datasync = 0, set_large_file = 0;
 	uid_t i_uid;
 	gid_t i_gid;
@@ -5141,9 +5141,9 @@ static int ext4_do_update_inode(handle_t
 					      bh->b_data);
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-	rc = ext4_handle_dirty_metadata(handle, NULL, bh);
-	if (!err)
-		err = rc;
+	err = ext4_handle_dirty_metadata(handle, NULL, bh);
+	if (err)
+		goto out_brelse;
 	ext4_clear_inode_state(inode, EXT4_STATE_NEW);
 	if (set_large_file) {
 		BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get write access");


