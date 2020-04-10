Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B1E1A40C9
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgDJDtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgDJDtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C02520B1F;
        Fri, 10 Apr 2020 03:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490542;
        bh=6cq8yXOWNTdEtp9bR4s1kXgpLYz5pdybxKlc4flNGEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qv/o/1Kw+bmXupvoZu76Ba/GhzZd8O8ClJhV0JMU0iROPOMT8AUYVni/kBdn58RHc
         8Ye/TZ9H2myAf1iqUxkZPr220KUquX95Q3orwDw0jHUxuXQZivap4pRrqnxLUUtPPe
         hJxcJiHiG3xHlGCD2l+kMR3noQMgd/SrSi5RaHPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 52/56] btrfs: hold a ref on the root in btrfs_recover_relocation
Date:   Thu,  9 Apr 2020 23:47:56 -0400
Message-Id: <20200410034800.8381-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034800.8381-1-sashal@kernel.org>
References: <20200410034800.8381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 932fd26df8125a5b14438563c4d3e33f59ba80f7 ]

We look up the fs root in various places in here when recovering from a
crashed relcoation.  Make sure we hold a ref on the root whenever we
look them up.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index da5abd62db223..9546ce3c86dc4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4547,6 +4547,12 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 					err = ret;
 					goto out;
 				}
+			} else {
+				if (!btrfs_grab_fs_root(fs_root)) {
+					err = -ENOENT;
+					goto out;
+				}
+				btrfs_put_fs_root(fs_root);
 			}
 		}
 
@@ -4596,10 +4602,15 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
 			goto out_free;
 		}
+		if (!btrfs_grab_fs_root(fs_root)) {
+			err = -ENOENT;
+			goto out_free;
+		}
 
 		err = __add_reloc_root(reloc_root);
 		BUG_ON(err < 0); /* -ENOMEM or logic error */
 		fs_root->reloc_root = reloc_root;
+		btrfs_put_fs_root(fs_root);
 	}
 
 	err = btrfs_commit_transaction(trans);
@@ -4631,10 +4642,14 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	if (err == 0) {
 		/* cleanup orphan inode in data relocation tree */
 		fs_root = read_fs_root(fs_info, BTRFS_DATA_RELOC_TREE_OBJECTID);
-		if (IS_ERR(fs_root))
+		if (IS_ERR(fs_root)) {
 			err = PTR_ERR(fs_root);
-		else
-			err = btrfs_orphan_cleanup(fs_root);
+		} else {
+			if (btrfs_grab_fs_root(fs_root)) {
+				err = btrfs_orphan_cleanup(fs_root);
+				btrfs_put_fs_root(fs_root);
+			}
+		}
 	}
 	return err;
 }
-- 
2.20.1

