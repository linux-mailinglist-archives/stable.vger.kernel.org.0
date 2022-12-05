Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054D7643380
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiLETgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiLETg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:36:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E314B220F0
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CD6EB81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08096C433C1;
        Mon,  5 Dec 2022 19:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268807;
        bh=yD4KWUQ3KdvD52boQDxFCJXWgEQ2eX2LaHIdjB+ceKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFvZBpFU/u0PMWZpARuYzwwg+V32t7AtdwF5t4lKz9cnryN4x1KkE4HG52zC7C3Ao
         iCPIbCAoc87qnWjTO4fednANFX3A+ol9H6C6p/ELOTGjYcD34dBpLgrRifp+b0JVk9
         PQUTKCGzsMEKMlLA4CKscC6IJDnUmQkqb8TCAaNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/120] btrfs: move QUOTA_ENABLED check to rescan_should_stop from btrfs_qgroup_rescan_worker
Date:   Mon,  5 Dec 2022 20:09:08 +0100
Message-Id: <20221205190806.811796189@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit db5df254120004471e1c957957ab2f1e612dcbd6 ]

Instead of having 2 places that short circuit the qgroup leaf scan have
everything in the qgroup_rescan_leaf function. In addition to that, also
ensure that the inconsistent qgroup flag is set when rescan_should_stop
returns true. This both retains the old behavior when -EINTR was set in
the body of the loop and at the same time also extends this behavior
when scanning is interrupted due to remount or unmount operations.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: f7e942b5bb35 ("btrfs: qgroup: fix sleep from invalid context bug in btrfs_qgroup_inherit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/qgroup.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e01065696e9c..b9db096c5286 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3280,7 +3280,8 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	return btrfs_fs_closing(fs_info) ||
-		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state) ||
+		!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 }
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
@@ -3310,11 +3311,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			err = PTR_ERR(trans);
 			break;
 		}
-		if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-			err = -EINTR;
-		} else {
-			err = qgroup_rescan_leaf(trans, path);
-		}
+
+		err = qgroup_rescan_leaf(trans, path);
+
 		if (err > 0)
 			btrfs_commit_transaction(trans);
 		else
@@ -3328,7 +3327,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	} else if (err < 0) {
+	} else if (err < 0 || stopped) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
-- 
2.35.1



