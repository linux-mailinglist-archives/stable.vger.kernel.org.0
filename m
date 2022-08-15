Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07499593FF2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiHOVMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiHOVIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0121454645;
        Mon, 15 Aug 2022 12:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A233E60FB9;
        Mon, 15 Aug 2022 19:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99859C433D6;
        Mon, 15 Aug 2022 19:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591121;
        bh=xYO+TDFOfQODSrEx0HoMIGJBE32gT1/jzGDxoOV/ltY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tql5egFyVxl8bBl6zYmmQ5j9cOPj+nTsPoAnRGkLExsYJJs3z3Gh7Qun0fjFOLBT6
         6egqfZ4xJYzEh1amBi3nAT8dmGcrXEuSy1vE89LjssJqD4wxa9RekdLPNkjFQvr7sG
         fq6ROglsOmYmwOx0iqvk8BNVHaFb2vPGuf8fdwmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0479/1095] bpf: Adapt copy_map_value for multiple offset case
Date:   Mon, 15 Aug 2022 19:57:58 +0200
Message-Id: <20220815180449.404334664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 4d7d7f69f4b104b2ddeec6a1e7fcfd2d044ed8c4 ]

Since now there might be at most 10 offsets that need handling in
copy_map_value, the manual shuffling and special case is no longer going
to work. Hence, let's generalise the copy_map_value function by using
a sorted array of offsets to skip regions that must be avoided while
copying into and out of a map value.

When the map is created, we populate the offset array in struct map,
Then, copy_map_value uses this sorted offset array is used to memcpy
while skipping timer, spin lock, and kptr. The array is allocated as
in most cases none of these special fields would be present in map
value, hence we can save on space for the common case by not embedding
the entire object inside bpf_map struct.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220424214901.2743946-6-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 56 +++++++++++++++-------------
 kernel/bpf/syscall.c | 88 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 117 insertions(+), 27 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2f6e7fc474ea..a3fe7f53e567 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -158,6 +158,9 @@ struct bpf_map_ops {
 enum {
 	/* Support at most 8 pointers in a BPF map value */
 	BPF_MAP_VALUE_OFF_MAX = 8,
+	BPF_MAP_OFF_ARR_MAX   = BPF_MAP_VALUE_OFF_MAX +
+				1 + /* for bpf_spin_lock */
+				1,  /* for bpf_timer */
 };
 
 enum bpf_kptr_type {
@@ -179,6 +182,12 @@ struct bpf_map_value_off {
 	struct bpf_map_value_off_desc off[];
 };
 
+struct bpf_map_off_arr {
+	u32 cnt;
+	u32 field_off[BPF_MAP_OFF_ARR_MAX];
+	u8 field_sz[BPF_MAP_OFF_ARR_MAX];
+};
+
 struct bpf_map {
 	/* The first two cachelines with read-mostly members of which some
 	 * are also accessed in fast-path (e.g. ops, max_entries).
@@ -207,10 +216,7 @@ struct bpf_map {
 	struct mem_cgroup *memcg;
 #endif
 	char name[BPF_OBJ_NAME_LEN];
-	bool bypass_spec_v1;
-	bool frozen; /* write-once; write-protected by freeze_mutex */
-	/* 6 bytes hole */
-
+	struct bpf_map_off_arr *off_arr;
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
 	 * particularly with refcounting.
 	 */
@@ -230,6 +236,8 @@ struct bpf_map {
 		bool jited;
 		bool xdp_has_frags;
 	} owner;
+	bool bypass_spec_v1;
+	bool frozen; /* write-once; write-protected by freeze_mutex */
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -253,37 +261,33 @@ static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
 		memset(dst + map->spin_lock_off, 0, sizeof(struct bpf_spin_lock));
 	if (unlikely(map_value_has_timer(map)))
 		memset(dst + map->timer_off, 0, sizeof(struct bpf_timer));
+	if (unlikely(map_value_has_kptrs(map))) {
+		struct bpf_map_value_off *tab = map->kptr_off_tab;
+		int i;
+
+		for (i = 0; i < tab->nr_off; i++)
+			*(u64 *)(dst + tab->off[i].offset) = 0;
+	}
 }
 
 /* copy everything but bpf_spin_lock and bpf_timer. There could be one of each. */
 static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 {
-	u32 s_off = 0, s_sz = 0, t_off = 0, t_sz = 0;
+	u32 curr_off = 0;
+	int i;
 
-	if (unlikely(map_value_has_spin_lock(map))) {
-		s_off = map->spin_lock_off;
-		s_sz = sizeof(struct bpf_spin_lock);
-	}
-	if (unlikely(map_value_has_timer(map))) {
-		t_off = map->timer_off;
-		t_sz = sizeof(struct bpf_timer);
+	if (likely(!map->off_arr)) {
+		memcpy(dst, src, map->value_size);
+		return;
 	}
 
-	if (unlikely(s_sz || t_sz)) {
-		if (s_off < t_off || !s_sz) {
-			swap(s_off, t_off);
-			swap(s_sz, t_sz);
-		}
-		memcpy(dst, src, t_off);
-		memcpy(dst + t_off + t_sz,
-		       src + t_off + t_sz,
-		       s_off - t_off - t_sz);
-		memcpy(dst + s_off + s_sz,
-		       src + s_off + s_sz,
-		       map->value_size - s_off - s_sz);
-	} else {
-		memcpy(dst, src, map->value_size);
+	for (i = 0; i < map->off_arr->cnt; i++) {
+		u32 next_off = map->off_arr->field_off[i];
+
+		memcpy(dst + curr_off, src + curr_off, next_off - curr_off);
+		curr_off += map->off_arr->field_sz[i];
 	}
+	memcpy(dst + curr_off, src + curr_off, map->value_size - curr_off);
 }
 void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 			   bool lock_src);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dc49bd880ac0..811bc71b0906 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -30,6 +30,7 @@
 #include <linux/pgtable.h>
 #include <linux/bpf_lsm.h>
 #include <linux/poll.h>
+#include <linux/sort.h>
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
@@ -551,6 +552,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
 	struct bpf_map *map = container_of(work, struct bpf_map, work);
 
 	security_bpf_map_free(map);
+	kfree(map->off_arr);
 	bpf_map_free_kptr_off_tab(map);
 	bpf_map_release_memcg(map);
 	/* implementation dependent freeing */
@@ -840,6 +842,84 @@ int map_check_no_btf(const struct bpf_map *map,
 	return -ENOTSUPP;
 }
 
+static int map_off_arr_cmp(const void *_a, const void *_b, const void *priv)
+{
+	const u32 a = *(const u32 *)_a;
+	const u32 b = *(const u32 *)_b;
+
+	if (a < b)
+		return -1;
+	else if (a > b)
+		return 1;
+	return 0;
+}
+
+static void map_off_arr_swap(void *_a, void *_b, int size, const void *priv)
+{
+	struct bpf_map *map = (struct bpf_map *)priv;
+	u32 *off_base = map->off_arr->field_off;
+	u32 *a = _a, *b = _b;
+	u8 *sz_a, *sz_b;
+
+	sz_a = map->off_arr->field_sz + (a - off_base);
+	sz_b = map->off_arr->field_sz + (b - off_base);
+
+	swap(*a, *b);
+	swap(*sz_a, *sz_b);
+}
+
+static int bpf_map_alloc_off_arr(struct bpf_map *map)
+{
+	bool has_spin_lock = map_value_has_spin_lock(map);
+	bool has_timer = map_value_has_timer(map);
+	bool has_kptrs = map_value_has_kptrs(map);
+	struct bpf_map_off_arr *off_arr;
+	u32 i;
+
+	if (!has_spin_lock && !has_timer && !has_kptrs) {
+		map->off_arr = NULL;
+		return 0;
+	}
+
+	off_arr = kmalloc(sizeof(*map->off_arr), GFP_KERNEL | __GFP_NOWARN);
+	if (!off_arr)
+		return -ENOMEM;
+	map->off_arr = off_arr;
+
+	off_arr->cnt = 0;
+	if (has_spin_lock) {
+		i = off_arr->cnt;
+
+		off_arr->field_off[i] = map->spin_lock_off;
+		off_arr->field_sz[i] = sizeof(struct bpf_spin_lock);
+		off_arr->cnt++;
+	}
+	if (has_timer) {
+		i = off_arr->cnt;
+
+		off_arr->field_off[i] = map->timer_off;
+		off_arr->field_sz[i] = sizeof(struct bpf_timer);
+		off_arr->cnt++;
+	}
+	if (has_kptrs) {
+		struct bpf_map_value_off *tab = map->kptr_off_tab;
+		u32 *off = &off_arr->field_off[off_arr->cnt];
+		u8 *sz = &off_arr->field_sz[off_arr->cnt];
+
+		for (i = 0; i < tab->nr_off; i++) {
+			*off++ = tab->off[i].offset;
+			*sz++ = sizeof(u64);
+		}
+		off_arr->cnt += tab->nr_off;
+	}
+
+	if (off_arr->cnt == 1)
+		return 0;
+	sort_r(off_arr->field_off, off_arr->cnt, sizeof(off_arr->field_off[0]),
+	       map_off_arr_cmp, map_off_arr_swap, map);
+	return 0;
+}
+
 static int map_check_btf(struct bpf_map *map, const struct btf *btf,
 			 u32 btf_key_id, u32 btf_value_id)
 {
@@ -1009,10 +1089,14 @@ static int map_create(union bpf_attr *attr)
 			attr->btf_vmlinux_value_type_id;
 	}
 
-	err = security_bpf_map_alloc(map);
+	err = bpf_map_alloc_off_arr(map);
 	if (err)
 		goto free_map;
 
+	err = security_bpf_map_alloc(map);
+	if (err)
+		goto free_map_off_arr;
+
 	err = bpf_map_alloc_id(map);
 	if (err)
 		goto free_map_sec;
@@ -1035,6 +1119,8 @@ static int map_create(union bpf_attr *attr)
 
 free_map_sec:
 	security_bpf_map_free(map);
+free_map_off_arr:
+	kfree(map->off_arr);
 free_map:
 	btf_put(map->btf);
 	map->ops->map_free(map);
-- 
2.35.1



