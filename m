Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E21C328CA1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240063AbhCASzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237575AbhCAStl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:49:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 382F4651F8;
        Mon,  1 Mar 2021 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619210;
        bh=SVvwAv75TrcbfHIFGGl1zVyBbXg6J0DTdJJ2z64Ys8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSnLJaxHnG8TfRNkDHypfxTNV8zxlHEcqNtvbgVCyKXBTbukqWcR5R+Wh9IMXT/+z
         FVGoRVVukL7a6valdUw67e06a0Ww3qt1z0f+KHuVzZMlH1lGai9H5GK1fzveXw0D7D
         RHLr/NKJtxbIiemLVzN+hdyTDUxm3is/F/pBooqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Li <yieli@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 373/663] nfsd: register pernet ops last, unregister first
Date:   Mon,  1 Mar 2021 17:10:21 +0100
Message-Id: <20210301161200.307560829@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit bd5ae9288d6451bd346a1b4a59d4fe7e62ba29b7 ]

These pernet operations may depend on stuff set up or torn down in the
module init/exit functions.  And they may be called at any time in
between.  So it makes more sense for them to be the last to be
registered in the init function, and the first to be unregistered in the
exit function.

In particular, without this, the drc slab is being destroyed before all
the per-net drcs are shut down, resulting in an "Objects remaining in
nfsd_drc on __kmem_cache_shutdown()" warning in exit_nfsd.

Reported-by: Zhi Li <yieli@redhat.com>
Fixes: 3ba75830ce17 "nfsd4: drc containerization"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f6d5d783f4a45..0759e589ab52b 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1522,12 +1522,9 @@ static int __init init_nfsd(void)
 	int retval;
 	printk(KERN_INFO "Installing knfsd (copyright (C) 1996 okir@monad.swb.de).\n");
 
-	retval = register_pernet_subsys(&nfsd_net_ops);
-	if (retval < 0)
-		return retval;
 	retval = register_cld_notifier();
 	if (retval)
-		goto out_unregister_pernet;
+		return retval;
 	retval = nfsd4_init_slabs();
 	if (retval)
 		goto out_unregister_notifier;
@@ -1544,9 +1541,14 @@ static int __init init_nfsd(void)
 		goto out_free_lockd;
 	retval = register_filesystem(&nfsd_fs_type);
 	if (retval)
+		goto out_free_exports;
+	retval = register_pernet_subsys(&nfsd_net_ops);
+	if (retval < 0)
 		goto out_free_all;
 	return 0;
 out_free_all:
+	unregister_pernet_subsys(&nfsd_net_ops);
+out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
 out_free_lockd:
@@ -1559,13 +1561,12 @@ out_free_slabs:
 	nfsd4_free_slabs();
 out_unregister_notifier:
 	unregister_cld_notifier();
-out_unregister_pernet:
-	unregister_pernet_subsys(&nfsd_net_ops);
 	return retval;
 }
 
 static void __exit exit_nfsd(void)
 {
+	unregister_pernet_subsys(&nfsd_net_ops);
 	nfsd_drc_slab_free();
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);
@@ -1575,7 +1576,6 @@ static void __exit exit_nfsd(void)
 	nfsd4_exit_pnfs();
 	unregister_filesystem(&nfsd_fs_type);
 	unregister_cld_notifier();
-	unregister_pernet_subsys(&nfsd_net_ops);
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
-- 
2.27.0



