Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2225842B167
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhJMA6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237147AbhJMA5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A740860EBB;
        Wed, 13 Oct 2021 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086549;
        bh=8w6nCCwfCDCGKC/ESbabK963/M8g6HzQJrjfEqIhZso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgVKmUkFjlrPy6gQjuFvB5WjAVrgw812898QSXwwF0a8blB1Z26+PtMd6bxvlTd+l
         awM+xzp+Uz+ZGWkWBBu3ekBKvNe9wGq5/i/XwePXtKlcJjoqKiZunzoTD8z4hvKhaR
         RsxVGDLDt4mrM1X6O4y+BF+iug1upqIUe8dcd0b59hm1ABupRggT5Li0G5xFFkcN51
         ewPOKLomjUrhYfiUhC8mUkcvPbdMo5KbiDmFORxniutVzRuOte1TNI58o8xbY+Dmds
         XSXlwx0tzSpZU7zl/ZYh4ZbvVykykoPFRcRyXjhpIfD5YHCnTJe/jcKsvQLy+pG1xD
         ZAHq5p0aKafVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/11] NFSD: Keep existing listeners on portlist error
Date:   Tue, 12 Oct 2021 20:55:29 -0400
Message-Id: <20211013005532.700190-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005532.700190-1-sashal@kernel.org>
References: <20211013005532.700190-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit c20106944eb679fa3ab7e686fe5f6ba30fbc51e5 ]

If nfsd has existing listening sockets without any processes, then an error
returned from svc_create_xprt() for an additional transport will remove
those existing listeners.  We're seeing this in practice when userspace
attempts to create rpcrdma transports without having the rpcrdma modules
present before creating nfsd kernel processes.  Fix this by checking for
existing sockets before calling nfsd_destroy().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 0759e589ab52..506da1c77bea 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -792,7 +792,10 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 		svc_xprt_put(xprt);
 	}
 out_err:
-	nfsd_destroy(net);
+	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
+		nn->nfsd_serv->sv_nrthreads--;
+	 else
+		nfsd_destroy(net);
 	return err;
 }
 
-- 
2.33.0

