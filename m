Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A604924DCA6
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgHURGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728240AbgHUQS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 12:18:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC3422BF5;
        Fri, 21 Aug 2020 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598026686;
        bh=Zd9trFmb/P/F9p8nDs9AnkiHR6lVNPcpkIQyVaBL0kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fzsGDqTZtLE+pvHmcrtpm2bb/41nJqq9ZxAmWGInJB+ch5fv7W6tJ9PQD6EQw7By
         4n31ww0vaAic9S8WaABom7/oZFCDsX5wtSFCqVm1zDBEOT5QzMrWFlj9sd01C8CSxA
         Ce0du8SOSWiyRkoBTmtQUCvsukx6fLehO3hXccKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com,
        Amir Goldstein <amir73il@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Colin Walters <walters@verbum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 48/48] hugetlbfs: prevent filesystem stacking of hugetlbfs
Date:   Fri, 21 Aug 2020 12:17:04 -0400
Message-Id: <20200821161704.348164-48-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821161704.348164-1-sashal@kernel.org>
References: <20200821161704.348164-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Kravetz <mike.kravetz@oracle.com>

[ Upstream commit 15568299b7d9988063afce60731df605ab236e2a ]

syzbot found issues with having hugetlbfs on a union/overlay as reported
in [1].  Due to the limitations (no write) and special functionality of
hugetlbfs, it does not work well in filesystem stacking.  There are no
know use cases for hugetlbfs stacking.  Rather than making modifications
to get hugetlbfs working in such environments, simply prevent stacking.

[1] https://lore.kernel.org/linux-mm/000000000000b4684e05a2968ca6@google.com/

Reported-by: syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Colin Walters <walters@verbum.org>
Link: http://lkml.kernel.org/r/80f869aa-810d-ef6c-8888-b46cee135907@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 40306c1eab07c..5fff7cb3582f0 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1284,6 +1284,12 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_magic = HUGETLBFS_MAGIC;
 	sb->s_op = &hugetlbfs_ops;
 	sb->s_time_gran = 1;
+
+	/*
+	 * Due to the special and limited functionality of hugetlbfs, it does
+	 * not work well as a stacking filesystem.
+	 */
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 	sb->s_root = d_make_root(hugetlbfs_get_root(sb, ctx));
 	if (!sb->s_root)
 		goto out_free;
-- 
2.25.1

