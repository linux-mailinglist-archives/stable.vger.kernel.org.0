Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F1321FB20
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgGNS7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730154AbgGNS7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B56E22B2B;
        Tue, 14 Jul 2020 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753139;
        bh=Tf7Ys4DJj3+tqhy6HZ6SoxXADmO3OI/lTItEAJWcBtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hS2QH8svYLnpmUGSWlTJSuedoXvnj1jHNB8g7ecs89E7CfMdMyqrxKAszgKFltWf
         jm3ri/MdqSOz17hYLRSYInNHnVjGpRIZCxKKtrqPQj1ZFkSVy59+31Qx7qYXUJTPmz
         +Egy7M9dmaL5L9qR+k79apWuat1kSO0pH92YypCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 135/166] btrfs: reset tree root pointer after error in init_tree_roots
Date:   Tue, 14 Jul 2020 20:45:00 +0200
Message-Id: <20200714184122.294065688@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 0465337c5599bbe360cdcff452992a1a6b7ed2d4 upstream.

Eric reported an issue where mounting -o recovery with a fuzzed fs
resulted in a kernel panic.  This is because we tried to free the tree
node, except it was an error from the read.  Fix this by properly
resetting the tree_root->node == NULL in this case.  The panic was the
following

  BTRFS warning (device loop0): failed to read tree root
  BUG: kernel NULL pointer dereference, address: 000000000000001f
  RIP: 0010:free_extent_buffer+0xe/0x90 [btrfs]
  Call Trace:
   free_root_extent_buffers.part.0+0x11/0x30 [btrfs]
   free_root_pointers+0x1a/0xa2 [btrfs]
   open_ctree+0x1776/0x18a5 [btrfs]
   btrfs_mount_root.cold+0x13/0xfa [btrfs]
   ? selinux_fs_context_parse_param+0x37/0x80
   legacy_get_tree+0x27/0x40
   vfs_get_tree+0x25/0xb0
   fc_mount+0xe/0x30
   vfs_kern_mount.part.0+0x71/0x90
   btrfs_mount+0x147/0x3e0 [btrfs]
   ? cred_has_capability+0x7c/0x120
   ? legacy_get_tree+0x27/0x40
   legacy_get_tree+0x27/0x40
   vfs_get_tree+0x25/0xb0
   do_mount+0x735/0xa40
   __x64_sys_mount+0x8e/0xd0
   do_syscall_64+0x4d/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

Nik says: this is problematic only if we fail on the last iteration of
the loop as this results in init_tree_roots returning err value with
tree_root->node = -ERR. Subsequently the caller does: fail_tree_roots
which calls free_root_pointers on the bogus value.

Reported-by: Eric Sandeen <sandeen@redhat.com>
Fixes: b8522a1e5f42 ("btrfs: Factor out tree roots initialization during mount")
CC: stable@vger.kernel.org # 5.5+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add details how the pointer gets dereferenced ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/disk-io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2583,10 +2583,12 @@ static int __cold init_tree_roots(struct
 		    !extent_buffer_uptodate(tree_root->node)) {
 			handle_error = true;
 
-			if (IS_ERR(tree_root->node))
+			if (IS_ERR(tree_root->node)) {
 				ret = PTR_ERR(tree_root->node);
-			else if (!extent_buffer_uptodate(tree_root->node))
+				tree_root->node = NULL;
+			} else if (!extent_buffer_uptodate(tree_root->node)) {
 				ret = -EUCLEAN;
+			}
 
 			btrfs_warn(fs_info, "failed to read tree root");
 			continue;


