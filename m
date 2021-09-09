Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1367D404D52
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245585AbhIIMBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345658AbhIIL7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 766B361452;
        Thu,  9 Sep 2021 11:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187962;
        bh=ji6FOxvP5bsC3vVdy9kIsBWYiGVsOWqbyx9E7qjHCiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jr9TJDKbs85z8ZJj3fPs+afAhsSAYeu4ZWfTpUwi/wzub2uscuhjN1imNikBAeoQI
         ixgk+izmlZvcJwhR0CNbm5G62L1T6lex1FC6KtdnHE31mNcp5wUb+mkNy5sezcAKGZ
         h4Gt3zO3pdFWAiCNikP9cftmebtGrMVP8CtSv4Etlkj/o7nzWysK2vo0QAzIdEvMCu
         LqIQnOyILgWdyJ9dwnB0H1JtCYMZCfuQH1Zzu5v0H8/6KoNqWgJelUT5XpYkXVfFX2
         iMzbmelM30b//iyo4oAJPmnzz7nn67w8Lq1kcgNIxbcICzEFXS5wWBDvRWXX8uxVcP
         LrbYhiAKCchkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 227/252] nfsd: fix crash on LOCKT on reexported NFSv3
Date:   Thu,  9 Sep 2021 07:40:41 -0400
Message-Id: <20210909114106.141462-227-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index bebe86cce7c7..cde6b81aa22c 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7040,8 +7040,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 /*
  * The NFSv4 spec allows a client to do a LOCKT without holding an OPEN,
  * so we do a temporary open here just to get an open file to pass to
- * vfs_test_lock.  (Arguably perhaps test_lock should be done with an
- * inode operation.)
+ * vfs_test_lock.
  */
 static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file_lock *lock)
 {
@@ -7056,7 +7055,9 @@ static __be32 nfsd_test_lock(struct svc_rqst *rqstp, struct svc_fh *fhp, struct
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

