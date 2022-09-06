Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B945AE9A2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiIFNc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbiIFNcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:32:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE6E760CE;
        Tue,  6 Sep 2022 06:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0A7DB818C4;
        Tue,  6 Sep 2022 13:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F85C433C1;
        Tue,  6 Sep 2022 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471136;
        bh=wqumMZXi1LsOqk20M9uLwZVwJ/RaUHqGDItllRlXl3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5kNkIk+8j29lQ6H5PmpnIkOBcVfSUg5X1Up1DrlUgm48Qs2uiya9ftsqs13zI/XG
         q8RXZQzbi6IEjNSMyjUezag4v5N9fq0biD0yz945QDcO3LRfwuw3uWMCRC9sqa6IOf
         0y2cAsgozTJQOkx+B9EhkrfYqtFUwk8MLhmls2Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/80] net: sched: tbf: dont call qdisc_put() while holding tree lock
Date:   Tue,  6 Sep 2022 15:30:10 +0200
Message-Id: <20220906132817.487086640@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit b05972f01e7d30419987a1f221b5593668fd6448 ]

The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
holding sch tree spinlock, which results sleeping-while-atomic BUG.

Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20220826013930.340121-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_tbf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 78e79029dc631..6eb17004a9e44 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -342,6 +342,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_TBF_MAX + 1];
 	struct tc_tbf_qopt *qopt;
 	struct Qdisc *child = NULL;
+	struct Qdisc *old = NULL;
 	struct psched_ratecfg rate;
 	struct psched_ratecfg peak;
 	u64 max_size;
@@ -433,7 +434,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_lock(sch);
 	if (child) {
 		qdisc_tree_flush_backlog(q->qdisc);
-		qdisc_put(q->qdisc);
+		old = q->qdisc;
 		q->qdisc = child;
 	}
 	q->limit = qopt->limit;
@@ -453,6 +454,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(&q->peak, &peak, sizeof(struct psched_ratecfg));
 
 	sch_tree_unlock(sch);
+	qdisc_put(old);
 	err = 0;
 
 	tbf_offload_change(sch);
-- 
2.35.1



