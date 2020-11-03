Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F42A54AD
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgKCVNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388720AbgKCVNl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 671B820757;
        Tue,  3 Nov 2020 21:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438020;
        bh=UOdRZ2iZSKkY4ZRYpVAhW/DwqEkJ3DpgJEjm42ozfCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOqwBzVz+5SIvSzL0MAfrS5nSmwW8K9yzhPD2hG2dS0yMjG4yGiHZ8ckIODrZ0Fug
         5RQaFnsYiqB5HKBqxCNO0JFBYSvvvqZdR/mshxVarHUlfQAJI00u2VST8AILSPF94D
         giEUxKJHpB9oGZbL0FP2yNQS99m7F7RfwqHKznNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Luo Meng <luomeng12@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 109/125] ext4: fix invalid inode checksum
Date:   Tue,  3 Nov 2020 21:38:06 +0100
Message-Id: <20201103203213.329431052@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

commit 1322181170bb01bce3c228b82ae3d5c6b793164f upstream.

During the stability test, there are some errors:
  ext4_lookup:1590: inode #6967: comm fsstress: iget: checksum invalid.

If the inode->i_iblocks too big and doesn't set huge file flag, checksum
will not be recalculated when update the inode information to it's buffer.
If other inode marks the buffer dirty, then the inconsistent inode will
be flushed to disk.

Fix this problem by checking i_blocks in advance.

Cc: stable@kernel.org
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Link: https://lore.kernel.org/r/20201020013631.3796673-1-luomeng12@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5135,6 +5135,12 @@ static int ext4_do_update_inode(handle_t
 	if (ext4_test_inode_state(inode, EXT4_STATE_NEW))
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
 
+	err = ext4_inode_blocks_set(handle, raw_inode, ei);
+	if (err) {
+		spin_unlock(&ei->i_raw_lock);
+		goto out_brelse;
+	}
+
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	i_uid = i_uid_read(inode);
 	i_gid = i_gid_read(inode);
@@ -5168,11 +5174,6 @@ static int ext4_do_update_inode(handle_t
 	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
 	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
 
-	err = ext4_inode_blocks_set(handle, raw_inode, ei);
-	if (err) {
-		spin_unlock(&ei->i_raw_lock);
-		goto out_brelse;
-	}
 	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
 	raw_inode->i_flags = cpu_to_le32(ei->i_flags & 0xFFFFFFFF);
 	if (likely(!test_opt2(inode->i_sb, HURD_COMPAT)))


