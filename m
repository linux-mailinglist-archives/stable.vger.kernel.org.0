Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3FF12C5FD
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfL2Rmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730133AbfL2Rmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8525C20718;
        Sun, 29 Dec 2019 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641363;
        bh=PRylnbn24HwMZ4fyfuSUYYUeY/UQ/uiCoiFt3mZAZhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V4y0IMeh2kO3QprAJfq12HWOUuL+fP6r7iGHjdCKkt9Hni01iAR227jRxo0UK74KV
         Hy26bubyavFTBLOh26If+CN/nm+ONvBmR/8Cq15Aa1/+uplSBpsRpHIqRdar8aqiK8
         OrRVEAd9IJtiYoRdaldEh6g1kWJ38tOmJ635kmcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 035/434] btrfs: skip log replay on orphaned roots
Date:   Sun, 29 Dec 2019 18:21:28 +0100
Message-Id: <20191229172704.366629402@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -6337,9 +6337,28 @@ again:
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
+				ret = btrfs_pin_extent_for_log_replay(fs_info,
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
@@ -6371,7 +6390,6 @@ again:
 						  &root->highest_objectid);
 		}
 
-		key.offset = found_key.offset - 1;
 		wc.replay_dest->log_root = NULL;
 		free_extent_buffer(log->node);
 		free_extent_buffer(log->commit_root);
@@ -6379,9 +6397,10 @@ again:
 
 		if (ret)
 			goto error;
-
+next:
 		if (found_key.offset == 0)
 			break;
+		key.offset = found_key.offset - 1;
 	}
 	btrfs_release_path(path);
 


