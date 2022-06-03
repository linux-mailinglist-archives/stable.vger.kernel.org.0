Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537F653CFCA
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbiFCR4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345733AbiFCR4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:56:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F6C56423;
        Fri,  3 Jun 2022 10:53:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76E79B82419;
        Fri,  3 Jun 2022 17:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF54C385A9;
        Fri,  3 Jun 2022 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278820;
        bh=Ig21DrWcYMhGZvJLpvkh2ETAM6uWDNlNzd6CvlZgm+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPbSnEDvXCI4dMy5FXWpOsJzX68G3ftFjSvsBd4Z+dw7/dPLA0TF+JwGOIkkm61Q8
         1w0tmWyCUHFgE1VUrIc1pYi7pgiA3m13m3JCUnoY6D/aOG8LgtC6jzRdYWmW+8ti8H
         /csEx4tbO9XpMf0Xkyp9fuOYLn5oVfbGbSP4ELF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuezhang Mo <Yuezhang.Mo@sony.com>,
        Andy Wu <Andy.Wu@sony.com>,
        Aoyama Wataru <wataru.aoyama@sony.com>,
        Daniel Palmer <daniel.palmer@sony.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.17 20/75] exfat: fix referencing wrong parent directory information after renaming
Date:   Fri,  3 Jun 2022 19:43:04 +0200
Message-Id: <20220603173822.321388602@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit d8dad2588addd1d861ce19e7df3b702330f0c7e3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/namei.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1062,6 +1062,7 @@ static int exfat_rename_file(struct inod
 
 		exfat_remove_entries(inode, p_dir, oldentry, 0,
 			num_old_entries);
+		ei->dir = *p_dir;
 		ei->entry = newentry;
 	} else {
 		if (exfat_get_entry_type(epold) == TYPE_FILE) {
@@ -1149,28 +1150,6 @@ static int exfat_move_file(struct inode
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
@@ -1201,8 +1180,6 @@ static int __exfat_rename(struct inode *
 		return -ENOENT;
 	}
 
-	exfat_update_parent_info(ei, old_parent_inode);
-
 	exfat_chain_dup(&olddir, &ei->dir);
 	dentry = ei->entry;
 
@@ -1223,8 +1200,6 @@ static int __exfat_rename(struct inode *
 			goto out;
 		}
 
-		exfat_update_parent_info(new_ei, new_parent_inode);
-
 		p_dir = &(new_ei->dir);
 		new_entry = new_ei->entry;
 		ep = exfat_get_dentry(sb, p_dir, new_entry, &new_bh);


