Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE933DA4D1
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhG2N4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237860AbhG2N4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2981F60EBC;
        Thu, 29 Jul 2021 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627566979;
        bh=doR6LMEEYb1rjzpVj1h50RnV5NItZ15HdlpAELiDtSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDf/OI46dWQrCd27I09uhyYnlUZZbPF36RQmocXaUmcHVdngZqJ4WDMiLWOoTVYUy
         pMypIfYLUCziN0lYJzHbc7/dwdxVgal8HKEDfMzVLzqAGyg7de34VhyaPxP5KYuzVL
         LTLkEKDWqgUyHsSk9qtcuoIOjrBMaxuR8SB8abvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/17] hfs: add missing clean-up in hfs_fill_super
Date:   Thu, 29 Jul 2021 15:54:12 +0200
Message-Id: <20210729135137.618723291@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 173876782f73..77b6f35a4aa9 100644
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



