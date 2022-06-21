Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907EB553C5C
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355761AbiFUVBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 17:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355541AbiFUU6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 16:58:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84709326E0;
        Tue, 21 Jun 2022 13:51:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89996B81B3A;
        Tue, 21 Jun 2022 20:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED80C36AE3;
        Tue, 21 Jun 2022 20:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655844632;
        bh=dIM7iEccu207ZB7h7nXDFCY96ISltuBe6kC/RN40lTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7Wuz9UYJGA3j95iwGySpKVmCQurqyzxziMkTHqepzwRhyxhWu30szvUJlBTct5Lm
         eoW8iwemZ5cReF6Mf6Ak7xqNf3JEtLCj3sn2walC164gQbCG1ia0aJd8XureetdVKU
         XxjDqH3O8Dp+x04PtpOKGVeIULigIMpjomqCSmrFxfvPmdAq49uySoyU2vGovooLbI
         z/xl4S/3ciPtqNWR7cw3hAP/7u9k3jFlMXF9B5apgM0tb8XX0XqoCae07OVcGNxuV8
         VKznvrhTSpUoM4yc1u2/7wztutbBiCin00l6j5wr1F4YrDKjeCX3/eTA4oMV3+0w6/
         u1ytaB3WRMJHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jack@suse.com,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 13/20] ext2: fix fs corruption when trying to remove a non-empty directory with IO error
Date:   Tue, 21 Jun 2022 16:50:03 -0400
Message-Id: <20220621205010.250185-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621205010.250185-1-sashal@kernel.org>
References: <20220621205010.250185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 27cfa258951a465e3eae63ee1e715e902cd45578 ]

We got issue as follows:
[home]# mount  /dev/sdd  test
[home]# cd test
[test]# ls
dir1  lost+found
[test]# rmdir  dir1
ext2_empty_dir: inject fault
[test]# ls
lost+found
[test]# cd ..
[home]# umount test
[home]# fsck.ext2 -fn  /dev/sdd
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Inode 4065, i_size is 0, should be 1024.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Unconnected directory inode 4065 (/???)
Connect to /lost+found? no

'..' in ... (4065) is / (2), should be <The NULL inode> (0).
Fix? no

Pass 4: Checking reference counts
Inode 2 ref count is 3, should be 4.  Fix? no

Inode 4065 ref count is 2, should be 3.  Fix? no

Pass 5: Checking group summary information

/dev/sdd: ********** WARNING: Filesystem still has errors **********

/dev/sdd: 14/128016 files (0.0% non-contiguous), 18477/512000 blocks

Reason is same with commit 7aab5c84a0f6. We can't assume directory
is empty when read directory entry failed.

Link: https://lore.kernel.org/r/20220615090010.1544152-1-yebin10@huawei.com
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/dir.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 2c2f179b6977..43de293cef56 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -672,17 +672,14 @@ int ext2_empty_dir (struct inode * inode)
 	void *page_addr = NULL;
 	struct page *page = NULL;
 	unsigned long i, npages = dir_pages(inode);
-	int dir_has_error = 0;
 
 	for (i = 0; i < npages; i++) {
 		char *kaddr;
 		ext2_dirent * de;
-		page = ext2_get_page(inode, i, dir_has_error, &page_addr);
+		page = ext2_get_page(inode, i, 0, &page_addr);
 
-		if (IS_ERR(page)) {
-			dir_has_error = 1;
-			continue;
-		}
+		if (IS_ERR(page))
+			goto not_empty;
 
 		kaddr = page_addr;
 		de = (ext2_dirent *)kaddr;
-- 
2.35.1

