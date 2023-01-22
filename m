Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF900676FAC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjAVPYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjAVPYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9D11CAC6
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 864EA60C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C28C433D2;
        Sun, 22 Jan 2023 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401038;
        bh=1s7zHPXd5oRvyw4A38we3ufP+2PUKcqxaNe0KiMTC+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unNmOqd/q13sBxtJMroKDMZUb6afaW1l1fRjXHasH6yV5AimhEpYqMcAhBvEj9Q0/
         hzWFlu0gtZKiP1ey62k0/3Asz38CSTHNscQQKy0iHLYkJHKxsRICKMD2Q5LlUJt3jA
         tAZVJ/1CSlfMrbBLhCHNMdbc6aEQaWUACwu0Sh4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 086/193] btrfs: do not abort transaction on failure to update log root
Date:   Sun, 22 Jan 2023 16:03:35 +0100
Message-Id: <20230122150250.322613248@linuxfoundation.org>
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

commit 09e44868f1e03c7825ca4283256abedc95e249a3 upstream.

When syncing a log, if we fail to update a log root in the log root tree,
we are aborting the transaction if the failure was not -ENOSPC. This is
excessive because there is a chance that a transaction commit can succeed,
and therefore avoid to turn the filesystem into RO mode. All we need to be
careful about is to mark the log for a full commit, which we already do,
to make sure no one commits a super block pointing to an outdated log root
tree.

So don't abort the transaction if we fail to update a log root in the log
root tree, and log an error if the failure is not -ENOSPC, so that it does
not go completely unnoticed.

CC: stable@vger.kernel.org # 6.0+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3075,15 +3075,12 @@ int btrfs_sync_log(struct btrfs_trans_ha
 
 		blk_finish_plug(&plug);
 		btrfs_set_log_full_commit(trans);
-
-		if (ret != -ENOSPC) {
-			btrfs_abort_transaction(trans, ret);
-			mutex_unlock(&log_root_tree->log_mutex);
-			goto out;
-		}
+		if (ret != -ENOSPC)
+			btrfs_err(fs_info,
+				  "failed to update log for root %llu ret %d",
+				  root->root_key.objectid, ret);
 		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = BTRFS_LOG_FORCE_COMMIT;
 		goto out;
 	}
 


