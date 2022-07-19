Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D352579DC7
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242188AbiGSMzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbiGSMyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:54:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A169097D74;
        Tue, 19 Jul 2022 05:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03D35B81B2C;
        Tue, 19 Jul 2022 12:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF50C341C6;
        Tue, 19 Jul 2022 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233306;
        bh=AGVlhapnJHOEqrr6lBO8D1LBDrm6Jidzcfdm+f6X8pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+mv5P8FZCD3HKBf1eY2ZRiYRCHTR6KY/Kfc5DIoA2OcNcNqsSTKuMcvAiaxisVEf
         d8N+qBmI6ZHbbVuh2GUwwz/eP3DCCI6IRH3lUthPQ5RMyNCF4DqTHDTMot4TNVjd2B
         n9BRdNhafCqXZWr1FCX6ne4AICsMa0JDRCkaCLkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 060/231] netfilter: ecache: move to separate structure
Date:   Tue, 19 Jul 2022 13:52:25 +0200
Message-Id: <20220719114719.210273645@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9027ce0b071a1bbd046682907fc2e23ca3592883 ]

This makes it easier for a followup patch to only expose ecache
related parts of nf_conntrack_net structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_conntrack.h |  8 ++++++--
 net/netfilter/nf_conntrack_ecache.c  | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b08b70989d2c..69e6c6a218be 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -43,6 +43,11 @@ union nf_conntrack_expect_proto {
 	/* insert expect proto private data here */
 };
 
+struct nf_conntrack_net_ecache {
+	struct delayed_work dwork;
+	struct netns_ct *ct_net;
+};
+
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
 	atomic_t count;
@@ -58,8 +63,7 @@ struct nf_conntrack_net {
 	struct ctl_table_header	*sysctl_header;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct delayed_work ecache_dwork;
-	struct netns_ct *ct_net;
+	struct nf_conntrack_net_ecache ecache;
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 07e65b4e92f8..0cb2da0a759a 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -96,8 +96,8 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 
 static void ecache_work(struct work_struct *work)
 {
-	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache_dwork.work);
-	struct netns_ct *ctnet = cnet->ct_net;
+	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache.dwork.work);
+	struct netns_ct *ctnet = cnet->ecache.ct_net;
 	int cpu, delay = -1;
 	struct ct_pcpu *pcpu;
 
@@ -127,7 +127,7 @@ static void ecache_work(struct work_struct *work)
 
 	ctnet->ecache_dwork_pending = delay > 0;
 	if (delay >= 0)
-		schedule_delayed_work(&cnet->ecache_dwork, delay);
+		schedule_delayed_work(&cnet->ecache.dwork, delay);
 }
 
 static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
@@ -293,12 +293,12 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	if (state == NFCT_ECACHE_DESTROY_FAIL &&
-	    !delayed_work_pending(&cnet->ecache_dwork)) {
-		schedule_delayed_work(&cnet->ecache_dwork, HZ);
+	    !delayed_work_pending(&cnet->ecache.dwork)) {
+		schedule_delayed_work(&cnet->ecache.dwork, HZ);
 		net->ct.ecache_dwork_pending = true;
 	} else if (state == NFCT_ECACHE_DESTROY_SENT) {
 		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &cnet->ecache_dwork, 0);
+		mod_delayed_work(system_wq, &cnet->ecache.dwork, 0);
 	}
 }
 
@@ -310,8 +310,9 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	net->ct.sysctl_events = nf_ct_events;
-	cnet->ct_net = &net->ct;
-	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
+
+	cnet->ecache.ct_net = &net->ct;
+	INIT_DELAYED_WORK(&cnet->ecache.dwork, ecache_work);
 
 	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* e->ctmask is u16 */
 }
@@ -320,5 +321,5 @@ void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
-	cancel_delayed_work_sync(&cnet->ecache_dwork);
+	cancel_delayed_work_sync(&cnet->ecache.dwork);
 }
-- 
2.35.1



