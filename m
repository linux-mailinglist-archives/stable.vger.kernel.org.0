Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D3CA8E45
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbfIDR5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387773AbfIDR5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:57:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B563D22CEA;
        Wed,  4 Sep 2019 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619823;
        bh=6DTqg9frxndXf+CFHwsm71uZlpFbznLVFeK7I+rtje8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X48g5W569boKknEM0ODWRkYTI7XBMmF9nEqkiMOa9m1ZLGdQ0E1AyS08vFvdr913c
         5QC9kAX3em5IzZy5mwNZ7kM4qoR/gKiQWkmws+CfCe9CJuQevnO7kRC/BIxNXuzLIz
         nNHt68G5QPxSIpMU5mFCuEMOClwZ8V2jO4QZKkQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Morris <dmorris@metaloft.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 46/77] netfilter: conntrack: Use consistent ct id hash calculation
Date:   Wed,  4 Sep 2019 19:53:33 +0200
Message-Id: <20190904175307.831985497@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 656c8e9cc1badbc18eefe6ba01d33ebbcae61b9a upstream.

Change ct id hash calculation to only use invariants.

Currently the ct id hash calculation is based on some fields that can
change in the lifetime on a conntrack entry in some corner cases. The
current hash uses the whole tuple which contains an hlist pointer which
will change when the conntrack is placed on the dying list resulting in
a ct id change.

This patch also removes the reply-side tuple and extension pointer from
the hash calculation so that the ct id will will not change from
initialization until confirmation.

Fixes: 3c79107631db1f7 ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Signed-off-by: Dirk Morris <dmorris@metaloft.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fd301fb137194..de0aad12b91d2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -241,13 +241,12 @@ EXPORT_SYMBOL_GPL(nf_ct_invert_tuple);
  * table location, we assume id gets exposed to userspace.
  *
  * Following nf_conn items do not change throughout lifetime
- * of the nf_conn after it has been committed to main hash table:
+ * of the nf_conn:
  *
  * 1. nf_conn address
- * 2. nf_conn->ext address
- * 3. nf_conn->master address (normally NULL)
- * 4. tuple
- * 5. the associated net namespace
+ * 2. nf_conn->master address (normally NULL)
+ * 3. the associated net namespace
+ * 4. the original direction tuple
  */
 u32 nf_ct_get_id(const struct nf_conn *ct)
 {
@@ -257,9 +256,10 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 	net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));
 
 	a = (unsigned long)ct;
-	b = (unsigned long)ct->master ^ net_hash_mix(nf_ct_net(ct));
-	c = (unsigned long)ct->ext;
-	d = (unsigned long)siphash(&ct->tuplehash, sizeof(ct->tuplehash),
+	b = (unsigned long)ct->master;
+	c = (unsigned long)nf_ct_net(ct);
+	d = (unsigned long)siphash(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+				   sizeof(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple),
 				   &ct_id_seed);
 #ifdef CONFIG_64BIT
 	return siphash_4u64((u64)a, (u64)b, (u64)c, (u64)d, &ct_id_seed);
-- 
2.20.1



