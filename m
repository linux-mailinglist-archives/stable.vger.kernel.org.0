Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC6640A0D0
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348994AbhIMWmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349385AbhIMWj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B64B061216;
        Mon, 13 Sep 2021 22:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572548;
        bh=z3fD1eXLu52vtiK1cOfP6pjzNLL6Ku0x60Rfm6bw5pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2OQc21lqC3f01U0uCc6Q6Gbzzzw1VurRPIYCZxBv37cz8LVgb7EVT31Q07m6U1lY
         jYeRYdTdCSyiOjs5Wqe2MSvx8eb59G3y7hFx2djFP6Ru2zRs0bkAlQa7sWOw153IXb
         OiiUag9CTI7dRiHT2Fmm1IqEpzhK8XLRQ8X7skTQEuVee/pHf88+MLxqDNn6T7b3ot
         AXIw0ZEmHd1QkFLfTV9luKcQkZhv0lS5BuVfn3AOyExd7c18ul55eSxKOKNwzZQfG9
         DMeAo6KYN2eyXnefUs6YoYU/V0QQHC9hC+9vLQALW2vtjy+F5wf5cKmWHRCiaR1Tvz
         8cCgiOOIkJf9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 9/9] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date:   Mon, 13 Sep 2021 18:35:35 -0400
Message-Id: <20210913223535.436405-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223535.436405-1-sashal@kernel.org>
References: <20210913223535.436405-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit 17243e1c3072b8417a5ebfc53065d0a87af7ca77 ]

kobject_put() should be used to cleanup the memory associated with the
kobject instead of kobject_del().  See the section "Kobject removal" of
"Documentation/core-api/kobject.rst".

Link: https://lkml.kernel.org/r/20210629022556.3985106-7-sunnanyong@huawei.com
Link: https://lkml.kernel.org/r/1625651306-10829-7-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 28f5572c6aae..33fba75aa9f3 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -224,7 +224,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
-- 
2.30.2

