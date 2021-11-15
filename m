Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571A84522E3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344674AbhKPBQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244690AbhKOTRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B6B61C4F;
        Mon, 15 Nov 2021 18:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000573;
        bh=d3WJIQtE4BeYgcR/D5QLzpqSONK1MQ+qEHnNRElMaWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxBt8YtVpjl5ujtYHSDfIrtjGmobrStHzU1KviI89htp40aSd6m9PUWishA2CXQ2j
         4HxeMYzzpWYVf3e8+u6RxInp7sBhM3PFyxsVzqjlKJ/TTDbXRC7mCeSIZyreYUgTUo
         rHVDIUG7jJvciLqCrHLDFPbddHbAMYDHRzHzN0f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 678/849] NFS: Fix dentry verifier races
Date:   Mon, 15 Nov 2021 18:02:41 +0100
Message-Id: <20211115165443.207066070@linuxfoundation.org>
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

[ Upstream commit cec08f452a687fce9dfdf47946d00a1d12a8bec5 ]

If the directory changed while we were revalidating the dentry, then
don't update the dentry verifier. There is no value in setting the
verifier to an older value, and we could end up overwriting a more up to
date verifier from a parallel revalidation.

Fixes: efeda80da38d ("NFSv4: Fix revalidation of dentries with delegations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 085b8ecdc17d9..5b68c44848caf 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1269,13 +1269,12 @@ static bool nfs_verifier_is_delegated(struct dentry *dentry)
 static void nfs_set_verifier_locked(struct dentry *dentry, unsigned long verf)
 {
 	struct inode *inode = d_inode(dentry);
+	struct inode *dir = d_inode(dentry->d_parent);
 
-	if (!nfs_verifier_is_delegated(dentry) &&
-	    !nfs_verify_change_attribute(d_inode(dentry->d_parent), verf))
-		goto out;
+	if (!nfs_verify_change_attribute(dir, verf))
+		return;
 	if (inode && NFS_PROTO(inode)->have_delegation(inode, FMODE_READ))
 		nfs_set_verifier_delegated(&verf);
-out:
 	dentry->d_time = verf;
 }
 
-- 
2.33.0



