Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8453E641
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiFFLM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbiFFLM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 07:12:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C3E527E8;
        Mon,  6 Jun 2022 04:12:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6857621A64;
        Mon,  6 Jun 2022 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654513969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YeYIPk1apoTTLgnmiValz725/dHCxKZfGsETM2bG6QM=;
        b=Jq4aGCh3QooHfvwovKAqIejGv+fbI6srBCpAMewFIwfsYNXXvSiYzyX6G11hsnUie0PC0j
        /PSLgWNikQVDf4F9/J0OaFffrDbMzkVVIYudMZT0vmHP7ek9wreB6BovzXsvFmpCHHphX7
        HgP12sYVf6hvyi9Q1gH5sb2kxYsKDiw=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 5FED22C141;
        Mon,  6 Jun 2022 11:12:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E9789DA832; Mon,  6 Jun 2022 13:08:21 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: add error messages to all unrecognized mount options
Date:   Mon,  6 Jun 2022 13:08:19 +0200
Message-Id: <20220606110819.3943-1-dsterba@suse.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d8e2eac0417e..719dda57dc7a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -764,6 +764,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				compress_force = false;
 				no_compress++;
 			} else {
+				btrfs_err(info, "unrecognized compression value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -822,8 +824,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -884,8 +889,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -902,6 +910,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, DISCARD_ASYNC,
 						   "turning on async discard");
 			} else {
+				btrfs_err(info, "unrecognized discard mode value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -934,6 +944,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_set_and_info(info, FREE_SPACE_TREE,
 						   "enabling free space tree");
 			} else {
+				btrfs_err(info, "unrecognized space_cache value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1015,8 +1027,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -1031,13 +1047,15 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -1045,8 +1063,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
@@ -1060,8 +1082,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
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
-- 
2.36.1

