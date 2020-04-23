Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115FD1B699B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgDWXY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48208 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-0004a2-2v; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6g2-90; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Slaby" <jslaby@suse.com>,
        "Vegard Nossum" <vegard.nossum@oracle.com>,
        "David Sterba" <dsterba@suse.com>
Date:   Fri, 24 Apr 2020 00:04:11 +0100
Message-ID: <lsq.1587683028.534889821@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 024/245] btrfs: handle invalid num_stripes in sys_array
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

commit f5cdedd73fa71b74dcc42f2a11a5735d89ce7c4f upstream.

We can handle the special case of num_stripes == 0 directly inside
btrfs_read_sys_array. The BUG_ON in btrfs_chunk_item_size is there to
catch other unhandled cases where we fail to validate external data.

A crafted or corrupted image crashes at mount time:

BTRFS: device fsid 9006933e-2a9a-44f0-917f-514252aeec2c devid 1 transid 7 /dev/loop0
BTRFS info (device loop0): disk space caching is enabled
BUG: failure at fs/btrfs/ctree.h:337/btrfs_chunk_item_size()!
Kernel panic - not syncing: BUG!
CPU: 0 PID: 313 Comm: mount Not tainted 4.2.5-00657-ge047887-dirty #25
Stack:
 637af890 60062489 602aeb2e 604192ba
 60387961 00000011 637af8a0 6038a835
 637af9c0 6038776b 634ef32b 00000000
Call Trace:
 [<6001c86d>] show_stack+0xfe/0x15b
 [<6038a835>] dump_stack+0x2a/0x2c
 [<6038776b>] panic+0x13e/0x2b3
 [<6020f099>] btrfs_read_sys_array+0x25d/0x2ff
 [<601cfbbe>] open_ctree+0x192d/0x27af
 [<6019c2c1>] btrfs_mount+0x8f5/0xb9a
 [<600bc9a7>] mount_fs+0x11/0xf3
 [<600d5167>] vfs_kern_mount+0x75/0x11a
 [<6019bcb0>] btrfs_mount+0x2e4/0xb9a
 [<600bc9a7>] mount_fs+0x11/0xf3
 [<600d5167>] vfs_kern_mount+0x75/0x11a
 [<600d710b>] do_mount+0xa35/0xbc9
 [<600d7557>] SyS_mount+0x95/0xc8
 [<6001e884>] handle_syscall+0x6b/0x8e

Reported-by: Jiri Slaby <jslaby@suse.com>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6092,6 +6092,14 @@ int btrfs_read_sys_array(struct btrfs_ro
 				goto out_short_read;
 
 			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
+			if (!num_stripes) {
+				printk(KERN_ERR
+	    "BTRFS: invalid number of stripes %u in sys_array at offset %u\n",
+					num_stripes, cur_offset);
+				ret = -EIO;
+				break;
+			}
+
 			len = btrfs_chunk_item_size(num_stripes);
 			if (cur_offset + len > array_size)
 				goto out_short_read;

