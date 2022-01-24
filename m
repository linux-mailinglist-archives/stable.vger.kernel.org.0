Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E337F499165
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379196AbiAXUKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48610 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377263AbiAXUFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:05:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D531B8121A;
        Mon, 24 Jan 2022 20:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D57C340E5;
        Mon, 24 Jan 2022 20:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054711;
        bh=2XGr8Nu1tgEUWl+Pl/DqQYYE7vo3QJeprvUIV3btP9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFefzcEOh4IyYDEIaFySWQ370mk42avSkVSfC4KQa/qLp/Lj4OMSiOjul5FVpjvd6
         ugwPERCKO+2w4rTU8yMfBot1cItOvjQSGMiLBjpC6CWGDXQifMDdi3soIe7QiEdkdR
         X8EAYGHC09UPd6xeo2fhdIaFUiwFWHlqlypDO4/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 479/563] ext4: use ext4_ext_remove_space() for fast commit replay delete range
Date:   Mon, 24 Jan 2022 19:44:04 +0100
Message-Id: <20220124184041.031457527@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Yin <yinxin.x@bytedance.com>

commit 0b5b5a62b945a141e64011b2f90ee7e46f14be98 upstream.

For now ,we use ext4_punch_hole() during fast commit replay delete range
procedure. But it will be affected by inode->i_size, which may not
correct during fast commit replay procedure. The following test will
failed.

-create & write foo (len 1000K)
-falloc FALLOC_FL_ZERO_RANGE foo (range 400K - 600K)
-create & fsync bar
-falloc FALLOC_FL_PUNCH_HOLE foo (range 300K-500K)
-fsync foo
-crash before a full commit

After the fast_commit reply procedure, the range 400K-500K will not be
removed. Because in this case, when calling ext4_punch_hole() the
inode->i_size is 0, and it just retruns with doing nothing.

Change to use ext4_ext_remove_space() instead of ext4_punch_hole()
to remove blocks of inode directly.

Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211223032337.5198-2-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1764,11 +1764,14 @@ ext4_fc_replay_del_range(struct super_bl
 		}
 	}
 
-	ret = ext4_punch_hole(inode,
-		le32_to_cpu(lrange.fc_lblk) << sb->s_blocksize_bits,
-		le32_to_cpu(lrange.fc_len) <<  sb->s_blocksize_bits);
-	if (ret)
-		jbd_debug(1, "ext4_punch_hole returned %d", ret);
+	down_write(&EXT4_I(inode)->i_data_sem);
+	ret = ext4_ext_remove_space(inode, lrange.fc_lblk,
+				lrange.fc_lblk + lrange.fc_len - 1);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	if (ret) {
+		iput(inode);
+		return 0;
+	}
 	ext4_ext_replay_shrink_inode(inode,
 		i_size_read(inode) >> sb->s_blocksize_bits);
 	ext4_mark_inode_dirty(NULL, inode);


