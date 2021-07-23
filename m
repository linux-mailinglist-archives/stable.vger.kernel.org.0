Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29FB3D3320
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 06:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhGWDTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234063AbhGWDSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A49560F4C;
        Fri, 23 Jul 2021 03:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012764;
        bh=6u0yXNQpcaXNrtN0Gbilq+d+MPQrdxQw4dBqmzYX2Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXivHPjKlvU0JdzzOD4xm+xJAly2zPp54VIea9pOFik/kWGGXsOKlQuLXPAhOm+l2
         o1Bg9WEGUmEBBYhXIUK2LDMPdF/Lenafj+a5BPwnGqnHRVhdCZ2Ng8ikyuo6Z6xzDH
         XkMkRdppG3WamUWBw5hkfnKXtaonsyZWncfWmN1hlvX4iLZ3TvB5UfSIDMJ8hJeglL
         birThdN/OgzAsXz9ZKuBQkOIcOBi5zS+juFMDbHry6eQcNOHDianHWz7pUGsN+HZYf
         ZMe5+0/aYsW4Ntd8HmPo7iP2ZOXXNgUrrJq4nO4TnsZkfvSXH4IDNp9LoQLjUmPdrm
         1OTNSo+htWtlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/7] hfs: add missing clean-up in hfs_fill_super
Date:   Thu, 22 Jul 2021 23:59:14 -0400
Message-Id: <20210723035918.532573-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035918.532573-1-sashal@kernel.org>
References: <20210723035918.532573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit 16ee572eaf0d09daa4c8a755fdb71e40dbf8562d ]

Patch series "hfs: fix various errors", v2.

This series ultimately aims to address a lockdep warning in
hfs_find_init reported by Syzbot [1].

The work done for this led to the discovery of another bug, and the
Syzkaller repro test also reveals an invalid memory access error after
clearing the lockdep warning.  Hence, this series is broken up into
three patches:

1. Add a missing call to hfs_find_exit for an error path in
   hfs_fill_super

2. Fix memory mapping in hfs_bnode_read by fixing calls to kmap

3. Add lock nesting notation to tell lockdep that the observed locking
   hierarchy is safe

This patch (of 3):

Before exiting hfs_fill_super, the struct hfs_find_data used in
hfs_find_init should be passed to hfs_find_exit to be cleaned up, and to
release the lock held on the btree.

The call to hfs_find_exit is missing from an error path.  We add it back
in by consolidating calls to hfs_find_exit for error paths.

Link: https://syzkaller.appspot.com/bug?id=f007ef1d7a31a469e3be7aeb0fde0769b18585db [1]
Link: https://lkml.kernel.org/r/20210701030756.58760-1-desmondcheongzx@gmail.com
Link: https://lkml.kernel.org/r/20210701030756.58760-2-desmondcheongzx@gmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4574fdd3d421..3eb815bb2c78 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -426,14 +426,12 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!res) {
 		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
 			res =  -EIO;
-			goto bail;
+			goto bail_hfs_find;
 		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
 	}
-	if (res) {
-		hfs_find_exit(&fd);
-		goto bail_no_root;
-	}
+	if (res)
+		goto bail_hfs_find;
 	res = -EINVAL;
 	root_inode = hfs_iget(sb, &fd.search_key->cat, &rec);
 	hfs_find_exit(&fd);
@@ -449,6 +447,8 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* everything's okay */
 	return 0;
 
+bail_hfs_find:
+	hfs_find_exit(&fd);
 bail_no_root:
 	pr_err("get root inode failed\n");
 bail:
-- 
2.30.2

