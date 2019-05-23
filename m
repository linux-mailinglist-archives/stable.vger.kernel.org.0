Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C99289C5
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbfEWTTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388715AbfEWTTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:19:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4992133D;
        Thu, 23 May 2019 19:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639175;
        bh=kesfgwBqgVXPkLx/zEwnlJg4dQOQm0nNiBwMUCHiobU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIc318X0NXF4+RmWoXQXCsDnvhK1MqSAwcgODxbros/QeaxFCJ0CZfyTnoddHGb7L
         dGoAIBrU78sQ4jOfaCQyTBFZx32jX8iZaTjBFkLAIr67pqrHZpQEr5HSkXWC5K1voX
         XTfHqSsyySSaxUNpaxYVy7FpskUAi00DSqCkNXXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 114/114] bpf, lru: avoid messing with eviction heuristics upon syscall lookup
Date:   Thu, 23 May 2019 21:06:53 +0200
Message-Id: <20190523181740.955032364@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 50b045a8c0ccf44f76640ac3eea8d80ca53979a3 upstream.

One of the biggest issues we face right now with picking LRU map over
regular hash table is that a map walk out of user space, for example,
to just dump the existing entries or to remove certain ones, will
completely mess up LRU eviction heuristics and wrong entries such
as just created ones will get evicted instead. The reason for this
is that we mark an entry as "in use" via bpf_lru_node_set_ref() from
system call lookup side as well. Thus upon walk, all entries are
being marked, so information of actual least recently used ones
are "lost".

In case of Cilium where it can be used (besides others) as a BPF
based connection tracker, this current behavior causes disruption
upon control plane changes that need to walk the map from user space
to evict certain entries. Discussion result from bpfconf [0] was that
we should simply just remove marking from system call side as no
good use case could be found where it's actually needed there.
Therefore this patch removes marking for regular LRU and per-CPU
flavor. If there ever should be a need in future, the behavior could
be selected via map creation flag, but due to mentioned reason we
avoid this here.

  [0] http://vger.kernel.org/bpfconf.html

Fixes: 29ba732acbee ("bpf: Add BPF_MAP_TYPE_LRU_HASH")
Fixes: 8f8449384ec3 ("bpf: Add BPF_MAP_TYPE_LRU_PERCPU_HASH")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/hashtab.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -518,18 +518,30 @@ static u32 htab_map_gen_lookup(struct bp
 	return insn - insn_buf;
 }
 
-static void *htab_lru_map_lookup_elem(struct bpf_map *map, void *key)
+static __always_inline void *__htab_lru_map_lookup_elem(struct bpf_map *map,
+							void *key, const bool mark)
 {
 	struct htab_elem *l = __htab_map_lookup_elem(map, key);
 
 	if (l) {
-		bpf_lru_node_set_ref(&l->lru_node);
+		if (mark)
+			bpf_lru_node_set_ref(&l->lru_node);
 		return l->key + round_up(map->key_size, 8);
 	}
 
 	return NULL;
 }
 
+static void *htab_lru_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	return __htab_lru_map_lookup_elem(map, key, true);
+}
+
+static void *htab_lru_map_lookup_elem_sys(struct bpf_map *map, void *key)
+{
+	return __htab_lru_map_lookup_elem(map, key, false);
+}
+
 static u32 htab_lru_map_gen_lookup(struct bpf_map *map,
 				   struct bpf_insn *insn_buf)
 {
@@ -1206,6 +1218,7 @@ const struct bpf_map_ops htab_lru_map_op
 	.map_free = htab_map_free,
 	.map_get_next_key = htab_map_get_next_key,
 	.map_lookup_elem = htab_lru_map_lookup_elem,
+	.map_lookup_elem_sys_only = htab_lru_map_lookup_elem_sys,
 	.map_update_elem = htab_lru_map_update_elem,
 	.map_delete_elem = htab_lru_map_delete_elem,
 	.map_gen_lookup = htab_lru_map_gen_lookup,
@@ -1237,7 +1250,6 @@ static void *htab_lru_percpu_map_lookup_
 
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value)
 {
-	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct htab_elem *l;
 	void __percpu *pptr;
 	int ret = -ENOENT;
@@ -1253,8 +1265,9 @@ int bpf_percpu_hash_copy(struct bpf_map
 	l = __htab_map_lookup_elem(map, key);
 	if (!l)
 		goto out;
-	if (htab_is_lru(htab))
-		bpf_lru_node_set_ref(&l->lru_node);
+	/* We do not mark LRU map element here in order to not mess up
+	 * eviction heuristics when user space does a map walk.
+	 */
 	pptr = htab_elem_get_ptr(l, map->key_size);
 	for_each_possible_cpu(cpu) {
 		bpf_long_memcpy(value + off,


