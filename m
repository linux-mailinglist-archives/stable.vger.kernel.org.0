Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F07126A21
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbfLSSoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbfLSSoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66FB024679;
        Thu, 19 Dec 2019 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781060;
        bh=pahtd4hOPN+QauF9eODSpt9bK7YQHXplYxhSaS/zQcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3WqWF3mHlhFoVNnme/qMGch3ARf4pZvSevqS4Jznok8oA4Qlavaza30uUDUoRJVI
         aq4l+uMSyy23DKBifaKfC6jKAdk73b2nRi2dXs5bNaQvZoKrMiCv75OjbobgDsQg0G
         JMqTrctgTPuX2LilN1NbgUimN48WV5Wqwjf3J/A0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhengbin <zhengbin13@huawei.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/199] nfsd: Return EPERM, not EACCES, in some SETATTR cases
Date:   Thu, 19 Dec 2019 19:32:28 +0100
Message-Id: <20191219183218.657419581@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index 8f0b19a3ca810..b8cd100cfcd6d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -395,10 +395,23 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
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



