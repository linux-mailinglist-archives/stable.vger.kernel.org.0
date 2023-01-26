Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A567C675
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 09:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236544AbjAZI7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 03:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjAZI7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 03:59:34 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BAD83EE;
        Thu, 26 Jan 2023 00:59:33 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id ADF0D44C1019;
        Thu, 26 Jan 2023 08:59:30 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru ADF0D44C1019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1674723570;
        bh=3+YMP5uQItOPeyz0DXAukyJSBmkHOU6buO5hiOYrjyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1Glr9iDV6y3Ooza+EZpcoS3Ab2bDvKMA/1slAvhdeMpjApTa7cnUP/ylSp3tF6Ev
         cCQn9yO6N//BDcxM2l81sfyKciqNh+Q4/BvaYD+ryPo98MSiszTuYHla84nCLNpbw0
         i6uNb89UH4dxaZkclyKsUdJRZUJz+mno+iV5XTWc=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Jan Kara <jack@suse.cz>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 4.14/4.19/5.4/5.10/5.15 1/1] fs: reiserfs: remove useless new_opts in reiserfs_remount
Date:   Thu, 26 Jan 2023 11:58:46 +0300
Message-Id: <20230126085846.466209-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126085846.466209-1-pchelkin@ispras.ru>
References: <20230126085846.466209-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

commit 81dedaf10c20959bdf5624f9783f408df26ba7a4 upstream.

Since the commit c3d98ea08291 ("VFS: Don't use save/replace_mount_options
if not using generic_show_options") eliminates replace_mount_options
in reiserfs_remount, but does not handle the allocated new_opts,
it will cause memory leak in the reiserfs_remount.

Because new_opts is useless in reiserfs_mount, so we fix this bug by
removing the useless new_opts in reiserfs_remount.

Fixes: c3d98ea08291 ("VFS: Don't use save/replace_mount_options if not using generic_show_options")
Link: https://lore.kernel.org/r/20211027143445.4156459-1-mudongliangabcd@gmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 fs/reiserfs/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 58481f8d63d5..f7b05c6b3dcf 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1437,7 +1437,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
-	char *new_opts;
 	int err;
 	char *qf_names[REISERFS_MAXQUOTAS];
 	unsigned int qfmt = 0;
@@ -1445,10 +1444,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	int i;
 #endif
 
-	new_opts = kstrdup(arg, GFP_KERNEL);
-	if (arg && !new_opts)
-		return -ENOMEM;
-
 	sync_filesystem(s);
 	reiserfs_write_lock(s);
 
@@ -1599,7 +1594,6 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 out_err_unlock:
 	reiserfs_write_unlock(s);
 out_err:
-	kfree(new_opts);
 	return err;
 }
 
-- 
2.34.1

