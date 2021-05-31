Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605AD395EE1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhEaOFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232399AbhEaOCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 899336194E;
        Mon, 31 May 2021 13:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468240;
        bh=5UMo4Vu4+ny9cwlNcrqTQOyBn8cjCWZaFGIgbUb9J/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nledX1euTnC5fafNgiftAjjsNy5kbIee9AXOoCFeXl1FpAlSIy7+7BHhgO9ZNVxDG
         LZ7EdEwv8RxqKkQ/IXfjJQA4seENViKzvwZzRnvQUj9JuCuWEEwot4bJREPK4Ckken
         2ngQcMSEnmegWxHl/3bttb3EbexCmlt/mAJlGrZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Boris Burkov <boris@bur.io>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/252] btrfs: return whole extents in fiemap
Date:   Mon, 31 May 2021 15:13:55 +0200
Message-Id: <20210531130703.787446522@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Burkov <boris@bur.io>

[ Upstream commit 15c7745c9a0078edad1f7df5a6bb7b80bc8cca23 ]

  `xfs_io -c 'fiemap <off> <len>' <file>`

can give surprising results on btrfs that differ from xfs.

btrfs prints out extents trimmed to fit the user input. If the user's
fiemap request has an offset, then rather than returning each whole
extent which intersects that range, we also trim the start extent to not
have start < off.

Documentation in filesystems/fiemap.txt and the xfs_io man page suggests
that returning the whole extent is expected.

Some cases which all yield the same fiemap in xfs, but not btrfs:
  dd if=/dev/zero of=$f bs=4k count=1
  sudo xfs_io -c 'fiemap 0 1024' $f
    0: [0..7]: 26624..26631
  sudo xfs_io -c 'fiemap 2048 1024' $f
    0: [4..7]: 26628..26631
  sudo xfs_io -c 'fiemap 2048 4096' $f
    0: [4..7]: 26628..26631
  sudo xfs_io -c 'fiemap 3584 512' $f
    0: [7..7]: 26631..26631
  sudo xfs_io -c 'fiemap 4091 5' $f
    0: [7..6]: 26631..26630

I believe this is a consequence of the logic for merging contiguous
extents represented by separate extent items. That logic needs to track
the last offset as it loops through the extent items, which happens to
pick up the start offset on the first iteration, and trim off the
beginning of the full extent. To fix it, start `off` at 0 rather than
`start` so that we keep the iteration/merging intact without cutting off
the start of the extent.

after the fix, all the above commands give:

  0: [0..7]: 26624..26631

The merging logic is exercised by fstest generic/483, and I have written
a new fstest for checking we don't have backwards or zero-length fiemaps
for cases like those above.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 30cf917a58e9..81e98a457130 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4662,7 +4662,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		  u64 start, u64 len)
 {
 	int ret = 0;
-	u64 off = start;
+	u64 off;
 	u64 max = start + len;
 	u32 flags = 0;
 	u32 found_type;
@@ -4698,6 +4698,11 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		goto out_free_ulist;
 	}
 
+	/*
+	 * We can't initialize that to 'start' as this could miss extents due
+	 * to extent item merging
+	 */
+	off = 0;
 	start = round_down(start, btrfs_inode_sectorsize(inode));
 	len = round_up(max, btrfs_inode_sectorsize(inode)) - start;
 
-- 
2.30.2



