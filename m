Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC081F0D5
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731750AbfEOLYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731488AbfEOLYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E15120862;
        Wed, 15 May 2019 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919441;
        bh=urVnFoCj9T1Nn55BZ2h7sx1pD3jhCm31Ghapvl4Row4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8lOvCPxlhRrlqMcfu2JyezVvst2uaJ6VwEibf/HqXrGVlj1CXGpyfS3P2O2j4K1o
         cuoTBCToX/Cpl/6D7Sc6vmAQ0FyXG1RYb0okk8eS8OZj95iRcjOe3Ef23KmliDG3s4
         cns1x3xKwS2ylZvh6ixyktvxDNp8jboMFJ31Is50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Semion Lisyansky <semionl@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 075/113] mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw ordered workqueue
Date:   Wed, 15 May 2019 12:56:06 +0200
Message-Id: <20190515090659.237017346@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4af0699782e2cc7d0d89db9eb6f8844dd3df82dc ]

The ordered workqueue is used to offload various objects such as routes
and neighbours in the order they are notified.

It should not be called as part of memory reclaim path, so remove the
WQ_MEM_RECLAIM flag. This can also result in a warning [1], if a worker
tries to flush a non-WQ_MEM_RECLAIM workqueue.

[1]
[97703.542861] workqueue: WQ_MEM_RECLAIM mlxsw_core_ordered:mlxsw_sp_router_fib6_event_work [mlxsw_spectrum] is flushing !WQ_MEM_RECLAIM events:rht_deferred_worker
[97703.542884] WARNING: CPU: 1 PID: 32492 at kernel/workqueue.c:2605 check_flush_dependency+0xb5/0x130
...
[97703.542988] Hardware name: Mellanox Technologies Ltd. MSN3700C/VMOD0008, BIOS 5.11 10/10/2018
[97703.543049] Workqueue: mlxsw_core_ordered mlxsw_sp_router_fib6_event_work [mlxsw_spectrum]
[97703.543061] RIP: 0010:check_flush_dependency+0xb5/0x130
...
[97703.543071] RSP: 0018:ffffb3f08137bc00 EFLAGS: 00010086
[97703.543076] RAX: 0000000000000000 RBX: ffff96e07740ae00 RCX: 0000000000000000
[97703.543080] RDX: 0000000000000094 RSI: ffffffff82dc1934 RDI: 0000000000000046
[97703.543084] RBP: ffffb3f08137bc20 R08: ffffffff82dc18a0 R09: 00000000000225c0
[97703.543087] R10: 0000000000000000 R11: 0000000000007eec R12: ffffffff816e4ee0
[97703.543091] R13: ffff96e06f6a5c00 R14: ffff96e077ba7700 R15: ffffffff812ab0c0
[97703.543097] FS: 0000000000000000(0000) GS:ffff96e077a80000(0000) knlGS:0000000000000000
[97703.543101] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[97703.543104] CR2: 00007f8cd135b280 CR3: 00000001e860e003 CR4: 00000000003606e0
[97703.543109] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[97703.543112] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[97703.543115] Call Trace:
[97703.543129] __flush_work+0xbd/0x1e0
[97703.543137] ? __cancel_work_timer+0x136/0x1b0
[97703.543145] ? pwq_dec_nr_in_flight+0x49/0xa0
[97703.543154] __cancel_work_timer+0x136/0x1b0
[97703.543175] ? mlxsw_reg_trans_bulk_wait+0x145/0x400 [mlxsw_core]
[97703.543184] cancel_work_sync+0x10/0x20
[97703.543191] rhashtable_free_and_destroy+0x23/0x140
[97703.543198] rhashtable_destroy+0xd/0x10
[97703.543254] mlxsw_sp_fib_destroy+0xb1/0xf0 [mlxsw_spectrum]
[97703.543310] mlxsw_sp_vr_put+0xa8/0xc0 [mlxsw_spectrum]
[97703.543364] mlxsw_sp_fib_node_put+0xbf/0x140 [mlxsw_spectrum]
[97703.543418] ? mlxsw_sp_fib6_entry_destroy+0xe8/0x110 [mlxsw_spectrum]
[97703.543475] mlxsw_sp_router_fib6_event_work+0x6cd/0x7f0 [mlxsw_spectrum]
[97703.543484] process_one_work+0x1fd/0x400
[97703.543493] worker_thread+0x34/0x410
[97703.543500] kthread+0x121/0x140
[97703.543507] ? process_one_work+0x400/0x400
[97703.543512] ? kthread_park+0x90/0x90
[97703.543523] ret_from_fork+0x35/0x40

Fixes: a3832b31898f ("mlxsw: core: Create an ordered workqueue for FIB offload")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Semion Lisyansky <semionl@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 426aea8ad72c4..7482db0767afb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1878,7 +1878,7 @@ static int __init mlxsw_core_module_init(void)
 	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, WQ_MEM_RECLAIM, 0);
 	if (!mlxsw_wq)
 		return -ENOMEM;
-	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", WQ_MEM_RECLAIM,
+	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", 0,
 					    mlxsw_core_driver_name);
 	if (!mlxsw_owq) {
 		err = -ENOMEM;
-- 
2.20.1



