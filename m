Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14AD35CBCB
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfGBIES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbfGBIEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DCD121848;
        Tue,  2 Jul 2019 08:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054654;
        bh=+xS1LmssqxErT9qWaTx18oNA8+k4W6Pln922osslIXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBtUvZeGXD79EEkW96Zh7hwzxf2fJAbp8t16GBrY5hQp+ewM+Xc+cM5YEJSsuIAbl
         YjUPQnSq0w1iDz4lftM38+oDhVo80YP7XjYx/iZrTJICWGnfrzKzZgzzPXIWUHd8ha
         nRbPcsQAkfW6BXaVhNBGez9lbGqkw3OtBXoxe7tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.1 45/55] bpf: lpm_trie: check left child of last leftmost node for NULL
Date:   Tue,  2 Jul 2019 10:01:53 +0200
Message-Id: <20190702080126.431826442@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

commit da2577fdd0932ea4eefe73903f1130ee366767d2 upstream.

If the leftmost parent node of the tree has does not have a child
on the left side, then trie_get_next_key (and bpftool map dump) will
not look at the child on the right.  This leads to the traversal
missing elements.

Lookup is not affected.

Update selftest to handle this case.

Reproducer:

 bpftool map create /sys/fs/bpf/lpm type lpm_trie key 6 \
     value 1 entries 256 name test_lpm flags 1
 bpftool map update pinned /sys/fs/bpf/lpm key  8 0 0 0  0   0 value 1
 bpftool map update pinned /sys/fs/bpf/lpm key 16 0 0 0  0 128 value 2
 bpftool map dump   pinned /sys/fs/bpf/lpm

Returns only 1 element. (2 expected)

Fixes: b471f2f1de8b ("bpf: implement MAP_GET_NEXT_KEY command for LPM_TRIE")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/lpm_trie.c                      |    9 ++++--
 tools/testing/selftests/bpf/test_lpm_map.c |   41 ++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 5 deletions(-)

--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -715,9 +715,14 @@ find_leftmost:
 	 * have exact two children, so this function will never return NULL.
 	 */
 	for (node = search_root; node;) {
-		if (!(node->flags & LPM_TREE_NODE_FLAG_IM))
+		if (node->flags & LPM_TREE_NODE_FLAG_IM) {
+			node = rcu_dereference(node->child[0]);
+		} else {
 			next_node = node;
-		node = rcu_dereference(node->child[0]);
+			node = rcu_dereference(node->child[0]);
+			if (!node)
+				node = rcu_dereference(next_node->child[1]);
+		}
 	}
 do_copy:
 	next_key->prefixlen = next_node->prefixlen;
--- a/tools/testing/selftests/bpf/test_lpm_map.c
+++ b/tools/testing/selftests/bpf/test_lpm_map.c
@@ -573,13 +573,13 @@ static void test_lpm_get_next_key(void)
 
 	/* add one more element (total two) */
 	key_p->prefixlen = 24;
-	inet_pton(AF_INET, "192.168.0.0", key_p->data);
+	inet_pton(AF_INET, "192.168.128.0", key_p->data);
 	assert(bpf_map_update_elem(map_fd, key_p, &value, 0) == 0);
 
 	memset(key_p, 0, key_size);
 	assert(bpf_map_get_next_key(map_fd, NULL, key_p) == 0);
 	assert(key_p->prefixlen == 24 && key_p->data[0] == 192 &&
-	       key_p->data[1] == 168 && key_p->data[2] == 0);
+	       key_p->data[1] == 168 && key_p->data[2] == 128);
 
 	memset(next_key_p, 0, key_size);
 	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
@@ -592,7 +592,7 @@ static void test_lpm_get_next_key(void)
 
 	/* Add one more element (total three) */
 	key_p->prefixlen = 24;
-	inet_pton(AF_INET, "192.168.128.0", key_p->data);
+	inet_pton(AF_INET, "192.168.0.0", key_p->data);
 	assert(bpf_map_update_elem(map_fd, key_p, &value, 0) == 0);
 
 	memset(key_p, 0, key_size);
@@ -628,6 +628,41 @@ static void test_lpm_get_next_key(void)
 	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
 	assert(next_key_p->prefixlen == 24 && next_key_p->data[0] == 192 &&
 	       next_key_p->data[1] == 168 && next_key_p->data[2] == 1);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 24 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168 && next_key_p->data[2] == 128);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 16 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
+	       errno == ENOENT);
+
+	/* Add one more element (total five) */
+	key_p->prefixlen = 28;
+	inet_pton(AF_INET, "192.168.1.128", key_p->data);
+	assert(bpf_map_update_elem(map_fd, key_p, &value, 0) == 0);
+
+	memset(key_p, 0, key_size);
+	assert(bpf_map_get_next_key(map_fd, NULL, key_p) == 0);
+	assert(key_p->prefixlen == 24 && key_p->data[0] == 192 &&
+	       key_p->data[1] == 168 && key_p->data[2] == 0);
+
+	memset(next_key_p, 0, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 28 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168 && next_key_p->data[2] == 1 &&
+	       next_key_p->data[3] == 128);
+
+	memcpy(key_p, next_key_p, key_size);
+	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);
+	assert(next_key_p->prefixlen == 24 && next_key_p->data[0] == 192 &&
+	       next_key_p->data[1] == 168 && next_key_p->data[2] == 1);
 
 	memcpy(key_p, next_key_p, key_size);
 	assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == 0);


