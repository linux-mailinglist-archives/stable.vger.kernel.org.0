Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70113A9F4
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbfFIQ4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbfFIQ4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50B9420833;
        Sun,  9 Jun 2019 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099371;
        bh=dJykZiyvFj01bfmT18jlvsg3qLoUL056bRVKxZDhlDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3o7P35n0HgGiyIYSLnrRvhuIBkfo/0y2XzXF6wTssQ0PPFCk1zRLiSrZl30Bf5Lt
         fEUgfEME5lJKY+HXydolp1xWgpgWmyHqbO7WWLLWjL/tg3q/w5ckAnM0t7ixmGyDPb
         k1Yahzoc/PPk9hLq7T4nFSeUAqnpVQgf/zD8b3sM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang Chen <liangchen.linux@gmail.com>,
        Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.4 019/241] bcache: fix a race between cache register and cacheset unregister
Date:   Sun,  9 Jun 2019 18:39:21 +0200
Message-Id: <20190609164148.337811075@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1355,6 +1355,7 @@ static void cache_set_free(struct closur
 	bch_btree_cache_free(c);
 	bch_journal_free(c);
 
+	mutex_lock(&bch_register_lock);
 	for_each_cache(ca, c, i)
 		if (ca) {
 			ca->set = NULL;
@@ -1377,7 +1378,6 @@ static void cache_set_free(struct closur
 		mempool_destroy(c->search);
 	kfree(c->devices);
 
-	mutex_lock(&bch_register_lock);
 	list_del(&c->list);
 	mutex_unlock(&bch_register_lock);
 


