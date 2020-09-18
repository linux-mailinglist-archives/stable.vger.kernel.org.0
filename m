Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4615126EE69
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgIRC2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgIRCP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:15:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD10F238EE;
        Fri, 18 Sep 2020 02:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395325;
        bh=3hHkqwQ4k+wx8x0Qlt8qQcccjUDEaGPJWNeIDlz0oaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lG1FkxIYXoPzVxkAu7glyCOYs0rS/USm3AATuYIJAH5jAD4oIDM4O4/t+3m9940Y
         uZM8BDqJhhep4Nr7CcWeMdyOrKErU0eURQCbtq9tiry6jGw+RUwgsSfdzI4Q23/BNG
         BPwUFc8AcO+XeAM/61UD5oCt7RITd8ABLKL5Zp5o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 26/90] ext4: make dioread_nolock the default
Date:   Thu, 17 Sep 2020 22:13:51 -0400
Message-Id: <20200918021455.2067301-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
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
index 472fa29c6f604..b1fd544929f7e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1367,6 +1367,7 @@ static const match_table_t tokens = {
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
 	{Opt_dioread_nolock, "dioread_nolock"},
+	{Opt_dioread_lock, "nodioread_nolock"},
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
@@ -3548,6 +3549,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, NO_UID32);
 	/* xattr user namespace & acls are now defaulted on */
 	set_opt(sb, XATTR_USER);
+	set_opt(sb, DIOREAD_NOLOCK);
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
@@ -3616,9 +3618,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

