Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84E215EF66
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388929AbgBNRr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388778AbgBNQAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157622187F;
        Fri, 14 Feb 2020 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696001;
        bh=LW51BosMbPwtKSdDEUrwZXmbL2W7qvtemK9FcFViVr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m50XhmqF1I54Zp6JCkcgkbakzwZ6aGx7b6a5iSww3e9uwesb0QCMm39Me36fip6AQ
         72w79Y0f92gCTONWziqzSdqF0h4D40GzsD0zAWYygzZReNjoK6nEXwcrqLUY3H1PPj
         QGur5EC+jYOMcZ6FavaysOxwbSyb/WiW19fG/RI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 520/542] NFSv4: pnfs_roc() must use cred_fscmp() to compare creds
Date:   Fri, 14 Feb 2020 10:48:32 -0500
Message-Id: <20200214154854.6746-520-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 387122478775be5d9816c34aa29de53d0b926835 ]

When comparing two 'struct cred' for equality w.r.t. behaviour under
filesystem access, we need to use cred_fscmp().

Fixes: a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 3ac6b4dea72d3..542ea8dfd1bc7 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1425,7 +1425,7 @@ bool pnfs_roc(struct inode *ino,
 	/* lo ref dropped in pnfs_roc_release() */
 	layoutreturn = pnfs_prepare_layoutreturn(lo, &stateid, &iomode);
 	/* If the creds don't match, we can't compound the layoutreturn */
-	if (!layoutreturn || cred != lo->plh_lc_cred)
+	if (!layoutreturn || cred_fscmp(cred, lo->plh_lc_cred) != 0)
 		goto out_noroc;
 
 	roc = layoutreturn;
-- 
2.20.1

