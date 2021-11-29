Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE71E461EAD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379532AbhK2SjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:39:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41830 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379120AbhK2ShF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:37:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A47E8B815C5;
        Mon, 29 Nov 2021 18:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0BAC53FAD;
        Mon, 29 Nov 2021 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210824;
        bh=asWmCeTm60LutrkNwdgIOWu0JvKwE3I63L4JSzcbc08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oi59uAnDHM0/hdatLvIUGQyLGmxxI6HKWorOkIlsTELujoZ2xpt6/YXiKR45uUc7p
         tuGLdZoweEdLESfAbvNVvBZykUmJtGCA3ReipNOXciuACHwzCkLN/sm4/AjGI0UaLq
         INUEVv8lV3cju02Gh9KG4CPcXQjGAt4q7Hz8SVCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/121] net/sched: sch_ets: dont peek at classes beyond nbands
Date:   Mon, 29 Nov 2021 19:18:46 +0100
Message-Id: <20211129181714.870357239@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit de6d25924c2a8c2988c6a385990cafbe742061bf ]

when the number of DRR classes decreases, the round-robin active list can
contain elements that have already been freed in ets_qdisc_change(). As a
consequence, it's possible to see a NULL dereference crash, caused by the
attempt to call cl->qdisc->ops->peek(cl->qdisc) when cl->qdisc is NULL:

 BUG: kernel NULL pointer dereference, address: 0000000000000018
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 1 PID: 910 Comm: mausezahn Not tainted 5.16.0-rc1+ #475
 Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
 RIP: 0010:ets_qdisc_dequeue+0x129/0x2c0 [sch_ets]
 Code: c5 01 41 39 ad e4 02 00 00 0f 87 18 ff ff ff 49 8b 85 c0 02 00 00 49 39 c4 0f 84 ba 00 00 00 49 8b ad c0 02 00 00 48 8b 7d 10 <48> 8b 47 18 48 8b 40 38 0f ae e8 ff d0 48 89 c3 48 85 c0 0f 84 9d
 RSP: 0000:ffffbb36c0b5fdd8 EFLAGS: 00010287
 RAX: ffff956678efed30 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000002 RSI: ffffffff9b938dc9 RDI: 0000000000000000
 RBP: ffff956678efed30 R08: e2f3207fe360129c R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000001 R12: ffff956678efeac0
 R13: ffff956678efe800 R14: ffff956611545000 R15: ffff95667ac8f100
 FS:  00007f2aa9120740(0000) GS:ffff95667b800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000018 CR3: 000000011070c000 CR4: 0000000000350ee0
 Call Trace:
  <TASK>
  qdisc_peek_dequeued+0x29/0x70 [sch_ets]
  tbf_dequeue+0x22/0x260 [sch_tbf]
  __qdisc_run+0x7f/0x630
  net_tx_action+0x290/0x4c0
  __do_softirq+0xee/0x4f8
  irq_exit_rcu+0xf4/0x130
  sysvec_apic_timer_interrupt+0x52/0xc0
  asm_sysvec_apic_timer_interrupt+0x12/0x20
 RIP: 0033:0x7f2aa7fc9ad4
 Code: b9 ff ff 48 8b 54 24 18 48 83 c4 08 48 89 ee 48 89 df 5b 5d e9 ed fc ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa <53> 48 83 ec 10 48 8b 05 10 64 33 00 48 8b 00 48 85 c0 0f 85 84 00
 RSP: 002b:00007ffe5d33fab8 EFLAGS: 00000202
 RAX: 0000000000000002 RBX: 0000561f72c31460 RCX: 0000561f72c31720
 RDX: 0000000000000002 RSI: 0000561f72c31722 RDI: 0000561f72c31720
 RBP: 000000000000002a R08: 00007ffe5d33fa40 R09: 0000000000000014
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000561f7187e380
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000561f72c31460
  </TASK>
 Modules linked in: sch_ets sch_tbf dummy rfkill iTCO_wdt intel_rapl_msr iTCO_vendor_support intel_rapl_common joydev virtio_balloon lpc_ich i2c_i801 i2c_smbus pcspkr ip_tables xfs libcrc32c crct10dif_pclmul crc32_pclmul crc32c_intel ahci libahci ghash_clmulni_intel serio_raw libata virtio_blk virtio_console virtio_net net_failover failover sunrpc dm_mirror dm_region_hash dm_log dm_mod
 CR2: 0000000000000018

Ensuring that 'alist' was never zeroed [1] was not sufficient, we need to
remove from the active list those elements that are no more SP nor DRR.

[1] https://lore.kernel.org/netdev/60d274838bf09777f0371253416e8af71360bc08.1633609148.git.dcaratti@redhat.com/

v3: fix race between ets_qdisc_change() and ets_qdisc_dequeue() delisting
    DRR classes beyond 'nbands' in ets_qdisc_change() with the qdisc lock
    acquired, thanks to Cong Wang.

v2: when a NULL qdisc is found in the DRR active list, try to dequeue skb
    from the next list item.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: dcc68b4d8084 ("net: sch_ets: Add a new Qdisc")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/7a5c496eed2d62241620bdbb83eb03fb9d571c99.1637762721.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_ets.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index c76701ac35abf..c34cb6e81d855 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -667,12 +667,14 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 			q->classes[i].deficit = quanta[i];
 		}
 	}
+	for (i = q->nbands; i < oldbands; i++) {
+		qdisc_tree_flush_backlog(q->classes[i].qdisc);
+		if (i >= q->nstrict)
+			list_del(&q->classes[i].alist);
+	}
 	q->nstrict = nstrict;
 	memcpy(q->prio2band, priomap, sizeof(priomap));
 
-	for (i = q->nbands; i < oldbands; i++)
-		qdisc_tree_flush_backlog(q->classes[i].qdisc);
-
 	for (i = 0; i < q->nbands; i++)
 		q->classes[i].quantum = quanta[i];
 
-- 
2.33.0



