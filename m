Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655E44F2505
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiDEHoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiDEHoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:44:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223A69549E;
        Tue,  5 Apr 2022 00:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F0961682;
        Tue,  5 Apr 2022 07:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81760C340EE;
        Tue,  5 Apr 2022 07:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144439;
        bh=1VBBbhxbPqgOccqe/3AVFKFROwjjGJwCABhf+k4mAfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrAwLdttVDCKaXzHfqA0iGjo5TX1+J5o/on15Svjzkioy47TMSuk39RuN1NK/fUd1
         Nimq8R1cqEki8HIrnoQQ2aSwfNjC4Ot1sayhrrZsvKqAEKOuS+AYOwE86sXJxNdu17
         dZ2X3mir76HGQQdC0P8qcQM0zo51GFEiT+6oVF2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 0044/1126] cifs: fix handlecache and multiuser
Date:   Tue,  5 Apr 2022 09:13:11 +0200
Message-Id: <20220405070408.852842321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 47178c7722ac528ea08aa82c3ef9ffa178962d7a upstream.

In multiuser each individual user has their own tcon structure for the
share and thus their own handle for a cached directory.
When we umount such a share we much make sure to release the pinned down dentry
for each such tcon and not just the master tcon.

Otherwise we will get nasty warnings on umount that dentries are still in use:
[ 3459.590047] BUG: Dentry 00000000115c6f41{i=12000000019d95,n=/}  still in use\
 (2) [unmount of cifs cifs]
...
[ 3459.590492] Call Trace:
[ 3459.590500]  d_walk+0x61/0x2a0
[ 3459.590518]  ? shrink_lock_dentry.part.0+0xe0/0xe0
[ 3459.590526]  shrink_dcache_for_umount+0x49/0x110
[ 3459.590535]  generic_shutdown_super+0x1a/0x110
[ 3459.590542]  kill_anon_super+0x14/0x30
[ 3459.590549]  cifs_kill_sb+0xf5/0x104 [cifs]
[ 3459.590773]  deactivate_locked_super+0x36/0xa0
[ 3459.590782]  cleanup_mnt+0x131/0x190
[ 3459.590789]  task_work_run+0x5c/0x90
[ 3459.590798]  exit_to_user_mode_loop+0x151/0x160
[ 3459.590809]  exit_to_user_mode_prepare+0x83/0xd0
[ 3459.590818]  syscall_exit_to_user_mode+0x12/0x30
[ 3459.590828]  do_syscall_64+0x48/0x90
[ 3459.590833]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -254,6 +254,9 @@ static void cifs_kill_sb(struct super_bl
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon;
 	struct cached_fid *cfid;
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct tcon_link *tlink;
 
 	/*
 	 * We ned to release all dentries for the cached directories
@@ -263,17 +266,21 @@ static void cifs_kill_sb(struct super_bl
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
-	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (tcon) {
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	node = rb_first(root);
+	while (node != NULL) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
 		cfid = &tcon->crfid;
 		mutex_lock(&cfid->fid_mutex);
 		if (cfid->dentry) {
-
 			dput(cfid->dentry);
 			cfid->dentry = NULL;
 		}
 		mutex_unlock(&cfid->fid_mutex);
+		node = rb_next(node);
 	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);


