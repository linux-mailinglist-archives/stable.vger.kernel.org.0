Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F044F1B68B7
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgDWXRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:17:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49338 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728331AbgDWXGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:42 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-0004hp-Fi; Fri, 24 Apr 2020 00:06:34 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvQ-00E6oO-C6; Fri, 24 Apr 2020 00:06:32 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Filipe Manana" <fdmanana@suse.com>,
        "Josef Bacik" <josef@toxicpanda.com>,
        "David Sterba" <dsterba@suse.com>
Date:   Fri, 24 Apr 2020 00:05:44 +0100
Message-ID: <lsq.1587683028.240301051@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 117/245] btrfs: skip log replay on orphaned roots
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 9bc574de590510eff899c3ca8dbaf013566b5efe upstream.

My fsstress modifications coupled with generic/475 uncovered a failure
to mount and replay the log if we hit a orphaned root.  We do not want
to replay the log for an orphan root, but it's completely legitimate to
have an orphaned root with a log attached.  Fix this by simply skipping
replaying the log.  We still need to pin it's root node so that we do
not overwrite it while replaying other logs, as we re-read the log root
at every stage of the replay.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 3.16:
 - Pass fs_info->extent_root, instead of fs_info, as first argument to
   btrfs_pin_extent_for_log_replay()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4583,9 +4583,29 @@ again:
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
+				ret = btrfs_pin_extent_for_log_replay(
+							fs_info->extent_root,
+							log->node->start,
+							log->node->len);
 			free_extent_buffer(log->node);
 			free_extent_buffer(log->commit_root);
 			kfree(log);
+
+			if (!ret)
+				goto next;
 			btrfs_error(fs_info, ret, "Couldn't read target root "
 				    "for tree log recovery.");
 			goto error;
@@ -4600,7 +4620,6 @@ again:
 						      path);
 		}
 
-		key.offset = found_key.offset - 1;
 		wc.replay_dest->log_root = NULL;
 		free_extent_buffer(log->node);
 		free_extent_buffer(log->commit_root);
@@ -4608,9 +4627,10 @@ again:
 
 		if (ret)
 			goto error;
-
+next:
 		if (found_key.offset == 0)
 			break;
+		key.offset = found_key.offset - 1;
 	}
 	btrfs_release_path(path);
 

