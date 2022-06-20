Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F89551A8E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiFTNHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244590AbiFTNFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5F1193F9;
        Mon, 20 Jun 2022 06:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D900561535;
        Mon, 20 Jun 2022 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90E6C341C4;
        Mon, 20 Jun 2022 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730018;
        bh=FNIdFJvrZZ+HBipVpv9LH7IBT5OABlgIFVbnLZpbZIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqPqt226lOoqPWgyLLGD9EahzWhDcy1U1ZUlYgj3daZazCukmjv5jWzClRTf2FDDs
         IOLEhQ+wtObS4LLDr7GloI2fETClYg1a28wkN2dlSQWUEBqtJJTYmBR38atOWoE2xb
         ijep3YTZuYcIUM71A9Sv+yCM/7jFheccjxnTgi9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.18 127/141] ext4: fix super block checksum incorrect after mount
Date:   Mon, 20 Jun 2022 14:51:05 +0200
Message-Id: <20220620124733.308680165@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit 9b6641dd95a0c441b277dd72ba22fed8d61f76ad upstream.

We got issue as follows:
[home]# mount  /dev/sda  test
EXT4-fs (sda): warning: mounting fs with errors, running e2fsck is recommended
[home]# dmesg
EXT4-fs (sda): warning: mounting fs with errors, running e2fsck is recommended
EXT4-fs (sda): Errors on filesystem, clearing orphan list.
EXT4-fs (sda): recovery complete
EXT4-fs (sda): mounted filesystem with ordered data mode. Quota mode: none.
[home]# debugfs /dev/sda
debugfs 1.46.5 (30-Dec-2021)
Checksum errors in superblock!  Retrying...

Reason is ext4_orphan_cleanup will reset ‘s_last_orphan’ but not update
super block checksum.

To solve above issue, defer update super block checksum after
ext4_orphan_cleanup.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: stable@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220525012904.1604737-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5422,14 +5422,6 @@ no_journal:
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
-	/*
-	 * Update the checksum after updating free space/inode
-	 * counters.  Otherwise the superblock can have an incorrect
-	 * checksum in the buffer cache until it is written out and
-	 * e2fsprogs programs trying to open a file system immediately
-	 * after it is mounted can fail.
-	 */
-	ext4_superblock_csum_set(sb);
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 					  ext4_count_dirs(sb), GFP_KERNEL);
@@ -5487,6 +5479,14 @@ no_journal:
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
+	/*
+	 * Update the checksum after updating free space/inode counters and
+	 * ext4_orphan_cleanup. Otherwise the superblock can have an incorrect
+	 * checksum in the buffer cache until it is written out and
+	 * e2fsprogs programs trying to open a file system immediately
+	 * after it is mounted can fail.
+	 */
+	ext4_superblock_csum_set(sb);
 	if (needs_recovery) {
 		ext4_msg(sb, KERN_INFO, "recovery complete");
 		err = ext4_mark_recovery_complete(sb, es);


