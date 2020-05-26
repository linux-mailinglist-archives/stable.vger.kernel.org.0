Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003E21DEABE
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgEVO4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 10:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730885AbgEVOvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 May 2020 10:51:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D5F6223E0;
        Fri, 22 May 2020 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159064;
        bh=pmeOm4DiY82BXXrfgxWB1khpemV4WYpFdghwFx6yf30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRIO20iZV5c2yaknyDg12kQQWH6PmxkZwD4hNus1phG6eBuBBDKZVEEQ9qC0vxpyy
         FCK4MTQJ2pet2YCnt/0QDLe0n8Pf+4QpcB38IZGbwtzkDwWxOd/WPygrNmdjzpi8Jv
         oJNZ5nmi4J0I7n7w1OLHvoiwDhe5pm5TYdZT7U6I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lei Xue <carmark.dlut@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-cachefs@redhat.com
Subject: [PATCH AUTOSEL 5.4 17/32] cachefiles: Fix race between read_waiter and read_copier involving op->to_do
Date:   Fri, 22 May 2020 10:50:29 -0400
Message-Id: <20200522145044.434677-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145044.434677-1-sashal@kernel.org>
References: <20200522145044.434677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lei Xue <carmark.dlut@gmail.com>

[ Upstream commit 7bb0c5338436dae953622470d52689265867f032 ]

There is a potential race in fscache operation enqueuing for reading and
copying multiple pages from cachefiles to netfs.  The problem can be seen
easily on a heavy loaded system (for example many processes reading files
continually on an NFS share covered by fscache triggered this problem within
a few minutes).

The race is due to cachefiles_read_waiter() adding the op to the monitor
to_do list and then then drop the object->work_lock spinlock before
completing fscache_enqueue_operation().  Once the lock is dropped,
cachefiles_read_copier() grabs the op, completes processing it, and
makes it through fscache_retrieval_complete() which sets the op->state to
the final state of FSCACHE_OP_ST_COMPLETE(4).  When cachefiles_read_waiter()
finally gets through the remainder of fscache_enqueue_operation()
it sees the invalid state, and hits the ASSERTCMP and the following
oops is seen:
[ 2259.612361] FS-Cache:
[ 2259.614785] FS-Cache: Assertion failed
[ 2259.618639] FS-Cache: 4 == 5 is false
[ 2259.622456] ------------[ cut here ]------------
[ 2259.627190] kernel BUG at fs/fscache/operation.c:70!
...
[ 2259.791675] RIP: 0010:[<ffffffffc061b4cf>]  [<ffffffffc061b4cf>] fscache_enqueue_operation+0xff/0x170 [fscache]
[ 2259.802059] RSP: 0000:ffffa0263d543be0  EFLAGS: 00010046
[ 2259.807521] RAX: 0000000000000019 RBX: ffffa01a4d390480 RCX: 0000000000000006
[ 2259.814847] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffa0263d553890
[ 2259.822176] RBP: ffffa0263d543be8 R08: 0000000000000000 R09: ffffa0263c2d8708
[ 2259.829502] R10: 0000000000001e7f R11: 0000000000000000 R12: ffffa01a4d390480
[ 2259.844483] R13: ffff9fa9546c5920 R14: ffffa0263d543c80 R15: ffffa0293ff9bf10
[ 2259.859554] FS:  00007f4b6efbd700(0000) GS:ffffa0263d540000(0000) knlGS:0000000000000000
[ 2259.875571] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2259.889117] CR2: 00007f49e1624ff0 CR3: 0000012b38b38000 CR4: 00000000007607e0
[ 2259.904015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2259.918764] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2259.933449] PKRU: 55555554
[ 2259.943654] Call Trace:
[ 2259.953592]  <IRQ>
[ 2259.955577]  [<ffffffffc03a7c12>] cachefiles_read_waiter+0x92/0xf0 [cachefiles]
[ 2259.978039]  [<ffffffffa34d3942>] __wake_up_common+0x82/0x120
[ 2259.991392]  [<ffffffffa34d3a63>] __wake_up_common_lock+0x83/0xc0
[ 2260.004930]  [<ffffffffa34d3510>] ? task_rq_unlock+0x20/0x20
[ 2260.017863]  [<ffffffffa34d3ab3>] __wake_up+0x13/0x20
[ 2260.030230]  [<ffffffffa34c72a0>] __wake_up_bit+0x50/0x70
[ 2260.042535]  [<ffffffffa35bdcdb>] unlock_page+0x2b/0x30
[ 2260.054495]  [<ffffffffa35bdd09>] page_endio+0x29/0x90
[ 2260.066184]  [<ffffffffa368fc81>] mpage_end_io+0x51/0x80

CPU1
cachefiles_read_waiter()
 20 static int cachefiles_read_waiter(wait_queue_entry_t *wait, unsigned mode,
 21                                   int sync, void *_key)
 22 {
...
 61         spin_lock(&object->work_lock);
 62         list_add_tail(&monitor->op_link, &op->to_do);
 63         spin_unlock(&object->work_lock);
<begin race window>
 64
 65         fscache_enqueue_retrieval(op);
182 static inline void fscache_enqueue_retrieval(struct fscache_retrieval *op)
183 {
184         fscache_enqueue_operation(&op->op);
185 }
 58 void fscache_enqueue_operation(struct fscache_operation *op)
 59 {
 60         struct fscache_cookie *cookie = op->object->cookie;
 61
 62         _enter("{OBJ%x OP%x,%u}",
 63                op->object->debug_id, op->debug_id, atomic_read(&op->usage));
 64
 65         ASSERT(list_empty(&op->pend_link));
 66         ASSERT(op->processor != NULL);
 67         ASSERT(fscache_object_is_available(op->object));
 68         ASSERTCMP(atomic_read(&op->usage), >, 0);
<end race window>

CPU2
cachefiles_read_copier()
168         while (!list_empty(&op->to_do)) {
...
202                 fscache_end_io(op, monitor->netfs_page, error);
203                 put_page(monitor->netfs_page);
204                 fscache_retrieval_complete(op, 1);

CPU1
 58 void fscache_enqueue_operation(struct fscache_operation *op)
 59 {
...
 69         ASSERTIFCMP(op->state != FSCACHE_OP_ST_IN_PROGRESS,
 70                     op->state, ==,  FSCACHE_OP_ST_CANCELLED);

Signed-off-by: Lei Xue <carmark.dlut@gmail.com>
Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/rdwr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 44a3ce1e4ce4..ad057ed2b30b 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -60,9 +60,9 @@ static int cachefiles_read_waiter(wait_queue_entry_t *wait, unsigned mode,
 	object = container_of(op->op.object, struct cachefiles_object, fscache);
 	spin_lock(&object->work_lock);
 	list_add_tail(&monitor->op_link, &op->to_do);
+	fscache_enqueue_retrieval(op);
 	spin_unlock(&object->work_lock);
 
-	fscache_enqueue_retrieval(op);
 	fscache_put_retrieval(op);
 	return 0;
 }
-- 
2.25.1

