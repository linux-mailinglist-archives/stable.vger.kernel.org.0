Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0A4BE5D6
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351164AbiBUJsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:48:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351665AbiBUJqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:46:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374443FD91;
        Mon, 21 Feb 2022 01:18:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9EB960F51;
        Mon, 21 Feb 2022 09:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1B0C340F5;
        Mon, 21 Feb 2022 09:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435117;
        bh=TXTiTY4Ys45f9GxVHtZc35Xx0/63xfUWdOIcjcLwCA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSOPhYZouQNsJtY7gL+uCOc3sFaeo5NE4pjKuR/aoYXAzzB3MawRiqCwKVGJL0ccK
         Mv/a6d49e5rsGCXEwnVYNjmpHLU2dWxF1js4P1adFLtsI/Z+5oxphPTCdFWTPy9abW
         j01a+SdDUyFkE29GZzTouk1wtDX+9RhSvAJW6JJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 051/227] vfs: make sync_filesystem return errors from ->sync_fs
Date:   Mon, 21 Feb 2022 09:47:50 +0100
Message-Id: <20220221084936.569402281@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 5679897eb104cec9e99609c3f045a0c20603da4c ]

Strangely, sync_filesystem ignores the return code from the ->sync_fs
call, which means that syscalls like syncfs(2) never see the error.
This doesn't seem right, so fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sync.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 3ce8e2137f310..c7690016453e4 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -29,7 +29,7 @@
  */
 int sync_filesystem(struct super_block *sb)
 {
-	int ret;
+	int ret = 0;
 
 	/*
 	 * We need to be protected against the filesystem going from
@@ -52,15 +52,21 @@ int sync_filesystem(struct super_block *sb)
 	 * at a time.
 	 */
 	writeback_inodes_sb(sb, WB_REASON_SYNC);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 0);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 0);
+		if (ret)
+			return ret;
+	}
 	ret = sync_blockdev_nowait(sb->s_bdev);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	sync_inodes_sb(sb);
-	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, 1);
+	if (sb->s_op->sync_fs) {
+		ret = sb->s_op->sync_fs(sb, 1);
+		if (ret)
+			return ret;
+	}
 	return sync_blockdev(sb->s_bdev);
 }
 EXPORT_SYMBOL(sync_filesystem);
-- 
2.34.1



