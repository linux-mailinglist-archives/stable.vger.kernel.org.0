Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4010C412110
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356758AbhITSB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350067AbhITR5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:57:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F87663211;
        Mon, 20 Sep 2021 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158088;
        bh=4b+FEYBFsrp7C5AadIDF3q+aauus9Zm1j/Ui/Od/HZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mk2pIvDJ0nmvJHVjvYpY4JsThIv8WjNbXP/uJTt8hpaPJ6hb9m95HcLBgdP736y8t
         IrklA0Dellrn1xdvo/W7iZQqty6VUKPc2t7GNPBUiuVNnunMgZx3KvTzB+zLdJhacB
         ntYL5tJ4PCIEh39NjgTOkgFOTZ6Cmo8cqcH35Z2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 290/293] fq_codel: reject silly quantum parameters
Date:   Mon, 20 Sep 2021 18:44:12 +0200
Message-Id: <20210920163943.356543513@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 8975fd1a1421..24ce2aab8946 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -779,6 +779,8 @@ struct tc_codel_xstats {
 
 /* FQ_CODEL */
 
+#define FQ_CODEL_QUANTUM_MAX (1 << 20)
+
 enum {
 	TCA_FQ_CODEL_UNSPEC,
 	TCA_FQ_CODEL_TARGET,
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index a862d9990be7..e4f69c779b8c 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -382,6 +382,7 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct fq_codel_sched_data *q = qdisc_priv(sch);
 	struct nlattr *tb[TCA_FQ_CODEL_MAX + 1];
+	u32 quantum = 0;
 	int err;
 
 	if (!opt)
@@ -399,6 +400,13 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -425,8 +433,8 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
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



