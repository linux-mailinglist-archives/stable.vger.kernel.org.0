Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4622B6340
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbgKQNgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:36:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732244AbgKQNgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D316C207BC;
        Tue, 17 Nov 2020 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620179;
        bh=6pm9zhYWTKSf9n/U7JJrG8UYnvk7dGT/fQfxR+jD/Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uR+dNe4RqGKnpLuFBYdN66U1VzquVMW2P87mLxZW6dyYf0KYqlyAaq3L1qQ95g2h6
         otzyMC6XtqhyePQ7g3E56wNHT7QxHrgL/TN6BXt8NkQVn2iPnnOFfkhjIWt0q/r+BX
         gSQwZ0kmrNH13t9soUIp6NBJLmiVPsTry+Uwx0L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.9 133/255] libbpf, hashmap: Fix undefined behavior in hash_bits
Date:   Tue, 17 Nov 2020 14:04:33 +0100
Message-Id: <20201117122145.411242639@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7a078d2d18801bba7bde7337a823d7342299acf7 ]

If bits is 0, the case when the map is empty, then the >> is the size of
the register which is undefined behavior - on x86 it is the same as a
shift by 0.

Fix by handling the 0 case explicitly and guarding calls to hash_bits for
empty maps in hashmap__for_each_key_entry and hashmap__for_each_entry_safe.

Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
Suggested-by: Andrii Nakryiko <andriin@fb.com>,
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20201029223707.494059-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/hashmap.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index e0af36b0e5d83..6a3c3d8bb4ab8 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -15,6 +15,9 @@
 static inline size_t hash_bits(size_t h, int bits)
 {
 	/* shuffle bits and return requested number of upper bits */
+	if (bits == 0)
+		return 0;
+
 #if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
 	/* LP64 case */
 	return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
@@ -162,17 +165,17 @@ bool hashmap__find(const struct hashmap *map, const void *key, void **value);
  * @key: key to iterate entries for
  */
 #define hashmap__for_each_key_entry(map, cur, _key)			    \
-	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
-					     map->cap_bits);		    \
-		     map->buckets ? map->buckets[bkt] : NULL; });	    \
+	for (cur = map->buckets						    \
+		     ? map->buckets[hash_bits(map->hash_fn((_key), map->ctx), map->cap_bits)] \
+		     : NULL;						    \
 	     cur;							    \
 	     cur = cur->next)						    \
 		if (map->equal_fn(cur->key, (_key), map->ctx))
 
 #define hashmap__for_each_key_entry_safe(map, cur, tmp, _key)		    \
-	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
-					     map->cap_bits);		    \
-		     cur = map->buckets ? map->buckets[bkt] : NULL; });	    \
+	for (cur = map->buckets						    \
+		     ? map->buckets[hash_bits(map->hash_fn((_key), map->ctx), map->cap_bits)] \
+		     : NULL;						    \
 	     cur && ({ tmp = cur->next; true; });			    \
 	     cur = tmp)							    \
 		if (map->equal_fn(cur->key, (_key), map->ctx))
-- 
2.27.0



