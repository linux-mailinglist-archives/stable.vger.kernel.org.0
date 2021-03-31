Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E670134C9E6
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbhC2IeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234590AbhC2IdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3281A619B9;
        Mon, 29 Mar 2021 08:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006729;
        bh=q4V0SiQrF84Nq9VKx+LEJXOgjK2tKh2XmOktLkFt6cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u85GARUhySxRlnyrLJOR419rDmMpnr2Aw+Dk7tgjDvRhgYz7JSMG5U7sLR+6yDaVX
         Aq3MHzRU8YqmIakh6xCpDsb66iO8VH0eqeEUfLdzV81FHCzuvYeZzMpbQiiqsCGWVU
         b/dTi4dHdfxKeZZALA2ukwVbxQMrsBouL81BdCZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Gompa <ngompa13@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 070/254] btrfs: initialize device::fs_info always
Date:   Mon, 29 Mar 2021 09:56:26 +0200
Message-Id: <20210329075635.456453790@linuxfoundation.org>
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

commit 820a49dafc3304de06f296c35c9ff1ebc1666343 upstream.

Neal reported a panic trying to use -o rescue=all

  BUG: kernel NULL pointer dereference, address: 0000000000000030
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP NOPTI
  CPU: 0 PID: 696 Comm: mount Tainted: G        W         5.12.0-rc2+ #296
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  RIP: 0010:btrfs_device_init_dev_stats+0x1d/0x200
  RSP: 0018:ffffafaec1483bb8 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff9a5715bcb298 RCX: 0000000000000070
  RDX: ffff9a5703248000 RSI: ffff9a57052ea150 RDI: ffff9a5715bca400
  RBP: ffff9a57052ea150 R08: 0000000000000070 R09: ffff9a57052ea150
  R10: 000130faf0741c10 R11: 0000000000000000 R12: ffff9a5703700000
  R13: 0000000000000000 R14: ffff9a5715bcb278 R15: ffff9a57052ea150
  FS:  00007f600d122c40(0000) GS:ffff9a577bc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000030 CR3: 0000000112a46005 CR4: 0000000000370ef0
  Call Trace:
   ? btrfs_init_dev_stats+0x1f/0xf0
   ? kmem_cache_alloc+0xef/0x1f0
   btrfs_init_dev_stats+0x5f/0xf0
   open_ctree+0x10cb/0x1720
   btrfs_mount_root.cold+0x12/0xea
   legacy_get_tree+0x27/0x40
   vfs_get_tree+0x25/0xb0
   vfs_kern_mount.part.0+0x71/0xb0
   btrfs_mount+0x10d/0x380
   legacy_get_tree+0x27/0x40
   vfs_get_tree+0x25/0xb0
   path_mount+0x433/0xa00
   __x64_sys_mount+0xe3/0x120
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This happens because when we call btrfs_init_dev_stats we do
device->fs_info->dev_root.  However device->fs_info isn't initialized
because we were only calling btrfs_init_devices_late() if we properly
read the device root.  However we don't actually need the device root to
init the devices, this function simply assigns the devices their
->fs_info pointer properly, so this needs to be done unconditionally
always so that we can properly dereference device->fs_info in rescue
cases.

Reported-by: Neal Gompa <ngompa13@gmail.com>
CC: stable@vger.kernel.org # 5.11+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2300,8 +2300,9 @@ static int btrfs_read_roots(struct btrfs
 	} else {
 		set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
 		fs_info->dev_root = root;
-		btrfs_init_devices_late(fs_info);
 	}
+	/* Initialize fs_info for all devices in any case */
+	btrfs_init_devices_late(fs_info);
 
 	/* If IGNOREDATACSUMS is set don't bother reading the csum root. */
 	if (!btrfs_test_opt(fs_info, IGNOREDATACSUMS)) {


