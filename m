Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9D16AE9BD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjCGR1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjCGR0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645E299D53
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 036E4614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A6EC433EF;
        Tue,  7 Mar 2023 17:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209716;
        bh=HCNCYHRAf0i6WmESxFb7hnJuhjl3av2KVNVLeJcOB08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mr6ATTJcOlNs8uEN5jt2OgWvTxkLVzNWJvmkZHSgl64yUbU7Z8xAJBINdLjuVxyBp
         W/UCvBgqnBYUt2v/5Ll0sm0HpeVrCD2r47vkgdwF5/dXtzpqGkPWRD4vc+PGVM43st
         noIW8k4kGG+Tno28BDu5ldXDqSvSnKlrYkulEVgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0308/1001] bpf: Zeroing allocated object from slab in bpf memory allocator
Date:   Tue,  7 Mar 2023 17:51:20 +0100
Message-Id: <20230307170034.924193767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 997849c4b969034e225153f41026657def66d286 ]

Currently the freed element in bpf memory allocator may be immediately
reused, for htab map the reuse will reinitialize special fields in map
value (e.g., bpf_spin_lock), but lookup procedure may still access
these special fields, and it may lead to hard-lockup as shown below:

 NMI backtrace for cpu 16
 CPU: 16 PID: 2574 Comm: htab.bin Tainted: G             L     6.1.0+ #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
 RIP: 0010:queued_spin_lock_slowpath+0x283/0x2c0
 ......
 Call Trace:
  <TASK>
  copy_map_value_locked+0xb7/0x170
  bpf_map_copy_value+0x113/0x3c0
  __sys_bpf+0x1c67/0x2780
  __x64_sys_bpf+0x1c/0x20
  do_syscall_64+0x30/0x60
  entry_SYSCALL_64_after_hwframe+0x46/0xb0
 ......
  </TASK>

For htab map, just like the preallocated case, these is no need to
initialize these special fields in map value again once these fields
have been initialized. For preallocated htab map, these fields are
initialized through __GFP_ZERO in bpf_map_area_alloc(), so do the
similar thing for non-preallocated htab in bpf memory allocator. And
there is no need to use __GFP_ZERO for per-cpu bpf memory allocator,
because __alloc_percpu_gfp() does it implicitly.

Fixes: 0fd7c5d43339 ("bpf: Optimize call_rcu in non-preallocated hash map.")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20230215082132.3856544-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 7 +++++++
 kernel/bpf/hashtab.c  | 4 ++--
 kernel/bpf/memalloc.c | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 634d37a599fa7..cf0d88109e3f9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -346,6 +346,13 @@ static inline void bpf_obj_init(const struct btf_field_offs *foffs, void *obj)
 		memset(obj + foffs->field_off[i], 0, foffs->field_sz[i]);
 }
 
+/* 'dst' must be a temporary buffer and should not point to memory that is being
+ * used in parallel by a bpf program or bpf syscall, otherwise the access from
+ * the bpf program or bpf syscall may be corrupted by the reinitialization,
+ * leading to weird problems. Even 'dst' is newly-allocated from bpf memory
+ * allocator, it is still possible for 'dst' to be used in parallel by a bpf
+ * program or bpf syscall.
+ */
 static inline void check_and_init_map_value(struct bpf_map *map, void *dst)
 {
 	bpf_obj_init(map->field_offs, dst);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 66bded1443773..5dfcb5ad0d068 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1004,8 +1004,6 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			l_new = ERR_PTR(-ENOMEM);
 			goto dec_count;
 		}
-		check_and_init_map_value(&htab->map,
-					 l_new->key + round_up(key_size, 8));
 	}
 
 	memcpy(l_new->key, key, key_size);
@@ -1592,6 +1590,7 @@ static int __htab_map_lookup_and_delete_elem(struct bpf_map *map, void *key,
 			else
 				copy_map_value(map, value, l->key +
 					       roundup_key_size);
+			/* Zeroing special fields in the temp buffer */
 			check_and_init_map_value(map, value);
 		}
 
@@ -1792,6 +1791,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 						      true);
 			else
 				copy_map_value(map, dst_val, value);
+			/* Zeroing special fields in the temp buffer */
 			check_and_init_map_value(map, dst_val);
 		}
 		if (do_delete) {
diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 1db156405b68b..7b784823a52ef 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -143,7 +143,7 @@ static void *__alloc(struct bpf_mem_cache *c, int node)
 		return obj;
 	}
 
-	return kmalloc_node(c->unit_size, flags, node);
+	return kmalloc_node(c->unit_size, flags | __GFP_ZERO, node);
 }
 
 static struct mem_cgroup *get_memcg(const struct bpf_mem_cache *c)
-- 
2.39.2



