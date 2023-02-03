Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60D668962D
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjBCKao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbjBCKaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854059D5AF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:29:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6F7E61ECF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA60C4339C;
        Fri,  3 Feb 2023 10:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420168;
        bh=K/+m3KzdjrsEAgujkqpU26Gnewl16JlFxIZPUQ9Pxd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wI8HA/yj0SY1clw6cM7Av7nCu+D5SPpUSo4tkUDT458iKbLDA5HgRO+8lNbP5h3rO
         Atz578D7JlwrUu4QNMkwoRM33foBbdiZG57uxJAuPFFMrKuJysNKkbrkNfxO+ieN8i
         W4Pvi3nRuZNv7FmZn2LwgSRlgSvI51nmwc9moo90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 5.4 103/134] nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted
Date:   Fri,  3 Feb 2023 11:13:28 +0100
Message-Id: <20230203101028.465616134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit c6c7f2a84da459bcc3714044e74a9cb66de31039 upstream.

In order to ensure that knfsd threads don't linger once the nfsd
pseudofs is unmounted (e.g. when the container is killed) we let
nfsd_umount() shut down those threads and wait for them to exit.

This also should ensure that we don't need to do a kernel mount of
the pseudofs, since the thread lifetime is now limited by the
lifetime of the filesystem.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h     |    6 +++---
 fs/nfsd/nfs4state.c |    8 +-------
 fs/nfsd/nfsctl.c    |   14 ++------------
 fs/nfsd/nfsd.h      |    3 +--
 fs/nfsd/nfssvc.c    |   35 ++++++++++++++++++++++++++++++++++-
 5 files changed, 41 insertions(+), 25 deletions(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -42,9 +42,6 @@ struct nfsd_net {
 	bool grace_ended;
 	time_t boot_time;
 
-	/* internal mount of the "nfsd" pseudofilesystem: */
-	struct vfsmount *nfsd_mnt;
-
 	struct dentry *nfsd_client_dir;
 
 	/*
@@ -121,6 +118,9 @@ struct nfsd_net {
 	wait_queue_head_t ntf_wq;
 	atomic_t ntf_refcnt;
 
+	/* Allow umount to wait for nfsd state cleanup */
+	struct completion nfsd_shutdown_complete;
+
 	/*
 	 * clientid and stateid data for construction of net unique COPY
 	 * stateids.
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7754,14 +7754,9 @@ nfs4_state_start_net(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	int ret;
 
-	ret = get_nfsdfs(net);
-	if (ret)
-		return ret;
 	ret = nfs4_state_create_net(net);
-	if (ret) {
-		mntput(nn->nfsd_mnt);
+	if (ret)
 		return ret;
-	}
 	locks_start_grace(net, &nn->nfsd4_manager);
 	nfsd4_client_tracking_init(net);
 	if (nn->track_reclaim_completes && nn->reclaim_str_hashtbl_size == 0)
@@ -7830,7 +7825,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	mntput(nn->nfsd_mnt);
 }
 
 void
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1417,6 +1417,8 @@ static void nfsd_umount(struct super_blo
 {
 	struct net *net = sb->s_fs_info;
 
+	nfsd_shutdown_threads(net);
+
 	kill_litter_super(sb);
 	put_net(net);
 }
@@ -1429,18 +1431,6 @@ static struct file_system_type nfsd_fs_t
 };
 MODULE_ALIAS_FS("nfsd");
 
-int get_nfsdfs(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct vfsmount *mnt;
-
-	mnt =  vfs_kern_mount(&nfsd_fs_type, SB_KERNMOUNT, "nfsd", NULL);
-	if (IS_ERR(mnt))
-		return PTR_ERR(mnt);
-	nn->nfsd_mnt = mnt;
-	return 0;
-}
-
 #ifdef CONFIG_PROC_FS
 static int create_proc_exports_entry(void)
 {
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -84,11 +84,10 @@ int		nfsd_get_nrthreads(int n, int *, st
 int		nfsd_set_nrthreads(int n, int *, struct net *);
 int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
+void		nfsd_shutdown_threads(struct net *net);
 
 void		nfsd_destroy(struct net *net);
 
-int get_nfsdfs(struct net *);
-
 struct nfsdfs_client {
 	struct kref cl_ref;
 	void (*cl_release)(struct kref *kref);
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -594,6 +594,37 @@ static const struct svc_serv_ops nfsd_th
 	.svo_module		= THIS_MODULE,
 };
 
+static void nfsd_complete_shutdown(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	WARN_ON(!mutex_is_locked(&nfsd_mutex));
+
+	nn->nfsd_serv = NULL;
+	complete(&nn->nfsd_shutdown_complete);
+}
+
+void nfsd_shutdown_threads(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
+
+	mutex_lock(&nfsd_mutex);
+	serv = nn->nfsd_serv;
+	if (serv == NULL) {
+		mutex_unlock(&nfsd_mutex);
+		return;
+	}
+
+	svc_get(serv);
+	/* Kill outstanding nfsd threads */
+	serv->sv_ops->svo_setup(serv, NULL, 0);
+	nfsd_destroy(net);
+	mutex_unlock(&nfsd_mutex);
+	/* Wait for shutdown of nfsd_serv to complete */
+	wait_for_completion(&nn->nfsd_shutdown_complete);
+}
+
 int nfsd_create_serv(struct net *net)
 {
 	int error;
@@ -611,11 +642,13 @@ int nfsd_create_serv(struct net *net)
 						&nfsd_thread_sv_ops);
 	if (nn->nfsd_serv == NULL)
 		return -ENOMEM;
+	init_completion(&nn->nfsd_shutdown_complete);
 
 	nn->nfsd_serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(nn->nfsd_serv, net);
 	if (error < 0) {
 		svc_destroy(nn->nfsd_serv);
+		nfsd_complete_shutdown(net);
 		return error;
 	}
 
@@ -664,7 +697,7 @@ void nfsd_destroy(struct net *net)
 		svc_shutdown_net(nn->nfsd_serv, net);
 	svc_destroy(nn->nfsd_serv);
 	if (destroy)
-		nn->nfsd_serv = NULL;
+		nfsd_complete_shutdown(net);
 }
 
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)


