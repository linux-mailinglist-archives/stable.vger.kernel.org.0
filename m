Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AA765F7CD
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 00:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbjAEXmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 18:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236589AbjAEXlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 18:41:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDED6D369;
        Thu,  5 Jan 2023 15:40:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2B961C63;
        Thu,  5 Jan 2023 23:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B427FC433EF;
        Thu,  5 Jan 2023 23:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672961954;
        bh=k2zX9ykuOQxejXRAE9f9jXrb0X06NknQnoJI39Wq2uI=;
        h=From:To:Cc:Subject:Date:From;
        b=RkwH/EqhZCJwBqJ5dkkcznlUnfj0cVy4Vc5roj2yb6DV6v450qdmWWY82DXxfL2gO
         GzWaq9cBVm7S6ZVy6/tSST7LMTtnQHM8HclV5zAjIxVvzuf63z4FlPDiqwRYSO9Bdd
         5/C4za4dfgHKapnAjjb6s90lDCduK2kyBbh2vdqeFezcPxmoamxf1IjtUhqKbe9Hpl
         45cCz9/cpqUQlQHYuKMZEcLGwsrNL95qjQphh6bp4Q719DgeXSBmdOdpovtL6C2+Fe
         Mr9vkj7pPCJH88S5c7hJAU+fknDB8E1rmObSfmmP820uTZs77a1zBxUJpoSfmbqK4p
         1VQOffNJb7PSA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org,
        Randall Huang <huangrandall@google.com>
Subject: [PATCH] f2fs: retry to update the inode page given EIO
Date:   Thu,  5 Jan 2023 15:39:08 -0800
Message-Id: <20230105233908.1030651-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In f2fs_update_inode_page, f2fs_get_node_page handles EIO along with
f2fs_handle_page_eio that stops checkpoint, if the disk couldn't be recovered.
As a result, we don't need to stop checkpoint right away given single EIO.

Cc: stable@vger.kernel.org
Signed-off-by: Randall Huang <huangrandall@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 01b9e6f85f6b..66e407fcefd3 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -719,10 +719,10 @@ void f2fs_update_inode_page(struct inode *inode)
 	if (IS_ERR(node_page)) {
 		int err = PTR_ERR(node_page);
 
-		if (err == -ENOMEM) {
+		if (err == -ENOMEM || err == -EIO) {
 			cond_resched();
 			goto retry;
-		} else if (err != -ENOENT) {
+		} else if (err != -ENOENT || f2fs_cp_error(sbi)) {
 			f2fs_stop_checkpoint(sbi, false,
 					STOP_CP_REASON_UPDATE_INODE);
 		}
-- 
2.39.0.314.g84b9a713c41-goog

