Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E72D499DC2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586193AbiAXWZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355736AbiAXWRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B072C04A2E7;
        Mon, 24 Jan 2022 12:46:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD8B260C19;
        Mon, 24 Jan 2022 20:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741BAC340E5;
        Mon, 24 Jan 2022 20:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057170;
        bh=XW8EBVukJqabCDHUK9SB0/ExquUtJR3sz0r9yhX2yWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9fQLygi4I1piEJsSzh4GS1bBQ0CFQAy70dd+qX0KSu6KeSSeZ7t68woQ72n18IXs
         L32ZhtqZmqY2KosWqjSMT+ir9qeSszgUElfjHJC1nV4+q0c6OabKPOk7JF6gHnCL9f
         3rfLFni3zdY88x0l+3pgVWN3/kV2zlnjsG/gkVs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 717/846] ext4: fix fast commit may miss tracking range for FALLOC_FL_ZERO_RANGE
Date:   Mon, 24 Jan 2022 19:43:54 +0100
Message-Id: <20220124184125.755716147@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -4645,8 +4645,6 @@ static long ext4_zero_range(struct file
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


