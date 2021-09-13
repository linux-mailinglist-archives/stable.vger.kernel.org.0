Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0252640A0FC
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbhIMWnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348889AbhIMWlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7374861374;
        Mon, 13 Sep 2021 22:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572572;
        bh=dzUQnti8MmQJQ7i89aFR2fr9cSQlYJvtm7gB5SOnJFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZHsPOazlM6Akhns13u6Y7Sl5fj8JTiDy+B9Ji0JhkQA8zd0D+rtFF1zHFmm3ij7Y
         kVrGr0y4nBn/mA0iFUjATffILJzwmrTRSBUFNSOJQv+t0VebZw6BcRiLL17mauBI/L
         TkYJCqkNRfI7RNOyvl7mCwQEZLDlYU5Fg+yzHHYG0S3Iz5KpJ6liQgYelWtTGFko04
         cAqnnO8nYKaV3FvWH1FWcskB8iiU7kaqvuE6Hrfta7m7aUge7CaHADCSsP3kX7ggYq
         ROgF8LoZTqchjr2j72AunPJP/IwZo6GRvPKEfcXqRpnSgicoYwhG06wdYsq2RVgpxp
         h15/ixACN1e2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 8/8] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date:   Mon, 13 Sep 2021 18:36:01 -0400
Message-Id: <20210913223601.436675-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223601.436675-1-sashal@kernel.org>
References: <20210913223601.436675-1-sashal@kernel.org>
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
index 73d872a24a21..49a148ebbcda 100644
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

