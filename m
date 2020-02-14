Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D76D15E8F2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391910AbgBNRDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392506AbgBNQPq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:15:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC83246E2;
        Fri, 14 Feb 2020 16:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696945;
        bh=nZ6V4uw3ZrXBLfZspGcx/9cmZIdgngtSWXyEIL1Y0As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkP00G9COKTfT5sx94gafS8qRZrfoZPyokO9gTfcFPjXo6xpDOZ0kInJ0Z+NudpNY
         oQKvOiu9JGU3vt76qKNMpORuTt/Inl7YpSZ9c/LcCsUhlhCYe2Pk8iXr/6AWyrotsg
         EBmfW6WKS3o8gxpYVJm9kEfkxd867mQV/qC2qtyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 187/252] f2fs: fix memleak of kobject
Date:   Fri, 14 Feb 2020 11:10:42 -0500
Message-Id: <20200214161147.15842-187-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit fe396ad8e7526f059f7b8c7290d33a1b84adacab ]

If kobject_init_and_add() failed, caller needs to invoke kobject_put()
to release kobject explicitly.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index b405548202d3b..9a59f49ba4050 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -658,10 +658,12 @@ int __init f2fs_init_sysfs(void)
 
 	ret = kobject_init_and_add(&f2fs_feat, &f2fs_feat_ktype,
 				   NULL, "features");
-	if (ret)
+	if (ret) {
+		kobject_put(&f2fs_feat);
 		kset_unregister(&f2fs_kset);
-	else
+	} else {
 		f2fs_proc_root = proc_mkdir("fs/f2fs", NULL);
+	}
 	return ret;
 }
 
@@ -682,8 +684,11 @@ int f2fs_register_sysfs(struct f2fs_sb_info *sbi)
 	init_completion(&sbi->s_kobj_unregister);
 	err = kobject_init_and_add(&sbi->s_kobj, &f2fs_sb_ktype, NULL,
 				"%s", sb->s_id);
-	if (err)
+	if (err) {
+		kobject_put(&sbi->s_kobj);
+		wait_for_completion(&sbi->s_kobj_unregister);
 		return err;
+	}
 
 	if (f2fs_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, f2fs_proc_root);
-- 
2.20.1

