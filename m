Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A095855C0
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiG2TwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 15:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbiG2TwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 15:52:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4571070E79;
        Fri, 29 Jul 2022 12:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3FF861FC2;
        Fri, 29 Jul 2022 19:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DB6C433C1;
        Fri, 29 Jul 2022 19:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659124340;
        bh=mSG7P6O7Xd2kC1WYTFpnIbFnh2amTSpyavm4dc9HIno=;
        h=From:To:Cc:Subject:Date:From;
        b=Nr5DlszR5vpP4qXj8qLy5LG6ca82+Z7ahJzYkhb6elKtt1csKcVYFkUOCzQuRYhch
         Y9C5K7rXZiORTWwoN+iRQnh7FZ0oUZhCM5Yme1IFu9sZKxKVvA01vqSQUVsqVERcA8
         fG2C9w52jsSSprYwgSYSSU0ml1KhBTnHUW80+PxK/3GkmISWt5GMyMDRFM6yPQp9RT
         5YscOxDxMtOv06kjOOjgRXZQNhuXlPTeAtuqqCILdcGyCjp/stQhR2fReTog7JcqXJ
         R/lkgnN9iGw/dJYV1plKjeCbK8aKPLUdKl9BpNLHi48SPRMy6w8lCO8ZMuxB4rKWEm
         0ysuKAgCDKCCQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     chuck.lever@oracle.com
Cc:     linux-nfs@vger.kernel.org, Olga Kornieskaia <kolga@netapp.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] nfsd: eliminate the NFSD_FILE_BREAK_* flags
Date:   Fri, 29 Jul 2022 15:52:18 -0400
Message-Id: <20220729195218.284339-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/nfsd/filecache.c | 24 +++---------------------
 fs/nfsd/filecache.h |  4 +---
 fs/nfsd/trace.h     |  2 --
 3 files changed, 4 insertions(+), 26 deletions(-)

This patch should apply cleanly on top of v5.19-rc8, and fixes the issue
I was seeing with missing CB_RECALLS. It also applies and works on top of
v5.18.15, but that requires a prerequisite patch. Hopefully I've got the
stable prereq tags right here.

I'll resend the tracepoint patches separately.

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 9cb2d590c036..8f3c0c567d70 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -184,12 +184,8 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 		nf->nf_hashval = hashval;
 		refcount_set(&nf->nf_ref, 1);
 		nf->nf_may = may & NFSD_FILE_MAY_MASK;
-		if (may & NFSD_MAY_NOT_BREAK_LEASE) {
-			if (may & NFSD_MAY_WRITE)
-				__set_bit(NFSD_FILE_BREAK_WRITE, &nf->nf_flags);
-			if (may & NFSD_MAY_READ)
-				__set_bit(NFSD_FILE_BREAK_READ, &nf->nf_flags);
-		}
+		__set_bit(NFSD_FILE_HASHED, &nf->nf_flags);
+		__set_bit(NFSD_FILE_PENDING, &nf->nf_flags);
 		nf->nf_mark = NULL;
 		trace_nfsd_file_alloc(nf);
 	}
@@ -958,21 +954,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
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
-- 
2.37.1

