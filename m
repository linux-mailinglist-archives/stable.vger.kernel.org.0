Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80B42B1AB
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhJMA7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237498AbhJMA6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72E8C61039;
        Wed, 13 Oct 2021 00:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086610;
        bh=kJ5iohGuoOvhSU249YjsejyelHG1H02dXpShYNbe9UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tm5nuK0jiiC35u6ecMKTl/dq1jgl9cJNN3+JRKIe+VbDfQ/N+zSeMHx8IL/JDcbEz
         wqIw/gssA5K/9KtccA7IQptyJDeXAXurTKCi1dl+uOl+XUK6AyNYVQjnd8EHaN0x2U
         aZIn0zBvPtdx5EwyunO2/T5TwUFx+r5QhPuMXWyGWZ0K0MPx4ZJlBH4++C6YJTYpZ7
         dm3EBE6XNbNEGX509FeVsp2HQ+8rk8aumejY4YEnjp1QKViOEuFK2SVAqn81mIUqT6
         h7qQkCMdLp/Q4f14ENAHHQ6l7zq3us/zOhbtEydK1FGSh6NeB1Azc+08rvWXXJzYAq
         hCux9Tqdr3q4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, bfields@fieldses.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] NFSD: Keep existing listeners on portlist error
Date:   Tue, 12 Oct 2021 20:56:42 -0400
Message-Id: <20211013005644.700705-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005644.700705-1-sashal@kernel.org>
References: <20211013005644.700705-1-sashal@kernel.org>
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
index f704f90db36c..2418b9d829ae 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -765,7 +765,10 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net)
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

