Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18804F3231
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343675AbiDEI51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbiDEIjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FF66350;
        Tue,  5 Apr 2022 01:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7768260FFC;
        Tue,  5 Apr 2022 08:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86205C385A1;
        Tue,  5 Apr 2022 08:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147602;
        bh=PhHmtdJRSs913RAx/hJdUrx6ytGr32/ms4SDsOiMmy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n8sDDVr9gj2B2/sHC8wrtFxusrTZnhnG96W4Kh9twA7NBmaKLqJYRTpT3SKBtDpc1
         mYMI5Io9AD32EhaFDC6rOlsO/CMoVIDNpVnjxjBzuy1hgFOs8F+3LwIIWxjS4C/WDZ
         WZwF2mM2JbAl8X4mN+5VlY6DjkZd4GZ7sa7OwclM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.16 0055/1017] cifs: fix handlecache and multiuser
Date:   Tue,  5 Apr 2022 09:16:08 +0200
Message-Id: <20220405070355.817742520@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
@@ -253,6 +253,9 @@ static void cifs_kill_sb(struct super_bl
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon;
 	struct cached_fid *cfid;
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct tcon_link *tlink;
 
 	/*
 	 * We ned to release all dentries for the cached directories
@@ -262,17 +265,21 @@ static void cifs_kill_sb(struct super_bl
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


