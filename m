Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E05F9907
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiJJHFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiJJHE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:04:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291C25A152;
        Mon, 10 Oct 2022 00:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5223360E84;
        Mon, 10 Oct 2022 07:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D59C433C1;
        Mon, 10 Oct 2022 07:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385466;
        bh=HNPPtoQnYBQEA6aJUF+GOhYCaUNi2L9VMOgqLx3VwZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jW9ePRayM/mBRktcSIZybsbdJvLJgWpNV2J6NKZloUGHYkJakw4xP4i9RuJpQPUx2
         eGcwXCKt4sV+Pl39MuqLNV9WUcgVUhNob9cZlDmQ1Ytuyt6SN6ONxtdKNcyaOslnZi
         G18QnF9MXipttm8fnw8YMzRcw/a9A0xT8KWh3mi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, Jiacheng Xu <stitch@zju.edu.cn>,
        "Christian Brauner (Microsoft)" <brauner@kernel.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.0 02/17] fs: fix UAF/GPF bug in nilfs_mdt_destroy
Date:   Mon, 10 Oct 2022 09:04:25 +0200
Message-Id: <20221010070330.249769257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
References: <20221010070330.159911806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 2e488f13755ffbb60f307e991b27024716a33b29 upstream.

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
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -192,8 +192,6 @@ int inode_init_always(struct super_block
 	inode->i_wb_frn_history = 0;
 #endif
 
-	if (security_inode_alloc(inode))
-		goto out;
 	spin_lock_init(&inode->i_lock);
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
@@ -228,11 +226,12 @@ int inode_init_always(struct super_block
 	inode->i_fsnotify_mask = 0;
 #endif
 	inode->i_flctx = NULL;
+
+	if (unlikely(security_inode_alloc(inode)))
+		return -ENOMEM;
 	this_cpu_inc(nr_inodes);
 
 	return 0;
-out:
-	return -ENOMEM;
 }
 EXPORT_SYMBOL(inode_init_always);
 


