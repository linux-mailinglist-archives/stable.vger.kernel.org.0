Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17620DA3F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbgF2TzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387662AbgF2TkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28014248E2;
        Mon, 29 Jun 2020 15:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444435;
        bh=Zwd2UDIgV9gzJZvzusMDwP5lbmSKJVOpDo/8rnFUOwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qE59pdMk58sbLhYpYpMLB1SV3NSt69TbDJ5xECl7feGe1arlySD9/mSHgTaTDqg+Q
         WirU5aOMG16oTonfVOBwYpQDbqWVWG2H3+tVjScaFO1e23wdrzmCaR1r7f61xTjKzb
         XN/b4lNCdxxiTMmQXDdJFreKRP7jMcaxF5nDQ9Dw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/178] afs: Fix storage of cell names
Date:   Mon, 29 Jun 2020 11:24:19 -0400
Message-Id: <20200629152523.2494198-115-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
@@ -203,6 +210,7 @@ static struct afs_cell *afs_alloc_cell(struct afs_net *net,
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
index 555ad7c9afcb6..7fe88d918b238 100644
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

