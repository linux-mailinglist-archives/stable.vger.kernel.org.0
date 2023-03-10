Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698B46B42D8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjCJOH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjCJOHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:07:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B8B11758B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:07:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1337D618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F64C4339B;
        Fri, 10 Mar 2023 14:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457223;
        bh=v39AbY21yJH2RbjjHHoqHB0sqEV9P+UMlIe3bHbqTY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcUiTTDKTVaTvcmK2Y4w46CMkBn4Khv+jLHX6VnHt3wrXp1L8SmFAs/glRwCi1f+F
         m5fk5QMt83XT5EDurH1x1chtfaQQasrU9nd+IPaG1a0ji5hD2UdePfYU20wY6w289G
         bvT2L0SFweGWQ5A6csayS4kC1RKOfwPl34sCgiHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/200] netfilter: conntrack: fix rmmod double-free race
Date:   Fri, 10 Mar 2023 14:37:48 +0100
Message-Id: <20230310133719.002715458@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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
index 8639e7efd0e22..adae86e8e02e8 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -384,7 +384,6 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
-	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 23b3fedd619a5..7f0f3bcaae031 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -890,10 +890,8 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
-		return -ETIMEDOUT;
-	}
+	if (!nf_ct_ext_valid_pre(ct->ext))
+		return -EAGAIN;
 
 	local_bh_disable();
 	do {
@@ -928,6 +926,19 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
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
@@ -936,12 +947,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
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



