Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B5950541B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiDRNEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241714AbiDRNDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2AD33E3F;
        Mon, 18 Apr 2022 05:44:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC4BBB80E44;
        Mon, 18 Apr 2022 12:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EDAC385A7;
        Mon, 18 Apr 2022 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285845;
        bh=YGLGlNKPSRLiIJ8DH4C8/86MKO/vsoWNz1NimBChd3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ad/u1OWMhMtxskg/iB4iFxSWRQ9bLXxopMTlyDA4PW95eSYY0i61J8fCZwgtz02pl
         YYnTsl5Vd2rcqsvLXaRbJrs9teQtzyzAcXgrLECN2ZE60nVOHm74HA7uwAsYO4IqWk
         PuOJ5BxrKCy8cGUzYeMLo6m2tIh+qVknb4TaWR4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 43/63] btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()
Date:   Mon, 18 Apr 2022 14:13:40 +0200
Message-Id: <20220418121137.110669226@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 6d4a6b515c39f1f8763093e0f828959b2fbc2f45 upstream.

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

Fixes: c9dc4c657850 ("Btrfs: two stage dirty block group writeout")
Fixes: 1bbc621ef284 ("Btrfs: allow block group cache writeout outside critical section in commit")
CC: stable@vger.kernel.org # 5.4+
Link: https://github.com/ClangBuiltLinux/linux/issues/1614
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2388,7 +2388,6 @@ int btrfs_start_dirty_block_groups(struc
 	struct btrfs_path *path = NULL;
 	LIST_HEAD(dirty);
 	struct list_head *io = &cur_trans->io_bgs;
-	int num_started = 0;
 	int loops = 0;
 
 	spin_lock(&cur_trans->dirty_bgs_lock);
@@ -2455,7 +2454,6 @@ again:
 			cache->io_ctl.inode = NULL;
 			ret = btrfs_write_out_cache(trans, cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
-				num_started++;
 				should_put = 0;
 
 				/*
@@ -2556,7 +2554,6 @@ int btrfs_write_dirty_block_groups(struc
 	int should_put;
 	struct btrfs_path *path;
 	struct list_head *io = &cur_trans->io_bgs;
-	int num_started = 0;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2614,7 +2611,6 @@ int btrfs_write_dirty_block_groups(struc
 			cache->io_ctl.inode = NULL;
 			ret = btrfs_write_out_cache(trans, cache, path);
 			if (ret == 0 && cache->io_ctl.inode) {
-				num_started++;
 				should_put = 0;
 				list_add_tail(&cache->io_list, io);
 			} else {


