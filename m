Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7636A58FD73
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiHKNg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiHKNg6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:36:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3B86B669
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57874B820CE
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C6EC433D6;
        Thu, 11 Aug 2022 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660225015;
        bh=yjUa1N7QyRc2J1f38CIvGYrO3N2TRKUMS5mmbWPXzKY=;
        h=Subject:To:Cc:From:Date:From;
        b=TC0UN8IcuQSVMVnEooAhE1HU6qyNVC7r83te740UdEbbQmYAcE1dUd9VbqmLrtcuc
         KUGBZAzGh/bVNEJg+BfO3zLvP1HughtYfx/Cyg76EkXRmSohsPOS3zgOHewjKx+Ucf
         CBxCX3CiJaqniJPIZTASIjbK9eZ9GowYWxFdekRo=
Subject: FAILED: patch "[PATCH] nfsd: eliminate the NFSD_FILE_BREAK_* flags" failed to apply to 5.4-stable tree
To:     jlayton@kernel.org, chuck.lever@oracle.com, kolga@netapp.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Aug 2022 15:36:52 +0200
Message-ID: <1660225012166119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23ba98de6dcec665e15c0ca19244379bb0d30932 Mon Sep 17 00:00:00 2001
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 29 Jul 2022 17:01:07 -0400
Subject: [PATCH] nfsd: eliminate the NFSD_FILE_BREAK_* flags

We had a report from the spring Bake-a-thon of data corruption in some
nfstest_interop tests. Looking at the traces showed the NFS server
allowing a v3 WRITE to proceed while a read delegation was still
outstanding.

Currently, we only set NFSD_FILE_BREAK_* flags if
NFSD_MAY_NOT_BREAK_LEASE was set when we call nfsd_file_alloc.
NFSD_MAY_NOT_BREAK_LEASE was intended to be set when finding files for
COMMIT ops, where we need a writeable filehandle but don't need to
break read leases.

It doesn't make any sense to consult that flag when allocating a file
since the file may be used on subsequent calls where we do want to break
the lease (and the usage of it here seems to be reverse from what it
should be anyway).

Also, after calling nfsd_open_break_lease, we don't want to clear the
BREAK_* bits. A lease could end up being set on it later (more than
once) and we need to be able to break those leases as well.

This means that the NFSD_FILE_BREAK_* flags now just mirror
NFSD_MAY_{READ,WRITE} flags, so there's no need for them at all. Just
drop those flags and unconditionally call nfsd_open_break_lease every
time.

Reported-by: Olga Kornieskaia <kolga@netapp.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2107360
Fixes: 65294c1f2c5e (nfsd: add a new struct file caching facility to nfsd)
Cc: <stable@vger.kernel.org> # 5.4.x : bb283ca18d1e NFSD: Clean up the show_nf_flags() macro
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 9cb2d590c036..e1f98d32cee1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -184,12 +184,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 		nf->nf_hashval = hashval;
 		refcount_set(&nf->nf_ref, 1);
 		nf->nf_may = may & NFSD_FILE_MAY_MASK;
-		if (may & NFSD_MAY_NOT_BREAK_LEASE) {
-			if (may & NFSD_MAY_WRITE)
-				__set_bit(NFSD_FILE_BREAK_WRITE, &nf->nf_flags);
-			if (may & NFSD_MAY_READ)
-				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
-		}
 		nf->nf_mark = NULL;
 		trace_nfsd_file_alloc(nf);
 	}
@@ -958,21 +952,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	this_cpu_inc(nfsd_file_cache_hits);
 
-	if (!(may_flags & NFSD_MAY_NOT_BREAK_LEASE)) {
-		bool write = (may_flags & NFSD_MAY_WRITE);
-
-		if (test_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags) ||
-		    (test_bit(NFSD_FILE_BREAK_WRITE, &nf->nf_flags) && write)) {
-			status = nfserrno(nfsd_open_break_lease(
-					file_inode(nf->nf_file), may_flags));
-			if (status == nfs_ok) {
-				clear_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
-				if (write)
-					clear_bit(NFSD_FILE_BREAK_WRITE,
-						  &nf->nf_flags);
-			}
-		}
-	}
+	status = nfserrno(nfsd_open_break_lease(file_inode(nf->nf_file), may_flags));
 out:
 	if (status == nfs_ok) {
 		*pnf = nf;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 1da0c79a5580..c9e3c6eb4776 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -37,9 +37,7 @@ struct nfsd_file {
 	struct net		*nf_net;
 #define NFSD_FILE_HASHED	(0)
 #define NFSD_FILE_PENDING	(1)
-#define NFSD_FILE_BREAK_READ	(2)
-#define NFSD_FILE_BREAK_WRITE	(3)
-#define NFSD_FILE_REFERENCED	(4)
+#define NFSD_FILE_REFERENCED	(2)
 	unsigned long		nf_flags;
 	struct inode		*nf_inode;
 	unsigned int		nf_hashval;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index a60ead3b227a..081179fb17e8 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -696,8 +696,6 @@ DEFINE_CLID_EVENT(confirmed_r);
 	__print_flags(val, "|",						\
 		{ 1 << NFSD_FILE_HASHED,	"HASHED" },		\
 		{ 1 << NFSD_FILE_PENDING,	"PENDING" },		\
-		{ 1 << NFSD_FILE_BREAK_READ,	"BREAK_READ" },		\
-		{ 1 << NFSD_FILE_BREAK_WRITE,	"BREAK_WRITE" },	\
 		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"})
 
 DECLARE_EVENT_CLASS(nfsd_file_class,

