Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9626184D
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732163AbgIHRvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730572AbgIHQNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46519248AF;
        Tue,  8 Sep 2020 15:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580352;
        bh=tH0WYc9LiYux1rTGMzgzCj9ahMv2kjb97oX/0ffA/C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCQPfeL3+JLMoHDgfDZRFGwJ6m4/7fLaE8JZnJHuxDM1f2O1fe4jVq/VSzUGVLOs1
         OhXKj0/lX13eKPNzuLqDUmTWQjLG1TVuTtpQ7oG0NWSCrE8BHydm5kvhAkDjQuyykR
         Qiw61EV2wF8Fd4hEShxPf5QyeAlMBX/XI+4gumVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/65] btrfs: set the lockdep class for log tree extent buffers
Date:   Tue,  8 Sep 2020 17:26:26 +0200
Message-Id: <20200908152219.150008815@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152217.022816723@linuxfoundation.org>
References: <20200908152217.022816723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit d3beaa253fd6fa40b8b18a216398e6e5376a9d21 ]

These are special extent buffers that get rewound in order to lookup
the state of the tree at a specific point in time.  As such they do not
go through the normal initialization paths that set their lockdep class,
so handle them appropriately when they are created and before they are
locked.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ae8ac4837eb19..cf1e8ba50f6bf 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1367,6 +1367,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	btrfs_tree_read_unlock_blocking(eb);
 	free_extent_buffer(eb);
 
+	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb_rewin),
+				       eb_rewin, btrfs_header_level(eb_rewin));
 	btrfs_tree_read_lock(eb_rewin);
 	__tree_mod_log_rewind(fs_info, eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
@@ -1437,7 +1439,6 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 
 	if (!eb)
 		return NULL;
-	btrfs_tree_read_lock(eb);
 	if (old_root) {
 		btrfs_set_header_bytenr(eb, eb->start);
 		btrfs_set_header_backref_rev(eb, BTRFS_MIXED_BACKREF_REV);
@@ -1445,6 +1446,9 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		btrfs_set_header_level(eb, old_root->level);
 		btrfs_set_header_generation(eb, old_generation);
 	}
+	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb), eb,
+				       btrfs_header_level(eb));
+	btrfs_tree_read_lock(eb);
 	if (tm)
 		__tree_mod_log_rewind(fs_info, eb, time_seq, tm);
 	else
-- 
2.25.1



