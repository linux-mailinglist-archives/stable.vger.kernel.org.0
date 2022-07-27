Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74058310C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiG0RpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243240AbiG0Rob (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:44:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59078BA98;
        Wed, 27 Jul 2022 09:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CBB5FCE2309;
        Wed, 27 Jul 2022 16:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF712C433C1;
        Wed, 27 Jul 2022 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940790;
        bh=1QI/Q7cS/pyQ6EjE/gPkhbaMHoT+HkDV5b+WsHny1O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvkmI6lAxjpeIM+i1TMHR1imk1v/9W77cHX5siei9+K71QU+0xzCqPxQVpfuhlffx
         5nmqID3+tNNVRTbD8GecjUt1iLOoB90M+/MsJU2JO1qylfh96laBKWp8Ff7QWIUeyj
         H0CuXSnHkC1mVuXx5QvUZgE2TqP2vfMYr6sd5kBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Andy Wu <Andy.Wu@sony.com>,
        Aoyama Wataru <wataru.aoyama@sony.com>,
        Daniel Palmer <daniel.palmer@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 150/158] exfat: fix referencing wrong parent directory information after renaming
Date:   Wed, 27 Jul 2022 18:13:34 +0200
Message-Id: <20220727161027.359196060@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit d8dad2588addd1d861ce19e7df3b702330f0c7e3 ]

During renaming, the parent directory information maybe
updated. But the file/directory still references to the
old parent directory information.

This bug will cause 2 problems.

(1) The renamed file can not be written.

    [10768.175172] exFAT-fs (sda1): error, failed to bmap (inode : 7afd50e4 iblock : 0, err : -5)
    [10768.184285] exFAT-fs (sda1): Filesystem has been set read-only
    ash: write error: Input/output error

(2) Some dentries of the renamed file/directory are not set
    to deleted after removing the file/directory.

exfat_update_parent_info() is a workaround for the wrong parent
directory information being used after renaming. Now that bug is
fixed, this is no longer needed, so remove it.

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Andy Wu <Andy.Wu@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index a02a04a993bf..76acc3721951 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1080,6 +1080,7 @@ static int exfat_rename_file(struct inode *inode, struct exfat_chain *p_dir,
 
 		exfat_remove_entries(inode, p_dir, oldentry, 0,
 			num_old_entries);
+		ei->dir = *p_dir;
 		ei->entry = newentry;
 	} else {
 		if (exfat_get_entry_type(epold) == TYPE_FILE) {
@@ -1167,28 +1168,6 @@ static int exfat_move_file(struct inode *inode, struct exfat_chain *p_olddir,
 	return 0;
 }
 
-static void exfat_update_parent_info(struct exfat_inode_info *ei,
-		struct inode *parent_inode)
-{
-	struct exfat_sb_info *sbi = EXFAT_SB(parent_inode->i_sb);
-	struct exfat_inode_info *parent_ei = EXFAT_I(parent_inode);
-	loff_t parent_isize = i_size_read(parent_inode);
-
-	/*
-	 * the problem that struct exfat_inode_info caches wrong parent info.
-	 *
-	 * because of flag-mismatch of ei->dir,
-	 * there is abnormal traversing cluster chain.
-	 */
-	if (unlikely(parent_ei->flags != ei->dir.flags ||
-		     parent_isize != EXFAT_CLU_TO_B(ei->dir.size, sbi) ||
-		     parent_ei->start_clu != ei->dir.dir)) {
-		exfat_chain_set(&ei->dir, parent_ei->start_clu,
-			EXFAT_B_TO_CLU_ROUND_UP(parent_isize, sbi),
-			parent_ei->flags);
-	}
-}
-
 /* rename or move a old file into a new file */
 static int __exfat_rename(struct inode *old_parent_inode,
 		struct exfat_inode_info *ei, struct inode *new_parent_inode,
@@ -1219,8 +1198,6 @@ static int __exfat_rename(struct inode *old_parent_inode,
 		return -ENOENT;
 	}
 
-	exfat_update_parent_info(ei, old_parent_inode);
-
 	exfat_chain_dup(&olddir, &ei->dir);
 	dentry = ei->entry;
 
@@ -1241,8 +1218,6 @@ static int __exfat_rename(struct inode *old_parent_inode,
 			goto out;
 		}
 
-		exfat_update_parent_info(new_ei, new_parent_inode);
-
 		p_dir = &(new_ei->dir);
 		new_entry = new_ei->entry;
 		ep = exfat_get_dentry(sb, p_dir, new_entry, &new_bh);
-- 
2.35.1



