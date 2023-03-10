Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 746B06B41DC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjCJN5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjCJN5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E58112DF5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1675FB822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5ABC4339B;
        Fri, 10 Mar 2023 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456624;
        bh=dE+5LADuhZBVnsFfNFjhlvGqNXHwb1Hr6Eeh0eL1FXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUeM3R8k8tAnrDv/tz6GkmTcWjLV+/bwE++AOIvg0kvPDh/eem1BcVCTSo9LBTQxm
         yIleKbeoaeGaw0Xp5dK0J0m+eE+6CBaHmDJbBDOUoYnb0U7C62ajrxh58y1/cAjfjz
         JVT4/9+3xeaDb+2SCZMkY1UALK0nFPcDNk6UDGT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 067/211] netfilter: conntrack: fix rmmod double-free race
Date:   Fri, 10 Mar 2023 14:37:27 +0100
Message-Id: <20230310133720.788881842@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e6d57e9ff0aec323717ee36fc9ea34ad89217151 ]

nf_conntrack_hash_check_insert() callers free the ct entry directly, via
nf_conntrack_free.

This isn't safe anymore because
nf_conntrack_hash_check_insert() might place the entry into the conntrack
table and then delteted the entry again because it found that a conntrack
extension has been removed at the same time.

In this case, the just-added entry is removed again and an error is
returned to the caller.

Problem is that another cpu might have picked up this entry and
incremented its reference count.

This results in a use-after-free/double-free, once by the other cpu and
once by the caller of nf_conntrack_hash_check_insert().

Fix this by making nf_conntrack_hash_check_insert() not fail anymore
after the insertion, just like before the 'Fixes' commit.

This is safe because a racing nf_ct_iterate() has to wait for us
to release the conntrack hash spinlocks.

While at it, make the function return -EAGAIN in the rmmod (genid
changed) case, this makes nfnetlink replay the command (suggested
by Pablo Neira).

Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_bpf.c     |  1 -
 net/netfilter/nf_conntrack_core.c    | 25 +++++++++++++++----------
 net/netfilter/nf_conntrack_netlink.c |  3 ---
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 24002bc61e07e..e1af14e3b63c5 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -381,7 +381,6 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
-	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 496c4920505b3..ead11a9c261f3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -886,10 +886,8 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
-		return -ETIMEDOUT;
-	}
+	if (!nf_ct_ext_valid_pre(ct->ext))
+		return -EAGAIN;
 
 	local_bh_disable();
 	do {
@@ -924,6 +922,19 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 			goto chaintoolong;
 	}
 
+	/* If genid has changed, we can't insert anymore because ct
+	 * extensions could have stale pointers and nf_ct_iterate_destroy
+	 * might have completed its table scan already.
+	 *
+	 * Increment of the ext genid right after this check is fine:
+	 * nf_ct_iterate_destroy blocks until locks are released.
+	 */
+	if (!nf_ct_ext_valid_post(ct->ext)) {
+		err = -EAGAIN;
+		goto out;
+	}
+
+	ct->status |= IPS_CONFIRMED;
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
@@ -932,12 +943,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
 
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		nf_ct_kill(ct);
-		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return -ETIMEDOUT;
-	}
-
 	return 0;
 chaintoolong:
 	NF_CT_STAT_INC(net, chaintoolong);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ca4d5bb1ea524..733bb56950c14 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2316,9 +2316,6 @@ ctnetlink_create_conntrack(struct net *net,
 	nfct_seqadj_ext_add(ct);
 	nfct_synproxy_ext_add(ct);
 
-	/* we must add conntrack extensions before confirmation. */
-	ct->status |= IPS_CONFIRMED;
-
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
-- 
2.39.2



