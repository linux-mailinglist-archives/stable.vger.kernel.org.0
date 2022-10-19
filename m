Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D09060446C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiJSMEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJSMDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:03:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AD550199;
        Wed, 19 Oct 2022 04:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CDEB82391;
        Wed, 19 Oct 2022 08:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70733C433C1;
        Wed, 19 Oct 2022 08:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169503;
        bh=nUoYxlS4P3sUkSZzW3n7UycxsTcJ6Of6LllWPr/hLhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggoYda00wrGE0upzqdwYOJUwwCgthxXevOOu+DTPXEOOrWCpyDocYi0L+MDsVpshT
         kf4/9NCWIVdbHtBHyeslsheGRboo89CC4FRHW/qPWuiByc1g3mk7PnkJICV18SynsW
         UYeiBaLB9JL1c9TG6CJRJEz/azAdA8IoQY4+8k1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Antoine Tenart <atenart@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 300/862] netfilter: conntrack: fix the gc rescheduling delay
Date:   Wed, 19 Oct 2022 10:26:27 +0200
Message-Id: <20221019083303.262065457@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 95eabdd207024312876d0ebed90b4c977e050e85 ]

Commit 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
changed the eviction rescheduling to the use average expiry of scanned
entries (within 1-60s) by doing:

  for (...) {
      expires = clamp(nf_ct_expires(tmp), ...);
      next_run += expires;
      next_run /= 2;
  }

The issue is the above will make the average ('next_run' here) more
dependent on the last expiration values than the firsts (for sets > 2).
Depending on the expiration values used to compute the average, the
result can be quite different than what's expected. To fix this we can
do the following:

  for (...) {
      expires = clamp(nf_ct_expires(tmp), ...);
      next_run += (expires - next_run) / ++count;
  }

Fixes: 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1357a2729a4b..2e6d5f1e6d63 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -67,6 +67,7 @@ struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
 	u32			avg_timeout;
+	u32			count;
 	u32			start_time;
 	bool			exiting;
 	bool			early_drop;
@@ -1466,6 +1467,7 @@ static void gc_worker(struct work_struct *work)
 	unsigned int expired_count = 0;
 	unsigned long next_run;
 	s32 delta_time;
+	long count;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
@@ -1475,10 +1477,12 @@ static void gc_worker(struct work_struct *work)
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->count = 1;
 		gc_work->start_time = start_time;
 	}
 
 	next_run = gc_work->avg_timeout;
+	count = gc_work->count;
 
 	end_time = start_time + GC_SCAN_MAX_DURATION;
 
@@ -1498,8 +1502,8 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
-			unsigned long expires;
 			struct net *net;
+			long expires;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
@@ -1513,6 +1517,7 @@ static void gc_worker(struct work_struct *work)
 
 				gc_work->next_bucket = i;
 				gc_work->avg_timeout = next_run;
+				gc_work->count = count;
 
 				delta_time = nfct_time_stamp - gc_work->start_time;
 
@@ -1528,8 +1533,8 @@ static void gc_worker(struct work_struct *work)
 			}
 
 			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
-			next_run /= 2u;
 
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
@@ -1570,6 +1575,7 @@ static void gc_worker(struct work_struct *work)
 		delta_time = nfct_time_stamp - end_time;
 		if (delta_time > 0 && i < hashsz) {
 			gc_work->avg_timeout = next_run;
+			gc_work->count = count;
 			gc_work->next_bucket = i;
 			next_run = 0;
 			goto early_exit;
-- 
2.35.1



