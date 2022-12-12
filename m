Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7276F64A1A5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiLLNnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbiLLNn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD7B140FC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A218CE0EFC
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7C1C433D2;
        Mon, 12 Dec 2022 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852545;
        bh=YSVbyQ65vNQgobC8rJaKgghnzqGEtKPpWMESo2BLjbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDxEISxqhdaG2mR29NH9uq53Zx5VSDH9nXt8IU971WxB1qsDpCATjLG7iFdrs75wO
         KJyx4VN1t+Ry9+xKRGcXqYOPIPMngAZmbdfU+bs3BShSnlnd8GX4w2verxZA/s3Hgl
         YjgxD9vVYMWztPJ78w2wTyjSw4cqJfhmaxQexA84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 103/157] inet: ping: use hlist_nulls rcu iterator during lookup
Date:   Mon, 12 Dec 2022 14:17:31 +0100
Message-Id: <20221212130938.976364067@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c25b7a7a565e5eeb2459b37583eea67942057511 ]

ping_lookup() does not acquire the table spinlock, so iteration should
use hlist_nulls_for_each_entry_rcu().

Spotted during code review.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20221129140644.28525-1-fw@strlen.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .clang-format      | 1 +
 include/net/ping.h | 3 ---
 net/ipv4/ping.c    | 7 ++++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/.clang-format b/.clang-format
index 1247d54f9e49..8d01225bfcb7 100644
--- a/.clang-format
+++ b/.clang-format
@@ -535,6 +535,7 @@ ForEachMacros:
   - 'perf_hpp_list__for_each_sort_list_safe'
   - 'perf_pmu__for_each_hybrid_pmu'
   - 'ping_portaddr_for_each_entry'
+  - 'ping_portaddr_for_each_entry_rcu'
   - 'plist_for_each'
   - 'plist_for_each_continue'
   - 'plist_for_each_entry'
diff --git a/include/net/ping.h b/include/net/ping.h
index e4ff3911cbf5..9233ad3de0ad 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -16,9 +16,6 @@
 #define PING_HTABLE_SIZE 	64
 #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
 
-#define ping_portaddr_for_each_entry(__sk, node, list) \
-	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
-
 /*
  * gid_t is either uint or ushort.  We want to pass it to
  * proc_dointvec_minmax(), so it must not be larger than MAX_INT
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b83c2bd9d722..3b2420829c23 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -48,6 +48,11 @@
 #include <net/transp_v6.h>
 #endif
 
+#define ping_portaddr_for_each_entry(__sk, node, list) \
+	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
+#define ping_portaddr_for_each_entry_rcu(__sk, node, list) \
+	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
+
 struct ping_table {
 	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
 	spinlock_t		lock;
@@ -191,7 +196,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	ping_portaddr_for_each_entry(sk, hnode, hslot) {
+	ping_portaddr_for_each_entry_rcu(sk, hnode, hslot) {
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
-- 
2.35.1



