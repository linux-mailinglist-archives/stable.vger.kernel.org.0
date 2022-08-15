Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657E6594C99
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241861AbiHPA6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344282AbiHPA4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:56:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C603819DAAF;
        Mon, 15 Aug 2022 13:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3E86127D;
        Mon, 15 Aug 2022 20:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D14C4314C;
        Mon, 15 Aug 2022 20:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596490;
        bh=QWABRTprLy9+UMnIwAwPfZnR1exe3gryeLHIPnzbSmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pojaVERLzXVlgIPuGfecrRcTTnSNLmLylJ0BXOj21i6WIqhrfEXSfHyr6ZygZj3tV
         jp7a6lhJ1+Yr8/NyXhxb0PYFgZplE4t7R8Tp1BrmJ0LiDaKf3SPhrwpCyWQp4zI0Xu
         lVRieWRThaV9mnNiG8VLTzCFI+EZc+atEgbYgt8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1097/1157] btrfs: join running log transaction when logging new name
Date:   Mon, 15 Aug 2022 20:07:33 +0200
Message-Id: <20220815180524.132079476@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 723df2bcc9e166ac7fb82b3932a53e09415dfcde ]

When logging a new name, in case of a rename, we pin the log before
changing it. We then either delete a directory entry from the log or
insert a key range item to mark the old name for deletion on log replay.

However when doing one of those log changes we may have another task that
started writing out the log (at btrfs_sync_log()) and it started before
we pinned the log root. So we may end up changing a log tree while its
writeback is being started by another task syncing the log. This can lead
to inconsistencies in a log tree and other unexpected results during log
replay, because we can get some committed node pointing to a node/leaf
that ends up not getting written to disk before the next log commit.

The problem, conceptually, started to happen in commit 88d2beec7e53fc
("btrfs: avoid logging all directory changes during renames"), because
there we started to update the log without joining its current transaction
first.

However the problem only became visible with commit 259c4b96d78dda
("btrfs: stop doing unnecessary log updates during a rename"), and that is
because we used to pin the log at btrfs_rename() and then before entering
btrfs_log_new_name(), when unlinking the old dentry, we ended up at
btrfs_del_inode_ref_in_log() and btrfs_del_dir_entries_in_log(). Both
of them join the current log transaction, effectively waiting for any log
transaction writeout (due to acquiring the root's log_mutex). This made it
safe even after leaving the current log transaction, because we remained
with the log pinned when we called btrfs_log_new_name().

Then in commit 259c4b96d78dda ("btrfs: stop doing unnecessary log updates
during a rename"), we removed the log pinning from btrfs_rename() and
stopped calling btrfs_del_inode_ref_in_log() and
btrfs_del_dir_entries_in_log() during the rename, and started to do all
the needed work at btrfs_log_new_name(), but without joining the current
log transaction, only pinning the log, which is racy because another task
may have started writeout of the log tree right before we pinned the log.

Both commits landed in kernel 5.18, so it doesn't make any practical
difference which should be blamed, but I'm blaming the second commit only
because with the first one, by chance, the problem did not happen due to
the fact we joined the log transaction after pinning the log and unpinned
it only after calling btrfs_log_new_name().

So make btrfs_log_new_name() join the current log transaction instead of
pinning it, so that we never do log updates if it's writeout is starting.

Fixes: 259c4b96d78dda ("btrfs: stop doing unnecessary log updates during a rename")
CC: stable@vger.kernel.org # 5.18+
Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Tested-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c94713c811bb..3c962bfd204f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7029,8 +7029,15 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		 * anyone from syncing the log until we have updated both inodes
 		 * in the log.
 		 */
+		ret = join_running_log_trans(root);
+		/*
+		 * At least one of the inodes was logged before, so this should
+		 * not fail, but if it does, it's not serious, just bail out and
+		 * mark the log for a full commit.
+		 */
+		if (WARN_ON_ONCE(ret < 0))
+			goto out;
 		log_pinned = true;
-		btrfs_pin_log_trans(root);
 
 		path = btrfs_alloc_path();
 		if (!path) {
-- 
2.35.1



