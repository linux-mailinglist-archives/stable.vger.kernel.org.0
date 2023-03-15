Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8F66BB157
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjCOM0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjCOM02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:26:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE1696637
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E02361D76
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E62C433EF;
        Wed, 15 Mar 2023 12:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883132;
        bh=ZsowzgbMxLxIFkdvBINhxiT3rHrj9ISiycPqOuoFcoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBsKxpB5c/ch9CfM5waz0Mg27eRU65eTr/yZ4zpGVY3KHJHI2q0Ft/OCEZe2S1K9T
         tHMKoL4kVh0G7Mvu99F8XghlzMtsl/fBfsbWzu7ZTgdZxV5M+uIfLdTVRrKw6KlBJX
         2yV3MORutRY86VKLA3wX4GT0FNYFvoiS3ZXmY+JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randall Huang <huangrandall@google.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/145] f2fs: retry to update the inode page given data corruption
Date:   Wed, 15 Mar 2023 13:11:33 +0100
Message-Id: <20230315115739.932295669@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 3aa51c61cb4a4dcb40df51ac61171e9ac5a35321 ]

If the storage gives a corrupted node block due to short power failure and
reset, f2fs stops the entire operations by setting the checkpoint failure flag.

Let's give more chances to live by re-issuing IOs for a while in such critical
path.

Cc: stable@vger.kernel.org
Suggested-by: Randall Huang <huangrandall@google.com>
Suggested-by: Chao Yu <chao@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2fa0fcffe0c6d..94e21136d5790 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -681,17 +681,19 @@ void f2fs_update_inode_page(struct inode *inode)
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
-			f2fs_stop_checkpoint(sbi, false);
-		}
+		f2fs_stop_checkpoint(sbi, false);
 		return;
 	}
 	f2fs_update_inode(inode, node_page);
-- 
2.39.2



