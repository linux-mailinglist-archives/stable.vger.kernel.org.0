Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44F140A0DF
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349457AbhIMWme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349456AbhIMWkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:40:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D4BD61361;
        Mon, 13 Sep 2021 22:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572561;
        bh=z3fD1eXLu52vtiK1cOfP6pjzNLL6Ku0x60Rfm6bw5pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TmbAxIy8VAY91dbGDwNPALfkTHU1FmH+Biw76n71OiHyjFigoFFpVxUIQbwes27kv
         Oi6g0OLj3OUMFgfLFyNxaNx5A1LPVQuIpa5IxtTa5b2HM35AHo90YD9LyCZLEvonH1
         bVum3b5EFFofdn+bdTgiYOdpFUUxuFaRyAZTX9hymjxEZyzG5azaIgsA1dQHHxOa3D
         DCxMKKDzIxEpQR/u5PKb1pR+rxIPx7lZF9ZC+e0znghIXZT7u83uyeM7G08k2+2LVc
         ccwfFnfuZ0UJEF/5JFuewZOFLR9sQ0lmBHJWLweYMUKiUwiumh7aRJxo3hslq9qzks
         d/c3qbYglWgjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 9/9] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date:   Mon, 13 Sep 2021 18:35:49 -0400
Message-Id: <20210913223549.436541-9-sashal@kernel.org>
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

