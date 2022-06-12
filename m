Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42750547970
	for <lists+stable@lfdr.de>; Sun, 12 Jun 2022 11:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbiFLJBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jun 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiFLJBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jun 2022 05:01:37 -0400
X-Greylist: delayed 428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Jun 2022 02:01:21 PDT
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B847612B3
        for <stable@vger.kernel.org>; Sun, 12 Jun 2022 02:01:19 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 97D35C020; Sun, 12 Jun 2022 10:54:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655024051; bh=diOrVOPA1DrszPTKQ6G1Sn5TRoaAaysLytyk8w/ytPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEqxsZOpI5UY8L6k/Hyl9zKBUgUhWi3iBUg6SAtx1bW4XJDs8x37Ed3znXtHO5bLH
         vV6l5qcd9yXSzShsEWowXq9AH5LAPrVIlUypkHj2bA8llA/uKgx2+T9WXfkky8H8HD
         uy268qCy2OERouN5ewO8UqD8/Rx+LIYYiP1EuxgmSB1QltwB83G3vu8ytmf51YG+t8
         pZ0uvws+TWP6bHSlVqTrE9hQg0QmOjy3hbY3n5lcA4nGIggARi2K61OpGQmpJw6hWo
         laXoHOoWufPuyu2RmHMM5U6/mQcD/Mqzj/eqWW/bxiupIwCZoZyoKdJQLYEtcUE2P+
         cxYQ/hTqc+TYA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0F523C009;
        Sun, 12 Jun 2022 10:54:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655024050; bh=diOrVOPA1DrszPTKQ6G1Sn5TRoaAaysLytyk8w/ytPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7+Fyk0YaikTR8PDuzHujHv0wrzZ6pAYvxQ6nilzdjvHQtMbQTqvQF7m7cT5D2lm1
         3ZUqWJdzV3yzlq6ob156CtpbKHCood01UscjCfoOh6AfHaMmqoSUqV0s/wH08Bdcf1
         RvrBmeKPof54b1OKaWGJKhXuzFJwOGetEVpc86KIMKBMzLyStIU4JurOL08seMZhEd
         e55j+UTc1NmESduVJLC8FXzlY9JDauq/rZ8AegrtuOoGP8YocXqyG1QhZjSKI8Zrif
         e/ivgLARLT6UBuSBFgeAEco2IlCNQh6Hw3L7K7naIYVvAioRtSgJYBUfMTP4XnBfag
         UQICS8ngDN5UQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 0605f16d;
        Sun, 12 Jun 2022 08:54:05 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jianyong Wu <jianyong.wu@arm.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 01/06] 9p: fix fid refcount leak in v9fs_vfs_atomic_open_dotl
Date:   Sun, 12 Jun 2022 17:53:24 +0900
Message-Id: <20220612085330.1451496-2-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220612085330.1451496-1-asmadeus@codewreck.org>
References: <20220612085330.1451496-1-asmadeus@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to release directory fid if we fail halfway through open

This fixes fid leaking with xfstests generic 531

Fixes: 6636b6dcc3db ("9p: add refcount to p9_fid struct")
Cc: stable@vger.kernel.org
Reported-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
 fs/9p/vfs_inode_dotl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index d17502a738a9..b6eb1160296c 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -274,6 +274,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(ofid)) {
 		err = PTR_ERR(ofid);
 		p9_debug(P9_DEBUG_VFS, "p9_client_walk failed %d\n", err);
+		p9_client_clunk(dfid);
 		goto out;
 	}
 
@@ -285,6 +286,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err) {
 		p9_debug(P9_DEBUG_VFS, "Failed to get acl values in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	err = p9_client_create_dotl(ofid, name, v9fs_open_to_dotl_flags(flags),
@@ -292,6 +294,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_open_dotl failed in creat %d\n",
 			 err);
+		p9_client_clunk(dfid);
 		goto error;
 	}
 	v9fs_invalidate_inode_attr(dir);
-- 
2.35.1

