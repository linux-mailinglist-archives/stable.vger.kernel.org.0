Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6137555CF65
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiF0LoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbiF0LnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB37114F;
        Mon, 27 Jun 2022 04:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBED4B81122;
        Mon, 27 Jun 2022 11:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46899C385A5;
        Mon, 27 Jun 2022 11:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329907;
        bh=N6/GuJ1UVeEj9l83NMoS9f2N8g6mAkWP8EsJUR+iyqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Av63d7znndpMrZ/X9SUyaKNsmHd0Tje9xsxI/sUQCk/yp3j2KhgCA0uzYSsYIWO+9
         wOySCVvN4MCvmSW9EVMd9SsG5fZtkbhZMbvB1adzcPrev7Ub8VeTNO1em6uD4K+tof
         bZCB88x/gxycogNCmHCpCFcYkwr2O5BHEr1gOa5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 020/181] btrfs: add error messages to all unrecognized mount options
Date:   Mon, 27 Jun 2022 13:19:53 +0200
Message-Id: <20220627111945.150353720@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
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
@@ -763,6 +763,8 @@ int btrfs_parse_options(struct btrfs_fs_
 				compress_force = false;
 				no_compress++;
 			} else {
+				btrfs_err(info, "unrecognized compression value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -821,8 +823,11 @@ int btrfs_parse_options(struct btrfs_fs_
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
@@ -883,8 +888,11 @@ int btrfs_parse_options(struct btrfs_fs_
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
@@ -901,6 +909,8 @@ int btrfs_parse_options(struct btrfs_fs_
 				btrfs_set_and_info(info, DISCARD_ASYNC,
 						   "turning on async discard");
 			} else {
+				btrfs_err(info, "unrecognized discard mode value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -933,6 +943,8 @@ int btrfs_parse_options(struct btrfs_fs_
 				btrfs_set_and_info(info, FREE_SPACE_TREE,
 						   "enabling free space tree");
 			} else {
+				btrfs_err(info, "unrecognized space_cache value %s",
+					  args[0].from);
 				ret = -EINVAL;
 				goto out;
 			}
@@ -1014,8 +1026,12 @@ int btrfs_parse_options(struct btrfs_fs_
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
@@ -1030,13 +1046,15 @@ int btrfs_parse_options(struct btrfs_fs_
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
@@ -1044,8 +1062,12 @@ int btrfs_parse_options(struct btrfs_fs_
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
@@ -1059,8 +1081,11 @@ int btrfs_parse_options(struct btrfs_fs_
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


