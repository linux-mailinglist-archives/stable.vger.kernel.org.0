Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DC2431EC3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhJROFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234979AbhJRODl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54305613A7;
        Mon, 18 Oct 2021 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564624;
        bh=vgO7421nswS0O3mEoLkmcesOBtxJ6kzPILryIbihVac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzGnUQBjJtC2ByhZdhzGDaaZvaGAsMT76g6jyQ2SmsPDqxX/U17fZcmR2raUz2DK2
         2Y6txMZ52/Z104s/Ek3zxDkYasJgxLQZGEI2pqytTbfZrxbP86lMyK7IudF/UIfGS2
         EuN3kuzY21QPcSHRErxVUNxtFAA0Jw943sv/yHPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 138/151] mqprio: Correct stats in mqprio_dump_class_stats().
Date:   Mon, 18 Oct 2021 15:25:17 +0200
Message-Id: <20211018132345.150770812@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 14132690860e4d06aa3e1c4d7d8e9866ba7756dd upstream.

Introduction of lockless subqueues broke the class statistics.
Before the change stats were accumulated in `bstats' and `qstats'
on the stack which was then copied to struct gnet_dump.

After the change the `bstats' and `qstats' are initialized to 0
and never updated, yet still fed to gnet_dump. The code updates
the global qdisc->cpu_bstats and qdisc->cpu_qstats instead,
clobbering them. Most likely a copy-paste error from the code in
mqprio_dump().

__gnet_stats_copy_basic() and __gnet_stats_copy_queue() accumulate
the values for per-CPU case but for global stats they overwrite
the value, so only stats from the last loop iteration / tc end up
in sch->[bq]stats.

Use the on-stack [bq]stats variables again and add the stats manually
in the global case.

Fixes: ce679e8df7ed2 ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
https://lore.kernel.org/all/20211007175000.2334713-2-bigeasy@linutronix.de/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_mqprio.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -529,22 +529,28 @@ static int mqprio_dump_class_stats(struc
 		for (i = tc.offset; i < tc.offset + tc.count; i++) {
 			struct netdev_queue *q = netdev_get_tx_queue(dev, i);
 			struct Qdisc *qdisc = rtnl_dereference(q->qdisc);
-			struct gnet_stats_basic_cpu __percpu *cpu_bstats = NULL;
-			struct gnet_stats_queue __percpu *cpu_qstats = NULL;
 
 			spin_lock_bh(qdisc_lock(qdisc));
+
 			if (qdisc_is_percpu_stats(qdisc)) {
-				cpu_bstats = qdisc->cpu_bstats;
-				cpu_qstats = qdisc->cpu_qstats;
-			}
+				qlen = qdisc_qlen_sum(qdisc);
 
-			qlen = qdisc_qlen_sum(qdisc);
-			__gnet_stats_copy_basic(NULL, &sch->bstats,
-						cpu_bstats, &qdisc->bstats);
-			__gnet_stats_copy_queue(&sch->qstats,
-						cpu_qstats,
-						&qdisc->qstats,
-						qlen);
+				__gnet_stats_copy_basic(NULL, &bstats,
+							qdisc->cpu_bstats,
+							&qdisc->bstats);
+				__gnet_stats_copy_queue(&qstats,
+							qdisc->cpu_qstats,
+							&qdisc->qstats,
+							qlen);
+			} else {
+				qlen		+= qdisc->q.qlen;
+				bstats.bytes	+= qdisc->bstats.bytes;
+				bstats.packets	+= qdisc->bstats.packets;
+				qstats.backlog	+= qdisc->qstats.backlog;
+				qstats.drops	+= qdisc->qstats.drops;
+				qstats.requeues	+= qdisc->qstats.requeues;
+				qstats.overlimits += qdisc->qstats.overlimits;
+			}
 			spin_unlock_bh(qdisc_lock(qdisc));
 		}
 


