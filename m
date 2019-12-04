Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3EE112C0D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 13:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfLDMub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 07:50:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7632 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727781AbfLDMub (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 07:50:31 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B4FFCAB60272E40E78D7;
        Wed,  4 Dec 2019 20:50:28 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Dec 2019
 20:50:20 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <hughd@google.com>, <viro@zeniv.linux.org.uk>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>,
        <yukuai3@huawei.com>, <houtao1@huawei.com>
Subject: [4.19.y PATCH] tmpfs: fix unable to remount nr_inodes from limited to unlimited
Date:   Wed, 4 Dec 2019 21:11:37 +0800
Message-ID: <20191204131137.10388-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tmpfs support 'size', 'nr_blocks' and 'nr_inodes' mount options. mount or
remount them to zero means unlimited. 'size' and 'br_blocks' can remount
from limited to unlimited, while 'nr_inodes' can't.

The problem is fixed since upstream commit 0b5071dd323d ("
shmem_parse_options(): use a separate structure to keep the results"). But
in order to backport it, the amount of related patches need to backport is
huge. 

So, I made some local changes to fix the problem.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 mm/shmem.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3c8742655756..966fc69ee8fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3444,7 +3444,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
 	if (percpu_counter_compare(&sbinfo->used_blocks, config.max_blocks) > 0)
 		goto out;
-	if (config.max_inodes < inodes)
+	if (config.max_inodes && config.max_inodes < inodes)
 		goto out;
 	/*
 	 * Those tests disallow limited->unlimited while any are in use;
@@ -3460,7 +3460,10 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 	sbinfo->huge = config.huge;
 	sbinfo->max_blocks  = config.max_blocks;
 	sbinfo->max_inodes  = config.max_inodes;
-	sbinfo->free_inodes = config.max_inodes - inodes;
+	if (!config.max_inodes)
+		sbinfo->free_inodes = 0;
+	else
+		sbinfo->free_inodes = config.max_inodes - inodes;
 
 	/*
 	 * Preserve previous mempolicy unless mpol remount option was specified.
-- 
2.17.2

