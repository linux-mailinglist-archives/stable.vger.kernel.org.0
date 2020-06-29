Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE820E84A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgF2WFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:05:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgF2SfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE4B246CE;
        Mon, 29 Jun 2020 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444020;
        bh=f8wWRBJu0xVCp0JlyfTc7Lt1H4gqJ376r6jAqEgVev0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/oD33WVMxmCOpXy4kav837aZr/P4NhsJU499GzZ1H4pHzCRNWXobdHtnDk9vvKeF
         cjhRddufqTycSVpIVNsVtfBpS5xuuZxvDSx6NHhEveIfVQnYoUW7CiKiPXzTfrxqBm
         9Tq6lz6QPOv5bKJJFl45RQJtUB/3mKolr5oJ5xKk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Xiumei Mu <xmu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 127/265] devmap: Use bpf_map_area_alloc() for allocating hash buckets
Date:   Mon, 29 Jun 2020 11:16:00 -0400
Message-Id: <20200629151818.2493727-128-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 99c51064fb06146b3d494b745c947e438a10aaa7 ]

Syzkaller discovered that creating a hash of type devmap_hash with a large
number of entries can hit the memory allocator limit for allocating
contiguous memory regions. There's really no reason to use kmalloc_array()
directly in the devmap code, so just switch it to the existing
bpf_map_area_alloc() function that is used elsewhere.

Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200616142829.114173-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/devmap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 58bdca5d978a8..badf382bbd365 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -85,12 +85,13 @@ static DEFINE_PER_CPU(struct list_head, dev_flush_list);
 static DEFINE_SPINLOCK(dev_map_lock);
 static LIST_HEAD(dev_map_list);
 
-static struct hlist_head *dev_map_create_hash(unsigned int entries)
+static struct hlist_head *dev_map_create_hash(unsigned int entries,
+					      int numa_node)
 {
 	int i;
 	struct hlist_head *hash;
 
-	hash = kmalloc_array(entries, sizeof(*hash), GFP_KERNEL);
+	hash = bpf_map_area_alloc(entries * sizeof(*hash), numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -138,7 +139,8 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 		return -EINVAL;
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets);
+		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
+							   dtab->map.numa_node);
 		if (!dtab->dev_index_head)
 			goto free_charge;
 
@@ -223,7 +225,7 @@ static void dev_map_free(struct bpf_map *map)
 			}
 		}
 
-		kfree(dtab->dev_index_head);
+		bpf_map_area_free(dtab->dev_index_head);
 	} else {
 		for (i = 0; i < dtab->map.max_entries; i++) {
 			struct bpf_dtab_netdev *dev;
-- 
2.25.1

