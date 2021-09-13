Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6C40A0DB
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349015AbhIMWma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237347AbhIMWk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E5A61248;
        Mon, 13 Sep 2021 22:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572559;
        bh=DTLkUcX8uZmbCVP4ckZc+XfsJHIBYPUK8tiOu761O4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbGOrCMmmNetvR17PPPRnT+dvGIIwnJHUHFAIeq1Ut6TYSNMbffVreXzWn7fq7IQa
         gWyzxMDqAJ+0bG774hjbzT6Ws+i72MAJ4hWCeYR877xFm4vUCsBDiDsgrtTp2h6VPn
         3jW27afqnRL7gWvxVNuBimBMfqYJMWA/4E4lKU334mCfulhtW3MfgzEHDu/HgJtmdv
         RsIoqpHGsilhE9/TKHne/PRsbL3ctky6wecYHatyio9HkcuP8DerRanDWc0T6LtNwN
         z6nS/2JyBBp+ucuXPZsWzBwVw1kAWVkXKAX7nx0coMs7kJ7ca0aXh3m9KYbAF8WT34
         YFJSKgXk9KvQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 8/9] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date:   Mon, 13 Sep 2021 18:35:48 -0400
Message-Id: <20210913223549.436541-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223549.436541-1-sashal@kernel.org>
References: <20210913223549.436541-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit b2fe39c248f3fa4bbb2a20759b4fdd83504190f7 ]

If kobject_init_and_add returns with error, kobject_put() is needed here
to avoid memory leak, because kobject_init_and_add may return error
without freeing the memory associated with the kobject it allocated.

Link: https://lkml.kernel.org/r/20210629022556.3985106-6-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-6-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 31eed118d0ce..28f5572c6aae 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -217,9 +217,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
-- 
2.30.2

