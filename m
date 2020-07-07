Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F302B217173
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgGGPUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729482AbgGGPUK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:20:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D6E7206E2;
        Tue,  7 Jul 2020 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135209;
        bh=GmYfSTP7acaBCHe4qM+HpWSymQK0vAq5XMbScdx8dBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iARsScGuCYRpSNHJAhU+SSVQ3PF85UDqrdoziZL+AgfFjojJ5bJs2rePAPQOOMTZK
         TuK4v5DoTuIg+5QHFBOfu1feeQkTp17SkVM2kA6GVcIDfTrtSGa/osa1EvSKJwNjau
         ZfV23OSKInkBaDoq5U+5Rh6T64VxSiMwp9PxkHr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Eidelman <anton@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/65] nvme-multipath: fix bogus request queue reference put
Date:   Tue,  7 Jul 2020 17:16:56 +0200
Message-Id: <20200707145753.293645501@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit c31244669f57963b6ce133a5555b118fc50aec95 ]

The mpath disk node takes a reference on the request mpath
request queue when adding live path to the mpath gendisk.
However if we connected to an inaccessible path device_add_disk
is not called, so if we disconnect and remove the mpath gendisk
we endup putting an reference on the request queue that was
never taken [1].

Fix that to check if we ever added a live path (using
NVME_NS_HEAD_HAS_DISK flag) and if not, clear the disk->queue
reference.

[1]:
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 1372 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
CPU: 1 PID: 1372 Comm: nvme Tainted: G           O      5.7.0-rc2+ #3
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
RIP: 0010:refcount_warn_saturate+0xa6/0xf0
RSP: 0018:ffffb29e8053bdc0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8b7a2f4fc060 RCX: 0000000000000007
RDX: 0000000000000007 RSI: 0000000000000092 RDI: ffff8b7a3ec99980
RBP: ffff8b7a2f4fc000 R08: 00000000000002e1 R09: 0000000000000004
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: fffffffffffffff2 R14: ffffb29e8053bf08 R15: ffff8b7a320e2da0
FS:  00007f135d4ca800(0000) GS:ffff8b7a3ec80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005651178c0c30 CR3: 000000003b650005 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 disk_release+0xa2/0xc0
 device_release+0x28/0x80
 kobject_put+0xa5/0x1b0
 nvme_put_ns_head+0x26/0x70 [nvme_core]
 nvme_put_ns+0x30/0x60 [nvme_core]
 nvme_remove_namespaces+0x9b/0xe0 [nvme_core]
 nvme_do_delete_ctrl+0x43/0x5c [nvme_core]
 nvme_sysfs_delete.cold+0x8/0xd [nvme_core]
 kernfs_fop_write+0xc1/0x1a0
 vfs_write+0xb6/0x1a0
 ksys_write+0x5f/0xe0
 do_syscall_64+0x52/0x1a0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: Anton Eidelman <anton@lightbitslabs.com>
Tested-by: Anton Eidelman <anton@lightbitslabs.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 574b52e911f08..e1eeed5856570 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -691,6 +691,14 @@ void nvme_mpath_remove_disk(struct nvme_ns_head *head)
 	kblockd_schedule_work(&head->requeue_work);
 	flush_work(&head->requeue_work);
 	blk_cleanup_queue(head->disk->queue);
+	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
+		/*
+		 * if device_add_disk wasn't called, prevent
+		 * disk release to put a bogus reference on the
+		 * request queue
+		 */
+		head->disk->queue = NULL;
+	}
 	put_disk(head->disk);
 }
 
-- 
2.25.1



