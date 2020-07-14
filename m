Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F422E21FAF8
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgGNS5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:57:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbgGNS5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E4A229CA;
        Tue, 14 Jul 2020 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753036;
        bh=ioGsaZgtYAtW88xHC/INvbWzaI67ca82sbbMgFtSmXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oswyk+46OQQtKzpq0K0QXqjzcyrSqjDYs+n3l0EOUYn/np8sVBKdPN4jKdpYJ4lHZ
         nk7HYplY7DID7RokvX6PaUwa61rWLSkab26zhI1rjag/KbNRS0IYgkqfjDraAo+XzD
         j2APjLkLuD8cztTlnMO3jTa6hGry3TDbsvNgWQEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 065/166] btrfs: fix reclaim_size counter leak after stealing from global reserve
Date:   Tue, 14 Jul 2020 20:43:50 +0200
Message-Id: <20200714184118.978112042@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6d548b9e5d56067cff17ff77585167cd65375e4b ]

Commit 7f9fe614407692 ("btrfs: improve global reserve stealing logic"),
added in the 5.8 merge window, introduced another leak for the space_info's
reclaim_size counter. This is very often triggered by the test cases
generic/269 and generic/416 from fstests, producing a stack trace like the
following during unmount:

[37079.155499] ------------[ cut here ]------------
[37079.156844] WARNING: CPU: 2 PID: 2000423 at fs/btrfs/block-group.c:3422 btrfs_free_block_groups+0x2eb/0x300 [btrfs]
[37079.158090] Modules linked in: dm_snapshot btrfs dm_thin_pool (...)
[37079.164440] CPU: 2 PID: 2000423 Comm: umount Tainted: G        W         5.7.0-rc7-btrfs-next-62 #1
[37079.165422] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), (...)
[37079.167384] RIP: 0010:btrfs_free_block_groups+0x2eb/0x300 [btrfs]
[37079.168375] Code: bd 58 ff ff ff 00 4c 8d (...)
[37079.170199] RSP: 0018:ffffaa53875c7de0 EFLAGS: 00010206
[37079.171120] RAX: ffff98099e701cf8 RBX: ffff98099e2d4000 RCX: 0000000000000000
[37079.172057] RDX: 0000000000000001 RSI: ffffffffc0acc5b1 RDI: 00000000ffffffff
[37079.173002] RBP: ffff98099e701cf8 R08: 0000000000000000 R09: 0000000000000000
[37079.173886] R10: 0000000000000000 R11: 0000000000000000 R12: ffff98099e701c00
[37079.174730] R13: ffff98099e2d5100 R14: dead000000000122 R15: dead000000000100
[37079.175578] FS:  00007f4d7d0a5840(0000) GS:ffff9809ec600000(0000) knlGS:0000000000000000
[37079.176434] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37079.177289] CR2: 0000559224dcc000 CR3: 000000012207a004 CR4: 00000000003606e0
[37079.178152] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37079.178935] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[37079.179675] Call Trace:
[37079.180419]  close_ctree+0x291/0x2d1 [btrfs]
[37079.181162]  generic_shutdown_super+0x6c/0x100
[37079.181898]  kill_anon_super+0x14/0x30
[37079.182641]  btrfs_kill_super+0x12/0x20 [btrfs]
[37079.183371]  deactivate_locked_super+0x31/0x70
[37079.184012]  cleanup_mnt+0x100/0x160
[37079.184650]  task_work_run+0x68/0xb0
[37079.185284]  exit_to_usermode_loop+0xf9/0x100
[37079.185920]  do_syscall_64+0x20d/0x260
[37079.186556]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
[37079.187197] RIP: 0033:0x7f4d7d2d9357
[37079.187836] Code: eb 0b 00 f7 d8 64 89 01 48 (...)
[37079.189180] RSP: 002b:00007ffee4e0d368 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[37079.189845] RAX: 0000000000000000 RBX: 00007f4d7d3fb224 RCX: 00007f4d7d2d9357
[37079.190515] RDX: ffffffffffffff78 RSI: 0000000000000000 RDI: 0000559224dc5c90
[37079.191173] RBP: 0000559224dc1970 R08: 0000000000000000 R09: 00007ffee4e0c0e0
[37079.191815] R10: 0000559224dc7b00 R11: 0000000000000246 R12: 0000000000000000
[37079.192451] R13: 0000559224dc5c90 R14: 0000559224dc1a80 R15: 0000559224dc1ba0
[37079.193096] irq event stamp: 0
[37079.193729] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[37079.194379] hardirqs last disabled at (0): [<ffffffff97ab8935>] copy_process+0x755/0x1ea0
[37079.195033] softirqs last  enabled at (0): [<ffffffff97ab8935>] copy_process+0x755/0x1ea0
[37079.195700] softirqs last disabled at (0): [<0000000000000000>] 0x0
[37079.196318] ---[ end trace b32710d864dea887 ]---

In the past commit d611add48b717a ("btrfs: fix reclaim counter leak of
space_info objects") fixed similar cases. That commit however has a date
more recent (April 7 2020) then the commit mentioned before (March 13
2020), however it was merged in kernel 5.7 while the older commit, which
introduces a new leak, was merged only in the 5.8 merge window. So the
leak sneaked in unnoticed.

Fix this by making steal_from_global_rsv() remove the ticket using the
helper remove_ticket(), which decrements the reclaim_size counter of the
space_info object.

Fixes: 7f9fe614407692 ("btrfs: improve global reserve stealing logic")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index eee6748c49e4e..756950aba1a66 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -879,8 +879,8 @@ static bool steal_from_global_rsv(struct btrfs_fs_info *fs_info,
 		return false;
 	}
 	global_rsv->reserved -= ticket->bytes;
+	remove_ticket(space_info, ticket);
 	ticket->bytes = 0;
-	list_del_init(&ticket->list);
 	wake_up(&ticket->wait);
 	space_info->tickets_id++;
 	if (global_rsv->reserved < global_rsv->size)
-- 
2.25.1



