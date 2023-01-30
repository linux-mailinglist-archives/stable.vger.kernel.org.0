Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B050681FA5
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 00:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjA3Xaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 18:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjA3Xa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 18:30:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214452B08D;
        Mon, 30 Jan 2023 15:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78691B80E78;
        Mon, 30 Jan 2023 23:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13131C433D2;
        Mon, 30 Jan 2023 23:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675121420;
        bh=FMTcL6olniPtNNtz/BQFcjIBXn318WG674lmTqi1i/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUL0FPguAEci4o3rmKuwbIuHfrpCDE4PCzCMDKo0uS947RQVAez3GvuuCKhWLoJsa
         Ml+fAKNw5mwwvBwpgdGQMT9ETdqLxoIWjYyOHgcWauFgFJC1jB1NRNIDprWnESV4GQ
         4vfRkS1ZzT1mDSrIfOrEwA87GJfZ5nGMzageALzYn5hE+8RUGCkF3HOR+FUXP2rvL9
         0mRmBIV8ZQEj18sXFWq42Ya21KGSIENzcI7UpV88pAQNpiyDWiSW22OdvdDrEVcbJz
         hwLdkW2lSTxZX3zgmO72bZjuui374zNvc+5YSJ6H8Y0XWB2vB6GEqfo9E5W4E2W7/R
         CJJQ9B40manDw==
Date:   Mon, 30 Jan 2023 15:30:18 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v3] f2fs: retry to update the inode page given
 EIO
Message-ID: <Y9hTCtWLo9/PQnnN@google.com>
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
 <Y74O+5SklijYqMU1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y74O+5SklijYqMU1@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the storage gives a corrupted node block due to short power failure and
reset, f2fs stops the entire operations by setting the checkpoint failure flag.

Let's give more chances to live by re-issuing IOs for a while in such critical
path.

Cc: stable@vger.kernel.org
Suggested-by: Randall Huang <huangrandall@google.com>
Suggested-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---

 Change log from v2:
  - adopting the retry logic

 fs/f2fs/inode.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index e1d6e021e82b..7bf660d4cad9 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -724,18 +724,19 @@ void f2fs_update_inode_page(struct inode *inode)
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
-- 
2.39.1.456.gfc5497dd1b-goog

