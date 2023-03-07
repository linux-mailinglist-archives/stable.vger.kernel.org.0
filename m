Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9C6AEC3F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjCGRxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjCGRxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:53:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE28DD31D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89EBCB819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD2FC433D2;
        Tue,  7 Mar 2023 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211259;
        bh=70y1U63keAodOZJFq4PorxI2kI6/zEqyIpIvlOXZUuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlO5iv8UvxoRoy4f0iSJaHoINqtX07p37BfTq5mIs/Zmbu8NqTho/SVks6iR99INW
         KMELv8yRDMcp1KGR9g22ywO+/dMaYisa3ofrDJYvfc/raf0uMEfXPd3xsji4LJj5V7
         kSF5UP9rZSbxBH7o9JT/Nr098l4Ds77L9iO4MHRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randall Huang <huangrandall@google.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.2 0805/1001] f2fs: retry to update the inode page given data corruption
Date:   Tue,  7 Mar 2023 17:59:37 +0100
Message-Id: <20230307170056.665594541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 3aa51c61cb4a4dcb40df51ac61171e9ac5a35321 upstream.

If the storage gives a corrupted node block due to short power failure and
reset, f2fs stops the entire operations by setting the checkpoint failure flag.

Let's give more chances to live by re-issuing IOs for a while in such critical
path.

Cc: stable@vger.kernel.org
Suggested-by: Randall Huang <huangrandall@google.com>
Suggested-by: Chao Yu <chao@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -714,18 +714,19 @@ void f2fs_update_inode_page(struct inode
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *node_page;
+	int count = 0;
 retry:
 	node_page = f2fs_get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(node_page)) {
 		int err = PTR_ERR(node_page);
 
-		if (err == -ENOMEM) {
-			cond_resched();
+		/* The node block was truncated. */
+		if (err == -ENOENT)
+			return;
+
+		if (err == -ENOMEM || ++count <= DEFAULT_RETRY_IO_COUNT)
 			goto retry;
-		} else if (err != -ENOENT) {
-			f2fs_stop_checkpoint(sbi, false,
-					STOP_CP_REASON_UPDATE_INODE);
-		}
+		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_UPDATE_INODE);
 		return;
 	}
 	f2fs_update_inode(inode, node_page);


