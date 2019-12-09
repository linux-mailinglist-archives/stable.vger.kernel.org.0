Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC4911743A
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLISae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 13:30:34 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44027 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbfLISad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 13:30:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0EFD722A2A;
        Mon,  9 Dec 2019 13:30:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 09 Dec 2019 13:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qcIVxk
        kF89FgXUmENyBr0WWj+RcKSsnEgQ2d6wBLjbM=; b=mIYDczJkdHJShGI7uO7buE
        gB+hlh9SBVa6x/aw8EdMYYg8lKWSGdF63uod/pRQktdRfEmEwsyDaqRh7A1Sy+kl
        TxfvqKafEKv6mNbM1lNJ+5SIjqcmFKo7K7tRmzCTy5YhfcP7K3cB+WsabEeHLb55
        VPCKSQxYGFUytU44pA0yYYMGjFjog3P6KuZZlXfAFboxEXtvPeSBKJPJckWOgTdK
        8unD65zOxr9Vf5ZZVYZt9Lsv65N6UO8hrxeIOkx/ADhtF8GbzCaF2QKss7JTrjog
        nG6+BC3OadckbfePCFpl2JhtzgLNoTZpYBHmo0aCF1Iy31sIu7QDmX6MJGvyGtAw
        ==
X-ME-Sender: <xms:yJLuXVbf5A4wNrH1ELlhvJW4Ovz7J85k2hzLjv7hJ4oDMh3BA7Msaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeltddguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:yJLuXUcB7d44SEC2ZxWgNybAqJIajZKyMXuEoqwNcVm3ADr9Gz3F9A>
    <xmx:yJLuXdEK4t4SI2JfWktpHw_EkpQNSYA-3hDWg2AlXo3FtiUC7tAqyQ>
    <xmx:yJLuXfPyyNtK-RYzFjRH6129frTfvZdTsSnweo24lsh-R1FcQqh-AA>
    <xmx:yZLuXYg_m6NwLinYwj-6LoyttL6HFKVp9FXpYodu7Cesli_dPSJngA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 75F8A30600D7;
        Mon,  9 Dec 2019 13:30:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] nfsd: Ensure CLONE persists data and metadata changes to the" failed to apply to 4.19-stable tree
To:     trondmy@gmail.com, bfields@redhat.com,
        trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Dec 2019 19:30:26 +0100
Message-ID: <157591622675229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a25e3726b32c746c0098125d4c7463bb84df72bb Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trondmy@gmail.com>
Date: Wed, 27 Nov 2019 17:05:51 -0500
Subject: [PATCH] nfsd: Ensure CLONE persists data and metadata changes to the
 target file

The NFSv4.2 CLONE operation has implicit persistence requirements on the
target file, since there is no protocol requirement that the client issue
a separate operation to persist data.
For that reason, we should call vfs_fsync_range() on the destination file
after a successful call to vfs_clone_file_range().

Fixes: ffa0160a1039 ("nfsd: implement the NFSv4.2 CLONE operation")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: stable@vger.kernel.org # v4.5+
Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4e3e77b76411..38c0aeda500e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1077,7 +1077,8 @@ nfsd4_clone(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		goto out;
 
 	status = nfsd4_clone_file_range(src->nf_file, clone->cl_src_pos,
-			dst->nf_file, clone->cl_dst_pos, clone->cl_count);
+			dst->nf_file, clone->cl_dst_pos, clone->cl_count,
+			EX_ISSYNC(cstate->current_fh.fh_export));
 
 	nfsd_file_put(dst);
 	nfsd_file_put(src);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index bd0a385df3fc..cf423fea0c6f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -525,7 +525,7 @@ __be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
 #endif
 
 __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
-		u64 dst_pos, u64 count)
+		u64 dst_pos, u64 count, bool sync)
 {
 	loff_t cloned;
 
@@ -534,6 +534,12 @@ __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 		return nfserrno(cloned);
 	if (count && cloned != count)
 		return nfserrno(-EINVAL);
+	if (sync) {
+		loff_t dst_end = count ? dst_pos + count - 1 : LLONG_MAX;
+		int status = vfs_fsync_range(dst, dst_pos, dst_end, 0);
+		if (status < 0)
+			return nfserrno(status);
+	}
 	return 0;
 }
 
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index a13fd9d7e1f5..cc110a10bfe8 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -56,7 +56,7 @@ __be32          nfsd4_set_nfs4_label(struct svc_rqst *, struct svc_fh *,
 __be32		nfsd4_vfs_fallocate(struct svc_rqst *, struct svc_fh *,
 				    struct file *, loff_t, loff_t, int);
 __be32		nfsd4_clone_file_range(struct file *, u64, struct file *,
-			u64, u64);
+				       u64, u64, bool);
 #endif /* CONFIG_NFSD_V4 */
 __be32		nfsd_create_locked(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,

