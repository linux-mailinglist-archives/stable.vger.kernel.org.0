Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757D045123F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346485AbhKOTdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:33:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244622AbhKOTRF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B58960E0C;
        Mon, 15 Nov 2021 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000552;
        bh=EwdOQZjfU5DW3qd7yYmufBEdkLWkSQGw2ODy15cqPAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jURkgZQ67IcFn9iopmOhcikDU+LqpOYSojhccBL9+2IIiSsxfIddHXvdtDq0ppgz+
         F6DBWdGk8mNhe8CdZkDCgcHH7fz3E9IEX75dgwfTDD5wsH04xx4YULkMZNgSNLNHWK
         0fqrnRvyZys4t+9IxDlmNHePAgfah5Z8bRN7+YrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 675/849] NFS: Default change_attr_type to NFS4_CHANGE_TYPE_IS_UNDEFINED
Date:   Mon, 15 Nov 2021 18:02:38 +0100
Message-Id: <20211115165443.112449434@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit eea413308f2e6deb00f061f18081a53f3ecc8cc6 ]

Both NFSv3 and NFSv2 generate their change attribute from the ctime
value that was supplied by the server. However the problem is that there
are plenty of servers out there with ctime resolutions of 1ms or worse.
In a modern performance system, this is insufficient when trying to
decide which is the most recent set of attributes when, for instance, a
READ or GETATTR call races with a WRITE or SETATTR.

For this reason, let's revert to labelling the NFSv2/v3 change
attributes as NFS4_CHANGE_TYPE_IS_UNDEFINED. This will ensure we protect
against such races.

Fixes: 7b24dacf0840 ("NFS: Another inode revalidation improvement")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c   | 4 +++-
 fs/nfs/nfs3xdr.c | 2 +-
 fs/nfs/proc.c    | 2 +-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 853213b3a2095..6ea1bde33cb62 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1777,8 +1777,10 @@ static int nfs_inode_finish_partial_attr_update(const struct nfs_fattr *fattr,
 		NFS_INO_INVALID_BLOCKS | NFS_INO_INVALID_OTHER |
 		NFS_INO_INVALID_NLINK;
 	unsigned long cache_validity = NFS_I(inode)->cache_validity;
+	enum nfs4_change_attr_type ctype = NFS_SERVER(inode)->change_attr_type;
 
-	if (!(cache_validity & NFS_INO_INVALID_CHANGE) &&
+	if (ctype != NFS4_CHANGE_TYPE_IS_UNDEFINED &&
+	    !(cache_validity & NFS_INO_INVALID_CHANGE) &&
 	    (cache_validity & check_valid) != 0 &&
 	    (fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 &&
 	    nfs_inode_attrs_cmp_monotonic(fattr, inode) == 0)
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index e6eca1d7481b8..9274c9c5efea6 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -2227,7 +2227,7 @@ static int decode_fsinfo3resok(struct xdr_stream *xdr,
 
 	/* ignore properties */
 	result->lease_time = 0;
-	result->change_attr_type = NFS4_CHANGE_TYPE_IS_TIME_METADATA;
+	result->change_attr_type = NFS4_CHANGE_TYPE_IS_UNDEFINED;
 	return 0;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index ea19dbf123014..ecc4e717808c4 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -91,7 +91,7 @@ nfs_proc_get_root(struct nfs_server *server, struct nfs_fh *fhandle,
 	info->dtpref = fsinfo.tsize;
 	info->maxfilesize = 0x7FFFFFFF;
 	info->lease_time = 0;
-	info->change_attr_type = NFS4_CHANGE_TYPE_IS_TIME_METADATA;
+	info->change_attr_type = NFS4_CHANGE_TYPE_IS_UNDEFINED;
 	return 0;
 }
 
-- 
2.33.0



