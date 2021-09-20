Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640F941237F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352478AbhITSZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378127AbhITSW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A018632C3;
        Mon, 20 Sep 2021 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158673;
        bh=SV9zXCgKsv+iv5dFw8krsfs3XKhw9f1DukgRVWuG7Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPZU1j/uNToFNyp4ojf8ts59+h3xdjTcmd+zG4IBbToAe36Zq41lcqMiyn5V38Txs
         rT4xGi/Yf93daQjlRXU9R32t1hBb+hiNgdgP76UerbH/53/LAhKvay6gV9z2DuaQUL
         NSaDJONhm13WU2VRvEQUCw9FfV2EL3TBjbxKJwSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 257/260] fq_codel: reject silly quantum parameters
Date:   Mon, 20 Sep 2021 18:44:35 +0200
Message-Id: <20210920163939.844396388@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c7c5e6ff533fe1f9afef7d2fa46678987a1335a7 ]

syzbot found that forcing a big quantum attribute would crash hosts fast,
essentially using this:

tc qd replace dev eth0 root fq_codel quantum 4294967295

This is because fq_codel_dequeue() would have to loop
~2^31 times in :

	if (flow->deficit <= 0) {
		flow->deficit += q->quantum;
		list_move_tail(&flow->flowchain, &q->old_flows);
		goto begin;
	}

SFQ max quantum is 2^19 (half a megabyte)
Lets adopt a max quantum of one megabyte for FQ_CODEL.

Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/pkt_sched.h |  2 ++
 net/sched/sch_fq_codel.c       | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index edbbf4bfdd9e..4a245d7a5c8d 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -807,6 +807,8 @@ struct tc_codel_xstats {
 
 /* FQ_CODEL */
 
+#define FQ_CODEL_QUANTUM_MAX (1 << 20)
+
 enum {
 	TCA_FQ_CODEL_UNSPEC,
 	TCA_FQ_CODEL_TARGET,
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 76d72c3f52ed..86fb2f953bd5 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -370,6 +370,7 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_FQ_CODEL_MAX + 1];
+	u32 quantum = 0;
 	int err;
 
 	if (!opt)
@@ -387,6 +388,13 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 		    q->flows_cnt > 65536)
 			return -EINVAL;
 	}
+	if (tb[TCA_FQ_CODEL_QUANTUM]) {
+		quantum = max(256U, nla_get_u32(tb[TCA_FQ_CODEL_QUANTUM]));
+		if (quantum > FQ_CODEL_QUANTUM_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid quantum");
+			return -EINVAL;
+		}
+	}
 	sch_tree_lock(sch);
 
 	if (tb[TCA_FQ_CODEL_TARGET]) {
@@ -413,8 +421,8 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_FQ_CODEL_ECN])
 		q->cparams.ecn = !!nla_get_u32(tb[TCA_FQ_CODEL_ECN]);
 
-	if (tb[TCA_FQ_CODEL_QUANTUM])
-		q->quantum = max(256U, nla_get_u32(tb[TCA_FQ_CODEL_QUANTUM]));
+	if (quantum)
+		q->quantum = quantum;
 
 	if (tb[TCA_FQ_CODEL_DROP_BATCH_SIZE])
 		q->drop_batch_size = max(1U, nla_get_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]));
-- 
2.30.2



