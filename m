Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B0439233
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 11:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhJYJYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 05:24:04 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:35893 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232371AbhJYJYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 05:24:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UtZwp5E_1635153697;
Received: from localhost.localdomain(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0UtZwp5E_1635153697)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 17:21:39 +0800
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
To:     akpm@linux-foundation.org, willy@infradead.org, song@kernel.org,
        william.kucharski@oracle.com, hughd@google.com, shy828301@gmail.com
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] mm, thp: fix incorrect unmap behavior for private pages
Date:   Mon, 25 Oct 2021 17:21:34 +0800
Message-Id: <20211025092134.18562-3-rongwei.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025092134.18562-1-rongwei.wang@linux.alibaba.com>
References: <20211025092134.18562-1-rongwei.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When truncating pagecache on file THP, the private pages
of a process should not be unmapped mapping. This
incorrect behavior on a dynamic shared libraries which
will cause related processes to happen core dump.

A simple test for a DSO (Prerequisite is the DSO mapped
in file THP):

int main(int argc, char *argv[])
{
	int fd;

	fd = open(argv[1], O_WRONLY);
	if (fd < 0) {
		perror("open");
	}

	close(fd);
	return 0;
}

The test only to open a target DSO, and do nothing. But
this operation will lead one or more process to happen
core dump. This patch mainly to fix this bug.

Fixes: eb6ecbed0aa2 ("mm, thp: relax the VM_DENYWRITE constraint on file-backed THPs")
Cc: <stable@vger.kernel.org>
Tested-by: Xu Yu <xuyu@linux.alibaba.com>
Signed-off-by: Rongwei Wang <rongwei.wang@linux.alibaba.com>
---
 fs/open.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index e73bf88e5060..f732fb94600c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -857,8 +857,17 @@ static int do_dentry_open(struct file *f,
 		 */
 		smp_mb();
 		if (filemap_nr_thps(inode->i_mapping)) {
+			struct address_space *mapping = inode->i_mapping;
+
 			filemap_invalidate_lock(inode->i_mapping);
-			truncate_pagecache(inode, 0);
+			/*
+			 * unmap_mapping_range just need to be called once
+			 * here, because the private pages is not need to be
+			 * unmapped mapping (e.g. data segment of dynamic
+			 * shared libraries here).
+			 */
+			unmap_mapping_range(mapping, 0, 0, 0);
+			truncate_inode_pages(mapping, 0);
 			filemap_invalidate_unlock(inode->i_mapping);
 		}
 	}
-- 
2.27.0

