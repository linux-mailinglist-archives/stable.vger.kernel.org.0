Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFED4418E1
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhKAJwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234427AbhKAJut (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 241DA61051;
        Mon,  1 Nov 2021 09:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759129;
        bh=AHOhMrl6UucbvEgAhr926CsU4dpASyMQh7skXV0Ck3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DL/SD8VIVv7kfyjHc0pIRUtr8CJUfAqP0Q27bq0dqCnYxf2IfkT9uZQvlpcJkP9/g
         V88LK67QS5T79WYZ+wgV21SPEld1MFGLCIpEi2eB/AC9kS1RxuOSAfX/uAfya+3cJE
         Ocr2LSIMo7uwcY5omUh87+lcrVGmVTGe6XOG1tU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 106/125] bpf: Use kvmalloc for map values in syscall
Date:   Mon,  1 Nov 2021 10:17:59 +0100
Message-Id: <20211101082553.197734079@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit f0dce1d9b7c81fc3dc9d0cc0bc7ef9b3eae22584 ]

Use kvmalloc/kvfree for temporary value when manipulating a map via
syscall. kmalloc might not be sufficient for percpu maps where the value
is big (and further multiplied by hundreds of CPUs).

Can be reproduced with netcnt test on qemu with "-smp 255".

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20210818235216.1159202-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d245061ba318..92ed4b2984b8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1066,7 +1066,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1081,7 +1081,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 	err = 0;
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
@@ -1127,16 +1127,10 @@ static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 		goto err_put;
 	}
 
-	if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
-	    map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
-		value_size = round_up(map->value_size, 8) * num_possible_cpus();
-	else
-		value_size = map->value_size;
+	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1147,7 +1141,7 @@ static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 	err = bpf_map_update_value(map, f, key, value, attr->flags);
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
@@ -1356,7 +1350,7 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!key)
 		return -ENOMEM;
 
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value) {
 		kfree(key);
 		return -ENOMEM;
@@ -1380,7 +1374,7 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
 
-	kfree(value);
+	kvfree(value);
 	kfree(key);
 	fdput(f);
 	return err;
@@ -1420,7 +1414,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	if (!buf_prevkey)
 		return -ENOMEM;
 
-	buf = kmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
+	buf = kvmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
 	if (!buf) {
 		kfree(buf_prevkey);
 		return -ENOMEM;
@@ -1483,7 +1477,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 
 free_buf:
 	kfree(buf_prevkey);
-	kfree(buf);
+	kvfree(buf);
 	return err;
 }
 
@@ -1538,7 +1532,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	value_size = bpf_map_value_size(map);
 
 	err = -ENOMEM;
-	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
+	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value)
 		goto free_key;
 
@@ -1570,7 +1564,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 	err = 0;
 
 free_value:
-	kfree(value);
+	kvfree(value);
 free_key:
 	kfree(key);
 err_put:
-- 
2.33.0



