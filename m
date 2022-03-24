Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E644E662F
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 16:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345700AbiCXPla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 11:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbiCXPla (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 11:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5599198F46;
        Thu, 24 Mar 2022 08:39:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1BFA61835;
        Thu, 24 Mar 2022 15:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5691C340EC;
        Thu, 24 Mar 2022 15:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648136397;
        bh=W2gwKBXTGnbi1TztKRUks+XIXhyWOZvvzMkuDRdIR+U=;
        h=From:To:Cc:Subject:Date:From;
        b=pkmMmzYnW3px4Ml8thL52AnBARS1xU5McoGTxS2ANE3DZgQouliDKdQGS6U5tf6F/
         n8yoRpkGLCBZbo9C6ws1l7wSAbDIBY7kPWdN8LwTaNnqqcbEe2nbX+/lUWyLOx/q5D
         9hpb7ScnOEf5oGfZMVkzQp6V2hJPx7E/6EdFMg5lIxJxtcf9G3TsKEWp+B46wCK9HX
         Lbpgfpf2i8qSkhgyI35ca1kMPn1OshG57j9G0tPisX0EreJPXMMmur/eCNZOSVaTfT
         gqc65f1xzzbmlB30wSjEDmiSP+UrQswqAuP2JX+B6iAl2eUJ+zwjHk29Rj92M19nlm
         g9AO4AjAhZxoA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] btrfs: Remove unused variable in btrfs_{start,write}_dirty_block_groups()
Date:   Thu, 24 Mar 2022 08:36:45 -0700
Message-Id: <20220324153644.4079376-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang's version of -Wunused-but-set-variable recently gained support for
unary operations, which reveals two unused variables:

  fs/btrfs/block-group.c:2949:6: error: variable 'num_started' set but not used [-Werror,-Wunused-but-set-variable]
          int num_started = 0;
              ^
  fs/btrfs/block-group.c:3116:6: error: variable 'num_started' set but not used [-Werror,-Wunused-but-set-variable]
          int num_started = 0;
              ^
  2 errors generated.

These variables appear to be unused from their introduction, so just
remove them to silence the warnings.

Cc: stable@vger.kernel.org
Fixes: c9dc4c657850 ("Btrfs: two stage dirty block group writeout")
Fixes: 1bbc621ef284 ("Btrfs: allow block group cache writeout outside critical section in commit")
Link: https://github.com/ClangBuiltLinux/linux/issues/1614
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

I am requesting a stable backport because this is visible with
allmodconfig, which enables CONFIG_WERROR, breaking the build.

To quote Linus:

"EVERYBODY should have CONFIG_WERROR=y on at least x86-64 and other
serious architectures, unless you have some completely random
experimental (and broken) compiler."

https://lore.kernel.org/r/CAHk-=wifoM9VOp-55OZCRcO9MnqQ109UTuCiXeZ-eyX_JcNVGg@mail.gmail.com/

 fs/btrfs/block-group.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c22d287e020b..9ad265066225 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2946,7 +2946,6 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	struct btrfs_path *path = NULL;
 	LIST_HEAD(dirty);
 	struct list_head *io = &cur_trans->io_bgs;
-	int num_started = 0;
 	int loops = 0;
 
 	spin_lock(&cur_trans->dirty_bgs_lock);
@@ -3012,7 +3011,6 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 			cache->io_ctl.inode = NULL;
 			ret = btrfs_write_out_cache(trans, cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
-				num_started++;
 				should_put = 0;
 
 				/*
@@ -3113,7 +3111,6 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 	int should_put;
 	struct btrfs_path *path;
 	struct list_head *io = &cur_trans->io_bgs;
-	int num_started = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3171,7 +3168,6 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans)
 			cache->io_ctl.inode = NULL;
 			ret = btrfs_write_out_cache(trans, cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
-				num_started++;
 				should_put = 0;
 				list_add_tail(&cache->io_list, io);
 			} else {

base-commit: d3e29967079c522ce1c5cab0e9fab2c280b977eb
-- 
2.35.1

