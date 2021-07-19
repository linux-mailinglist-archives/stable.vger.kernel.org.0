Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1503CD8CB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbhGSOZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242957AbhGSOXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E1E161263;
        Mon, 19 Jul 2021 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706997;
        bh=H8XKvv7C/vZQIIq332tLdtjj2OrbCFylKP6Mya91x9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GXMAuwe18k4q7HVNFJCc1HT5hGZEXeGIn01JYJs42J5LAaj+JzRsOf4WMxtD72Iy7
         YlK5qSkKfo5bt73J1li2FQQQm3VJ3XqqBbr8el5tGqHO5h10Yc8CjezSWGa7Unh7SQ
         aKVKthplOesQTA33xJ2jQuyQe/ZtsDlC9NHYBo+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 179/188] nfs: fix acl memory leak of posix_acl_create()
Date:   Mon, 19 Jul 2021 16:52:43 +0200
Message-Id: <20210719144942.341156605@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1fcb6fcd74a222d9ead54d405842fc763bb86262 ]

When looking into another nfs xfstests report, I found acl and
default_acl in nfs3_proc_create() and nfs3_proc_mknod() error
paths are possibly leaked. Fix them in advance.

Fixes: 013cdf1088d7 ("nfs: use generic posix ACL infrastructure for v3 Posix ACLs")
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs3proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index cb28cceefebe..9f365b004453 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -363,7 +363,7 @@ nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 				break;
 
 			case NFS3_CREATE_UNCHECKED:
-				goto out;
+				goto out_release_acls;
 		}
 		nfs_fattr_init(data->res.dir_attr);
 		nfs_fattr_init(data->res.fattr);
@@ -708,7 +708,7 @@ nfs3_proc_mknod(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		break;
 	default:
 		status = -EINVAL;
-		goto out;
+		goto out_release_acls;
 	}
 
 	status = nfs3_do_create(dir, dentry, data);
-- 
2.30.2



