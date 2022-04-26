Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74BA450F848
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346683AbiDZJIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345161AbiDZJG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A919C8AAA;
        Tue, 26 Apr 2022 01:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB05160C42;
        Tue, 26 Apr 2022 08:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09E3C385AC;
        Tue, 26 Apr 2022 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962864;
        bh=tmI7oITx1Lz52yEj+WkYtG/SsUK9NT6eScUQX4l7xUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkTdnbFLrLoFq4VJsqZ+LRN5J5AK5a7hBwjvaYCnwD8Cn+Oq/rAC1WJScNSi309ky
         sy185+xhBAcG0ql/gPOYpdIc5vsswmxUJQlNbsaRgRRN1ppZsAMAy9hYZ5ZFKXNdQS
         rRghRz+6ExrUKzXr+nMh4bB0T/pDb2bj8xPP6aqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 115/146] cifs: fix NULL ptr dereference in refresh_mounts()
Date:   Tue, 26 Apr 2022 10:21:50 +0200
Message-Id: <20220426081753.288771630@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit 41f10081a92a0ed280008218a8ec18ad8ba0fceb upstream.

Either mount(2) or automount might not have server->origin_fullpath
set yet while refresh_cache_worker() is attempting to refresh DFS
referrals.  Add missing NULL check and locking around it.

This fixes bellow crash:

[ 1070.276835] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
[ 1070.277676] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[ 1070.278219] CPU: 1 PID: 8506 Comm: kworker/u8:1 Not tainted 5.18.0-rc3 #10
[ 1070.278701] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
[ 1070.279495] Workqueue: cifs-dfscache refresh_cache_worker [cifs]
[ 1070.280044] RIP: 0010:strcasecmp+0x34/0x150
[ 1070.280359] Code: 00 00 00 fc ff df 41 54 55 48 89 fd 53 48 83 ec 10 eb 03 4c 89 fe 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 08 84 c0 0f 85 bc 00 00 00 0f b6 45 ff 44
[ 1070.281729] RSP: 0018:ffffc90008367958 EFLAGS: 00010246
[ 1070.282114] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
[ 1070.282691] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1070.283273] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff873eda27
[ 1070.283857] R10: ffffc900083679a0 R11: 0000000000000001 R12: ffff88812624c000
[ 1070.284436] R13: dffffc0000000000 R14: ffff88810e6e9a88 R15: ffff888119bb9000
[ 1070.284990] FS:  0000000000000000(0000) GS:ffff888151200000(0000) knlGS:0000000000000000
[ 1070.285625] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1070.286100] CR2: 0000561a4d922418 CR3: 000000010aecc000 CR4: 0000000000350ee0
[ 1070.286683] Call Trace:
[ 1070.286890]  <TASK>
[ 1070.287070]  refresh_cache_worker+0x895/0xd20 [cifs]
[ 1070.287475]  ? __refresh_tcon.isra.0+0xfb0/0xfb0 [cifs]
[ 1070.287905]  ? __lock_acquire+0xcd1/0x6960
[ 1070.288247]  ? is_dynamic_key+0x1a0/0x1a0
[ 1070.288591]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[ 1070.289012]  ? lock_downgrade+0x6f0/0x6f0
[ 1070.289318]  process_one_work+0x7bd/0x12d0
[ 1070.289637]  ? worker_thread+0x160/0xec0
[ 1070.289970]  ? pwq_dec_nr_in_flight+0x230/0x230
[ 1070.290318]  ? _raw_spin_lock_irq+0x5e/0x90
[ 1070.290619]  worker_thread+0x5ac/0xec0
[ 1070.290891]  ? process_one_work+0x12d0/0x12d0
[ 1070.291199]  kthread+0x2a5/0x350
[ 1070.291430]  ? kthread_complete_and_exit+0x20/0x20
[ 1070.291770]  ret_from_fork+0x22/0x30
[ 1070.292050]  </TASK>
[ 1070.292223] Modules linked in: bpfilter cifs cifs_arc4 cifs_md4
[ 1070.292765] ---[ end trace 0000000000000000 ]---
[ 1070.293108] RIP: 0010:strcasecmp+0x34/0x150
[ 1070.293471] Code: 00 00 00 fc ff df 41 54 55 48 89 fd 53 48 83 ec 10 eb 03 4c 89 fe 48 89 ef 48 83 c5 01 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 28 38 d0 7f 08 84 c0 0f 85 bc 00 00 00 0f b6 45 ff 44
[ 1070.297718] RSP: 0018:ffffc90008367958 EFLAGS: 00010246
[ 1070.298622] RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
[ 1070.299428] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1070.300296] RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff873eda27
[ 1070.301204] R10: ffffc900083679a0 R11: 0000000000000001 R12: ffff88812624c000
[ 1070.301932] R13: dffffc0000000000 R14: ffff88810e6e9a88 R15: ffff888119bb9000
[ 1070.302645] FS:  0000000000000000(0000) GS:ffff888151200000(0000) knlGS:0000000000000000
[ 1070.303462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1070.304131] CR2: 0000561a4d922418 CR3: 000000010aecc000 CR4: 0000000000350ee0
[ 1070.305004] Kernel panic - not syncing: Fatal exception
[ 1070.305711] Kernel Offset: disabled
[ 1070.305971] ---[ end Kernel panic - not syncing: Fatal exception ]---

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c   |    2 ++
 fs/cifs/dfs_cache.c |   19 ++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3675,9 +3675,11 @@ static void setup_server_referral_paths(
 {
 	struct TCP_Server_Info *server = mnt_ctx->server;
 
+	mutex_lock(&server->refpath_lock);
 	server->origin_fullpath = mnt_ctx->origin_fullpath;
 	server->leaf_fullpath = mnt_ctx->leaf_fullpath;
 	server->current_fullpath = mnt_ctx->leaf_fullpath;
+	mutex_unlock(&server->refpath_lock);
 	mnt_ctx->origin_fullpath = mnt_ctx->leaf_fullpath = NULL;
 }
 
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1422,12 +1422,14 @@ static int refresh_tcon(struct cifs_ses
 	struct TCP_Server_Info *server = tcon->ses->server;
 
 	mutex_lock(&server->refpath_lock);
-	if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
-		__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
+	if (server->origin_fullpath) {
+		if (server->leaf_fullpath && strcasecmp(server->leaf_fullpath,
+							server->origin_fullpath))
+			__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, force_refresh);
+		__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
+	}
 	mutex_unlock(&server->refpath_lock);
 
-	__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, force_refresh);
-
 	return 0;
 }
 
@@ -1530,11 +1532,14 @@ static void refresh_mounts(struct cifs_s
 		list_del_init(&tcon->ulist);
 
 		mutex_lock(&server->refpath_lock);
-		if (strcasecmp(server->leaf_fullpath, server->origin_fullpath))
-			__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
+		if (server->origin_fullpath) {
+			if (server->leaf_fullpath && strcasecmp(server->leaf_fullpath,
+								server->origin_fullpath))
+				__refresh_tcon(server->leaf_fullpath + 1, sessions, tcon, false);
+			__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
+		}
 		mutex_unlock(&server->refpath_lock);
 
-		__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
 		cifs_put_tcon(tcon);
 	}
 }


