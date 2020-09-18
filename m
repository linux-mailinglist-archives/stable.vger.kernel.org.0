Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41D526EDAA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgIRCWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbgIRCRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B60923888;
        Fri, 18 Sep 2020 02:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395424;
        bh=/3ETK0CJZF2j2HnUIvIYR8GjbyTgnlOglF1HHfQkJow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJiHKRdGzGO3Zm4hCURgEU5MOVFrbzLKpze6DqH3a0+6ghKhZu8eVwaIwYLkCby/i
         Z62FST8gLRN2C+qmfw0JkZHwPUBaao7HG6+1DB57AZGPhe242XO/rDfoA+kRCuACDW
         zNaPHdgOGwAgCEwTaly7tXZtUNL+d38rfeHkjwSs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 18/64] ext4: make dioread_nolock the default
Date:   Thu, 17 Sep 2020 22:15:57 -0400
Message-Id: <20200918021643.2067895-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 244adf6426ee31a83f397b700d964cff12a247d3 ]

This fixes the direct I/O versus writeback race which can reveal stale
data, and it improves the tail latency of commits on slow devices.

Link: https://lore.kernel.org/r/20200125022254.1101588-1-tytso@mit.edu
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aca086a25b2ef..5a623ea954882 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1251,6 +1251,7 @@ static const match_table_t tokens = {
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
 	{Opt_dioread_nolock, "dioread_nolock"},
+	{Opt_dioread_lock, "nodioread_nolock"},
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
@@ -3380,6 +3381,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, NO_UID32);
 	/* xattr user namespace & acls are now defaulted on */
 	set_opt(sb, XATTR_USER);
+	set_opt(sb, DIOREAD_NOLOCK);
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
@@ -3448,9 +3450,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
-			    "with data=journal disables delayed "
-			    "allocation and O_DIRECT support!\n");
+		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with data=journal disables delayed allocation, dioread_nolock, and O_DIRECT support!\n");
+		clear_opt(sb, DIOREAD_NOLOCK);
 		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "both data=journal and delalloc");
-- 
2.25.1

