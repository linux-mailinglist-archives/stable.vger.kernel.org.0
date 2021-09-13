Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C56B409FE7
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244522AbhIMWft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348506AbhIMWfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C6D610FB;
        Mon, 13 Sep 2021 22:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572454;
        bh=KwiaTbPmsT4YO8Qo3dXcfQ3TTwgw1wvyf3TZaJv1R7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olJ1Bzh2c1sybXFz2G6nlRjcsvPIiCdlNRzk45ylrRWpcBtXweT+Nk/0ANRNYJvJ5
         0AZan+3GstV7HWEnHWgdaR5MeuZ7VV2Z9sy3Qz3fuI02tPze9QULfmgcQ7j5Wad5lH
         sv7uEZ9+ATEno7iM4lALmQp5OcKn4t0rXLZdOnixkVXnqU/be23C0uGG6ZvShUOr03
         QZwhF1qOYh+8+lsrfwIEUxBqIps7EAYGm1/zElgk00322w4JbC8/9J7ZRik1+4qcG8
         hOAnXFqvPxYQW9wZPgJVjgU/rP+B0Eq8Ni23t7pexA0UEkWPFWQim0DqfLEzxpQYgJ
         wFgBblBcgBpZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 25/25] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date:   Mon, 13 Sep 2021 18:33:39 -0400
Message-Id: <20210913223339.435347-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
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
index 5ba87573ad3b..62f8a7ac19c8 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -202,7 +202,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
-- 
2.30.2

