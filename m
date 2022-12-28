Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B34657F2D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiL1QCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiL1QCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:02:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8E18B0E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:01:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D089E6155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BBEC433D2;
        Wed, 28 Dec 2022 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243316;
        bh=L1ICOmezN/HAnWLrPH2HXhwqI9K9sqtnDxq5kNpIiJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUoPNOssCkWMez5CxVPkJIz7CeCq7il/nZhjbOzko8t+3xdbNF+IhX5uhJZJFkna0
         3GTJ+y7MeNz3c13IAu5+hnBisErOAiAu2u5+Kp9OGe9Vvq4BgykpZ2yKiv1Z53aa1Q
         NVzH4Ucz00SsT4EIAcay2J23RsA98yZByDdy6Hjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Julian Anastasov <ja@ssi.bg>,
        yunhong-cgl jiang <xintian1976@gmail.com>,
        "dust.li" <dust.li@linux.alibaba.com>,
        Jiri Wiesner <jwiesner@suse.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0516/1073] ipvs: use u64_stats_t for the per-cpu counters
Date:   Wed, 28 Dec 2022 15:35:04 +0100
Message-Id: <20221228144342.060076176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 1dbd8d9a82e3f26b9d063292d47ece673f48fce2 ]

Use the provided u64_stats_t type to avoid
load/store tearing.

Fixes: 316580b69d0a ("u64_stats: provide u64_stats_t type")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Cc: yunhong-cgl jiang <xintian1976@gmail.com>
Cc: "dust.li" <dust.li@linux.alibaba.com>
Reviewed-by: Jiri Wiesner <jwiesner@suse.de>
Tested-by: Jiri Wiesner <jwiesner@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h             | 10 +++++-----
 net/netfilter/ipvs/ip_vs_core.c | 30 +++++++++++++++---------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 10 +++++-----
 net/netfilter/ipvs/ip_vs_est.c  | 20 ++++++++++----------
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ff1804a0c469..1fca6a88114a 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -351,11 +351,11 @@ struct ip_vs_seq {
 
 /* counters per cpu */
 struct ip_vs_counters {
-	__u64		conns;		/* connections scheduled */
-	__u64		inpkts;		/* incoming packets */
-	__u64		outpkts;	/* outgoing packets */
-	__u64		inbytes;	/* incoming bytes */
-	__u64		outbytes;	/* outgoing bytes */
+	u64_stats_t	conns;		/* connections scheduled */
+	u64_stats_t	inpkts;		/* incoming packets */
+	u64_stats_t	outpkts;	/* outgoing packets */
+	u64_stats_t	inbytes;	/* incoming bytes */
+	u64_stats_t	outbytes;	/* outgoing bytes */
 };
 /* Stats per cpu */
 struct ip_vs_cpu_stats {
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 51ad557a525b..b5ae419661b8 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -132,21 +132,21 @@ ip_vs_in_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 
 		s = this_cpu_ptr(dest->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.inpkts++;
-		s->cnt.inbytes += skb->len;
+		u64_stats_inc(&s->cnt.inpkts);
+		u64_stats_add(&s->cnt.inbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		svc = rcu_dereference(dest->svc);
 		s = this_cpu_ptr(svc->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.inpkts++;
-		s->cnt.inbytes += skb->len;
+		u64_stats_inc(&s->cnt.inpkts);
+		u64_stats_add(&s->cnt.inbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		s = this_cpu_ptr(ipvs->tot_stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.inpkts++;
-		s->cnt.inbytes += skb->len;
+		u64_stats_inc(&s->cnt.inpkts);
+		u64_stats_add(&s->cnt.inbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		local_bh_enable();
@@ -168,21 +168,21 @@ ip_vs_out_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 
 		s = this_cpu_ptr(dest->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.outpkts++;
-		s->cnt.outbytes += skb->len;
+		u64_stats_inc(&s->cnt.outpkts);
+		u64_stats_add(&s->cnt.outbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		svc = rcu_dereference(dest->svc);
 		s = this_cpu_ptr(svc->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.outpkts++;
-		s->cnt.outbytes += skb->len;
+		u64_stats_inc(&s->cnt.outpkts);
+		u64_stats_add(&s->cnt.outbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		s = this_cpu_ptr(ipvs->tot_stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
-		s->cnt.outpkts++;
-		s->cnt.outbytes += skb->len;
+		u64_stats_inc(&s->cnt.outpkts);
+		u64_stats_add(&s->cnt.outbytes, skb->len);
 		u64_stats_update_end(&s->syncp);
 
 		local_bh_enable();
@@ -200,17 +200,17 @@ ip_vs_conn_stats(struct ip_vs_conn *cp, struct ip_vs_service *svc)
 
 	s = this_cpu_ptr(cp->dest->stats.cpustats);
 	u64_stats_update_begin(&s->syncp);
-	s->cnt.conns++;
+	u64_stats_inc(&s->cnt.conns);
 	u64_stats_update_end(&s->syncp);
 
 	s = this_cpu_ptr(svc->stats.cpustats);
 	u64_stats_update_begin(&s->syncp);
-	s->cnt.conns++;
+	u64_stats_inc(&s->cnt.conns);
 	u64_stats_update_end(&s->syncp);
 
 	s = this_cpu_ptr(ipvs->tot_stats.cpustats);
 	u64_stats_update_begin(&s->syncp);
-	s->cnt.conns++;
+	u64_stats_inc(&s->cnt.conns);
 	u64_stats_update_end(&s->syncp);
 
 	local_bh_enable();
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5a7349002508..65bda976845d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2297,11 +2297,11 @@ static int ip_vs_stats_percpu_show(struct seq_file *seq, void *v)
 
 		do {
 			start = u64_stats_fetch_begin(&u->syncp);
-			conns = u->cnt.conns;
-			inpkts = u->cnt.inpkts;
-			outpkts = u->cnt.outpkts;
-			inbytes = u->cnt.inbytes;
-			outbytes = u->cnt.outbytes;
+			conns = u64_stats_read(&u->cnt.conns);
+			inpkts = u64_stats_read(&u->cnt.inpkts);
+			outpkts = u64_stats_read(&u->cnt.outpkts);
+			inbytes = u64_stats_read(&u->cnt.inbytes);
+			outbytes = u64_stats_read(&u->cnt.outbytes);
 		} while (u64_stats_fetch_retry(&u->syncp, start));
 
 		seq_printf(seq, "%3X %8LX %8LX %8LX %16LX %16LX\n",
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index 9a1a7af6a186..f53150d82a92 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -67,11 +67,11 @@ static void ip_vs_read_cpu_stats(struct ip_vs_kstats *sum,
 		if (add) {
 			do {
 				start = u64_stats_fetch_begin(&s->syncp);
-				conns = s->cnt.conns;
-				inpkts = s->cnt.inpkts;
-				outpkts = s->cnt.outpkts;
-				inbytes = s->cnt.inbytes;
-				outbytes = s->cnt.outbytes;
+				conns = u64_stats_read(&s->cnt.conns);
+				inpkts = u64_stats_read(&s->cnt.inpkts);
+				outpkts = u64_stats_read(&s->cnt.outpkts);
+				inbytes = u64_stats_read(&s->cnt.inbytes);
+				outbytes = u64_stats_read(&s->cnt.outbytes);
 			} while (u64_stats_fetch_retry(&s->syncp, start));
 			sum->conns += conns;
 			sum->inpkts += inpkts;
@@ -82,11 +82,11 @@ static void ip_vs_read_cpu_stats(struct ip_vs_kstats *sum,
 			add = true;
 			do {
 				start = u64_stats_fetch_begin(&s->syncp);
-				sum->conns = s->cnt.conns;
-				sum->inpkts = s->cnt.inpkts;
-				sum->outpkts = s->cnt.outpkts;
-				sum->inbytes = s->cnt.inbytes;
-				sum->outbytes = s->cnt.outbytes;
+				sum->conns = u64_stats_read(&s->cnt.conns);
+				sum->inpkts = u64_stats_read(&s->cnt.inpkts);
+				sum->outpkts = u64_stats_read(&s->cnt.outpkts);
+				sum->inbytes = u64_stats_read(&s->cnt.inbytes);
+				sum->outbytes = u64_stats_read(&s->cnt.outbytes);
 			} while (u64_stats_fetch_retry(&s->syncp, start));
 		}
 	}
-- 
2.35.1



