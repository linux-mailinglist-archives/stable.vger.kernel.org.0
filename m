Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADF967801B
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 16:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbjAWPkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 10:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbjAWPko (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 10:40:44 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6095B5FCC
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:40:42 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id rl14so28233023ejb.2
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXfOmSrWLbewnQ8H4K953Tkjw028E4iL0jF40mTU9G0=;
        b=VydVzxgXeTov2q1T0E5btMv3w6KVrcMkHuHvSOAMy0rcsnkHIbWHtx4gaQJRiBMeXz
         b0SF8JGr3IabGg19U6v5dooBgkLaayPQg1v4h4aPOcJk5ZIak3/CP9alUVbwrR+zSiJ6
         TYADPBjkL3e7VWnSdlb0Zvm2+QJED60uaKZc4wJGkgU9tL1SVbBdfrEJZ4TTLT6JPP8t
         4FU5Dyj2iKCZSvV/CWLJWJ0x9ifg7gaB9MQFZfTsEXFw0oO7RrNAFKYq7HNZdki4LMDI
         YLk5Cl5BiQ0QwYpPVhmoL8JLVjqKgdy8Cmz5JntWnVq5pZthR0+SUutxI63kStRu4AaA
         1LMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fXfOmSrWLbewnQ8H4K953Tkjw028E4iL0jF40mTU9G0=;
        b=wydn/B+mO6B3j0Izp6xzmoTjkICgHrw9WMF6nuR4K5yeBV5pLDVrVCoi8DD8T/gJiq
         YL0jHS4+Wg1HibJP2Bj4jtgedB5ULdd3p2kuPsamUsAeUE6QBYKjdyEsgjhsuyI8dBM7
         E9FFTMmhNSLBJU3VhMR4WcOY5NYDmZivdSCJyK0mTvUyngaHBOhDm3oWEnSIy2dGH/Gc
         YSMLM345Ebz311Sm0wTDGFfp3fr5A9dgA8DEQYLq3w47AHxRsx5XVn35XRHeDBjtur9f
         tOzZgWQ2vvl4VsZc4yIRqNGzTO2FPR3C4ZDuSfADm+aiEhtYT3hDKoa7MNb/RVeJbSon
         uZAA==
X-Gm-Message-State: AFqh2krUMuNXF8lQwP2YG2VFqr8rC0VV+w2/cxH9qC4c8vcHgg48e1r7
        EkIuFiADh55N7K98xB1AFQrBQBnCrtd5hpHZ
X-Google-Smtp-Source: AMrXdXswqEAKWbHZluJ2hfnmRAg1TrlLORv69YjoC+Y8w7igxjrY7ClzX9CXCGHf9p6g0bfjNISLwA==
X-Received: by 2002:a17:907:3a09:b0:870:e823:c03 with SMTP id fb9-20020a1709073a0900b00870e8230c03mr23347271ejc.45.1674488440751;
        Mon, 23 Jan 2023 07:40:40 -0800 (PST)
Received: from marvin.internal.lan (193.92.101.37.dsl.dyn.forthnet.gr. [193.92.101.37])
        by smtp.gmail.com with ESMTPSA id b4-20020a1709065e4400b00865ef3a3109sm15614843eju.66.2023.01.23.07.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 07:40:40 -0800 (PST)
From:   Nikos Tsironis <ntsironis@arrikto.com>
To:     stable@vger.kernel.org
Cc:     bfields@fieldses.org, chuck.lever@oracle.com,
        ntsironis@arrikto.com, linux-nfs@vger.kernel.org,
        trond.myklebust@hammerspace.com
Subject: [PATCH 5.10 1/1] nfsd: Ensure knfsd shuts down when the "nfsd" pseudofs is unmounted
Date:   Mon, 23 Jan 2023 17:40:37 +0200
Message-Id: <20230123154037.879413-2-ntsironis@arrikto.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230123154037.879413-1-ntsironis@arrikto.com>
References: <20230123154037.879413-1-ntsironis@arrikto.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 fs/nfsd/netns.h     |  6 +++---
 fs/nfsd/nfs4state.c |  8 +-------
 fs/nfsd/nfsctl.c    | 14 ++------------
 fs/nfsd/nfsd.h      |  3 +--
 fs/nfsd/nfssvc.c    | 35 ++++++++++++++++++++++++++++++++++-
 5 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 7346acda9d76..02d3d2f0e616 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -42,9 +42,6 @@ struct nfsd_net {
 	bool grace_ended;
 	time64_t boot_time;
 
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
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9a47cc66963f..cb13a1649632 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7394,14 +7394,9 @@ nfs4_state_start_net(struct net *net)
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
@@ -7471,7 +7466,6 @@ nfs4_state_shutdown_net(struct net *net)
 
 	nfsd4_client_tracking_exit(net);
 	nfs4_state_destroy_net(net);
-	mntput(nn->nfsd_mnt);
 }
 
 void
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index dedec4771ecc..c4b11560ac1b 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1417,6 +1417,8 @@ static void nfsd_umount(struct super_block *sb)
 {
 	struct net *net = sb->s_fs_info;
 
+	nfsd_shutdown_threads(net);
+
 	kill_litter_super(sb);
 	put_net(net);
 }
@@ -1429,18 +1431,6 @@ static struct file_system_type nfsd_fs_type = {
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
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index cb742e17e04a..4362d295ed34 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -85,13 +85,12 @@ int		nfsd_get_nrthreads(int n, int *, struct net *);
 int		nfsd_set_nrthreads(int n, int *, struct net *);
 int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
+void		nfsd_shutdown_threads(struct net *net);
 
 void		nfsd_destroy(struct net *net);
 
 bool		i_am_nfsd(void);
 
-int get_nfsdfs(struct net *);
-
 struct nfsdfs_client {
 	struct kref cl_ref;
 	void (*cl_release)(struct kref *kref);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index c7fffe1453bd..2e61a565cdbd 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -600,6 +600,37 @@ static const struct svc_serv_ops nfsd_thread_sv_ops = {
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
 bool i_am_nfsd(void)
 {
 	return kthread_func(current) == nfsd;
@@ -622,11 +653,13 @@ int nfsd_create_serv(struct net *net)
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
 
@@ -675,7 +708,7 @@ void nfsd_destroy(struct net *net)
 		svc_shutdown_net(nn->nfsd_serv, net);
 	svc_destroy(nn->nfsd_serv);
 	if (destroy)
-		nn->nfsd_serv = NULL;
+		nfsd_complete_shutdown(net);
 }
 
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
-- 
2.30.2

