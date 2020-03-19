Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE23618B6F4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgCSNVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbgCSNVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:21:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F9E7206D7;
        Thu, 19 Mar 2020 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624102;
        bh=cG8xBS3xZCfN0tOEGRJjaUOF0nL+MWt/juF0Qz+0BpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HBFfHYfWbgb3OySKWbXZyunskcTf90iHHtJ4PjtPDo2s0TowygfxJ8kzoE6/KJ2q
         vpA+vsmu/AQTYRxfVBRdQAY1eDqYh+mln4T83GYxppdIyfpm//caWIbA+BivY2FizE
         uTDXrF2t8rej1bEatw/DoqNdtuEMsTg5eprGvhU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/60] netfilter: hashlimit: do not use indirect calls during gc
Date:   Thu, 19 Mar 2020 14:03:39 +0100
Message-Id: <20200319123919.801650823@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 28b3a4270c0fc064557e409111f2a678e64b6fa7 ]

no need, just use a simple boolean to indicate we want to reap all
entries.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_hashlimit.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 1b68a131083c2..7a2c4b8408c49 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -358,21 +358,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	return 0;
 }
 
-static bool select_all(const struct xt_hashlimit_htable *ht,
-		       const struct dsthash_ent *he)
-{
-	return true;
-}
-
-static bool select_gc(const struct xt_hashlimit_htable *ht,
-		      const struct dsthash_ent *he)
-{
-	return time_after_eq(jiffies, he->expires);
-}
-
-static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
-			bool (*select)(const struct xt_hashlimit_htable *ht,
-				      const struct dsthash_ent *he))
+static void htable_selective_cleanup(struct xt_hashlimit_htable *ht, bool select_all)
 {
 	unsigned int i;
 
@@ -382,7 +368,7 @@ static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
 
 		spin_lock_bh(&ht->lock);
 		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
-			if ((*select)(ht, dh))
+			if (time_after_eq(jiffies, dh->expires) || select_all)
 				dsthash_free(ht, dh);
 		}
 		spin_unlock_bh(&ht->lock);
@@ -396,7 +382,7 @@ static void htable_gc(struct work_struct *work)
 
 	ht = container_of(work, struct xt_hashlimit_htable, gc_work.work);
 
-	htable_selective_cleanup(ht, select_gc);
+	htable_selective_cleanup(ht, false);
 
 	queue_delayed_work(system_power_efficient_wq,
 			   &ht->gc_work, msecs_to_jiffies(ht->cfg.gc_interval));
@@ -420,7 +406,7 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 {
 	cancel_delayed_work_sync(&hinfo->gc_work);
 	htable_remove_proc_entry(hinfo);
-	htable_selective_cleanup(hinfo, select_all);
+	htable_selective_cleanup(hinfo, true);
 	kfree(hinfo->name);
 	vfree(hinfo);
 }
-- 
2.20.1



