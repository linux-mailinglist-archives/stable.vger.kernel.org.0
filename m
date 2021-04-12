Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4737D35B89A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbhDLCX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhDLCX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF4261220;
        Mon, 12 Apr 2021 02:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194220;
        bh=OEX6bXPH/uy9qmeLiXbpdIscWAfBPZ3pTaAdyHXC6V8=;
        h=From:To:Cc:Subject:Date:From;
        b=MtA84TIwSGPTytZ34WxmcZ4a0MkP+ruRz2vHTNuTA7+StNQB6qKiIAkawPN8zemX6
         prbqZ59rzyyNrZPr8JPHV/h5s/u5momrzg61Caw9sg2yTxOiRG7jwKm1KgNLPwjAXg
         G5D9Mfq663gua+Y+QSgligdjeur9gYkQKzLJIwiJCpxhi2VjF5yRhpGCqaXhvhzM+u
         /Gd78qkZVjhCP+SkLBbBxo2C44udvVXWtdN/JPISGcqEYREE4w/6jhfoYibScF87MI
         Ql1jabKVOLl6+/UgAeR14vAPSYC79IIWDHomXiGNNQPXHFO9txNcVv6WVuv1cwfIxa
         F7K+Rh5AOljKA==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, a.darwish@linutronix.de
Cc:     Steffen Klassert <steffen.klassert@secunet.com>
Subject: FAILED: Patch "net: xfrm: Localize sequence counter per network namespace" failed to apply to 4.9-stable tree
Date:   Sun, 11 Apr 2021 22:23:38 -0400
Message-Id: <20210412022338.284844-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From e88add19f68191448427a6e4eb059664650a837f Mon Sep 17 00:00:00 2001
From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Date: Tue, 16 Mar 2021 11:56:29 +0100
Subject: [PATCH] net: xfrm: Localize sequence counter per network namespace

A sequence counter write section must be serialized or its internal
state can get corrupted. The "xfrm_state_hash_generation" seqcount is
global, but its write serialization lock (net->xfrm.xfrm_state_lock) is
instantiated per network namespace. The write protection is thus
insufficient.

To provide full protection, localize the sequence counter per network
namespace instead. This should be safe as both the seqcount read and
write sections access data exclusively within the network namespace. It
also lays the foundation for transforming "xfrm_state_hash_generation"
data type from seqcount_t to seqcount_LOCKNAME_t in further commits.

Fixes: b65e3d7be06f ("xfrm: state: add sequence count to detect hash resizes")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netns/xfrm.h |  4 +++-
 net/xfrm/xfrm_state.c    | 10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 59f45b1e9dac..b59d73d529ba 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -72,7 +72,9 @@ struct netns_xfrm {
 #if IS_ENABLED(CONFIG_IPV6)
 	struct dst_ops		xfrm6_dst_ops;
 #endif
-	spinlock_t xfrm_state_lock;
+	spinlock_t		xfrm_state_lock;
+	seqcount_t		xfrm_state_hash_generation;
+
 	spinlock_t xfrm_policy_lock;
 	struct mutex xfrm_cfg_mutex;
 };
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index d01ca1a18418..ffd315cff984 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -44,7 +44,6 @@ static void xfrm_state_gc_task(struct work_struct *work);
  */
 
 static unsigned int xfrm_state_hashmax __read_mostly = 1 * 1024 * 1024;
-static __read_mostly seqcount_t xfrm_state_hash_generation = SEQCNT_ZERO(xfrm_state_hash_generation);
 static struct kmem_cache *xfrm_state_cache __ro_after_init;
 
 static DECLARE_WORK(xfrm_state_gc_work, xfrm_state_gc_task);
@@ -140,7 +139,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	}
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	write_seqcount_begin(&xfrm_state_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	nhashmask = (nsize / sizeof(struct hlist_head)) - 1U;
 	odst = xfrm_state_deref_prot(net->xfrm.state_bydst, net);
@@ -156,7 +155,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	rcu_assign_pointer(net->xfrm.state_byspi, nspi);
 	net->xfrm.state_hmask = nhashmask;
 
-	write_seqcount_end(&xfrm_state_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_state_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
 	osize = (ohashmask + 1) * sizeof(struct hlist_head);
@@ -1063,7 +1062,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 
 	to_put = NULL;
 
-	sequence = read_seqcount_begin(&xfrm_state_hash_generation);
+	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	rcu_read_lock();
 	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
@@ -1176,7 +1175,7 @@ out:
 	if (to_put)
 		xfrm_state_put(to_put);
 
-	if (read_seqcount_retry(&xfrm_state_hash_generation, sequence)) {
+	if (read_seqcount_retry(&net->xfrm.xfrm_state_hash_generation, sequence)) {
 		*err = -EAGAIN;
 		if (x) {
 			xfrm_state_put(x);
@@ -2666,6 +2665,7 @@ int __net_init xfrm_state_init(struct net *net)
 	net->xfrm.state_num = 0;
 	INIT_WORK(&net->xfrm.state_hash_work, xfrm_hash_resize);
 	spin_lock_init(&net->xfrm.xfrm_state_lock);
+	seqcount_init(&net->xfrm.xfrm_state_hash_generation);
 	return 0;
 
 out_byspi:
-- 
2.30.2




