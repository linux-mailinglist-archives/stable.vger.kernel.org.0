Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8A355AAFD
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiFYO3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiFYO3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C518217AB8
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6055C61454
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540B8C3411C;
        Sat, 25 Jun 2022 14:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656167383;
        bh=sC3QyiPmP1yroThFBESiPeQ+65hOYsgoCN1xrK1ImOI=;
        h=Subject:To:Cc:From:Date:From;
        b=AWkp6wzoFV1lw9xi7K36UuO2UMaXyiJIgdYFHHgMA5zPq9szPKnlNPoo5Wvpyj4B4
         yWwsDUVYnrPMeFK0b+7QP3AIwUOVqtzq6Yqq6NCwJBLTce6r0WiMIbVHt39yyqLRy/
         XSekLZ2BjKb7n6Idlw0xWvB6cIAWO5qNIh0dykBE=
Subject: FAILED: patch "[PATCH] btrfs: add error messages to all unrecognized mount options" failed to apply to 5.4-stable tree
To:     dsterba@suse.com, anand.jain@oracle.com, nborisov@suse.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:29:40 +0200
Message-ID: <1656167380195193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e3a4167c880cf889f66887a152799df4d609dd21 Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Thu, 2 Jun 2022 23:57:17 +0200
Subject: [PATCH] btrfs: add error messages to all unrecognized mount options

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

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1387fbe935c1..6627dd7875ee 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -763,6 +763,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				compress_force = false;
 				no_compress++;
 			} else {
+				btrfs_err(info, "unrecognized compression value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -821,8 +823,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -883,8 +888,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -901,6 +909,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, DISCARD_ASYNC,
 						   "turning on async discard");
 			} else {
+				btrfs_err(info, "unrecognized discard mode value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -933,6 +943,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, FREE_SPACE_TREE,
 						   "enabling free space tree");
 			} else {
+				btrfs_err(info, "unrecognized space_cache value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1014,8 +1026,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -1030,13 +1046,15 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -1044,8 +1062,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -1059,8 +1081,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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

