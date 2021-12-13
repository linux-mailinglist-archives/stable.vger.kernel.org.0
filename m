Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1319472970
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbhLMKUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242368AbhLMKSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:18:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED70EC08EDBE;
        Mon, 13 Dec 2021 01:56:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45849CE0E85;
        Mon, 13 Dec 2021 09:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CE1C34601;
        Mon, 13 Dec 2021 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389395;
        bh=Y0uMhUOUyU4IpXzXbrKxRz/MuUwtep8S0LlwzRngT7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxhpY0atDUF7TYlefBjaEpRUWKBRD+eHkBDXq4d2HGxbASuUDRexJoM23plVAgwXI
         +yhQW8IbmdSMYdAwFZBtxMgdD6Hsgu89DtF4FrTCoW8aDON0FBtSkjCOxCaVFj97YY
         jpMbsm5Anj0/E2BBaOm4TFnbneaOiLLFa9b3X9wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.15 085/171] nfsd: Fix nsfd startup race (again)
Date:   Mon, 13 Dec 2021 10:30:00 +0100
Message-Id: <20211213092947.917284601@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit b10252c7ae9c9d7c90552f88b544a44ee773af64 upstream.

Commit bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
has re-opened rpc_pipefs_event() race against nfsd_net_id registration
(register_pernet_subsys()) which has been fixed by commit bb7ffbf29e76
("nfsd: fix nsfd startup race triggering BUG_ON").

Restore the order of register_pernet_subsys() vs register_cld_notifier().
Add WARN_ON() to prevent a future regression.

Crash info:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000012
CPU: 8 PID: 345 Comm: mount Not tainted 5.4.144-... #1
pc : rpc_pipefs_event+0x54/0x120 [nfsd]
lr : rpc_pipefs_event+0x48/0x120 [nfsd]
Call trace:
 rpc_pipefs_event+0x54/0x120 [nfsd]
 blocking_notifier_call_chain
 rpc_fill_super
 get_tree_keyed
 rpc_fs_get_tree
 vfs_get_tree
 do_mount
 ksys_mount
 __arm64_sys_mount
 el0_svc_handler
 el0_svc

Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |    1 +
 fs/nfsd/nfsctl.c      |   14 +++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -2156,6 +2156,7 @@ static struct notifier_block nfsd4_cld_b
 int
 register_cld_notifier(void)
 {
+	WARN_ON(!nfsd_net_id);
 	return rpc_pipefs_notifier_register(&nfsd4_cld_block);
 }
 
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1521,12 +1521,9 @@ static int __init init_nfsd(void)
 	int retval;
 	printk(KERN_INFO "Installing knfsd (copyright (C) 1996 okir@monad.swb.de).\n");
 
-	retval = register_cld_notifier();
-	if (retval)
-		return retval;
 	retval = nfsd4_init_slabs();
 	if (retval)
-		goto out_unregister_notifier;
+		return retval;
 	retval = nfsd4_init_pnfs();
 	if (retval)
 		goto out_free_slabs;
@@ -1545,9 +1542,14 @@ static int __init init_nfsd(void)
 		goto out_free_exports;
 	retval = register_pernet_subsys(&nfsd_net_ops);
 	if (retval < 0)
+		goto out_free_filesystem;
+	retval = register_cld_notifier();
+	if (retval)
 		goto out_free_all;
 	return 0;
 out_free_all:
+	unregister_pernet_subsys(&nfsd_net_ops);
+out_free_filesystem:
 	unregister_filesystem(&nfsd_fs_type);
 out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
@@ -1561,13 +1563,12 @@ out_free_pnfs:
 	nfsd4_exit_pnfs();
 out_free_slabs:
 	nfsd4_free_slabs();
-out_unregister_notifier:
-	unregister_cld_notifier();
 	return retval;
 }
 
 static void __exit exit_nfsd(void)
 {
+	unregister_cld_notifier();
 	unregister_pernet_subsys(&nfsd_net_ops);
 	nfsd_drc_slab_free();
 	remove_proc_entry("fs/nfs/exports", NULL);
@@ -1577,7 +1578,6 @@ static void __exit exit_nfsd(void)
 	nfsd4_free_slabs();
 	nfsd4_exit_pnfs();
 	unregister_filesystem(&nfsd_fs_type);
-	unregister_cld_notifier();
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");


