Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A133443AF
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhCVMxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231683AbhCVMvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C22F619D9;
        Mon, 22 Mar 2021 12:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417141;
        bh=vHmQcHxkMwQVDl+2Pdz78Xo6020Fn8ofBGJYxahBQuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Buw/O8ub3TeNkTtkATxA7GgbIZdgckupXsuU4Kj3M4p7eZ+atwPSzWCfqLGSrha1F
         ayPxSkHQKrZv7Vn6pYAt8B74m3oFnWdxn8HMDdwew1z9RPkEgfIhmZ8z/vMNTzk9q6
         NL0DIhek7Uj3T3fTfaFEUK2V99HYz9rfh3XqFXCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijie Luo <luoshijie1@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 41/43] ext4: fix potential error in ext4_do_update_inode
Date:   Mon, 22 Mar 2021 13:28:55 +0100
Message-Id: <20210322121921.240655861@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121919.936671417@linuxfoundation.org>
References: <20210322121919.936671417@linuxfoundation.org>
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
@@ -5266,7 +5266,7 @@ static int ext4_do_update_inode(handle_t
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	struct super_block *sb = inode->i_sb;
-	int err = 0, rc, block;
+	int err = 0, block;
 	int need_datasync = 0, set_large_file = 0;
 	uid_t i_uid;
 	gid_t i_gid;
@@ -5378,9 +5378,9 @@ static int ext4_do_update_inode(handle_t
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


