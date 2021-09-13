Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E840A0BF
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349326AbhIMWlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241402AbhIMWjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:39:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A6256124A;
        Mon, 13 Sep 2021 22:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572547;
        bh=DTLkUcX8uZmbCVP4ckZc+XfsJHIBYPUK8tiOu761O4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLnNJWzKv2KrcO9cjOvUWhqq3Mbf+pxWbczmvWBzObYr3s1D9zmkIIYOYzuTyodfc
         EingDB3ZPiKyn8+Rs9FaQ3/q3GW8Wa+NBAkZq/ohqqL4hYWA/Nt2IDoDAOeaHk92oi
         npCpvGHpbHZW5XIXKPBOvCYWUrYssxaZ9T7fAfX1CuDxwhMhI3zPMq1et0vfZb8NGj
         ytx8GXaYGQsOJTjLgdGVtL4DXIkvzDJxnbxSMXPYv/v835ErvW1G9xiimJpas1mAlb
         6h+xtWNqTOUjY3EzbqBCb5YuENpTsHeoNM362g30fw7S+kEH3Wss7RpodstLGC60dj
         rJhJaf4rHfhQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/9] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date:   Mon, 13 Sep 2021 18:35:34 -0400
Message-Id: <20210913223535.436405-8-sashal@kernel.org>
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

