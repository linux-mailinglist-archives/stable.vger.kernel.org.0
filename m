Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5816C408F8A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhIMNoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243173AbhIMNmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59A3A61409;
        Mon, 13 Sep 2021 13:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539804;
        bh=rgDUh1MOK9zHmoxEWJmcgdk9UcoBZzxp9Kao/q7MEm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vr853Zg04X8KX5c0/JKM76I6OOMPE9Pa7ypzyXwMpTSlprqoBz/wKsf3YLxNX9P+m
         gP9qIcE5FcwybbOlpJaNLi6eV+MSyfx53A9rzUq86B/SXHcmadE1qmEdntKCHMn+RR
         8eOyO9UgSb5KZUjGykOPJ4oqEBnjrpXtukMnW+hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/236] nfsd4: Fix forced-expiry locking
Date:   Mon, 13 Sep 2021 15:14:31 +0200
Message-Id: <20210913131106.020822412@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 80e394a2e3fd..142aac9b63a8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2646,9 +2646,9 @@ static void force_expire_client(struct nfs4_client *clp)
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



