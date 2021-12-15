Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEC74750AA
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 03:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbhLOCC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 21:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbhLOCC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 21:02:29 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018D5C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:02:29 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id 4-20020a170902c20400b0014381f710d5so5902518pll.11
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FlzDF6nhPiY5bpjYDzWkdMAw8xJHwqi+9SwOSC1TqQQ=;
        b=gvMHn2DKFP4sGv3qDKGW4d2ABdFHAP/SO68b4r5vHIiBfLoa4fG1kxYAs24WArfRgr
         ehh+TLuTJloXru2UugbSR72EScRJ3ItKrCKXURfbZzoA57/KeIl7J4m5QI7vEB+RFBhe
         Vluw+vadg51IoXreaJdIZYwRUbnvj8rWBLCqlEA3EeuxVCX3J8jamznEeMnLo++wrsL4
         GF4oDs8+gJfRVNYMBjGFyUreuJjqgaskIxzKIXC+wxRjdNzqgg6mRi2WHjDtGYAxLyX4
         nLUxg0NIdC185huuAfb/rIQepW8Fl+Zao3Sa07BYYIzvvePtu32Pwa+M/U9sLfyY4Sh/
         uBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FlzDF6nhPiY5bpjYDzWkdMAw8xJHwqi+9SwOSC1TqQQ=;
        b=RttxVjFMcaoon3Dr1bKkiE7iFTCRPvPP4CwUYyvK2ofWv6q24hOwomODJXmejBSYwx
         1627vdRNJGw4IeMoJcPy/VoUmZtELkXwLR38Y3F+ExDQ/TbQ5sYavM4YTfDUTSXtII9c
         8JkI5MHXOjcxutAq7hoZCL2QmlLcPpRY2sVFcrU4wjPHE0whuvcYImeCXf9HZ4ObPuDx
         7B4m5c2mF4zG/ccPNb73Wody3+tSxHNkp+U51uZ0zrZfDn5Ju0NfIb/i+l1XpxI70VWp
         Gq2vDCU94S5IsL9ZsUu2YPckgI2j5mlelupZ4sdGGuTl+v9wwsWXVsrDkSTBePNbybiA
         JlFQ==
X-Gm-Message-State: AOAM530DND1dARkW7cusEQzdLBcjJD+5SXAd4jpp/Bzw9td88M8YMr6Q
        w01TPiNSHe0fDhs9n3W1l9VVYQfDX+mwZlz4DHx44may/eNiutyQPSok6G2dklJ9EEVQDGcLtWQ
        qwu41IvrT5pqWnqpZSFV5mwHTVUIsPZcGG9R3R+45qEHc5Dz1all0mPlTQ4DX1v7h
X-Google-Smtp-Source: ABdhPJzw9oJGnCP36DXfaVtGwaxqRjknFat5Dl4UPiWUHAHc6VZnWQeQ5cKUn5t8IQWa3xkMDDZe6WaKeJjN
X-Received: from connoro.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:a99])
 (user=connoro job=sendgmr) by 2002:aa7:9d1e:0:b0:494:6dec:6425 with SMTP id
 k30-20020aa79d1e000000b004946dec6425mr6906711pfp.83.1639533748295; Tue, 14
 Dec 2021 18:02:28 -0800 (PST)
Date:   Wed, 15 Dec 2021 02:01:39 +0000
Message-Id: <20211215020139.126521-1-connoro@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH] bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc
From:   "Connor O'Brien" <connoro@google.com>
To:     stable@vger.kernel.org
Cc:     Bui Quang Minh <minhquangbui99@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Connor O'Brien" <connoro@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit 7dd5d437c258bbf4cc15b35229e5208b87b8b4e0 upstream.

In 32-bit architecture, the result of sizeof() is a 32-bit integer so
the expression becomes the multiplication between 2 32-bit integer which
can potentially leads to integer overflow. As a result,
bpf_map_area_alloc() allocates less memory than needed.

Fix this by casting 1 operand to u64.

Fixes: 0d2c4f964050 ("bpf: Eliminate rlimit-based memory accounting for sockmap and sockhash maps")
Fixes: 99c51064fb06 ("devmap: Use bpf_map_area_alloc() for allocating hash buckets")
Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device references")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210613143440.71975-1-minhquangbui99@gmail.com
Signed-off-by: Connor O'Brien <connoro@google.com>
---
Hello,

This is for the 5.4 and 5.10 kernels.

Thanks,
Connor

 kernel/bpf/devmap.c | 4 ++--
 net/core/sock_map.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 6684696fa457..4b2819b0a05a 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -94,7 +94,7 @@ static struct hlist_head *dev_map_create_hash(unsigned int entries,
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc(entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -159,7 +159,7 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
-		dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
+		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index df52061f99f7..2646e8f98f67 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -48,7 +48,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	if (err)
 		goto free_stab;
 
-	stab->sks = bpf_map_area_alloc(stab->map.max_entries *
+	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (stab->sks)
-- 
2.34.1.173.g76aa8bc2d0-goog

