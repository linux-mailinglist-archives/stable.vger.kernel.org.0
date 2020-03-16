Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7FF18629C
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgCPCiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729989AbgCPCew (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BEA62073E;
        Mon, 16 Mar 2020 02:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326091;
        bh=OGv4NJMH6egSO3CM+oM4/EP7ikbuiFpvtEs66GSlFxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nal4SxkVifYfOzHjgZJOKQfGU7HRzJMLKeFkO1olo2uVviykxF0hkN/YOHASBbYu+
         jLzA/8pcWUoqurVRMgqVHMXKJ4hgnfblRF6PXTqjLy2VEi+CpFjUq9P+5x1gXwxugW
         JWgdaJy7rJh0NyThkAk+3GEl34YqoYZIQw+AOpsI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Carlo Nonato <carlo.nonato95@gmail.com>,
        Kwon Je Oh <kwonje.oh2@gmail.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org, cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/35] block, bfq: fix overwrite of bfq_group pointer in bfq_find_set_group()
Date:   Sun, 15 Mar 2020 22:34:10 -0400
Message-Id: <20200316023411.1263-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlo Nonato <carlo.nonato95@gmail.com>

[ Upstream commit 14afc59361976c0ba39e3a9589c3eaa43ebc7e1d ]

The bfq_find_set_group() function takes as input a blkcg (which represents
a cgroup) and retrieves the corresponding bfq_group, then it updates the
bfq internal group hierarchy (see comments inside the function for why
this is needed) and finally it returns the bfq_group.
In the hierarchy update cycle, the pointer holding the correct bfq_group
that has to be returned is mistakenly used to traverse the hierarchy
bottom to top, meaning that in each iteration it gets overwritten with the
parent of the current group. Since the update cycle stops at root's
children (depth = 2), the overwrite becomes a problem only if the blkcg
describes a cgroup at a hierarchy level deeper than that (depth > 2). In
this case the root's child that happens to be also an ancestor of the
correct bfq_group is returned. The main consequence is that processes
contained in a cgroup at depth greater than 2 are wrongly placed in the
group described above by BFQ.

This commits fixes this problem by using a different bfq_group pointer in
the update cycle in order to avoid the overwrite of the variable holding
the original group reference.

Reported-by: Kwon Je Oh <kwonje.oh2@gmail.com>
Signed-off-by: Carlo Nonato <carlo.nonato95@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index d0e36d6522649..86cd718e0380b 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -593,12 +593,13 @@ struct bfq_group *bfq_find_set_group(struct bfq_data *bfqd,
 	 */
 	entity = &bfqg->entity;
 	for_each_entity(entity) {
-		bfqg = container_of(entity, struct bfq_group, entity);
-		if (bfqg != bfqd->root_group) {
-			parent = bfqg_parent(bfqg);
+		struct bfq_group *curr_bfqg = container_of(entity,
+						struct bfq_group, entity);
+		if (curr_bfqg != bfqd->root_group) {
+			parent = bfqg_parent(curr_bfqg);
 			if (!parent)
 				parent = bfqd->root_group;
-			bfq_group_set_parent(bfqg, parent);
+			bfq_group_set_parent(curr_bfqg, parent);
 		}
 	}
 
-- 
2.20.1

