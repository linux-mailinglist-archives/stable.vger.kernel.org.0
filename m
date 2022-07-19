Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7809579DCF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242199AbiGSMzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242556AbiGSMyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:54:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0233F97D7C;
        Tue, 19 Jul 2022 05:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4938B81B36;
        Tue, 19 Jul 2022 12:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451DDC341CA;
        Tue, 19 Jul 2022 12:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233309;
        bh=w2oiqg+MxnTiHaiUG3hsFk6LU/L2vahhpaOcgaZDLXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mvq/3Lw0ABrEIohz4j+xMVqCsO+inWlX/B2OlwlAmFdrE7rK/Qx+DQGmpWBrSzW2q
         iK8oF7kIOBPNpaekvIsI2QIzwkviaIASO0rPjZzhRBYv1I5u5/JD0gl0x43ltjjYoE
         RYpUfMxJ0wQP7O56USmWLttUimJntbyImqmI5KF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 078/231] cipso: Fix data-races around sysctl.
Date:   Tue, 19 Jul 2022 13:52:43 +0200
Message-Id: <20220719114721.428329791@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit dd44f04b9214adb68ef5684ae87a81ba03632250 ]

While reading cipso sysctl variables, they can be changed concurrently.
So, we need to add READ_ONCE() to avoid data-races.

Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst |  2 +-
 net/ipv4/cipso_ipv4.c                  | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 66828293d9cb..8ffed7135fc1 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1085,7 +1085,7 @@ cipso_cache_enable - BOOLEAN
 cipso_cache_bucket_size - INTEGER
 	The CIPSO label cache consists of a fixed size hash table with each
 	hash bucket containing a number of cache entries.  This variable limits
-	the number of entries in each hash bucket; the larger the value the
+	the number of entries in each hash bucket; the larger the value is, the
 	more CIPSO label mappings that can be cached.  When the number of
 	entries in a given hash bucket reaches this limit adding new entries
 	causes the oldest entry in the bucket to be removed to make room.
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 62d5f99760aa..6cd3b6c559f0 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -239,7 +239,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 	struct cipso_v4_map_cache_entry *prev_entry = NULL;
 	u32 hash;
 
-	if (!cipso_v4_cache_enabled)
+	if (!READ_ONCE(cipso_v4_cache_enabled))
 		return -ENOENT;
 
 	hash = cipso_v4_map_cache_hash(key, key_len);
@@ -296,13 +296,14 @@ static int cipso_v4_cache_check(const unsigned char *key,
 int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 		       const struct netlbl_lsm_secattr *secattr)
 {
+	int bkt_size = READ_ONCE(cipso_v4_cache_bucketsize);
 	int ret_val = -EPERM;
 	u32 bkt;
 	struct cipso_v4_map_cache_entry *entry = NULL;
 	struct cipso_v4_map_cache_entry *old_entry = NULL;
 	u32 cipso_ptr_len;
 
-	if (!cipso_v4_cache_enabled || cipso_v4_cache_bucketsize <= 0)
+	if (!READ_ONCE(cipso_v4_cache_enabled) || bkt_size <= 0)
 		return 0;
 
 	cipso_ptr_len = cipso_ptr[1];
@@ -322,7 +323,7 @@ int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 
 	bkt = entry->hash & (CIPSO_V4_CACHE_BUCKETS - 1);
 	spin_lock_bh(&cipso_v4_cache[bkt].lock);
-	if (cipso_v4_cache[bkt].size < cipso_v4_cache_bucketsize) {
+	if (cipso_v4_cache[bkt].size < bkt_size) {
 		list_add(&entry->list, &cipso_v4_cache[bkt].list);
 		cipso_v4_cache[bkt].size += 1;
 	} else {
@@ -1199,7 +1200,8 @@ static int cipso_v4_gentag_rbm(const struct cipso_v4_doi *doi_def,
 		/* This will send packets using the "optimized" format when
 		 * possible as specified in  section 3.4.2.6 of the
 		 * CIPSO draft. */
-		if (cipso_v4_rbm_optfmt && ret_val > 0 && ret_val <= 10)
+		if (READ_ONCE(cipso_v4_rbm_optfmt) && ret_val > 0 &&
+		    ret_val <= 10)
 			tag_len = 14;
 		else
 			tag_len = 4 + ret_val;
@@ -1603,7 +1605,7 @@ int cipso_v4_validate(const struct sk_buff *skb, unsigned char **option)
 			 * all the CIPSO validations here but it doesn't
 			 * really specify _exactly_ what we need to validate
 			 * ... so, just make it a sysctl tunable. */
-			if (cipso_v4_rbm_strictvalid) {
+			if (READ_ONCE(cipso_v4_rbm_strictvalid)) {
 				if (cipso_v4_map_lvl_valid(doi_def,
 							   tag[3]) < 0) {
 					err_offset = opt_iter + 3;
-- 
2.35.1



