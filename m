Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DCA6254D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbfGHPP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730222AbfGHPPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3DCE21707;
        Mon,  8 Jul 2019 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598924;
        bh=JY3Ss7+9I/5YbzT4G4hscZjnHpJHZ06hnfh6paYK1CQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lm63dCa8YKRlPUt+3foF3T3Z9U7Pavnep1YCFY5c594OAg/F+iMB79drrCwDmKfAW
         ADduIU++Xf9Y2yQ3oyVDfaNGW8Bmvx9AIzRVdcgnuJrXcya8ORxitroDHx8t1WN5iS
         fAVtoMC4ihkCp3gKwhFJ/cILxl/WrNw5Cyg95oeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH 4.4 19/73] Btrfs: fix race between readahead and device replace/removal
Date:   Mon,  8 Jul 2019 17:12:29 +0200
Message-Id: <20190708150520.780124226@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ce7791ffee1e1ee9f97193b817c7dd1fa6746aad upstream.

The list of devices is protected by the device_list_mutex and the device
replace code, in its finishing phase correctly takes that mutex before
removing the source device from that list. However the readahead code was
iterating that list without acquiring the respective mutex leading to
crashes later on due to invalid memory accesses:

[125671.831036] general protection fault: 0000 [#1] PREEMPT SMP
[125671.832129] Modules linked in: btrfs dm_flakey dm_mod crc32c_generic xor raid6_pq acpi_cpufreq tpm_tis tpm ppdev evdev parport_pc psmouse sg parport
processor ser
[125671.834973] CPU: 10 PID: 19603 Comm: kworker/u32:19 Tainted: G        W       4.6.0-rc7-btrfs-next-29+ #1
[125671.834973] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS by qemu-project.org 04/01/2014
[125671.834973] Workqueue: btrfs-readahead btrfs_readahead_helper [btrfs]
[125671.834973] task: ffff8801ac520540 ti: ffff8801ac918000 task.ti: ffff8801ac918000
[125671.834973] RIP: 0010:[<ffffffff81270479>]  [<ffffffff81270479>] __radix_tree_lookup+0x6a/0x105
[125671.834973] RSP: 0018:ffff8801ac91bc28  EFLAGS: 00010206
[125671.834973] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6a RCX: 0000000000000000
[125671.834973] RDX: 0000000000000000 RSI: 00000000000c1bff RDI: ffff88002ebd62a8
[125671.834973] RBP: ffff8801ac91bc70 R08: 0000000000000001 R09: 0000000000000000
[125671.834973] R10: ffff8801ac91bc70 R11: 0000000000000000 R12: ffff88002ebd62a8
[125671.834973] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000c1bff
[125671.834973] FS:  0000000000000000(0000) GS:ffff88023fd40000(0000) knlGS:0000000000000000
[125671.834973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[125671.834973] CR2: 000000000073cae4 CR3: 00000000b7723000 CR4: 00000000000006e0
[125671.834973] Stack:
[125671.834973]  0000000000000000 ffff8801422d5600 ffff8802286bbc00 0000000000000000
[125671.834973]  0000000000000001 ffff8802286bbc00 00000000000c1bff 0000000000000000
[125671.834973]  ffff88002e639eb8 ffff8801ac91bc80 ffffffff81270541 ffff8801ac91bcb0
[125671.834973] Call Trace:
[125671.834973]  [<ffffffff81270541>] radix_tree_lookup+0xd/0xf
[125671.834973]  [<ffffffffa04ae6a6>] reada_peer_zones_set_lock+0x3e/0x60 [btrfs]
[125671.834973]  [<ffffffffa04ae8b9>] reada_pick_zone+0x29/0x103 [btrfs]
[125671.834973]  [<ffffffffa04af42f>] reada_start_machine_worker+0x129/0x2d3 [btrfs]
[125671.834973]  [<ffffffffa04880be>] btrfs_scrubparity_helper+0x185/0x3aa [btrfs]
[125671.834973]  [<ffffffffa0488341>] btrfs_readahead_helper+0xe/0x10 [btrfs]
[125671.834973]  [<ffffffff81069691>] process_one_work+0x271/0x4e9
[125671.834973]  [<ffffffff81069dda>] worker_thread+0x1eb/0x2c9
[125671.834973]  [<ffffffff81069bef>] ? rescuer_thread+0x2b3/0x2b3
[125671.834973]  [<ffffffff8106f403>] kthread+0xd4/0xdc
[125671.834973]  [<ffffffff8149e242>] ret_from_fork+0x22/0x40
[125671.834973]  [<ffffffff8106f32f>] ? kthread_stop+0x286/0x286

So fix this by taking the device_list_mutex in the readahead code. We
can't use here the lighter approach of using a rcu_read_lock() and
rcu_read_unlock() pair together with a list_for_each_entry_rcu() call
because we end up doing calls to sleeping functions (kzalloc()) in the
respective code path.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/reada.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -764,12 +764,14 @@ static void __reada_start_machine(struct
 
 	do {
 		enqueued = 0;
+		mutex_lock(&fs_devices->device_list_mutex);
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
 			if (atomic_read(&device->reada_in_flight) <
 			    MAX_IN_FLIGHT)
 				enqueued += reada_start_machine_dev(fs_info,
 								    device);
 		}
+		mutex_unlock(&fs_devices->device_list_mutex);
 		total += enqueued;
 	} while (enqueued && total < 10000);
 


