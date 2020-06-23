Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA06206316
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgFWUQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388703AbgFWUQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63A4C2080C;
        Tue, 23 Jun 2020 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943401;
        bh=P5F2rZemRLTnANMPkKWHcAJrGkkcoo6QKlbcVU9KaQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zKdT1yZCHw6HkBecEQRRhFU2QVC5zWAD5A3Wzkxtj8loTqXvd9Ibac/C07sj26VKn
         axsXhuRppBekmayeI/IoEED/CTrH3CGZ3kv6TqgknzzijKb7ctEZZ7jS5A3D6NRKSv
         lRgfsWJP52yeuuzlorUlz6E+3V4afydY8AzsUWMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 378/477] bpf: Fix memlock accounting for sock_hash
Date:   Tue, 23 Jun 2020 21:56:15 +0200
Message-Id: <20200623195425.399940958@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

[ Upstream commit 60e5ca8a64bad8f3e2e20a1e57846e497361c700 ]

Add missed bpf_map_charge_init() in sock_hash_alloc() and
correspondingly bpf_map_charge_finish() on ENOMEM.

It was found accidentally while working on unrelated selftest that
checks "map->memory.pages > 0" is true for all map types.

Before:
	# bpftool m l
	...
	3692: sockhash  name m_sockhash  flags 0x0
		key 4B  value 4B  max_entries 8  memlock 0B

After:
	# bpftool m l
	...
	84: sockmap  name m_sockmap  flags 0x0
		key 4B  value 4B  max_entries 8  memlock 4096B

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200612000857.2881453-1-rdna@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 7e858c1dd7113..591457fcbd028 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -984,11 +984,15 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr *attr)
 		err = -EINVAL;
 		goto free_htab;
 	}
+	err = bpf_map_charge_init(&htab->map.memory, cost);
+	if (err)
+		goto free_htab;
 
 	htab->buckets = bpf_map_area_alloc(htab->buckets_num *
 					   sizeof(struct bpf_htab_bucket),
 					   htab->map.numa_node);
 	if (!htab->buckets) {
+		bpf_map_charge_finish(&htab->map.memory);
 		err = -ENOMEM;
 		goto free_htab;
 	}
-- 
2.25.1



