Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF01B2A53FC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733153AbgKCVGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388197AbgKCVGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DE31205ED;
        Tue,  3 Nov 2020 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437598;
        bh=Dfdhbeiqel2PPFbuFVOTIlPxH709A4ndOr6BQIcowRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEgAbmYmhxMQaxoj1vLrub8M51xJ1TX+17hwjgH1qyq9Tsi8mhcZzcn6WobKIX/1U
         bR0rGazL0/b4MVCZCN43RIggKIGonCHVy8WV+Dj7G4kS+LTn1Ox20OFMVggTaBNeBc
         x0N0rXQhHXqNcp0m69izuYqO73glRzUHEdWsJ5b0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 128/191] btrfs: qgroup: fix wrong qgroup metadata reserve for delayed inode
Date:   Tue,  3 Nov 2020 21:37:00 +0100
Message-Id: <20201103203245.136301717@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit b4c5d8fdfff3e2b6c4fa4a5043e8946dff500f8c upstream.

For delayed inode facility, qgroup metadata is reserved for it, and
later freed.

However we're freeing more bytes than we reserved.
In btrfs_delayed_inode_reserve_metadata():

	num_bytes = btrfs_calc_metadata_size(fs_info, 1);
	...
		ret = btrfs_qgroup_reserve_meta_prealloc(root,
				fs_info->nodesize, true);
		...
		if (!ret) {
			node->bytes_reserved = num_bytes;

But in btrfs_delayed_inode_release_metadata():

	if (qgroup_free)
		btrfs_qgroup_free_meta_prealloc(node->root,
				node->bytes_reserved);
	else
		btrfs_qgroup_convert_reserved_meta(node->root,
				node->bytes_reserved);

This means, we're always releasing more qgroup metadata rsv than we have
reserved.

This won't trigger selftest warning, as btrfs qgroup metadata rsv has
extra protection against cases like quota enabled half-way.

But we still need to fix this problem any way.

This patch will use the same num_bytes for qgroup metadata rsv so we
could handle it correctly.

Fixes: f218ea6c4792 ("btrfs: delayed-inode: Remove wrong qgroup meta reservation calls")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/delayed-inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -620,8 +620,7 @@ static int btrfs_delayed_inode_reserve_m
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root,
-				fs_info->nodesize, true);
+		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
 		if (ret < 0)
 			return ret;
 		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,


