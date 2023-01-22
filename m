Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3D676FA9
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjAVPX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjAVPXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:23:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B981E2A0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:23:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4EA60C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBB0C433D2;
        Sun, 22 Jan 2023 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401033;
        bh=Z3v8u28F2/rDFaLHq5E8JDJeqSMGVvL1mmRi8hKsLNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKsLPmafW/Xw8PhwElmcBb9n/Xcj6Mu7POnYuzqhX0NgfUXzGpVUFkILuWBtgcuQ4
         G5+3j7SXmXSwTUJlHLlW8Ju21pXdmMw9EHnkqrT+7IQ6rny6GMcNQ6rG/RgX3RnQXI
         r50t4C8Snop0UEgRJpEwtxA7jVfTDntm83y6WYpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 084/193] btrfs: add missing setup of log for full commit at add_conflicting_inode()
Date:   Sun, 22 Jan 2023 16:03:33 +0100
Message-Id: <20230122150250.226938729@linuxfoundation.org>
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

commit 94cd63ae679973edeb5ea95ec25a54467c3e54c8 upstream.

When logging conflicting inodes, if we reach the maximum limit of inodes,
we return BTRFS_LOG_FORCE_COMMIT to force a transaction commit. However
we don't mark the log for full commit (with btrfs_set_log_full_commit()),
which means that once we leave the log transaction and before we commit
the transaction, some other task may sync the log, which is incomplete
as we have not logged all conflicting inodes, leading to some inconsistent
in case that log ends up being replayed.

So also call btrfs_set_log_full_commit() at add_conflicting_inode().

Fixes: e09d94c9e448 ("btrfs: log conflicting inodes without holding log mutex of the initial inode")
CC: stable@vger.kernel.org # 6.1
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5626,8 +5626,10 @@ static int add_conflicting_inode(struct
 	 * LOG_INODE_EXISTS mode) and slow down other fsyncs or transaction
 	 * commits.
 	 */
-	if (ctx->num_conflict_inodes >= MAX_CONFLICT_INODES)
+	if (ctx->num_conflict_inodes >= MAX_CONFLICT_INODES) {
+		btrfs_set_log_full_commit(trans);
 		return BTRFS_LOG_FORCE_COMMIT;
+	}
 
 	inode = btrfs_iget(root->fs_info->sb, ino, root);
 	/*


