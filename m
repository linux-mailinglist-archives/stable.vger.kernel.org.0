Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E85AEAAF
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiIFNu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238746AbiIFNsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2B41F62C;
        Tue,  6 Sep 2022 06:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40B63B818CB;
        Tue,  6 Sep 2022 13:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A7FC433D6;
        Tue,  6 Sep 2022 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471423;
        bh=wqumMZXi1LsOqk20M9uLwZVwJ/RaUHqGDItllRlXl3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWVvVkJUCc/L+LbChcYYZtbSTa8y9FbB++zjS9cb2XeSWlHiyn8NrFefgO0LIiF2q
         IbXenKwuzY6e8MpQCp3M2O+d7g5Li1x0aql0zMmEKugIgShSjpYqtaa0B1EK5DGr9U
         scPNngmB71/MSLsbppSIbS15K0KIHRFvS8JEI7F0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/107] net: sched: tbf: dont call qdisc_put() while holding tree lock
Date:   Tue,  6 Sep 2022 15:30:02 +0200
Message-Id: <20220906132822.654023854@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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



