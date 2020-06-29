Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7424620E6E0
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404550AbgF2Vvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D4F2474F;
        Mon, 29 Jun 2020 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444069;
        bh=aR/n9YmbFGdYRzA85sOOciIhQUIcNMLgmVGFMBCDFl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKBOCN7m4mtRZ7FT7VQdvpo9nche5LLGmLYKQBDbqO2+xYGUrXf3iYQmbqPQ4JBzn
         qsj7YM2HCkM15ihvnSSA7bVvq0WQpdyNhI2RLAUBXu4Rg1CbvFYuH1tQpKBiRXoW85
         GzBQLExsYLRa6JKkJl3vjzg6rk2ggJYZJrR+X2rQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 178/265] afs: Fix storage of cell names
Date:   Mon, 29 Jun 2020 11:16:51 -0400
Message-Id: <20200629151818.2493727-179-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 719fdd32921fb7e3208db8832d32ae1c2d68900f ]

The cell name stored in the afs_cell struct is a 64-char + NUL buffer -
when it needs to be able to handle up to AFS_MAXCELLNAME (256 chars) + NUL.

Fix this by changing the array to a pointer and allocating the string.

Found using Coverity.

Fixes: 989782dcdc91 ("afs: Overhaul cell database management")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c     | 9 +++++++++
 fs/afs/internal.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 78ba5f9322879..296b489861a9a 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -154,10 +154,17 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	cell->name = kmalloc(namelen + 1, GFP_KERNEL);
+	if (!cell->name) {
+		kfree(cell);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	cell->net = net;
 	cell->name_len = namelen;
 	for (i = 0; i < namelen; i++)
 		cell->name[i] = tolower(name[i]);
+	cell->name[i] = 0;
 
 	atomic_set(&cell->usage, 2);
 	INIT_WORK(&cell->manager, afs_manage_cell);
@@ -203,6 +210,7 @@ parse_failed:
 	if (ret == -EINVAL)
 		printk(KERN_ERR "kAFS: bad VL server IP address\n");
 error:
+	kfree(cell->name);
 	kfree(cell);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
@@ -483,6 +491,7 @@ static void afs_cell_destroy(struct rcu_head *rcu)
 
 	afs_put_vlserverlist(cell->net, rcu_access_pointer(cell->vl_servers));
 	key_put(cell->anonymous_key);
+	kfree(cell->name);
 	kfree(cell);
 
 	_leave(" [destroyed]");
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 98e0cebd5e5e9..c67a9767397d0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -397,7 +397,7 @@ struct afs_cell {
 	struct afs_vlserver_list __rcu *vl_servers;
 
 	u8			name_len;	/* Length of name */
-	char			name[64 + 1];	/* Cell name, case-flattened and NUL-padded */
+	char			*name;		/* Cell name, case-flattened and NUL-padded */
 };
 
 /*
-- 
2.25.1

