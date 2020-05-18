Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2A1D8548
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbgERR4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731662AbgERR4l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 951AD20674;
        Mon, 18 May 2020 17:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824600;
        bh=s5dKiON6sWwu8xyTCzaIeRFcTC0uj7VFpLEAgChKdtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twqQYhmIQTcewPapN4H5SgKYXo7LJYNdddEtO5jgv5TuQadJSNLf2eNzFq3YghYeK
         AFCgJemwORzD0jO2YSoboQRFfM+xkS6kDjDo/Ds7jiHZKJXHzGtqGblHBsPQ8lnhgY
         4YBs47Nm0QYIKa8o47+GJA9iFOTrJlyEAz2Oc4H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/147] nfs: fscache: use timespec64 in inode auxdata
Date:   Mon, 18 May 2020 19:36:38 +0200
Message-Id: <20200518173523.209431838@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 6e31ded6895adfca97211118cc9b72236e8f6d53 ]

nfs currently behaves differently on 32-bit and 64-bit kernels regarding
the on-disk format of nfs_fscache_inode_auxdata.

That format should really be the same on any kernel, and we should avoid
the 'timespec' type in order to remove that from the kernel later on.

Using plain 'timespec64' would not be good here, since that includes
implied padding and would possibly leak kernel stack data to the on-disk
format on 32-bit architectures.

struct __kernel_timespec would work as a replacement, but open-coding
the two struct members in nfs_fscache_inode_auxdata makes it more
obvious what's going on here, and keeps the current format for 64-bit
architectures.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fscache-index.c |  6 ++++--
 fs/nfs/fscache.c       | 18 ++++++++++++------
 fs/nfs/fscache.h       |  8 +++++---
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/fscache-index.c b/fs/nfs/fscache-index.c
index 15f271401dcca..573b1da9342c1 100644
--- a/fs/nfs/fscache-index.c
+++ b/fs/nfs/fscache-index.c
@@ -84,8 +84,10 @@ enum fscache_checkaux nfs_fscache_inode_check_aux(void *cookie_netfs_data,
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
 	memset(&auxdata, 0, sizeof(auxdata));
-	auxdata.mtime = timespec64_to_timespec(nfsi->vfs_inode.i_mtime);
-	auxdata.ctime = timespec64_to_timespec(nfsi->vfs_inode.i_ctime);
+	auxdata.mtime_sec  = nfsi->vfs_inode.i_mtime.tv_sec;
+	auxdata.mtime_nsec = nfsi->vfs_inode.i_mtime.tv_nsec;
+	auxdata.ctime_sec  = nfsi->vfs_inode.i_ctime.tv_sec;
+	auxdata.ctime_nsec = nfsi->vfs_inode.i_ctime.tv_nsec;
 
 	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
 		auxdata.change_attr = inode_peek_iversion_raw(&nfsi->vfs_inode);
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 3184063322d48..d0c629f97789e 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -241,8 +241,10 @@ void nfs_fscache_init_inode(struct inode *inode)
 		return;
 
 	memset(&auxdata, 0, sizeof(auxdata));
-	auxdata.mtime = timespec64_to_timespec(nfsi->vfs_inode.i_mtime);
-	auxdata.ctime = timespec64_to_timespec(nfsi->vfs_inode.i_ctime);
+	auxdata.mtime_sec  = nfsi->vfs_inode.i_mtime.tv_sec;
+	auxdata.mtime_nsec = nfsi->vfs_inode.i_mtime.tv_nsec;
+	auxdata.ctime_sec  = nfsi->vfs_inode.i_ctime.tv_sec;
+	auxdata.ctime_nsec = nfsi->vfs_inode.i_ctime.tv_nsec;
 
 	if (NFS_SERVER(&nfsi->vfs_inode)->nfs_client->rpc_ops->version == 4)
 		auxdata.change_attr = inode_peek_iversion_raw(&nfsi->vfs_inode);
@@ -266,8 +268,10 @@ void nfs_fscache_clear_inode(struct inode *inode)
 	dfprintk(FSCACHE, "NFS: clear cookie (0x%p/0x%p)\n", nfsi, cookie);
 
 	memset(&auxdata, 0, sizeof(auxdata));
-	auxdata.mtime = timespec64_to_timespec(nfsi->vfs_inode.i_mtime);
-	auxdata.ctime = timespec64_to_timespec(nfsi->vfs_inode.i_ctime);
+	auxdata.mtime_sec  = nfsi->vfs_inode.i_mtime.tv_sec;
+	auxdata.mtime_nsec = nfsi->vfs_inode.i_mtime.tv_nsec;
+	auxdata.ctime_sec  = nfsi->vfs_inode.i_ctime.tv_sec;
+	auxdata.ctime_nsec = nfsi->vfs_inode.i_ctime.tv_nsec;
 	fscache_relinquish_cookie(cookie, &auxdata, false);
 	nfsi->fscache = NULL;
 }
@@ -308,8 +312,10 @@ void nfs_fscache_open_file(struct inode *inode, struct file *filp)
 		return;
 
 	memset(&auxdata, 0, sizeof(auxdata));
-	auxdata.mtime = timespec64_to_timespec(nfsi->vfs_inode.i_mtime);
-	auxdata.ctime = timespec64_to_timespec(nfsi->vfs_inode.i_ctime);
+	auxdata.mtime_sec  = nfsi->vfs_inode.i_mtime.tv_sec;
+	auxdata.mtime_nsec = nfsi->vfs_inode.i_mtime.tv_nsec;
+	auxdata.ctime_sec  = nfsi->vfs_inode.i_ctime.tv_sec;
+	auxdata.ctime_nsec = nfsi->vfs_inode.i_ctime.tv_nsec;
 
 	if (inode_is_open_for_write(inode)) {
 		dfprintk(FSCACHE, "NFS: nfsi 0x%p disabling cache\n", nfsi);
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index ad041cfbf9ec0..6754c8607230b 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -62,9 +62,11 @@ struct nfs_fscache_key {
  * cache object.
  */
 struct nfs_fscache_inode_auxdata {
-	struct timespec	mtime;
-	struct timespec	ctime;
-	u64		change_attr;
+	s64	mtime_sec;
+	s64	mtime_nsec;
+	s64	ctime_sec;
+	s64	ctime_nsec;
+	u64	change_attr;
 };
 
 /*
-- 
2.20.1



