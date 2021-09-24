Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D710417248
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343834AbhIXMr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343913AbhIXMqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:46:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A69A61263;
        Fri, 24 Sep 2021 12:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487501;
        bh=vZWHKSv42FCaUR+GqF5uloDitBwgn08r9izr/hJ+XqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goyfwgfj3NB7Eehau/sW9GXHGPtDQIz077YBbIDWjObB1JivJut83i1j52cMeCwUa
         lj503uPtC/Q+Zd7p4sZW/D3RQc5ZtEOwJPO/95dUW2R1kXEQfg6YXliRGGTCohYOie
         26aSk5QxOqtXELPmraKQJacfIraMLyW+cWmMya6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nanyong Sun <sunnanyong@huawei.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 20/23] nilfs2: fix memory leak in nilfs_sysfs_delete_snapshot_group
Date:   Fri, 24 Sep 2021 14:44:01 +0200
Message-Id: <20210924124328.478548409@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124327.816210800@linuxfoundation.org>
References: <20210924124327.816210800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



