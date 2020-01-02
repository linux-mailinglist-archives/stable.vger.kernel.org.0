Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E89B12EFD1
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgABW1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:27:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbgABW1M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:27:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB04220863;
        Thu,  2 Jan 2020 22:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004031;
        bh=eZwvdfSSuLBn6dqS85spYRe+hojyQ5eJOo9l4WIMymI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMpiYJ56e+XY5UQi1aVawbUlXafcjL7QOq3jjvSq/RtbrPbR3imMBfGD2wqBS3gNi
         GnUKqXF9kvf8I1/L04vWyUefGFar2AvMhMdAzdaUnK8QekzPwahcIE26G3XqVI4iUa
         o4TrcmP3eCrca4WXhEPwcFGuJJNzXibZtJX1I9yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 001/171] btrfs: skip log replay on orphaned roots
Date:   Thu,  2 Jan 2020 23:05:32 +0100
Message-Id: <20200102220547.135965980@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 9bc574de590510eff899c3ca8dbaf013566b5efe upstream.

My fsstress modifications coupled with generic/475 uncovered a failure
to mount and replay the log if we hit a orphaned root.  We do not want
to replay the log for an orphan root, but it's completely legitimate to
have an orphaned root with a log attached.  Fix this by simply skipping
replaying the log.  We still need to pin it's root node so that we do
not overwrite it while replaying other logs, as we re-read the log root
at every stage of the replay.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5702,9 +5702,28 @@ again:
 		wc.replay_dest = btrfs_read_fs_root_no_name(fs_info, &tmp_key);
 		if (IS_ERR(wc.replay_dest)) {
 			ret = PTR_ERR(wc.replay_dest);
+
+			/*
+			 * We didn't find the subvol, likely because it was
+			 * deleted.  This is ok, simply skip this log and go to
+			 * the next one.
+			 *
+			 * We need to exclude the root because we can't have
+			 * other log replays overwriting this log as we'll read
+			 * it back in a few more times.  This will keep our
+			 * block from being modified, and we'll just bail for
+			 * each subsequent pass.
+			 */
+			if (ret == -ENOENT)
+				ret = btrfs_pin_extent_for_log_replay(fs_info->extent_root,
+							log->node->start,
+							log->node->len);
 			free_extent_buffer(log->node);
 			free_extent_buffer(log->commit_root);
 			kfree(log);
+
+			if (!ret)
+				goto next;
 			btrfs_handle_fs_error(fs_info, ret,
 				"Couldn't read target root for tree log recovery.");
 			goto error;
@@ -5736,7 +5755,6 @@ again:
 						  &root->highest_objectid);
 		}
 
-		key.offset = found_key.offset - 1;
 		wc.replay_dest->log_root = NULL;
 		free_extent_buffer(log->node);
 		free_extent_buffer(log->commit_root);
@@ -5744,9 +5762,10 @@ again:
 
 		if (ret)
 			goto error;
-
+next:
 		if (found_key.offset == 0)
 			break;
+		key.offset = found_key.offset - 1;
 	}
 	btrfs_release_path(path);
 


