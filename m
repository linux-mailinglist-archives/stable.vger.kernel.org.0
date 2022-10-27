Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EDD60FE51
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiJ0REU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbiJ0RES (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:04:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5E8196EE9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56099B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD6EC433D7;
        Thu, 27 Oct 2022 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890254;
        bh=Fovyr9kqu/O6fxYnvqE2fWU6wQaMtMCoOSgaUdMRS7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1a3Y4PYkj9+rAegC2phhQErxvMa5umJMY7DIRnef3TSKWtBlHRnyyTUmH2oypYSkh
         Jdl1+vS3XjO+JcwILkkW+BoPJjHdEsmPK1oMn5ZJkNv1sCDedeZ+DD47fiigd6kiP/
         gkQke4wYc5d+4X+5lb+9Q34f9i5Qg9Ugr+HgkIqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 58/79] net: sched: delete duplicate cleanup of backlog and qlen
Date:   Thu, 27 Oct 2022 18:55:56 +0200
Message-Id: <20221027165056.846677339@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c19d893fbf3f2f8fa864ae39652c7fee939edde2 ]

qdisc_reset() is clearing qdisc->q.qlen and qdisc->qstats.backlog
_after_ calling qdisc->ops->reset. There is no need to clear them
again in the specific reset function.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20220824005231.345727-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 2a3fc78210b9 ("net: sched: sfb: fix null pointer access issue when sfb_init() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 -
 net/sched/sch_atm.c       | 1 -
 net/sched/sch_cbq.c       | 1 -
 net/sched/sch_choke.c     | 2 --
 net/sched/sch_drr.c       | 2 --
 net/sched/sch_dsmark.c    | 2 --
 net/sched/sch_etf.c       | 3 ---
 net/sched/sch_ets.c       | 2 --
 net/sched/sch_fq_codel.c  | 2 --
 net/sched/sch_fq_pie.c    | 3 ---
 net/sched/sch_hfsc.c      | 2 --
 net/sched/sch_htb.c       | 2 --
 net/sched/sch_multiq.c    | 1 -
 net/sched/sch_prio.c      | 2 --
 net/sched/sch_qfq.c       | 2 --
 net/sched/sch_red.c       | 2 --
 net/sched/sch_sfb.c       | 2 --
 net/sched/sch_skbprio.c   | 3 ---
 net/sched/sch_taprio.c    | 2 --
 net/sched/sch_tbf.c       | 2 --
 net/sched/sch_teql.c      | 1 -
 21 files changed, 40 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 1958d1260fe9..891b44d80c98 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1177,7 +1177,6 @@ static inline void __qdisc_reset_queue(struct qdisc_skb_head *qh)
 static inline void qdisc_reset_queue(struct Qdisc *sch)
 {
 	__qdisc_reset_queue(&sch->q);
-	sch->qstats.backlog = 0;
 }
 
 static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 7d8518176b45..70fe1c5e44ad 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -576,7 +576,6 @@ static void atm_tc_reset(struct Qdisc *sch)
 	pr_debug("atm_tc_reset(sch %p,[qdisc %p])\n", sch, p);
 	list_for_each_entry(flow, &p->flows, list)
 		qdisc_reset(flow->q);
-	sch->q.qlen = 0;
 }
 
 static void atm_tc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index e0da15530f0e..fd7e10567371 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -1053,7 +1053,6 @@ cbq_reset(struct Qdisc *sch)
 			cl->cpriority = cl->priority;
 		}
 	}
-	sch->q.qlen = 0;
 }
 
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 2adbd945bf15..25d2daaa8122 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -315,8 +315,6 @@ static void choke_reset(struct Qdisc *sch)
 		rtnl_qdisc_drop(skb, sch);
 	}
 
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	if (q->tab)
 		memset(q->tab, 0, (q->tab_mask + 1) * sizeof(struct sk_buff *));
 	q->head = q->tail = 0;
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 642cd179b7a7..80a88e208d2b 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -444,8 +444,6 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void drr_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 4c100d105269..7da6dc38a382 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -409,8 +409,6 @@ static void dsmark_reset(struct Qdisc *sch)
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
 	if (p->q)
 		qdisc_reset(p->q);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void dsmark_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c48f91075b5c..d96103b0e2bf 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -445,9 +445,6 @@ static void etf_reset(struct Qdisc *sch)
 	timesortedlist_clear(sch);
 	__qdisc_reset_queue(&sch->q);
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	q->last = 0;
 }
 
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index 44fa2532a87c..175e07b3d25c 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -722,8 +722,6 @@ static void ets_qdisc_reset(struct Qdisc *sch)
 	}
 	for (band = 0; band < q->nbands; band++)
 		qdisc_reset(q->classes[band].qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void ets_qdisc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index bb0cd6d3d2c2..efda894bbb78 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -347,8 +347,6 @@ static void fq_codel_reset(struct Qdisc *sch)
 		codel_vars_init(&flow->cvars);
 	}
 	memset(q->backlogs, 0, q->flows_cnt * sizeof(u32));
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	q->memory_usage = 0;
 }
 
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index d6aba6edd16e..35c35465226b 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -521,9 +521,6 @@ static void fq_pie_reset(struct Qdisc *sch)
 		INIT_LIST_HEAD(&flow->flowchain);
 		pie_vars_init(&flow->vars);
 	}
-
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 }
 
 static void fq_pie_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index b7ac30cca035..c802a027b4f3 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1485,8 +1485,6 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 	}
 	q->eligible = RB_ROOT;
 	qdisc_watchdog_cancel(&q->watchdog);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5cbc32fee867..caabdaa2f30f 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1008,8 +1008,6 @@ static void htb_reset(struct Qdisc *sch)
 	}
 	qdisc_watchdog_cancel(&q->watchdog);
 	__qdisc_reset_queue(&q->direct_queue);
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	memset(q->hlevel, 0, sizeof(q->hlevel));
 	memset(q->row_mask, 0, sizeof(q->row_mask));
 }
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index e282e7382117..8b99f07aa3a7 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -152,7 +152,6 @@ multiq_reset(struct Qdisc *sch)
 
 	for (band = 0; band < q->bands; band++)
 		qdisc_reset(q->queues[band]);
-	sch->q.qlen = 0;
 	q->curband = 0;
 }
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 03fdf31ccb6a..2e0b1e7f5466 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -135,8 +135,6 @@ prio_reset(struct Qdisc *sch)
 
 	for (prio = 0; prio < q->bands; prio++)
 		qdisc_reset(q->queues[prio]);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static int prio_offload(struct Qdisc *sch, struct tc_prio_qopt *qopt)
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index aea435b0aeb3..50e51c1322fc 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1459,8 +1459,6 @@ static void qfq_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void qfq_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 40adf1f07a82..f1e013e3f04a 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -176,8 +176,6 @@ static void red_reset(struct Qdisc *sch)
 	struct red_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	red_restart(&q->vars);
 }
 
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 2829455211f8..1be8d04d69dc 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -456,8 +456,6 @@ static void sfb_reset(struct Qdisc *sch)
 	struct sfb_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	q->slot = 0;
 	q->double_buffering = false;
 	sfb_zero_all_buckets(q);
diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 7a5e4c454715..df72fb83d9c7 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -213,9 +213,6 @@ static void skbprio_reset(struct Qdisc *sch)
 	struct skbprio_sched_data *q = qdisc_priv(sch);
 	int prio;
 
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
-
 	for (prio = 0; prio < SKBPRIO_MAX_PRIORITY; prio++)
 		__skb_queue_purge(&q->qdiscs[prio]);
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ae7ca68f2cf9..bd10a8eeb82d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1637,8 +1637,6 @@ static void taprio_reset(struct Qdisc *sch)
 			if (q->qdiscs[i])
 				qdisc_reset(q->qdiscs[i]);
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void taprio_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 6eb17004a9e4..7461e5c67d50 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -316,8 +316,6 @@ static void tbf_reset(struct Qdisc *sch)
 	struct tbf_sched_data *q = qdisc_priv(sch);
 
 	qdisc_reset(q->qdisc);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 	q->t_c = ktime_get_ns();
 	q->tokens = q->buffer;
 	q->ptokens = q->mtu;
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 6af6b95bdb67..79aaab51cbf5 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -124,7 +124,6 @@ teql_reset(struct Qdisc *sch)
 	struct teql_sched_data *dat = qdisc_priv(sch);
 
 	skb_queue_purge(&dat->q);
-	sch->q.qlen = 0;
 }
 
 static void
-- 
2.35.1



