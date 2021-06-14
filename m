Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1593A634F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhFNLL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhFNLJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC6A61935;
        Mon, 14 Jun 2021 10:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667612;
        bh=Qs9Cio5h40e/M3j0XY31Z5BfMO3Zyc0Lwc1CfiErz3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CH78yYxqlzGT7LPYRemcU/VTilFKXC1cPYE40m0m3HI4yOcnGaVrZLTSNixyvbI7i
         SHy3xp3mRuPYJ9ezVpnqyUb46byRKWKYvZ20xZ2Y8di4PpTLE3b3HoBFpg1OdlEpM1
         eiMhJ3QD562bXcaxS1H3Hzff8zzxRucbhFl8F7ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/131] NFS: Fix a potential NULL dereference in nfs_get_client()
Date:   Mon, 14 Jun 2021 12:28:01 +0200
Message-Id: <20210614102657.094070310@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 09226e8303beeec10f2ff844d2e46d1371dc58e0 ]

None of the callers are expecting NULL returns from nfs_get_client() so
this code will lead to an Oops.  It's better to return an error
pointer.  I expect that this is dead code so hopefully no one is
affected.

Fixes: 31434f496abb ("nfs: check hostname in nfs_get_client")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 4b8cc93913f7..723d425796cc 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -406,7 +406,7 @@ struct nfs_client *nfs_get_client(const struct nfs_client_initdata *cl_init)
 
 	if (cl_init->hostname == NULL) {
 		WARN_ON(1);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* see if the client already exists */
-- 
2.30.2



