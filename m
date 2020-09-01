Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394F32593C3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgIAPan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729373AbgIAPak (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:30:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 472AD20767;
        Tue,  1 Sep 2020 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974240;
        bh=Zd9trFmb/P/F9p8nDs9AnkiHR6lVNPcpkIQyVaBL0kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvvYUxDonjQfRpW2KCBUVksnl2gPX11bNU8hnug7jG8lbx3ZPYFYMXgR9TqdkpZRx
         qY6Yrv6qk+ArOhIFF2BRVFmNWs/jG7YKErMNRCQprBU+AVxNc35Fagb3v2WmCMQonn
         2BDc8PYkSYS6Rue63/bHYsiLLYgTDoFAfbGIgefo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com,
        Amir Goldstein <amir73il@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Colin Walters <walters@verbum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/214] hugetlbfs: prevent filesystem stacking of hugetlbfs
Date:   Tue,  1 Sep 2020 17:08:59 +0200
Message-Id: <20200901150955.817821964@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



