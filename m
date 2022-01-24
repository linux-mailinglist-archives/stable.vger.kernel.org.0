Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522D24998A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449406AbiAXV2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39808 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376998AbiAXVQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A911614BB;
        Mon, 24 Jan 2022 21:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC3CC36AE3;
        Mon, 24 Jan 2022 21:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059011;
        bh=PhEMH2TmR9SH/HlCq8r5xzc38BxxMHpemwszlBVQ4WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+mQOG4+xrnbK4TJSdwdCGOxTMCq6yNHqZFrCGAQ0A/obHf/P5MbgNR7cyV/9OzgI
         ObZlCDjsMqIZWmFsONBCr91HopG5keOuOfRKQeuwe1YZ68LDbOBhfeA68NfYp0fswl
         wxCUNcQzC8Az6M06KyRlW2y1B6ciPdcvSpvvqP0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0443/1039] ext4: avoid trim error on fs with small groups
Date:   Mon, 24 Jan 2022 19:37:12 +0100
Message-Id: <20220124184140.185237193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 606dee9e08a32..220a4c8178b5e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1117,8 +1117,6 @@ resizefs_out:
 		    sizeof(range)))
 			return -EFAULT;
 
-		range.minlen = max((unsigned int)range.minlen,
-				   q->limits.discard_granularity);
 		ret = ext4_trim_fs(sb, &range);
 		if (ret < 0)
 			return ret;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 215b7068f548a..9af83b6242ddf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6404,6 +6404,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
  */
 int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
+	struct request_queue *q = bdev_get_queue(sb->s_bdev);
 	struct ext4_group_info *grp;
 	ext4_group_t group, first_group, last_group;
 	ext4_grpblk_t cnt = 0, first_cluster, last_cluster;
@@ -6422,6 +6423,13 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
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



