Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3316B94D1
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjCNMtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjCNMsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:48:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C517A72B19;
        Tue, 14 Mar 2023 05:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09390B8191D;
        Tue, 14 Mar 2023 12:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15AAC4339E;
        Tue, 14 Mar 2023 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797846;
        bh=7k+n3dNoc7z/dJQxCR6EdQjZROTFnPWiYiSHDPqcrvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeBjZtvpPq8tTO6poj3fmCYmF/PquFnKP3cX2zOwC7veRiM/zqStcf+A5APmpJ5mz
         oVIRvg1EfMbR8c5iGzQFZwp3hPwFF2q4As1PEOUAz6niLg2YsljeZEufbSm+yXLbLB
         8Ve1nw+SOBma3217jntx1rNVRflN1GdVMtYRfx+MVL0RbJiAOT3FZoP4RQQwGK3eAU
         oSIwIbkPnNQI6f3lPLK+nQE4pgVlMTOxWLRPGH8hSTMlQY9GGX8FZGq+4zo2d2rUpj
         jdKoUsR1XaB90YHDTrEyvmhs3wvy5qL77qsf2y/G2VAPKuav0mNFOHRwgS10JXEBQ4
         +CSmVjW/vivcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/8] ext4: fail ext4_iget if special inode unallocated
Date:   Tue, 14 Mar 2023 08:43:56 -0400
Message-Id: <20230314124400.471257-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124400.471257-1-sashal@kernel.org>
References: <20230314124400.471257-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 5cd740287ae5e3f9d1c46f5bfe8778972fd6d3fe ]

In ext4_fill_super(), EXT4_ORPHAN_FS flag is cleared after
ext4_orphan_cleanup() is executed. Therefore, when __ext4_iget() is
called to get an inode whose i_nlink is 0 when the flag exists, no error
is returned. If the inode is a special inode, a null pointer dereference
may occur. If the value of i_nlink is 0 for any inodes (except boot loader
inodes) got by using the EXT4_IGET_SPECIAL flag, the current file system
is corrupted. Therefore, make the ext4_iget() function return an error if
it gets such an abnormal special inode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199179
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216541
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216539
Reported-by: Luís Henriques <lhenriques@suse.de>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230107032126.4165860-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 355343cf4609b..03805ec32dae5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4716,13 +4716,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
 
-	if ((ino == EXT4_ROOT_INO) && (raw_inode->i_links_count == 0)) {
-		ext4_error_inode(inode, function, line, 0,
-				 "iget: root inode unallocated");
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
-	}
-
 	if ((flags & EXT4_IGET_HANDLE) &&
 	    (raw_inode->i_links_count == 0) && (raw_inode->i_mode == 0)) {
 		ret = -ESTALE;
@@ -4795,11 +4788,16 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	 * NeilBrown 1999oct15
 	 */
 	if (inode->i_nlink == 0) {
-		if ((inode->i_mode == 0 ||
+		if ((inode->i_mode == 0 || flags & EXT4_IGET_SPECIAL ||
 		     !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
 		    ino != EXT4_BOOT_LOADER_INO) {
-			/* this inode is deleted */
-			ret = -ESTALE;
+			/* this inode is deleted or unallocated */
+			if (flags & EXT4_IGET_SPECIAL) {
+				ext4_error_inode(inode, function, line, 0,
+						 "iget: special inode unallocated");
+				ret = -EFSCORRUPTED;
+			} else
+				ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
-- 
2.39.2

