Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF90129933
	for <lists+stable@lfdr.de>; Mon, 23 Dec 2019 18:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLWRPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 12:15:36 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44037 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726718AbfLWRPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 12:15:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F16621F82;
        Mon, 23 Dec 2019 12:15:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 23 Dec 2019 12:15:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=244WeK
        6N2L/DMKFXo5EGtLj+jjyW0kYpbqEFaN0iGuA=; b=NZTLOTtZXV32BrPJ+cfND1
        KLxVM1yCJAUCZlvIBJZb9S5i4ah4rFhTzvbZxHwcYkzrKibl99r0/bQA6bczbpTg
        0bMGXaqKqYnXczUG/HiiKEtYB8setiAzQZdbp7RbU2yzFepbWIp0Zwuta6iWDH0p
        nsi4KfrmoeDl26Qgri2sfwiylCW04vv2l/EyZRyozxKMHrB96iQL8lK4se7aSbiA
        TEm93APedOAhxxJyD7LsdQiocseOHNDyO4NqsHd7ws+Aq97fbxj4PsajBPVi/HcJ
        EIQ/a7bK3k0+py4BatPXV4m06iSxqHsVDOD9axU9ZvXYdzuzSo0O68Q1kv30cVAw
        ==
X-ME-Sender: <xms:N_YAXm9RAzYKE_jpm-hIXJqSuD2gp_ywiqWu3SC8Tt8Z-g_HRjEPIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeduleekrdekledrieegrddvgeelnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedutd
X-ME-Proxy: <xmx:N_YAXjaykVycfivoBfPgIpGiO6pO8DEk14SUikZ-_fgSld9K3IZsoA>
    <xmx:N_YAXv5H2-e5Rh4fL7wHHSiQiO2ZSjeSVgLoL1Yxf41Q5kSemqnoQQ>
    <xmx:N_YAXonO-fppdaW0qr_Le4zWBLhBSLJY-W1OzQ8EFlh6iGxCDScnnQ>
    <xmx:N_YAXvbEose-q_6acqpDx8sM5qmS0OHJa_Hiz82xO72joiPsFo6-AQ>
Received: from localhost (unknown [198.89.64.249])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF4293060A6E;
        Mon, 23 Dec 2019 12:15:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: skip log replay on orphaned roots" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Dec 2019 12:15:30 -0500
Message-ID: <157712133014473@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9bc574de590510eff899c3ca8dbaf013566b5efe Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 6 Dec 2019 09:37:17 -0500
Subject: [PATCH] btrfs: skip log replay on orphaned roots

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

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79866f1b33d6..d3f115909ff0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6317,9 +6317,28 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
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
@@ -6351,7 +6370,6 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 						  &root->highest_objectid);
 		}
 
-		key.offset = found_key.offset - 1;
 		wc.replay_dest->log_root = NULL;
 		free_extent_buffer(log->node);
 		free_extent_buffer(log->commit_root);
@@ -6359,9 +6377,10 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 		if (ret)
 			goto error;
-
+next:
 		if (found_key.offset == 0)
 			break;
+		key.offset = found_key.offset - 1;
 	}
 	btrfs_release_path(path);
 

