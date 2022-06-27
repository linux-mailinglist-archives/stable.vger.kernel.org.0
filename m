Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE6C55D157
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiF0LXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiF0LXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8C2654B;
        Mon, 27 Jun 2022 04:23:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B1286144F;
        Mon, 27 Jun 2022 11:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D283C3411D;
        Mon, 27 Jun 2022 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656328982;
        bh=XfgLOJdxrlG9Mmu3iDIZDiD4n1y+qaWvN+p8XJPvlh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uS9wMaWhaW6pIwK614Y9QrrFi68r6n9z7cUnhCKIiVT3Jy2P1MlfS5fp+edEpn5qn
         lhTqnb8PrU5lAspaV52H9z0JTKaSEgXljVKna0B5khfDlRP+zFf8NAPUciEu0/GPnW
         DcMq9FDrgXe8fe9M76DQfGSYokSAoohieTVL/YQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 012/102] btrfs: add error messages to all unrecognized mount options
Date:   Mon, 27 Jun 2022 13:20:23 +0200
Message-Id: <20220627111933.828735444@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit e3a4167c880cf889f66887a152799df4d609dd21 upstream.

Almost none of the errors stemming from a valid mount option but wrong
value prints a descriptive message which would help to identify why
mount failed. Like in the linked report:

  $ uname -r
  v4.19
  $ mount -o compress=zstd /dev/sdb /mnt
  mount: /mnt: wrong fs type, bad option, bad superblock on
  /dev/sdb, missing codepage or helper program, or other error.
  $ dmesg
  ...
  BTRFS error (device sdb): open_ctree failed

Errors caused by memory allocation failures are left out as it's not a
user error so reporting that would be confusing.

Link: https://lore.kernel.org/linux-btrfs/9c3fec36-fc61-3a33-4977-a7e207c3fa4e@gmx.de/
CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -652,6 +652,8 @@ int btrfs_parse_options(struct btrfs_fs_
 				compress_force = false;
 				no_compress++;
 			} else {
+				btrfs_err(info, "unrecognized compression value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -710,8 +712,11 @@ int btrfs_parse_options(struct btrfs_fs_
 		case Opt_thread_pool:
 			ret = match_int(&args[0], &intarg);
 			if (ret) {
+				btrfs_err(info, "unrecognized thread_pool value %s",
+					  args[0].from);
 				goto out;
 			} else if (intarg == 0) {
+				btrfs_err(info, "invalid value 0 for thread_pool");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -772,8 +777,11 @@ int btrfs_parse_options(struct btrfs_fs_
 			break;
 		case Opt_ratio:
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info, "unrecognized metadata_ratio value %s",
+					  args[0].from);
 				goto out;
+			}
 			info->metadata_ratio = intarg;
 			btrfs_info(info, "metadata ratio %u",
 				   info->metadata_ratio);
@@ -790,6 +798,8 @@ int btrfs_parse_options(struct btrfs_fs_
 				btrfs_set_and_info(info, DISCARD_ASYNC,
 						   "turning on async discard");
 			} else {
+				btrfs_err(info, "unrecognized discard mode value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -814,6 +824,8 @@ int btrfs_parse_options(struct btrfs_fs_
 				btrfs_set_and_info(info, FREE_SPACE_TREE,
 						   "enabling free space tree");
 			} else {
+				btrfs_err(info, "unrecognized space_cache value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -889,8 +901,12 @@ int btrfs_parse_options(struct btrfs_fs_
 			break;
 		case Opt_check_integrity_print_mask:
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info,
+				"unrecognized check_integrity_print_mask value %s",
+					args[0].from);
 				goto out;
+			}
 			info->check_integrity_print_mask = intarg;
 			btrfs_info(info, "check_integrity_print_mask 0x%x",
 				   info->check_integrity_print_mask);
@@ -905,13 +921,15 @@ int btrfs_parse_options(struct btrfs_fs_
 			goto out;
 #endif
 		case Opt_fatal_errors:
-			if (strcmp(args[0].from, "panic") == 0)
+			if (strcmp(args[0].from, "panic") == 0) {
 				btrfs_set_opt(info->mount_opt,
 					      PANIC_ON_FATAL_ERROR);
-			else if (strcmp(args[0].from, "bug") == 0)
+			} else if (strcmp(args[0].from, "bug") == 0) {
 				btrfs_clear_opt(info->mount_opt,
 					      PANIC_ON_FATAL_ERROR);
-			else {
+			} else {
+				btrfs_err(info, "unrecognized fatal_errors value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -919,8 +937,12 @@ int btrfs_parse_options(struct btrfs_fs_
 		case Opt_commit_interval:
 			intarg = 0;
 			ret = match_int(&args[0], &intarg);
-			if (ret)
+			if (ret) {
+				btrfs_err(info, "unrecognized commit_interval value %s",
+					  args[0].from);
+				ret = -EINVAL;
 				goto out;
+			}
 			if (intarg == 0) {
 				btrfs_info(info,
 					   "using default commit interval %us",
@@ -934,8 +956,11 @@ int btrfs_parse_options(struct btrfs_fs_
 			break;
 		case Opt_rescue:
 			ret = parse_rescue_options(info, args[0].from);
-			if (ret < 0)
+			if (ret < 0) {
+				btrfs_err(info, "unrecognized rescue value %s",
+					  args[0].from);
 				goto out;
+			}
 			break;
 #ifdef CONFIG_BTRFS_DEBUG
 		case Opt_fragment_all:


