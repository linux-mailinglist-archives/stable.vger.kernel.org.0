Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1723360B258
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiJXQpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiJXQoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:44:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345F2D997D;
        Mon, 24 Oct 2022 08:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE1F2B8197A;
        Mon, 24 Oct 2022 12:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F149C433C1;
        Mon, 24 Oct 2022 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615256;
        bh=J5srUAPsiaKQ/KlrKrgKe4unUypBVzdCg0g02qpvcU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jrt0MMVfPC9vd3lTwAmI7pzCCLKuUc12EkLrDOUfYVfivfdc6pWWxYVW6M6V70CXk
         YgIlehihUfdqbn/rSNy+dtRv9Dc/nm6u3t1rLGWO/udDOCp7xbx1dTi1NsqVLfLnFK
         6LjeNtGPWb3r2EIaMLzosZjJaYlYmT6ewffcDAT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Antoine Tenart <atenart@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/530] netfilter: conntrack: fix the gc rescheduling delay
Date:   Mon, 24 Oct 2022 13:28:45 +0200
Message-Id: <20221024113053.217472850@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index 31399c53dfb1..ee72da164190 100644
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
@@ -1439,6 +1440,7 @@ static void gc_worker(struct work_struct *work)
 	unsigned int expired_count = 0;
 	unsigned long next_run;
 	s32 delta_time;
+	long count;
 
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
@@ -1448,10 +1450,12 @@ static void gc_worker(struct work_struct *work)
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->count = 1;
 		gc_work->start_time = start_time;
 	}
 
 	next_run = gc_work->avg_timeout;
+	count = gc_work->count;
 
 	end_time = start_time + GC_SCAN_MAX_DURATION;
 
@@ -1471,8 +1475,8 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
-			unsigned long expires;
 			struct net *net;
+			long expires;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
@@ -1486,6 +1490,7 @@ static void gc_worker(struct work_struct *work)
 
 				gc_work->next_bucket = i;
 				gc_work->avg_timeout = next_run;
+				gc_work->count = count;
 
 				delta_time = nfct_time_stamp - gc_work->start_time;
 
@@ -1501,8 +1506,8 @@ static void gc_worker(struct work_struct *work)
 			}
 
 			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			expires = (expires - (long)next_run) / ++count;
 			next_run += expires;
-			next_run /= 2u;
 
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
@@ -1540,6 +1545,7 @@ static void gc_worker(struct work_struct *work)
 		delta_time = nfct_time_stamp - end_time;
 		if (delta_time > 0 && i < hashsz) {
 			gc_work->avg_timeout = next_run;
+			gc_work->count = count;
 			gc_work->next_bucket = i;
 			next_run = 0;
 			goto early_exit;
-- 
2.35.1



