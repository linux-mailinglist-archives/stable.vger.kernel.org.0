Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5899753D03B
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242726AbiFCSB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346163AbiFCR7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0A5338B4;
        Fri,  3 Jun 2022 10:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D4B3B823B0;
        Fri,  3 Jun 2022 17:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC07BC385B8;
        Fri,  3 Jun 2022 17:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278923;
        bh=QD+HJNsnhOFMJYKOHSXc3QpDtVkl4y/4VvD1PIOsQ/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmNuJrkG1etR7QBNEwcvrhs/NgKY7FJYt/h4HNvBkX9asy2tL2JwQTpZUxsEN0ng3
         Fiy7bWkzGjF8cuqReG9CcPGKiHhfpopH3CaB1beKPoThICVFTVFH/Xfe4xmUtd98Wh
         0ih5Zq9jSHLfWrT3FxL1QLoPutwBKsOSddbfB17g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5.17 72/75] bpf: Fix usage of trace RCU in local storage.
Date:   Fri,  3 Jun 2022 19:43:56 +0200
Message-Id: <20220603173823.770225341@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KP Singh <kpsingh@kernel.org>

commit dcf456c9a095a6e71f53d6f6f004133ee851ee70 upstream.

bpf_{sk,task,inode}_storage_free() do not need to use
call_rcu_tasks_trace as no BPF program should be accessing the owner
as it's being destroyed. The only other reader at this point is
bpf_local_storage_map_free() which uses normal RCU.

The only path that needs trace RCU are:

* bpf_local_storage_{delete,update} helpers
* map_{delete,update}_elem() syscalls

Fixes: 0fe4b381a59e ("bpf: Allow bpf_local_storage to be used by sleepable programs")
Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20220418155158.2865678-1-kpsingh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_local_storage.h |    4 ++--
 kernel/bpf/bpf_inode_storage.c    |    4 ++--
 kernel/bpf/bpf_local_storage.c    |   29 +++++++++++++++++++----------
 kernel/bpf/bpf_task_storage.c     |    4 ++--
 net/core/bpf_sk_storage.c         |    6 +++---
 5 files changed, 28 insertions(+), 19 deletions(-)

--- a/include/linux/bpf_local_storage.h
+++ b/include/linux/bpf_local_storage.h
@@ -143,9 +143,9 @@ void bpf_selem_link_storage_nolock(struc
 
 bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 				     struct bpf_local_storage_elem *selem,
-				     bool uncharge_omem);
+				     bool uncharge_omem, bool use_trace_rcu);
 
-void bpf_selem_unlink(struct bpf_local_storage_elem *selem);
+void bpf_selem_unlink(struct bpf_local_storage_elem *selem, bool use_trace_rcu);
 
 void bpf_selem_link_map(struct bpf_local_storage_map *smap,
 			struct bpf_local_storage_elem *selem);
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -90,7 +90,7 @@ void bpf_inode_storage_free(struct inode
 		 */
 		bpf_selem_unlink_map(selem);
 		free_inode_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, false);
+			local_storage, selem, false, false);
 	}
 	raw_spin_unlock_bh(&local_storage->lock);
 	rcu_read_unlock();
@@ -149,7 +149,7 @@ static int inode_storage_delete(struct i
 	if (!sdata)
 		return -ENOENT;
 
-	bpf_selem_unlink(SELEM(sdata));
+	bpf_selem_unlink(SELEM(sdata), true);
 
 	return 0;
 }
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -106,7 +106,7 @@ static void bpf_selem_free_rcu(struct rc
  */
 bool bpf_selem_unlink_storage_nolock(struct bpf_local_storage *local_storage,
 				     struct bpf_local_storage_elem *selem,
-				     bool uncharge_mem)
+				     bool uncharge_mem, bool use_trace_rcu)
 {
 	struct bpf_local_storage_map *smap;
 	bool free_local_storage;
@@ -150,11 +150,16 @@ bool bpf_selem_unlink_storage_nolock(str
 	    SDATA(selem))
 		RCU_INIT_POINTER(local_storage->cache[smap->cache_idx], NULL);
 
-	call_rcu_tasks_trace(&selem->rcu, bpf_selem_free_rcu);
+	if (use_trace_rcu)
+		call_rcu_tasks_trace(&selem->rcu, bpf_selem_free_rcu);
+	else
+		kfree_rcu(selem, rcu);
+
 	return free_local_storage;
 }
 
-static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem)
+static void __bpf_selem_unlink_storage(struct bpf_local_storage_elem *selem,
+				       bool use_trace_rcu)
 {
 	struct bpf_local_storage *local_storage;
 	bool free_local_storage = false;
@@ -169,12 +174,16 @@ static void __bpf_selem_unlink_storage(s
 	raw_spin_lock_irqsave(&local_storage->lock, flags);
 	if (likely(selem_linked_to_storage(selem)))
 		free_local_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, true);
+			local_storage, selem, true, use_trace_rcu);
 	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 
-	if (free_local_storage)
-		call_rcu_tasks_trace(&local_storage->rcu,
+	if (free_local_storage) {
+		if (use_trace_rcu)
+			call_rcu_tasks_trace(&local_storage->rcu,
 				     bpf_local_storage_free_rcu);
+		else
+			kfree_rcu(local_storage, rcu);
+	}
 }
 
 void bpf_selem_link_storage_nolock(struct bpf_local_storage *local_storage,
@@ -214,14 +223,14 @@ void bpf_selem_link_map(struct bpf_local
 	raw_spin_unlock_irqrestore(&b->lock, flags);
 }
 
-void bpf_selem_unlink(struct bpf_local_storage_elem *selem)
+void bpf_selem_unlink(struct bpf_local_storage_elem *selem, bool use_trace_rcu)
 {
 	/* Always unlink from map before unlinking from local_storage
 	 * because selem will be freed after successfully unlinked from
 	 * the local_storage.
 	 */
 	bpf_selem_unlink_map(selem);
-	__bpf_selem_unlink_storage(selem);
+	__bpf_selem_unlink_storage(selem, use_trace_rcu);
 }
 
 struct bpf_local_storage_data *
@@ -454,7 +463,7 @@ bpf_local_storage_update(void *owner, st
 	if (old_sdata) {
 		bpf_selem_unlink_map(SELEM(old_sdata));
 		bpf_selem_unlink_storage_nolock(local_storage, SELEM(old_sdata),
-						false);
+						false, true);
 	}
 
 unlock:
@@ -532,7 +541,7 @@ void bpf_local_storage_map_free(struct b
 				migrate_disable();
 				__this_cpu_inc(*busy_counter);
 			}
-			bpf_selem_unlink(selem);
+			bpf_selem_unlink(selem, false);
 			if (busy_counter) {
 				__this_cpu_dec(*busy_counter);
 				migrate_enable();
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -102,7 +102,7 @@ void bpf_task_storage_free(struct task_s
 		 */
 		bpf_selem_unlink_map(selem);
 		free_task_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, false);
+			local_storage, selem, false, false);
 	}
 	raw_spin_unlock_irqrestore(&local_storage->lock, flags);
 	bpf_task_storage_unlock();
@@ -191,7 +191,7 @@ static int task_storage_delete(struct ta
 	if (!sdata)
 		return -ENOENT;
 
-	bpf_selem_unlink(SELEM(sdata));
+	bpf_selem_unlink(SELEM(sdata), true);
 
 	return 0;
 }
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -40,7 +40,7 @@ static int bpf_sk_storage_del(struct soc
 	if (!sdata)
 		return -ENOENT;
 
-	bpf_selem_unlink(SELEM(sdata));
+	bpf_selem_unlink(SELEM(sdata), true);
 
 	return 0;
 }
@@ -75,8 +75,8 @@ void bpf_sk_storage_free(struct sock *sk
 		 * sk_storage.
 		 */
 		bpf_selem_unlink_map(selem);
-		free_sk_storage = bpf_selem_unlink_storage_nolock(sk_storage,
-								  selem, true);
+		free_sk_storage = bpf_selem_unlink_storage_nolock(
+			sk_storage, selem, true, false);
 	}
 	raw_spin_unlock_bh(&sk_storage->lock);
 	rcu_read_unlock();


