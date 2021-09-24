Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6550641751C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345726AbhIXNO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346632AbhIXNKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D3E461555;
        Fri, 24 Sep 2021 12:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488282;
        bh=UeBROoZE8I14fO4wH1+GgC1sxKy7eBLxxiwXXDRBVzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nv7c1wVbDT2rb+jNXJlM0fJgdMT68LEriyAyebg4Oki37FyFfLqXGfAYRgnk1ViWg
         gszc8r8zIY8oqWf359mB+n/DseQXIkh4awCw5QADmgak3fFwo7u3i2Pcz1c9SHYxU7
         txdmskaMgYb9HR9cT7eVbn0cnN71kyypylkCRags=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 53/63] nilfs2: fix memory leak in nilfs_sysfs_create_snapshot_group
Date:   Fri, 24 Sep 2021 14:44:53 +0200
Message-Id: <20210924124336.095937907@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 34893a57a7b9..44b9ad70a564 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -208,9 +208,9 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
-- 
2.33.0



