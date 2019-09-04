Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C07A8E21
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbfIDR4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732038AbfIDR4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797B822CF5;
        Wed,  4 Sep 2019 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619775;
        bh=65wrpjWoktkSJp86Ap3AYdw1m1DK/ZBIbQ9wj+ThaWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtzoMC/ObOybUB0PXmFnvyETG4p2NcgBumVbz8/Oko5dhHuJGJBbf6DUXB4RKcJEX
         g4lOwQkvIJbo921XG3ig9WPAou/BmRjnw+dSNLf2p2kJk8qwcucMcX49DvuHG8lX2L
         dmTvWnqCZyhiICZLjuPIf0E8R46/vM/CTpc4VeEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.4 30/77] dm btree: fix order of block initialization in btree_split_beneath
Date:   Wed,  4 Sep 2019 19:53:17 +0200
Message-Id: <20190904175306.423975993@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-btree.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -616,39 +616,40 @@ static int btree_split_beneath(struct sh
 
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
 


