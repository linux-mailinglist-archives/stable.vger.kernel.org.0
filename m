Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99497328914
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhCARtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238914AbhCARnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:43:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68DD64FDD;
        Mon,  1 Mar 2021 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617890;
        bh=9rj+LRcxD1850915KJhU5ryX+AAJC5m4+jNdVpJTFlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frwSGSU2xL8Q6EOy0gKd4dNaKLmh6QtF+nYP/UES0mC5MSSVwTB/vQioAkcIIPh7F
         TcLewa1wSZOtVbnwYw5oVC8i7sEvIJaiunFh7LjThSahic/9MFefzpCzsunpDoSPbi
         q9hOdfV9xJf1o00zW14QgN/K6dRmmii9pI5Mu6i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Li <yieli@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/340] nfsd: register pernet ops last, unregister first
Date:   Mon,  1 Mar 2021 17:12:17 +0100
Message-Id: <20210301161057.806637162@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index be418fccc9d86..7f39d6091dfa0 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1523,12 +1523,9 @@ static int __init init_nfsd(void)
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
@@ -1546,9 +1543,14 @@ static int __init init_nfsd(void)
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
@@ -1562,13 +1564,12 @@ out_free_slabs:
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
@@ -1579,7 +1580,6 @@ static void __exit exit_nfsd(void)
 	nfsd_fault_inject_cleanup();
 	unregister_filesystem(&nfsd_fs_type);
 	unregister_cld_notifier();
-	unregister_pernet_subsys(&nfsd_net_ops);
 }
 
 MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
-- 
2.27.0



