Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1DB498BAF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343535AbiAXTPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346121AbiAXTNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:13:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10F8C061759;
        Mon, 24 Jan 2022 11:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60C08609EE;
        Mon, 24 Jan 2022 19:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D61C340E8;
        Mon, 24 Jan 2022 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051146;
        bh=neIPTLVyB5ZDKcVbq97LECf0V9QFMR4MwIP1lmK80SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkNGlDXcVuKfxqhZ9FKpf5ZYrkdlGqQ2hGmPB7/R9Txwfhx52WAH1WeUIAROGOGlh
         Y9RIHhs37hzcVQUpGMvGiTo8rCKCp9OSsRNC7eCidrBWBJylHYLvd5RQu/hFGfk5WL
         jMWvUaV16BceXNNFmNlxiZGCdhN/B4CtOKbH1pDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 068/186] ext4: avoid trim error on fs with small groups
Date:   Mon, 24 Jan 2022 19:42:23 +0100
Message-Id: <20220124183939.315222726@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 173b6e383d2a204c9921ffc1eca3b87aa2106c33 ]

A user reported FITRIM ioctl failing for him on ext4 on some devices
without apparent reason.  After some debugging we've found out that
these devices (being LVM volumes) report rather large discard
granularity of 42MB and the filesystem had 1k blocksize and thus group
size of 8MB. Because ext4 FITRIM implementation puts discard
granularity into minlen, ext4_trim_fs() declared the trim request as
invalid. However just silently doing nothing seems to be a more
appropriate reaction to such combination of parameters since user did
not specify anything wrong.

CC: Lukas Czerner <lczerner@redhat.com>
Fixes: 5c2ed62fd447 ("ext4: Adjust minlen with discard_granularity in the FITRIM ioctl")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20211112152202.26614-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c   | 2 --
 fs/ext4/mballoc.c | 8 ++++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6718c7ccd6314..3bd79fc4e9487 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -992,8 +992,6 @@ resizefs_out:
 		    sizeof(range)))
 			return -EFAULT;
 
-		range.minlen = max((unsigned int)range.minlen,
-				   q->limits.discard_granularity);
 		ret = ext4_trim_fs(sb, &range);
 		if (ret < 0)
 			return ret;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c40d3c44a1d69..28bee66c5fbf0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5284,6 +5284,7 @@ out:
  */
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
+	struct request_queue *q = bdev_get_queue(sb->s_bdev);
 	struct ext4_group_info *grp;
 	ext4_group_t group, first_group, last_group;
 	ext4_grpblk_t cnt = 0, first_cluster, last_cluster;
@@ -5302,6 +5303,13 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	    start >= max_blks ||
 	    range->len < sb->s_blocksize)
 		return -EINVAL;
+	/* No point to try to trim less than discard granularity */
+	if (range->minlen < q->limits.discard_granularity) {
+		minlen = EXT4_NUM_B2C(EXT4_SB(sb),
+			q->limits.discard_granularity >> sb->s_blocksize_bits);
+		if (minlen > EXT4_CLUSTERS_PER_GROUP(sb))
+			goto out;
+	}
 	if (end >= max_blks)
 		end = max_blks - 1;
 	if (end <= first_data_blk)
-- 
2.34.1



