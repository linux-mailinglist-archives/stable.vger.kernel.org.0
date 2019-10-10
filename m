Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952AAD23D8
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388674AbfJJIqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389330AbfJJIqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BE92064A;
        Thu, 10 Oct 2019 08:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697190;
        bh=GpHbb/LaO6aeMHRI2StGRXtT6KWoyzfJ8Y94lMYThn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgjtIhI35K3Gq0J9BmaGrgP2MT8c/eYCnDkUVJVoxJupfe+IG3EJmHqVuXGUvqegP
         a60/T5l+tYdXpy6yHQcqKW2IOEKZgyRY85uGch6JAG1s05Qm9hqbWmMPcj3Ncau7Wl
         rPZv6th81KXYdcretS17DFxpmzZoGIK1nSi0hEX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Shuaibing <shuaibinglu@126.com>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/114] 9p: Transport error uninitialized
Date:   Thu, 10 Oct 2019 10:35:59 +0200
Message-Id: <20191010083608.279505974@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Shuaibing <shuaibinglu@126.com>

[ Upstream commit 0ce772fe79b68f83df40f07f28207b292785c677 ]

The p9_tag_alloc() does not initialize the transport error t_err field.
The struct p9_req_t *req is allocated and stored in a struct p9_client
variable. The field t_err is never initialized before p9_conn_cancel()
checks its value.

KUMSAN(KernelUninitializedMemorySantizer, a new error detection tool)
reports this bug.

==================================================================
BUG: KUMSAN: use of uninitialized memory in p9_conn_cancel+0x2d9/0x3b0
Read of size 4 at addr ffff88805f9b600c by task kworker/1:2/1216

CPU: 1 PID: 1216 Comm: kworker/1:2 Not tainted 5.2.0-rc4+ #28
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: events p9_write_work
Call Trace:
 dump_stack+0x75/0xae
 __kumsan_report+0x17c/0x3e6
 kumsan_report+0xe/0x20
 p9_conn_cancel+0x2d9/0x3b0
 p9_write_work+0x183/0x4a0
 process_one_work+0x4d1/0x8c0
 worker_thread+0x6e/0x780
 kthread+0x1ca/0x1f0
 ret_from_fork+0x35/0x40

Allocated by task 1979:
 save_stack+0x19/0x80
 __kumsan_kmalloc.constprop.3+0xbc/0x120
 kmem_cache_alloc+0xa7/0x170
 p9_client_prepare_req.part.9+0x3b/0x380
 p9_client_rpc+0x15e/0x880
 p9_client_create+0x3d0/0xac0
 v9fs_session_init+0x192/0xc80
 v9fs_mount+0x67/0x470
 legacy_get_tree+0x70/0xd0
 vfs_get_tree+0x4a/0x1c0
 do_mount+0xba9/0xf90
 ksys_mount+0xa8/0x120
 __x64_sys_mount+0x62/0x70
 do_syscall_64+0x6d/0x1e0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88805f9b6008
 which belongs to the cache p9_req_t of size 144
The buggy address is located 4 bytes inside of
 144-byte region [ffff88805f9b6008, ffff88805f9b6098)
The buggy address belongs to the page:
page:ffffea00017e6d80 refcount:1 mapcount:0 mapping:ffff888068b63740 index:0xffff88805f9b7d90 compound_mapcount: 0
flags: 0x100000000010200(slab|head)
raw: 0100000000010200 ffff888068b66450 ffff888068b66450 ffff888068b63740
raw: ffff88805f9b7d90 0000000000100001 00000001ffffffff 0000000000000000
page dumped because: kumsan: bad access detected
==================================================================

Link: http://lkml.kernel.org/r/20190613070854.10434-1-shuaibinglu@126.com
Signed-off-by: Lu Shuaibing <shuaibinglu@126.com>
[dominique.martinet@cea.fr: grouped the added init with the others]
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index b615aae5a0f81..d62f83f93d7bb 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -296,6 +296,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 
 	p9pdu_reset(&req->tc);
 	p9pdu_reset(&req->rc);
+	req->t_err = 0;
 	req->status = REQ_STATUS_ALLOC;
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
-- 
2.20.1



