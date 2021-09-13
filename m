Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19BB4092BB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344635AbhIMOPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344243AbhIMOLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:11:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A3661AA8;
        Mon, 13 Sep 2021 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540533;
        bh=EB1r5Yr637ISSg4xwlnZbCG//Nyb9WBYl3rh+8XpsB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcj2DZQjOjKjK7Zaegy8CFmtTvmxTLhQt2+FDuDkscV/E3nyPn2SZAaSv6TxDa/a/
         dC1/YqqFf3QVussT+ST8zWuo0ZGu01vwXuarZH8+dnx2lBgExdaXNRNCth0xJLKIlg
         uUVLReGoadKlXwG69VHMIrYb5fEvwQSWgDPMP2xc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 200/300] nfsd4: Fix forced-expiry locking
Date:   Mon, 13 Sep 2021 15:14:21 +0200
Message-Id: <20210913131116.124627036@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit f7104cc1a9159cd0d3e8526cb638ae0301de4b61 ]

This should use the network-namespace-wide client_lock, not the
per-client cl_lock.

You shouldn't see any bugs unless you're actually using the
forced-expiry interface introduced by 89c905beccbb.

Fixes: 89c905beccbb "nfsd: allow forced expiration of NFSv4 clients"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 90e81f6491ff..ab81e8ae3265 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2665,9 +2665,9 @@ static void force_expire_client(struct nfs4_client *clp)
 	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 	bool already_expired;
 
-	spin_lock(&clp->cl_lock);
+	spin_lock(&nn->client_lock);
 	clp->cl_time = 0;
-	spin_unlock(&clp->cl_lock);
+	spin_unlock(&nn->client_lock);
 
 	wait_event(expiry_wq, atomic_read(&clp->cl_rpc_users) == 0);
 	spin_lock(&nn->client_lock);
-- 
2.30.2



