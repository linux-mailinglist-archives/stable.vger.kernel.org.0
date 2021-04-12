Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F24035BC97
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhDLInz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237561AbhDLInx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4625D61221;
        Mon, 12 Apr 2021 08:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217015;
        bh=yZ4RDwF4eYw0HNvFN02ubTvSDkJz0zTvxg86LRgDtec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CC4NDmrQUuqWmrrXWWzo4g5n5cT545LrhwADdAExEEhikSM4Iv81sEAjpZisP0a9N
         9jNgU5B0htnPTM+pqW3oSMJOAGsbfDqujajRZlweXG7LuPJMZSvbITDn8jjE3YERen
         Ub5qSSwJPY4oCeeQ7SUArB7iPTh+JV/TAWdQL7S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/66] net: xfrm: Localize sequence counter per network namespace
Date:   Mon, 12 Apr 2021 10:40:37 +0200
Message-Id: <20210412083959.133534415@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed S. Darwish <a.darwish@linutronix.de>

[ Upstream commit e88add19f68191448427a6e4eb059664650a837f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/xfrm.h |  4 +++-
 net/xfrm/xfrm_state.c    | 10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 9991e5ef52cc..fbfa59801454 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -70,7 +70,9 @@ struct netns_xfrm {
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
index 84dea0ad1666..44acc724122b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -41,7 +41,6 @@ static void xfrm_state_gc_task(struct work_struct *work);
  */
 
 static unsigned int xfrm_state_hashmax __read_mostly = 1 * 1024 * 1024;
-static __read_mostly seqcount_t xfrm_state_hash_generation = SEQCNT_ZERO(xfrm_state_hash_generation);
 static struct kmem_cache *xfrm_state_cache __ro_after_init;
 
 static DECLARE_WORK(xfrm_state_gc_work, xfrm_state_gc_task);
@@ -137,7 +136,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	}
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	write_seqcount_begin(&xfrm_state_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	nhashmask = (nsize / sizeof(struct hlist_head)) - 1U;
 	odst = xfrm_state_deref_prot(net->xfrm.state_bydst, net);
@@ -153,7 +152,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	rcu_assign_pointer(net->xfrm.state_byspi, nspi);
 	net->xfrm.state_hmask = nhashmask;
 
-	write_seqcount_end(&xfrm_state_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_state_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
 	osize = (ohashmask + 1) * sizeof(struct hlist_head);
@@ -965,7 +964,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 
 	to_put = NULL;
 
-	sequence = read_seqcount_begin(&xfrm_state_hash_generation);
+	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	rcu_read_lock();
 	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
@@ -1076,7 +1075,7 @@ out:
 	if (to_put)
 		xfrm_state_put(to_put);
 
-	if (read_seqcount_retry(&xfrm_state_hash_generation, sequence)) {
+	if (read_seqcount_retry(&net->xfrm.xfrm_state_hash_generation, sequence)) {
 		*err = -EAGAIN;
 		if (x) {
 			xfrm_state_put(x);
@@ -2406,6 +2405,7 @@ int __net_init xfrm_state_init(struct net *net)
 	net->xfrm.state_num = 0;
 	INIT_WORK(&net->xfrm.state_hash_work, xfrm_hash_resize);
 	spin_lock_init(&net->xfrm.xfrm_state_lock);
+	seqcount_init(&net->xfrm.xfrm_state_hash_generation);
 	return 0;
 
 out_byspi:
-- 
2.30.2



