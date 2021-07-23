Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ED93D330B
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 06:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhGWDTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234235AbhGWDSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A55460F26;
        Fri, 23 Jul 2021 03:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012752;
        bh=Jak8ZkmCLa0oz8T4zwIaW/iDvItCwLsURakycKZ58Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8w8+mOgmRKIa7TYrYGB94fU4sw4N3A/RSCjXN0O8jy8sYrnd/C6h4wzAOCPadR9q
         4gN8Ks07TwVlmZHlOCr0C3EkWn4KQTphMI5EyXeA29MMU+wo9UZm03oD6Gih9q1dQO
         o/OHAT76lyaHjRV40DoKhqbPKn2e+YMFZTNiC/9c2XB3QZlIjsF2Sn7cdFMOmeLYsj
         6NTPzjbRFPAn4nlbdg/i4vPcxBXadRtx2rOx2GW2YTc68/Nw/T1Sj1PSpJ+YBww3Yd
         NUAeVMIwnDW9coM643hAi2sBgg/MDg+ueR1UwXavUvPRMuvu0LrGvIdV96GfJh+m+0
         m9ngD/IK3FQng==
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
Subject: [PATCH AUTOSEL 4.9 4/7] hfs: add missing clean-up in hfs_fill_super
Date:   Thu, 22 Jul 2021 23:59:03 -0400
Message-Id: <20210723035906.532444-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035906.532444-1-sashal@kernel.org>
References: <20210723035906.532444-1-sashal@kernel.org>
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
index bf6304a350a6..c2a5a0ca3948 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -427,14 +427,12 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -450,6 +448,8 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* everything's okay */
 	return 0;
 
+bail_hfs_find:
+	hfs_find_exit(&fd);
 bail_no_root:
 	pr_err("get root inode failed\n");
 bail:
-- 
2.30.2

