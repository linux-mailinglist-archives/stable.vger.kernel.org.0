Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62850B92B4
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbfITOZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:25:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36016 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388111AbfITOZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0004xX-NJ; Fri, 20 Sep 2019 15:25:00 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007sa-Ap; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Liang Chen" <liangchen.linux@gmail.com>,
        "Jens Axboe" <axboe@kernel.dk>, "Coly Li" <colyli@suse.de>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.722999903@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 050/132] bcache: fix a race between cache register
 and cacheset unregister
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Chen <liangchen.linux@gmail.com>

commit a4b732a248d12cbdb46999daf0bf288c011335eb upstream.

There is a race between cache device register and cache set unregister.
For an already registered cache device, register_bcache will call
bch_is_open to iterate through all cachesets and check every cache
there. The race occurs if cache_set_free executes at the same time and
clears the caches right before ca is dereferenced in bch_is_open_cache.
To close the race, let's make sure the clean up work is protected by
the bch_register_lock as well.

This issue can be reproduced as follows,
while true; do echo /dev/XXX> /sys/fs/bcache/register ; done&
while true; do echo 1> /sys/block/XXX/bcache/set/unregister ; done &

and results in the following oops,

[  +0.000053] BUG: unable to handle kernel NULL pointer dereference at 0000000000000998
[  +0.000457] #PF error: [normal kernel read fault]
[  +0.000464] PGD 800000003ca9d067 P4D 800000003ca9d067 PUD 3ca9c067 PMD 0
[  +0.000388] Oops: 0000 [#1] SMP PTI
[  +0.000269] CPU: 1 PID: 3266 Comm: bash Not tainted 5.0.0+ #6
[  +0.000346] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.fc28 04/01/2014
[  +0.000472] RIP: 0010:register_bcache+0x1829/0x1990 [bcache]
[  +0.000344] Code: b0 48 83 e8 50 48 81 fa e0 e1 10 c0 0f 84 a9 00 00 00 48 89 c6 48 89 ca 0f b7 ba 54 04 00 00 4c 8b 82 60 0c 00 00 85 ff 74 2f <49> 3b a8 98 09 00 00 74 4e 44 8d 47 ff 31 ff 49 c1 e0 03 eb 0d
[  +0.000839] RSP: 0018:ffff92ee804cbd88 EFLAGS: 00010202
[  +0.000328] RAX: ffffffffc010e190 RBX: ffff918b5c6b5000 RCX: ffff918b7d8e0000
[  +0.000399] RDX: ffff918b7d8e0000 RSI: ffffffffc010e190 RDI: 0000000000000001
[  +0.000398] RBP: ffff918b7d318340 R08: 0000000000000000 R09: ffffffffb9bd2d7a
[  +0.000385] R10: ffff918b7eb253c0 R11: ffffb95980f51200 R12: ffffffffc010e1a0
[  +0.000411] R13: fffffffffffffff2 R14: 000000000000000b R15: ffff918b7e232620
[  +0.000384] FS:  00007f955bec2740(0000) GS:ffff918b7eb00000(0000) knlGS:0000000000000000
[  +0.000420] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000801] CR2: 0000000000000998 CR3: 000000003cad6000 CR4: 00000000001406e0
[  +0.000837] Call Trace:
[  +0.000682]  ? _cond_resched+0x10/0x20
[  +0.000691]  ? __kmalloc+0x131/0x1b0
[  +0.000710]  kernfs_fop_write+0xfa/0x170
[  +0.000733]  __vfs_write+0x2e/0x190
[  +0.000688]  ? inode_security+0x10/0x30
[  +0.000698]  ? selinux_file_permission+0xd2/0x120
[  +0.000752]  ? security_file_permission+0x2b/0x100
[  +0.000753]  vfs_write+0xa8/0x1a0
[  +0.000676]  ksys_write+0x4d/0xb0
[  +0.000699]  do_syscall_64+0x3a/0xf0
[  +0.000692]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1364,6 +1364,7 @@ static void cache_set_free(struct closur
 	bch_btree_cache_free(c);
 	bch_journal_free(c);
 
+	mutex_lock(&bch_register_lock);
 	for_each_cache(ca, c, i)
 		if (ca) {
 			ca->set = NULL;
@@ -1386,7 +1387,6 @@ static void cache_set_free(struct closur
 		mempool_destroy(c->search);
 	kfree(c->devices);
 
-	mutex_lock(&bch_register_lock);
 	list_del(&c->list);
 	mutex_unlock(&bch_register_lock);
 

