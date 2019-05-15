Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995321F228
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbfEOLOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729601AbfEOLOA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:14:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 870C720843;
        Wed, 15 May 2019 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918840;
        bh=Y87KmI3co308UEE0i8ML6W4v7reqTLE/52R1lrcrR1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0efntzK2z5PekJqfQVUJNgoIcC6gWbuUgwtOtHEwvoHdVJacROQQEeCJokIa5fSD
         ZLRYOyC6+cN313xwDXlKcrHgi8Oic8P2WRD8zZRmO1j6HP31COg0Er00FwNvceLnFI
         9UAZrsvJACYzNPhgUCnLeemVtom7YzXpk97Hd0B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Perry <jonperry@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Chenbo Feng <fengc@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/51] bpf: fix struct htab_elem layout
Date:   Wed, 15 May 2019 12:55:37 +0200
Message-Id: <20190515090618.200974773@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 9f691549f76d488a0c74397b3e51e943865ea01f upstream.

when htab_elem is removed from the bucket list the htab_elem.hash_node.next
field should not be overridden too early otherwise we have a tiny race window
between lookup and delete.
The bug was discovered by manual code analysis and reproducible
only with explicit udelay() in lookup_elem_raw().

Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
Reported-by: Jonathan Perry <jonperry@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chenbo Feng <fengc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index a36a532c056df..f9d53ac57f640 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -41,8 +41,13 @@ enum extra_elem_state {
 struct htab_elem {
 	union {
 		struct hlist_node hash_node;
-		struct bpf_htab *htab;
-		struct pcpu_freelist_node fnode;
+		struct {
+			void *padding;
+			union {
+				struct bpf_htab *htab;
+				struct pcpu_freelist_node fnode;
+			};
+		};
 	};
 	union {
 		struct rcu_head rcu;
@@ -114,8 +119,10 @@ static int prealloc_elems_and_freelist(struct bpf_htab *htab)
 	if (err)
 		goto free_elems;
 
-	pcpu_freelist_populate(&htab->freelist, htab->elems, htab->elem_size,
-			       htab->map.max_entries);
+	pcpu_freelist_populate(&htab->freelist,
+			       htab->elems + offsetof(struct htab_elem, fnode),
+			       htab->elem_size, htab->map.max_entries);
+
 	return 0;
 
 free_elems:
@@ -148,6 +155,11 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	int err, i;
 	u64 cost;
 
+	BUILD_BUG_ON(offsetof(struct htab_elem, htab) !=
+		     offsetof(struct htab_elem, hash_node.pprev));
+	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
+		     offsetof(struct htab_elem, hash_node.pprev));
+
 	if (attr->map_flags & ~BPF_F_NO_PREALLOC)
 		/* reserved bits should not be used */
 		return ERR_PTR(-EINVAL);
@@ -429,9 +441,13 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 	int err = 0;
 
 	if (prealloc) {
-		l_new = (struct htab_elem *)pcpu_freelist_pop(&htab->freelist);
-		if (!l_new)
+		struct pcpu_freelist_node *l;
+
+		l = pcpu_freelist_pop(&htab->freelist);
+		if (!l)
 			err = -E2BIG;
+		else
+			l_new = container_of(l, struct htab_elem, fnode);
 	} else {
 		if (atomic_inc_return(&htab->count) > htab->map.max_entries) {
 			atomic_dec(&htab->count);
-- 
2.20.1



