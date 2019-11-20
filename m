Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3D3103F6B
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbfKTPnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52870 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730105AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004ak-NU; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Ir-3L; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "ZhangXiaoxu" <zhangxiaoxu5@huawei.com>
Date:   Wed, 20 Nov 2019 15:37:53 +0000
Message-ID: <lsq.1574264230.960316735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 43/83] dm btree: fix order of block initialization in
 btree_split_beneath
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

commit e4f9d6013820d1eba1432d51dd1c5795759aa77f upstream.

When btree_split_beneath() splits a node to two new children, it will
allocate two blocks: left and right.  If right block's allocation
failed, the left block will be unlocked and marked dirty.  If this
happened, the left block'ss content is zero, because it wasn't
initialized with the btree struct before the attempot to allocate the
right block.  Upon return, when flushing the left block to disk, the
validator will fail when check this block.  Then a BUG_ON is raised.

Fix this by completely initializing the left block before allocating and
initializing the right block.

Fixes: 4dcb8b57df359 ("dm btree: fix leak of bufio-backed block in btree_split_beneath error path")
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/persistent-data/dm-btree.c | 31 ++++++++++++++-------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -533,39 +533,40 @@ static int btree_split_beneath(struct sh
 
 	new_parent = shadow_current(s);
 
+	pn = dm_block_data(new_parent);
+	size = le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
+		sizeof(__le64) : s->info->value_type.size;
+
+	/* create & init the left block */
 	r = new_block(s->info, &left);
 	if (r < 0)
 		return r;
 
+	ln = dm_block_data(left);
+	nr_left = le32_to_cpu(pn->header.nr_entries) / 2;
+
+	ln->header.flags = pn->header.flags;
+	ln->header.nr_entries = cpu_to_le32(nr_left);
+	ln->header.max_entries = pn->header.max_entries;
+	ln->header.value_size = pn->header.value_size;
+	memcpy(ln->keys, pn->keys, nr_left * sizeof(pn->keys[0]));
+	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
+
+	/* create & init the right block */
 	r = new_block(s->info, &right);
 	if (r < 0) {
 		unlock_block(s->info, left);
 		return r;
 	}
 
-	pn = dm_block_data(new_parent);
-	ln = dm_block_data(left);
 	rn = dm_block_data(right);
-
-	nr_left = le32_to_cpu(pn->header.nr_entries) / 2;
 	nr_right = le32_to_cpu(pn->header.nr_entries) - nr_left;
 
-	ln->header.flags = pn->header.flags;
-	ln->header.nr_entries = cpu_to_le32(nr_left);
-	ln->header.max_entries = pn->header.max_entries;
-	ln->header.value_size = pn->header.value_size;
-
 	rn->header.flags = pn->header.flags;
 	rn->header.nr_entries = cpu_to_le32(nr_right);
 	rn->header.max_entries = pn->header.max_entries;
 	rn->header.value_size = pn->header.value_size;
-
-	memcpy(ln->keys, pn->keys, nr_left * sizeof(pn->keys[0]));
 	memcpy(rn->keys, pn->keys + nr_left, nr_right * sizeof(pn->keys[0]));
-
-	size = le32_to_cpu(pn->header.flags) & INTERNAL_NODE ?
-		sizeof(__le64) : s->info->value_type.size;
-	memcpy(value_ptr(ln, 0), value_ptr(pn, 0), nr_left * size);
 	memcpy(value_ptr(rn, 0), value_ptr(pn, nr_left),
 	       nr_right * size);
 

