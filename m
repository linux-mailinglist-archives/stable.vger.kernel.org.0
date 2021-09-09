Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77140505B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349823AbhIIM1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350443AbhIIMWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD2361350;
        Thu,  9 Sep 2021 11:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188253;
        bh=pIgvIe9Ol6VEP6zcdmzvTCrnIyEqLK2/SqSN9+LnhvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qr5lDEcbe88aCBtWTMWa/B3SmcguYzoYIhOkwnDSZ1MTd3ZRT+6ETeeyuyfTN+m/U
         Tebr/s5Ol3BFsxodOHoX2t9g4goDx4LG3PW6NMFKa+TQif09zOlYvZAwQoyd4HVt5k
         YXdohs7BGSgOjkIPTSTSrFqTZyssiezkYaTASRT3GBcFLGosv/B4fPHeo92Vhr1LtA
         2O/V4Hsskud8dMDYcNKwh+BUKGE8v0XHDtNZe9HVjmFHEee+UmZA8TmuRI8eJJe+w3
         qPLSiaVhikhgHgx7albMpBDfQ8ZtVJXkT42Qo7AFaYfdbgFI9RaR2AOG8kZJnuqAEV
         9Q7YBstdFNvcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 200/219] nfsd: fix crash on LOCKT on reexported NFSv3
Date:   Thu,  9 Sep 2021 07:46:16 -0400
Message-Id: <20210909114635.143983-200-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

[ Upstream commit 0bcc7ca40bd823193224e9f38bafbd8325aaf566 ]

Unlike other filesystems, NFSv3 tries to use fl_file in the GETLK case.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 323d57e72d25..60fd9daf6b3b 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6932,8 +6932,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 /*
  * The NFSv4 spec allows a client to do a LOCKT without holding an OPEN,
  * so we do a temporary open here just to get an open file to pass to
- * vfs_test_lock.  (Arguably perhaps test_lock should be done with an
- * inode operation.)
+ * vfs_test_lock.
  */
 static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
 {
@@ -6948,7 +6947,9 @@ static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct
 							NFSD_MAY_READ));
 	if (err)
 		goto out;
+	lock->fl_file = nf->nf_file;
 	err = nfserrno(vfs_test_lock(nf->nf_file, lock));
+	lock->fl_file = NULL;
 out:
 	fh_unlock(fhp);
 	nfsd_file_put(nf);
-- 
2.30.2

