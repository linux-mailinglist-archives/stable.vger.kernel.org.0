Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4979460FE90
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiJ0RGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiJ0RGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:06:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494A1198448
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE926B825F3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51311C433D6;
        Thu, 27 Oct 2022 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890377;
        bh=4pKsCfR+mH6d2/nMvwiiBSeAkUWetSjUx5fHeVs3Ark=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfJns9z+5+x/zHgMbFzzqr8R+NCJSJ2a890Q/u0O9mWNBjlduCqFb/vLYFDTwH2q3
         Uze0WaoBRbKxn8a4yTplgEiau/Tis0kuxDwE7zjavAVkzUj/WLUoIdAcglB4SshNFm
         yGKHovar0Egz7jYawuxAhdAdXe24gzOBlhmLk3fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/79] net: sched: delete duplicate cleanup of backlog and qlen
Date:   Thu, 27 Oct 2022 18:55:57 +0200
Message-Id: <20221027165055.949021859@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
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
index bed2387af456..e7e8c318925d 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1178,7 +1178,6 @@ static inline void __qdisc_reset_queue(struct qdisc_skb_head *qh)
 static inline void qdisc_reset_queue(struct Qdisc *sch)
 {
 	__qdisc_reset_queue(&sch->q);
-	sch->qstats.backlog = 0;
 }
 
 static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 1c281cc81f57..794c7377cd7e 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -575,7 +575,6 @@ static void atm_tc_reset(struct Qdisc *sch)
 	pr_debug("atm_tc_reset(sch %p,[qdisc %p])\n", sch, p);
 	list_for_each_entry(flow, &p->flows, list)
 		qdisc_reset(flow->q);
-	sch->q.qlen = 0;
 }
 
 static void atm_tc_destroy(struct Qdisc *sch)
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 4a78fcf5d4f9..9a3dff02b7a2 100644
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
index dde564670ad8..08424aac6da8 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -443,8 +443,6 @@ static void drr_reset_qdisc(struct Qdisc *sch)
 			qdisc_reset(cl->qdisc);
 		}
 	}
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void drr_destroy_qdisc(struct Qdisc *sch)
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index 76ed1a05ded2..a75bc7f80cd7 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -408,8 +408,6 @@ static void dsmark_reset(struct Qdisc *sch)
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
index 9c224872ef03..05817c55692f 100644
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
index 99e8db262198..01d6eea5b0ce 100644
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
index c70802785518..cf04f70e96bf 100644
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
index d1902fca9844..cdc43a06aa9b 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1484,8 +1484,6 @@ hfsc_reset_qdisc(struct Qdisc *sch)
 	}
 	q->eligible = RB_ROOT;
 	qdisc_watchdog_cancel(&q->watchdog);
-	sch->qstats.backlog = 0;
-	sch->q.qlen = 0;
 }
 
 static void
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index cd70dbcbd72f..c3ba018fd083 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -966,8 +966,6 @@ static void htb_reset(struct Qdisc *sch)
 	}
 	qdisc_watchdog_cancel(&q->watchdog);
 	__qdisc_reset_queue(&q->direct_queue);
-	sch->q.qlen = 0;
-	sch->qstats.backlog = 0;
 	memset(q->hlevel, 0, sizeof(q->hlevel));
 	memset(q->row_mask, 0, sizeof(q->row_mask));
 }
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 5c27b4270b90..1c6dbcfa89b8 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -152,7 +152,6 @@ multiq_reset(struct Qdisc *sch)
 
 	for (band = 0; band < q->bands; band++)
 		qdisc_reset(q->queues[band]);
-	sch->q.qlen = 0;
 	q->curband = 0;
 }
 
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 3eabb871a1d5..1c805fe05b82 100644
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
index af8c63a9ec18..1d1d81aeb389 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1458,8 +1458,6 @@ static void qfq_reset_qdisc(struct Qdisc *sch)
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
index b2724057629f..0e1cb517b0d9 100644
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
index ab8835a72cee..7f33b31c7b8b 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1626,8 +1626,6 @@ static void taprio_reset(struct Qdisc *sch)
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



