Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C44C3C5418
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351252AbhGLH5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234078AbhGLHwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D434761151;
        Mon, 12 Jul 2021 07:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076186;
        bh=enG2DySTu6vwZh44exzPR3f3UPPjmJkNOSXIn0v09QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dem6ZIMbShhh7w96ydyBJFc4UCzWYHZRiuKhEG1c52sqVqaKAvupxRDV5WJoG/gBs
         GZoon78G2GTsz2WRbtA7KM9+CQwzhjWTaDmuKiOoVqpSAGY3W00xtoXw6Q5aydYB8Q
         CUvqaWbL/p0cOCUMCjwMDAkb3KQonE741FM4NSWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 536/800] bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc
Date:   Mon, 12 Jul 2021 08:09:19 +0200
Message-Id: <20210712061024.370185928@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 7dd5d437c258bbf4cc15b35229e5208b87b8b4e0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 4 ++--
 net/core/sock_map.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index aa516472ce46..3b45c23286c0 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -92,7 +92,7 @@ static struct hlist_head *dev_map_create_hash(unsigned int entries,
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc(entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -143,7 +143,7 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
-		dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
+		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6f1b82b8ad49..60decd6420ca 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -48,7 +48,7 @@ static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
 
-	stab->sks = bpf_map_area_alloc(stab->map.max_entries *
+	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (!stab->sks) {
-- 
2.30.2



