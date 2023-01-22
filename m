Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D08676FAD
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjAVPYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjAVPYF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB051A96E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED2760C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E69C433D2;
        Sun, 22 Jan 2023 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401041;
        bh=4R7EWBfTbCU1BF2aKnFQ4VzWy8st9aEc8I9SL60lcAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIl/5xR+loYCYoVqShofuEDPlDW/8r3DzSunu04l4t6KSGlYB/phzLaUmeUbQS3ll
         nUtowqiONuww4GP9E7prK6m8k0pBr8ZHV92uoB4WMHqAAnBqmLc09P/mh4ysCX8fl8
         4jB8RFb3pER57g8Y9cuhcmoSLjG0UbbCkWmu4uEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lukas Straub <lukasstraub2@web.de>,
        HanatoK <summersnow9403@gmail.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 087/193] btrfs: qgroup: do not warn on record without old_roots populated
Date:   Sun, 22 Jan 2023 16:03:36 +0100
Message-Id: <20230122150250.366577372@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 75181406b4eafacc531ff2ee5fb032bd93317e2b upstream.

[BUG]
There are some reports from the mailing list that since v6.1 kernel, the
WARN_ON() inside btrfs_qgroup_account_extent() gets triggered during
rescan:

  WARNING: CPU: 3 PID: 6424 at fs/btrfs/qgroup.c:2756 btrfs_qgroup_account_extents+0x1ae/0x260 [btrfs]
  CPU: 3 PID: 6424 Comm: snapperd Tainted: P           OE      6.1.2-1-default #1 openSUSE Tumbleweed 05c7a1b1b61d5627475528f71f50444637b5aad7
  RIP: 0010:btrfs_qgroup_account_extents+0x1ae/0x260 [btrfs]
  Call Trace:
   <TASK>
  btrfs_commit_transaction+0x30c/0xb40 [btrfs c39c9c546c241c593f03bd6d5f39ea1b676250f6]
   ? start_transaction+0xc3/0x5b0 [btrfs c39c9c546c241c593f03bd6d5f39ea1b676250f6]
  btrfs_qgroup_rescan+0x42/0xc0 [btrfs c39c9c546c241c593f03bd6d5f39ea1b676250f6]
   btrfs_ioctl+0x1ab9/0x25c0 [btrfs c39c9c546c241c593f03bd6d5f39ea1b676250f6]
   ? __rseq_handle_notify_resume+0xa9/0x4a0
   ? mntput_no_expire+0x4a/0x240
   ? __seccomp_filter+0x319/0x4d0
   __x64_sys_ioctl+0x90/0xd0
   do_syscall_64+0x5b/0x80
   ? syscall_exit_to_user_mode+0x17/0x40
   ? do_syscall_64+0x67/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  RIP: 0033:0x7fd9b790d9bf
   </TASK>

[CAUSE]
Since commit e15e9f43c7ca ("btrfs: introduce
BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING to skip qgroup accounting"), if
our qgroup is already in inconsistent state, we will no longer do the
time-consuming backref walk.

This can leave some qgroup records without a valid old_roots ulist.
Normally this is fine, as btrfs_qgroup_account_extents() would also skip
those records if we have NO_ACCOUNTING flag set.

But there is a small window, if we have NO_ACCOUNTING flag set, and
inserted some qgroup_record without a old_roots ulist, but then the user
triggered a qgroup rescan.

During btrfs_qgroup_rescan(), we firstly clear NO_ACCOUNTING flag, then
commit current transaction.

And since we have a qgroup_record with old_roots = NULL, we trigger the
WARN_ON() during btrfs_qgroup_account_extents().

[FIX]
Unfortunately due to the introduction of NO_ACCOUNTING flag, the
assumption that every qgroup_record would have its old_roots populated
is no longer correct.

Fix the false alerts and drop the WARN_ON().

Reported-by: Lukas Straub <lukasstraub2@web.de>
Reported-by: HanatoK <summersnow9403@gmail.com>
Fixes: e15e9f43c7ca ("btrfs: introduce BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING to skip qgroup accounting")
CC: stable@vger.kernel.org # 6.1
Link: https://lore.kernel.org/linux-btrfs/2403c697-ddaf-58ad-3829-0335fc89df09@gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2751,9 +2751,19 @@ int btrfs_qgroup_account_extents(struct
 			      BTRFS_QGROUP_RUNTIME_FLAG_NO_ACCOUNTING)) {
 			/*
 			 * Old roots should be searched when inserting qgroup
-			 * extent record
+			 * extent record.
+			 *
+			 * But for INCONSISTENT (NO_ACCOUNTING) -> rescan case,
+			 * we may have some record inserted during
+			 * NO_ACCOUNTING (thus no old_roots populated), but
+			 * later we start rescan, which clears NO_ACCOUNTING,
+			 * leaving some inserted records without old_roots
+			 * populated.
+			 *
+			 * Those cases are rare and should not cause too much
+			 * time spent during commit_transaction().
 			 */
-			if (WARN_ON(!record->old_roots)) {
+			if (!record->old_roots) {
 				/* Search commit root to find old_roots */
 				ret = btrfs_find_all_roots(NULL, fs_info,
 						record->bytenr, 0,


