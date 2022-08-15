Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87FA593B07
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345936AbiHOUJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbiHOUIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4FF6D540;
        Mon, 15 Aug 2022 11:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC9C36123D;
        Mon, 15 Aug 2022 18:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F68C433D6;
        Mon, 15 Aug 2022 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589734;
        bh=nn6sIa4BYZyKOQW1zlH9MzcJGUv54KSwFmdGAddyjIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJmjqPGBkCt5AmoaxFotXm7CQUMolEpUO5ArQWCcjr5bk4xuPSmRbky20KxwiZRtP
         rnw97P54yBjPcEv2LUcJUBE3rL5DaHWP9g8KX5rt2iRj1/X0k2TWWgfBH2P5d3J+GO
         EGbKxJc/l+V2bb+8Fqp73lAngolWJgYVCozgrRlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornieskaia <kolga@netapp.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.18 0007/1095] nfsd: eliminate the NFSD_FILE_BREAK_* flags
Date:   Mon, 15 Aug 2022 19:50:06 +0200
Message-Id: <20220815180429.604972860@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeff Layton <jlayton@kernel.org>

commit 23ba98de6dcec665e15c0ca19244379bb0d30932 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   22 +---------------------
 fs/nfsd/filecache.h |    4 +---
 fs/nfsd/trace.h     |    2 --
 3 files changed, 2 insertions(+), 26 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -183,12 +183,6 @@ nfsd_file_alloc(struct inode *inode, uns
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
@@ -954,21 +948,7 @@ wait_for_construction:
 
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


