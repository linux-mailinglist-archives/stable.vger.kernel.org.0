Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3108B344343
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCVMtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232557AbhCVMrx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:47:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C400619CF;
        Mon, 22 Mar 2021 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417023;
        bh=2AS2Pj1W4u5fZCmxZoNfVHVRx4P6DorZMHs3XiEJNxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YHZi549MilIoiAZdCZ9Q0nU3QO13kP23OMKqLJED9g8LGeS+yUanAcXzQrbrOSpc
         V+4v5PSomfQi9P9mlHsXsOJm2Go/e3HKLU/3XamLaWmtfeiFYgjXy5X7jP2SxQaRyv
         Z2CbtmawSmlHHmQvHWYTs2C+TiqEAAp2QRn/Sr7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shijie Luo <luoshijie1@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 56/60] ext4: fix potential error in ext4_do_update_inode
Date:   Mon, 22 Mar 2021 13:28:44 +0100
Message-Id: <20210322121924.225145259@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
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
@@ -5267,7 +5267,7 @@ static int ext4_do_update_inode(handle_t
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct buffer_head *bh = iloc->bh;
 	struct super_block *sb = inode->i_sb;
-	int err = 0, rc, block;
+	int err = 0, block;
 	int need_datasync = 0, set_large_file = 0;
 	uid_t i_uid;
 	gid_t i_gid;
@@ -5379,9 +5379,9 @@ static int ext4_do_update_inode(handle_t
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


