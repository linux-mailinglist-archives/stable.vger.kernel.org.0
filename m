Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF215953CF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 09:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiHPHcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 03:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiHPHcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 03:32:18 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D42945061;
        Mon, 15 Aug 2022 21:10:26 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 27G4A3WV004209-27G4A3WY004209
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 16 Aug 2022 12:10:10 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, Jiacheng Xu <stitch@zju.edu.cn>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] fs: fix UAF/GPF bug in nilfs_mdt_destroy
Date:   Tue, 16 Aug 2022 12:08:58 +0800
Message-Id: <20220816040859.659129-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

In alloc_inode, inode_init_always() could return -ENOMEM if
security_inode_alloc() fails, which causes inode->i_private
uninitialized. Then nilfs_is_metadata_file_inode() returns
true and nilfs_free_inode() wrongly calls nilfs_mdt_destroy(),
which frees the uninitialized inode->i_private
and leads to crashes(e.g., UAF/GPF).

Fix this by moving security_inode_alloc just prior to
this_cpu_inc(nr_inodes)

Link: https://lkml.kernel.org/r/CAFcO6XOcf1Jj2SeGt=jJV59wmhESeSKpfR0omdFRq+J9nD1vfQ@mail.gmail.com
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Reported-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: Jiacheng Xu <stitch@zju.edu.cn>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
---
v1->v2: move security_inode_alloc at the very end according to Al Viro
	other than initializing i_private before security_inode_alloc.
 fs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6462276dfdf0..49d1eb91728c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -192,8 +192,6 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_wb_frn_history = 0;
 #endif
 
-	if (security_inode_alloc(inode))
-		goto out;
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
@@ -228,6 +226,9 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fsnotify_mask = 0;
 #endif
 	inode->i_flctx = NULL;
+
+	if (security_inode_alloc(inode))
+		goto out;
 	this_cpu_inc(nr_inodes);
 
 	return 0;
-- 
2.35.1

