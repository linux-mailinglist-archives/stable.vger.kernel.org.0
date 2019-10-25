Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E031E5392
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbfJYSGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46828 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731459AbfJYSFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OE-KJ; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xu-0001hi-Ry; Fri, 25 Oct 2019 19:05:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hulk Robot" <hulkci@huawei.com>,
        "YueHaibing" <yuehaibing@huawei.com>,
        "Dominique Martinet" <dominique.martinet@cea.fr>
Date:   Fri, 25 Oct 2019 19:03:04 +0100
Message-ID: <lsq.1572026582.970851512@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 03/47] 9p/virtio: Add cleanup path in p9_virtio_init
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit d4548543fc4ece56c6f04b8586f435fb4fd84c20 upstream.

KASAN report this:

BUG: unable to handle kernel paging request at ffffffffa0097000
PGD 3870067 P4D 3870067 PUD 3871063 PMD 2326e2067 PTE 0
Oops: 0000 [#1
CPU: 0 PID: 5340 Comm: modprobe Not tainted 5.1.0-rc7+ #25
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:__list_add_valid+0x10/0x70
Code: c3 48 8b 06 55 48 89 e5 5d 48 39 07 0f 94 c0 0f b6 c0 c3 90 90 90 90 90 90 90 55 48 89 d0 48 8b 52 08 48 89 e5 48 39 f2 75 19 <48> 8b 32 48 39 f0 75 3a

RSP: 0018:ffffc90000e23c68 EFLAGS: 00010246
RAX: ffffffffa00ad000 RBX: ffffffffa009d000 RCX: 0000000000000000
RDX: ffffffffa0097000 RSI: ffffffffa0097000 RDI: ffffffffa009d000
RBP: ffffc90000e23c68 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffa0097000
R13: ffff888231797180 R14: 0000000000000000 R15: ffffc90000e23e78
FS:  00007fb215285540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa0097000 CR3: 000000022f144000 CR4: 00000000000006f0
Call Trace:
 v9fs_register_trans+0x2f/0x60 [9pnet
 ? 0xffffffffa0087000
 p9_virtio_init+0x25/0x1000 [9pnet_virtio
 do_one_initcall+0x6c/0x3cc
 ? kmem_cache_alloc_trace+0x248/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7fb214d8e839
Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01

RSP: 002b:00007ffc96554278 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000055e67eed2aa0 RCX: 00007fb214d8e839
RDX: 0000000000000000 RSI: 000055e67ce95c2e RDI: 0000000000000003
RBP: 000055e67ce95c2e R08: 0000000000000000 R09: 000055e67eed2aa0
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
R13: 000055e67eeda500 R14: 0000000000040000 R15: 000055e67eed2aa0
Modules linked in: 9pnet_virtio(+) 9pnet gre rfkill vmw_vsock_virtio_transport_common vsock [last unloaded: 9pnet_virtio
CR2: ffffffffa0097000
---[ end trace 4a52bb13ff07b761

If register_virtio_driver() fails in p9_virtio_init,
we should call v9fs_unregister_trans() to do cleanup.

Link: http://lkml.kernel.org/r/20190430115942.41840-1-yuehaibing@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: b530cc794024 ("9p: add virtio transport")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/9p/trans_virtio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -718,10 +718,16 @@ static struct p9_trans_module p9_virtio_
 /* The standard init function */
 static int __init p9_virtio_init(void)
 {
+	int rc;
+
 	INIT_LIST_HEAD(&virtio_chan_list);
 
 	v9fs_register_trans(&p9_virtio_trans);
-	return register_virtio_driver(&p9_virtio_drv);
+	rc = register_virtio_driver(&p9_virtio_drv);
+	if (rc)
+		v9fs_unregister_trans(&p9_virtio_trans);
+
+	return rc;
 }
 
 static void __exit p9_virtio_cleanup(void)

