Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFBD2F9E7D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390604AbhARLkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390599AbhARLkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB51B2222A;
        Mon, 18 Jan 2021 11:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969974;
        bh=tNXGkqWfC90gafyra9vmGIS57WqsuRn78WNPPkvH2H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZUARRPFx1ey3R64zdg9OcosGMavIvmxoVxM7Ot/XxaoSgUmrqoxQeeaB/xT4oWCd
         56MvdhYLUWlHRycYUsQQQTsnYAGpakix+MjrtLMpjD/JpwZfSvjXII/x0lfRhadePH
         9vkPuD5Vf5cY2wJ93ggvL9NwztzdnXgAWZxaa8M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/76] netfilter: ipset: fixes possible oops in mtype_resize
Date:   Mon, 18 Jan 2021 12:34:29 +0100
Message-Id: <20210118113342.376647623@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 2b33d6ffa9e38f344418976b06057e2fc2aa9e2a ]

currently mtype_resize() can cause oops

        t = ip_set_alloc(htable_size(htable_bits));
        if (!t) {
                ret = -ENOMEM;
                goto out;
        }
        t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));

Increased htable_bits can force htable_size() to return 0.
In own turn ip_set_alloc(0) returns not 0 but ZERO_SIZE_PTR,
so follwoing access to t->hregion should trigger an OOPS.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1a58cfdb862d6..500de37858ac8 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -630,7 +630,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct htype *h = set->data;
 	struct htable *t, *orig;
 	u8 htable_bits;
-	size_t dsize = set->dsize;
+	size_t hsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
 	struct mtype_elem *tmp;
@@ -654,14 +654,12 @@ mtype_resize(struct ip_set *set, bool retried)
 retry:
 	ret = 0;
 	htable_bits++;
-	if (!htable_bits) {
-		/* In case we have plenty of memory :-) */
-		pr_warn("Cannot increase the hashsize of set %s further\n",
-			set->name);
-		ret = -IPSET_ERR_HASH_FULL;
-		goto out;
-	}
-	t = ip_set_alloc(htable_size(htable_bits));
+	if (!htable_bits)
+		goto hbwarn;
+	hsize = htable_size(htable_bits);
+	if (!hsize)
+		goto hbwarn;
+	t = ip_set_alloc(hsize);
 	if (!t) {
 		ret = -ENOMEM;
 		goto out;
@@ -803,6 +801,12 @@ cleanup:
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
+
+hbwarn:
+	/* In case we have plenty of memory :-) */
+	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
+	ret = -IPSET_ERR_HASH_FULL;
+	goto out;
 }
 
 /* Get the current number of elements and ext_size in the set  */
-- 
2.27.0



