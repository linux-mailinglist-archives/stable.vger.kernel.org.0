Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5AD5AECBA
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbiIFOIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238821AbiIFOH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E202844DA;
        Tue,  6 Sep 2022 06:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86CC861554;
        Tue,  6 Sep 2022 13:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7A1C433C1;
        Tue,  6 Sep 2022 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471878;
        bh=q3OPIMRBgEIY5bMK5aztTplCEFi/FNMDMX8qk6XNKow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDkw4Y1jsMcd+liVHeJZER3hCgQiHRrcUbCayCNgBROXDolBCaUgJaK6/XiUYUYif
         pVovzXssQL60TqKFY4i0Xd96WtDae+SxUkCG9FpZj46IaB40SEEFFVU0maqnoenC3A
         c9Z7tmBgHdiexUWTSGYqDsqkwnQ+9v3WJuDgvkxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 039/155] net: sched: tbf: dont call qdisc_put() while holding tree lock
Date:   Tue,  6 Sep 2022 15:29:47 +0200
Message-Id: <20220906132831.063545548@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
index 72102277449e1..36079fdde2cb5 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -356,6 +356,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_TBF_MAX + 1];
 	struct tc_tbf_qopt *qopt;
 	struct Qdisc *child = NULL;
+	struct Qdisc *old = NULL;
 	struct psched_ratecfg rate;
 	struct psched_ratecfg peak;
 	u64 max_size;
@@ -447,7 +448,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_lock(sch);
 	if (child) {
 		qdisc_tree_flush_backlog(q->qdisc);
-		qdisc_put(q->qdisc);
+		old = q->qdisc;
 		q->qdisc = child;
 	}
 	q->limit = qopt->limit;
@@ -467,6 +468,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt,
 	memcpy(&q->peak, &peak, sizeof(struct psched_ratecfg));
 
 	sch_tree_unlock(sch);
+	qdisc_put(old);
 	err = 0;
 
 	tbf_offload_change(sch);
-- 
2.35.1



