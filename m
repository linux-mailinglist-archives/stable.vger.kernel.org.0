Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A234C9DC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhC2IeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234528AbhC2IdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C165961601;
        Mon, 29 Mar 2021 08:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006725;
        bh=/2fTOAQOoXW4vjMQADVMxZOcP011X+DBEPZprpL4H5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WQjfWdCLL0NyD4xTee/xhqeqECPm9vj1576g4CqGQ+QmF+yTrf3MA4Q4dxXMrFyr
         UKEeb119gcNTBMyDFBxJ9Zv45xr6yJAuJHC0Sp/cE3UKY+2bAEsz3wi7ZOPPHa/QbU
         0fvH3J2+BT3wCNKldKDZTPrtZoVckSZQfwxi+3iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Gompa <ngompa13@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 068/254] btrfs: do not initialize dev replace for bad dev root
Date:   Mon, 29 Mar 2021 09:56:24 +0200
Message-Id: <20210329075635.388141565@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 3cb894972f1809aa8d087c42e5e8b26c64b7d508 upstream.

While helping Neal fix his broken file system I added a debug patch to
catch if we were calling btrfs_search_slot with a NULL root, and this
stack trace popped:

  we tried to search with a NULL root
  CPU: 0 PID: 1760 Comm: mount Not tainted 5.11.0-155.nealbtrfstest.1.fc34.x86_64 #1
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/22/2020
  Call Trace:
   dump_stack+0x6b/0x83
   btrfs_search_slot.cold+0x11/0x1b
   ? btrfs_init_dev_replace+0x36/0x450
   btrfs_init_dev_replace+0x71/0x450
   open_ctree+0x1054/0x1610
   btrfs_mount_root.cold+0x13/0xfa
   legacy_get_tree+0x27/0x40
   vfs_get_tree+0x25/0xb0
   vfs_kern_mount.part.0+0x71/0xb0
   btrfs_mount+0x131/0x3d0
   ? legacy_get_tree+0x27/0x40
   ? btrfs_show_options+0x640/0x640
   legacy_get_tree+0x27/0x40
   vfs_get_tree+0x25/0xb0
   path_mount+0x441/0xa80
   __x64_sys_mount+0xf4/0x130
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f644730352e

Fix this by not starting the device replace stuff if we do not have a
NULL dev root.

Reported-by: Neal Gompa <ngompa13@gmail.com>
CC: stable@vger.kernel.org # 5.11+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/dev-replace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -80,6 +80,9 @@ int btrfs_init_dev_replace(struct btrfs_
 	struct btrfs_dev_replace_item *ptr;
 	u64 src_devid;
 
+	if (!dev_root)
+		return 0;
+
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;


