Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEF026EF87
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgIRCgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgIRCM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93822376E;
        Fri, 18 Sep 2020 02:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395177;
        bh=bfQLjtX0VTcjsk8579wkG6Q6EvF2coDfWVk/9ijALns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FxISzLRSYfbvE5TOIRWeKJX9pG47tWF8liJjNRDbDyjlL+LSkSqG2HqXwRcRODTW
         EzCCN4CO9YMnSMUYZ5xapPb/VhYO6gNyoG+kyJ6XIyqloT6sFdTDVWRZZ6Y117RK7P
         CQTTkkiuJewk2Tl0ueyq2l0etx5Ik0eNhQ2MRDRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 033/127] ext4: make dioread_nolock the default
Date:   Thu, 17 Sep 2020 22:10:46 -0400
Message-Id: <20200918021220.2066485-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
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
index 634c822d1dc98..74516e7fa80f1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1471,6 +1471,7 @@ static const match_table_t tokens = {
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
 	{Opt_dioread_nolock, "dioread_nolock"},
+	{Opt_dioread_lock, "nodioread_nolock"},
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
@@ -3633,6 +3634,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, NO_UID32);
 	/* xattr user namespace & acls are now defaulted on */
 	set_opt(sb, XATTR_USER);
+	set_opt(sb, DIOREAD_NOLOCK);
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	set_opt(sb, POSIX_ACL);
 #endif
@@ -3770,9 +3772,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

