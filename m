Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6E3621527
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbiKHOI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiKHOIr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:08:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3185C6391
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:08:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0DA8B81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D30C433C1;
        Tue,  8 Nov 2022 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916523;
        bh=Ul3IsQXrLuX6zOqN8dbJWLr1CBOOWCvxxydffxBYEOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbIT5hvEySrUbb92hfzHNFYkDjHizMOsShqChMW3drqNe7coyg9hHN9V89tWjJJYS
         PViOPX9HwxQUWlAg1D4JljWCyyrS66ynEVGMtClG7mUje2Y6N8H9qhGWMoOwhG5jw6
         pQ3rqhmskRBx8KBTWbOF8ym3EZnPYZB1x6TvXCY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Xu <dxu@dxuuu.xyz>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 048/197] netfilter: ipset: enforce documented limit to prevent allocating huge memory
Date:   Tue,  8 Nov 2022 14:38:06 +0100
Message-Id: <20221108133357.002841526@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 510841da1fcc16f702440ab58ef0b4d82a9056b7 ]

Daniel Xu reported that the hash:net,iface type of the ipset subsystem does
not limit adding the same network with different interfaces to a set, which
can lead to huge memory usage or allocation failure.

The quick reproducer is

$ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
$ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -exist; done

The backtrace when vmalloc fails:

        [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
        <...>
        [Tue Oct 25 00:13:08 2022] Call Trace:
        [Tue Oct 25 00:13:08 2022]  <TASK>
        [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
        [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
        [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
        [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
        [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
        [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
        [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
        <...>

The fix is to enforce the limit documented in the ipset(8) manpage:

>  The internal restriction of the hash:net,iface set type is that the same
>  network prefix cannot be stored with more than 64 different interfaces
>  in a single set.

Fixes: ccf0a4b7fc68 ("netfilter: ipset: Add bucketsize parameter to all hash types")
Reported-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 30 ++++++---------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6e391308431d..3adc291d9ce1 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -42,31 +42,8 @@
 #define AHASH_MAX_SIZE			(6 * AHASH_INIT_SIZE)
 /* Max muber of elements in the array block when tuned */
 #define AHASH_MAX_TUNED			64
-
 #define AHASH_MAX(h)			((h)->bucketsize)
 
-/* Max number of elements can be tuned */
-#ifdef IP_SET_HASH_WITH_MULTI
-static u8
-tune_bucketsize(u8 curr, u32 multi)
-{
-	u32 n;
-
-	if (multi < curr)
-		return curr;
-
-	n = curr + AHASH_INIT_SIZE;
-	/* Currently, at listing one hash bucket must fit into a message.
-	 * Therefore we have a hard limit here.
-	 */
-	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
-}
-#define TUNE_BUCKETSIZE(h, multi)	\
-	((h)->bucketsize = tune_bucketsize((h)->bucketsize, multi))
-#else
-#define TUNE_BUCKETSIZE(h, multi)
-#endif
-
 /* A hash bucket */
 struct hbucket {
 	struct rcu_head rcu;	/* for call_rcu */
@@ -936,7 +913,12 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >= n->size) {
-		TUNE_BUCKETSIZE(h, multi);
+#ifdef IP_SET_HASH_WITH_MULTI
+		if (h->bucketsize >= AHASH_MAX_TUNED)
+			goto set_full;
+		else if (h->bucketsize < multi)
+			h->bucketsize += AHASH_INIT_SIZE;
+#endif
 		if (n->size >= AHASH_MAX(h)) {
 			/* Trigger rehashing */
 			mtype_data_next(&h->next, d);
-- 
2.35.1



