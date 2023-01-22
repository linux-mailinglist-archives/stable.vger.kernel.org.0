Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5AE676FAB
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjAVPYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjAVPYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175DF1A96E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0D5CB80B1E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC406C433D2;
        Sun, 22 Jan 2023 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401036;
        bh=Hb2CeQYYKhm0/0h/O+GTpyoSJ5AjoXU65uFx7yUbww4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+05fdhfiSdm8VHdq38fXrzvTTGkriShK6tJMftR7966671xJJVoG52EBDMbhp7Uj
         pE0RlCg1RKYAjrYVEkHUalz3zWyo7yvBbWGUX2COcmAfBXPzPQANVnb1M/6Um5vWHK
         WgWvy4fl5Xrq99HKgENZKvR/Sv/lOo8LkLx6pflc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 085/193] btrfs: do not abort transaction on failure to write log tree when syncing log
Date:   Sun, 22 Jan 2023 16:03:34 +0100
Message-Id: <20230122150250.272618529@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

commit 16199ad9eb6db60a6b10794a09fc1ac6d09312ff upstream.

When syncing the log, if we fail to write log tree extent buffers, we mark
the log for a full commit and abort the transaction. However we don't need
to abort the transaction, all we really need to do is to make sure no one
can commit a superblock pointing to new log tree roots. Just because we
got a failure writing extent buffers for a log tree, it does not mean we
will also fail to do a transaction commit.

One particular case is if due to a bug somewhere, when writing log tree
extent buffers, the tree checker detects some corruption and the writeout
fails because of that. Aborting the transaction can be very disruptive for
a user, specially if the issue happened on a root filesystem. One example
is the scenario in the Link tag below, where an isolated corruption on log
tree leaves was causing transaction aborts when syncing the log.

Link: https://lore.kernel.org/linux-btrfs/ae169fc6-f504-28f0-a098-6fa6a4dfb612@leemhuis.info/
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c  |    9 ++++++++-
 fs/btrfs/tree-log.c |    2 --
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -344,7 +344,14 @@ error:
 	btrfs_print_tree(eb, 0);
 	btrfs_err(fs_info, "block=%llu write time tree block corruption detected",
 		  eb->start);
-	WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+	/*
+	 * Be noisy if this is an extent buffer from a log tree. We don't abort
+	 * a transaction in case there's a bad log tree extent buffer, we just
+	 * fallback to a transaction commit. Still we want to know when there is
+	 * a bad log tree extent buffer, as that may signal a bug somewhere.
+	 */
+	WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG) ||
+		btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID);
 	return ret;
 }
 
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3011,7 +3011,6 @@ int btrfs_sync_log(struct btrfs_trans_ha
 		ret = 0;
 	if (ret) {
 		blk_finish_plug(&plug);
-		btrfs_abort_transaction(trans, ret);
 		btrfs_set_log_full_commit(trans);
 		mutex_unlock(&root->log_mutex);
 		goto out;
@@ -3143,7 +3142,6 @@ int btrfs_sync_log(struct btrfs_trans_ha
 		goto out_wake_log_root;
 	} else if (ret) {
 		btrfs_set_log_full_commit(trans);
-		btrfs_abort_transaction(trans, ret);
 		mutex_unlock(&log_root_tree->log_mutex);
 		goto out_wake_log_root;
 	}


