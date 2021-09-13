Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB840A082
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349032AbhIMWjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343977AbhIMWhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4708C61262;
        Mon, 13 Sep 2021 22:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572521;
        bh=eQ3LCeWRN8D9/OAav1FmOG19LmXMe7aLh9WavSLwbbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Deq+iG95cL0ks/F+1LHVLtWxNxEfj9Iixw6FZBSm/wJBhq758+oUegB/TEgJRAwZG
         i9Ut5MJZDbmGwTltvC4Ky2SIPJf2Z0qk2MA4yk5mJ6tVpVN4/29o+JWonsNRfTcCuM
         t2Kc7i4u7ndOZmti/w5ChYxCtpuR8iu+dwz5NbZTyxQqJ/cWt8GdRhu2aG90Lk4eFl
         AxbyvM+WtMbUfq9ja9CQYRLOPdTGLt9UGK91c7IKss+B78kgkL9TFshdgK+CA+CNJF
         8qrHqgxCTK1jyvjY5b95p8TbndUc2Gm7Hqb2wyiY6F3rsZHUnv+5shw3X4NvpSowyI
         HYm2T0TisSmxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/12] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date:   Mon, 13 Sep 2021 18:35:04 -0400
Message-Id: <20210913223504.436087-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223504.436087-1-sashal@kernel.org>
References: <20210913223504.436087-1-sashal@kernel.org>
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
index 6c92ac314b06..28a2db3b1787 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -215,7 +215,7 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
-- 
2.30.2

