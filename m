Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E935AB329
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 16:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiIBOOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 10:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbiIBOOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 10:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02AA148D31;
        Fri,  2 Sep 2022 06:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B807E62134;
        Fri,  2 Sep 2022 12:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBDAC433D7;
        Fri,  2 Sep 2022 12:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121472;
        bh=PAG8xLbYDcu+i7ic8V0Wj3/QsiRebpHiLJ4x+qywz1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qragnagnZJl36ISOErL+gsyOPLRHNMJgkqzkxFRQZPOo6qAShI85G9gsMf/vtTUD8
         1xaMYpiHwg4vWzI2Z/pz6K+Djja3Cb8EbawDlgWcBe+GmZ4dGtZN85aQaUytJbmMLZ
         PJnggFOtrDxZA4k5gZJijk7yMsTNGRFjwIVeg/xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/56] net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
Date:   Fri,  2 Sep 2022 14:18:39 +0200
Message-Id: <20220902121400.843903558@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit bf955b5ab8f6f7b0632cdef8e36b14e4f6e77829 ]

While reading weight_p, it can be changed concurrently.  Thus, we need
to add READ_ONCE() to its reader.

Also, dev_[rt]x_weight can be read/written at the same time.  So, we
need to use READ_ONCE() and WRITE_ONCE() for its access.  Moreover, to
use the same weight_p while changing dev_[rt]x_weight, we add a mutex
in proc_do_dev_weight().

Fixes: 3d48b53fb2ae ("net: dev_weight: TX/RX orthogonality")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c             |  2 +-
 net/core/sysctl_net_core.c | 15 +++++++++------
 net/sched/sch_generic.c    |  2 +-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 42f6ff8b9703c..6ee4390863fbe 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5851,7 +5851,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		net_rps_action_and_irq_enable(sd);
 	}
 
-	napi->weight = dev_rx_weight;
+	napi->weight = READ_ONCE(dev_rx_weight);
 	while (again) {
 		struct sk_buff *skb;
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 0a0bf80623658..d7e39167ceca0 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -231,14 +231,17 @@ static int set_default_qdisc(struct ctl_table *table, int write,
 static int proc_do_dev_weight(struct ctl_table *table, int write,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int ret;
+	static DEFINE_MUTEX(dev_weight_mutex);
+	int ret, weight;
 
+	mutex_lock(&dev_weight_mutex);
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (ret != 0)
-		return ret;
-
-	dev_rx_weight = weight_p * dev_weight_rx_bias;
-	dev_tx_weight = weight_p * dev_weight_tx_bias;
+	if (!ret && write) {
+		weight = READ_ONCE(weight_p);
+		WRITE_ONCE(dev_rx_weight, weight * dev_weight_rx_bias);
+		WRITE_ONCE(dev_tx_weight, weight * dev_weight_tx_bias);
+	}
+	mutex_unlock(&dev_weight_mutex);
 
 	return ret;
 }
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index cad2586c34734..c966dacf1130b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -397,7 +397,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 
 void __qdisc_run(struct Qdisc *q)
 {
-	int quota = dev_tx_weight;
+	int quota = READ_ONCE(dev_tx_weight);
 	int packets;
 
 	while (qdisc_restart(q, &packets)) {
-- 
2.35.1



