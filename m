Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61DB11B07C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732686AbfLKPXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732695AbfLKPXS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2989C208C3;
        Wed, 11 Dec 2019 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077797;
        bh=iBaeBTi4gm6B265A0WfKfXom3ys8x5RM8gWVd8rslJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wY2NG67Aiz+leRq1bFtNeChr9wI9m9i3VjBscAOuJzawVEPWFWYdNlb4+rSx5By3v
         F8KM/mhqIfb1pvysBRAMEl6qW/b/Xw+UG5aPhaMfDiO9E7EBL5vq7QRFMOcsMcWi4l
         OK4iKmJkx46zQN+Boprhx0KFPG7qzedlQ3fRxrfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhengbin <zhengbin13@huawei.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/243] nfsd: Return EPERM, not EACCES, in some SETATTR cases
Date:   Wed, 11 Dec 2019 16:05:36 +0100
Message-Id: <20191211150350.922075473@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit 255fbca65137e25b12bced18ec9a014dc77ecda0 ]

As the man(2) page for utime/utimes states, EPERM is returned when the
second parameter of utime or utimes is not NULL, the caller's effective UID
does not match the owner of the file, and the caller is not privileged.

However, in a NFS directory mounted from knfsd, it will return EACCES
(from nfsd_setattr-> fh_verify->nfsd_permission).  This patch fixes
that.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index b53e76391e525..4fe8db3149506 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -396,10 +396,23 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 
-	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME | ATTR_SIZE))
+	if (iap->ia_valid & ATTR_SIZE) {
 		accmode |= NFSD_MAY_WRITE|NFSD_MAY_OWNER_OVERRIDE;
-	if (iap->ia_valid & ATTR_SIZE)
 		ftype = S_IFREG;
+	}
+
+	/*
+	 * If utimes(2) and friends are called with times not NULL, we should
+	 * not set NFSD_MAY_WRITE bit. Otherwise fh_verify->nfsd_permission
+	 * will return EACCESS, when the caller's effective UID does not match
+	 * the owner of the file, and the caller is not privileged. In this
+	 * situation, we should return EPERM(notify_change will return this).
+	 */
+	if (iap->ia_valid & (ATTR_ATIME | ATTR_MTIME)) {
+		accmode |= NFSD_MAY_OWNER_OVERRIDE;
+		if (!(iap->ia_valid & (ATTR_ATIME_SET | ATTR_MTIME_SET)))
+			accmode |= NFSD_MAY_WRITE;
+	}
 
 	/* Callers that do fh_verify should do the fh_want_write: */
 	get_write_count = !fhp->fh_dentry;
-- 
2.20.1



