Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4983457ACE9
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242221AbiGTB2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242027AbiGTB1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4087876473;
        Tue, 19 Jul 2022 18:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C87B81DEA;
        Wed, 20 Jul 2022 01:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D94C341C6;
        Wed, 20 Jul 2022 01:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279910;
        bh=yvYYLK8GTpvd0DLQXvYV+6tSNlBZQRy5OKk9R12S89Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noxgCKL2mllNuRxMoCis/H7toQ0RwSU/YGfJdPabFMYmTfX4sWLAdU71ROrGz5Njs
         3n7qCx1NfYprtCcfaJjAJNyooH0GXHAgCUFxbVibUWUzdzjHzKzPd1FCTkfLk12kdB
         IJhTxPZ1jEg9l0LY16Cs3vyE0idP0Sh+zb9ACuJMOLDNBuwmqqj4/UtGhDCRZrgPiJ
         J2VqErt4mrgck6s6zTcj2r9MVG6sK+ZdPjDqeDBMFnsE/x+O+tcMXdjTUw7AOsA51Y
         fv9M6PGc+ZPZu4Hj2nkbUkNF0Zqvwxx18swrEIP6mD/0LT5kmwzV4bv1fXVnOuWSe3
         lUhNF9PHlHsXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Tommy Pettersson <ptp@lysator.liu.se>,
        Ciprian Craciun <ciprian.craciun@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 5/8] nilfs2: fix incorrect masking of permission flags for symlinks
Date:   Tue, 19 Jul 2022 21:18:07 -0400
Message-Id: <20220720011810.1025308-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011810.1025308-1-sashal@kernel.org>
References: <20220720011810.1025308-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 5924e6ec1585445f251ea92713eb15beb732622a ]

The permission flags of newly created symlinks are wrongly dropped on
nilfs2 with the current umask value even though symlinks should have 777
(rwxrwxrwx) permissions:

 $ umask
 0022
 $ touch file && ln -s file symlink; ls -l file symlink
 -rw-r--r--. 1 root root 0 Jun 23 16:29 file
 lrwxr-xr-x. 1 root root 4 Jun 23 16:29 symlink -> file

This fixes the bug by inserting a missing check that excludes
symlinks.

Link: https://lkml.kernel.org/r/1655974441-5612-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Tommy Pettersson <ptp@lysator.liu.se>
Reported-by: Ciprian Craciun <ciprian.craciun@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/nilfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 8699bdc9e391..cca30f0f965c 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -198,6 +198,9 @@ static inline int nilfs_acl_chmod(struct inode *inode)
 
 static inline int nilfs_init_acl(struct inode *inode, struct inode *dir)
 {
+	if (S_ISLNK(inode->i_mode))
+		return 0;
+
 	inode->i_mode &= ~current_umask();
 	return 0;
 }
-- 
2.35.1

