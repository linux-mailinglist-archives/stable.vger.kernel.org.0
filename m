Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94859499162
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379177AbiAXUKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48538 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377178AbiAXUFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:05:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66A97B810BD;
        Mon, 24 Jan 2022 20:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDA5C340E5;
        Mon, 24 Jan 2022 20:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054702;
        bh=bB4C5zhKszU8JAgQjhLPFX1ZWh9xWPpfbk5EACEQjd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Td7NoFtV9mUQzrqDkwdiuRZ+i6GKTg76H7l0XAZczjOsHgTgJwNO58PoGq1ZoPq4W
         qs4Kldh0GmuAEoPD7+qo/UbjrGNU+/6XO8wKE74JvWp9QxF8/cbHyspJ/SRsqXT84b
         XM3teUO7k9D3jw9DsDpRgwJ0FVaYZA0v0AUMf58Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 476/563] ext4: fix fast commit may miss tracking range for FALLOC_FL_ZERO_RANGE
Date:   Mon, 24 Jan 2022 19:44:01 +0100
Message-Id: <20220124184040.931288157@linuxfoundation.org>
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

commit 5e4d0eba1ccaf19f93222abdeda5a368be141785 upstream.

when call falloc with FALLOC_FL_ZERO_RANGE, to set an range to unwritten,
which has been already initialized. If the range is align to blocksize,
fast commit will not track range for this change.

Also track range for unwritten range in ext4_map_blocks().

Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211221022839.374606-1-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    2 --
 fs/ext4/inode.c   |    7 ++++---
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4638,8 +4638,6 @@ static long ext4_zero_range(struct file
 	ret = ext4_mark_inode_dirty(handle, inode);
 	if (unlikely(ret))
 		goto out_handle;
-	ext4_fc_track_range(handle, inode, offset >> inode->i_sb->s_blocksize_bits,
-			(offset + len - 1) >> inode->i_sb->s_blocksize_bits);
 	/* Zero out partial block at the edges of the range */
 	ret = ext4_zero_partial_blocks(handle, inode, offset, len);
 	if (ret >= 0)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -741,10 +741,11 @@ out_sem:
 			if (ret)
 				return ret;
 		}
-		ext4_fc_track_range(handle, inode, map->m_lblk,
-			    map->m_lblk + map->m_len - 1);
 	}
-
+	if (retval > 0 && (map->m_flags & EXT4_MAP_UNWRITTEN ||
+				map->m_flags & EXT4_MAP_MAPPED))
+		ext4_fc_track_range(handle, inode, map->m_lblk,
+					map->m_lblk + map->m_len - 1);
 	if (retval < 0)
 		ext_debug(inode, "failed with err %d\n", retval);
 	return retval;


