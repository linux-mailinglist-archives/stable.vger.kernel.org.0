Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CD4469CA0
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358963AbhLFPYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:24:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38922 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356436AbhLFPWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC28A612D3;
        Mon,  6 Dec 2021 15:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CA9C341C5;
        Mon,  6 Dec 2021 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803914;
        bh=dt9SeqqfwDHVE9j0I9wLqY3L+NJYVyCjo4mdQQgk5WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvDiQNvRnCSUlI65jbqiBmHgUhqyJy6Q3KVz5iM+p8FqQuWg5Xvijt9KKH/QCfpWx
         hR6w8e27YdjN4iBSgAZDvwyD3WUyePvly5i22Aca2WlOWGxYw94NYf4cOhRQpUfOYZ
         U/t/bE41zNq0C+HKl6DxVnrAS4/J3n26i+7KTHlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 091/130] net/smc: fix wrong list_del in smc_lgr_cleanup_early
Date:   Mon,  6 Dec 2021 15:56:48 +0100
Message-Id: <20211206145602.795671791@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>

commit 789b6cc2a5f9123b9c549b886fdc47c865cfe0ba upstream.

smc_lgr_cleanup_early() meant to delete the link
group from the link group list, but it deleted
the list head by mistake.

This may cause memory corruption since we didn't
remove the real link group from the list and later
memseted the link group structure.
We got a list corruption panic when testing:

[  231.277259] list_del corruption. prev->next should be ffff8881398a8000, but was 0000000000000000
[  231.278222] ------------[ cut here ]------------
[  231.278726] kernel BUG at lib/list_debug.c:53!
[  231.279326] invalid opcode: 0000 [#1] SMP NOPTI
[  231.279803] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.46+ #435
[  231.280466] Hardware name: Alibaba Cloud ECS, BIOS 8c24b4c 04/01/2014
[  231.281248] Workqueue: events smc_link_down_work
[  231.281732] RIP: 0010:__list_del_entry_valid+0x70/0x90
[  231.282258] Code: 4c 60 82 e8 7d cc 6a 00 0f 0b 48 89 fe 48 c7 c7 88 4c
60 82 e8 6c cc 6a 00 0f 0b 48 89 fe 48 c7 c7 c0 4c 60 82 e8 5b cc 6a 00 <0f>
0b 48 89 fe 48 c7 c7 00 4d 60 82 e8 4a cc 6a 00 0f 0b cc cc cc
[  231.284146] RSP: 0018:ffffc90000033d58 EFLAGS: 00010292
[  231.284685] RAX: 0000000000000054 RBX: ffff8881398a8000 RCX: 0000000000000000
[  231.285415] RDX: 0000000000000001 RSI: ffff88813bc18040 RDI: ffff88813bc18040
[  231.286141] RBP: ffffffff8305ad40 R08: 0000000000000003 R09: 0000000000000001
[  231.286873] R10: ffffffff82803da0 R11: ffffc90000033b90 R12: 0000000000000001
[  231.287606] R13: 0000000000000000 R14: ffff8881398a8000 R15: 0000000000000003
[  231.288337] FS:  0000000000000000(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[  231.289160] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  231.289754] CR2: 0000000000e72058 CR3: 000000010fa96006 CR4: 00000000003706f0
[  231.290485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  231.291211] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  231.291940] Call Trace:
[  231.292211]  smc_lgr_terminate_sched+0x53/0xa0
[  231.292677]  smc_switch_conns+0x75/0x6b0
[  231.293085]  ? update_load_avg+0x1a6/0x590
[  231.293517]  ? ttwu_do_wakeup+0x17/0x150
[  231.293907]  ? update_load_avg+0x1a6/0x590
[  231.294317]  ? newidle_balance+0xca/0x3d0
[  231.294716]  smcr_link_down+0x50/0x1a0
[  231.295090]  ? __wake_up_common_lock+0x77/0x90
[  231.295534]  smc_link_down_work+0x46/0x60
[  231.295933]  process_one_work+0x18b/0x350

Fixes: a0a62ee15a829 ("net/smc: separate locks for SMCD and SMCR link group lists")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc_core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -204,18 +204,17 @@ static void smc_lgr_unregister_conn(stru
 void smc_lgr_cleanup_early(struct smc_connection *conn)
 {
 	struct smc_link_group *lgr = conn->lgr;
-	struct list_head *lgr_list;
 	spinlock_t *lgr_lock;
 
 	if (!lgr)
 		return;
 
 	smc_conn_free(conn);
-	lgr_list = smc_lgr_list_head(lgr, &lgr_lock);
+	smc_lgr_list_head(lgr, &lgr_lock);
 	spin_lock_bh(lgr_lock);
 	/* do not use this link group for new connections */
-	if (!list_empty(lgr_list))
-		list_del_init(lgr_list);
+	if (!list_empty(&lgr->list))
+		list_del_init(&lgr->list);
 	spin_unlock_bh(lgr_lock);
 	__smc_lgr_terminate(lgr, true);
 }


